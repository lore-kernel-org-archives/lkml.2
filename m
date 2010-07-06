Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab0GFWOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 18:14:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37347 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab0GFWOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 18:14:04 -0400
X-Authority-Analysis: v=1.1 cv=jfMbZ+4tkgrYlaJBi3iJCtg6TDszHDHJJpQ3TdTfnr0= c=1 sm=0 a=mS1qFslhlkkA:10 a=uEzv4HemXiYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=Z4Rwk6OoAAAA:8 a=omOdbC7AAAAA:8 a=VJBOa9clF3mQgUN0duQA:9 a=O1cW2Pu4KjVT6zuiwQsA:7 a=NNowfNjm8CRdnnoGBWT9AVpIJ9MA:4 a=PUjeQqilurYA:10 a=jbrJJM5MRmoA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/2] sched: make sched_param arugment static variables
 in some sched_setscheduler() caller
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       James Morris <jmorris@namei.org>
In-Reply-To: <20100706095013.CCD9.A69D9226@jp.fujitsu.com>
References: <20100702144941.8fa101c3.akpm@linux-foundation.org>
	 <20100706091607.CCCC.A69D9226@jp.fujitsu.com>
	 <20100706095013.CCD9.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 06 Jul 2010 18:13:58 -0400
Message-ID: <1278454438.1537.54.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-06 at 09:51 +0900, KOSAKI Motohiro wrote:
> Andrew Morton pointed out almost sched_setscheduler() caller are
> using fixed parameter and it can be converted static. it reduce
> runtume memory waste a bit.

We are replacing runtime waste with permanent waste?

> 
> Reported-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



> --- a/kernel/trace/trace_selftest.c
> +++ b/kernel/trace/trace_selftest.c
> @@ -560,7 +560,7 @@ trace_selftest_startup_nop(struct tracer *trace, struct trace_array *tr)
>  static int trace_wakeup_test_thread(void *data)
>  {
>  	/* Make this a RT thread, doesn't need to be too high */
> -	struct sched_param param = { .sched_priority = 5 };
> +	static struct sched_param param = { .sched_priority = 5 };
>  	struct completion *x = data;
>  

This is a thread that runs on boot up to test the sched_wakeup tracer.
Then it is deleted and all memory is reclaimed.

Thus, this patch just took memory that was usable at run time and
removed it permanently.

Please Cc me on all tracing changes.

-- Steve


