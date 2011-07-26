Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab1GZMfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 08:35:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50013 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab1GZMff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 08:35:35 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=3NOpT3G9tzkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=WQuCyQq__gPjfFxVObEA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 6/7] sched: Balance RT tasks when forked as well
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1311683108.24752.33.camel@twins>
References: <20110617015516.301117218@goodmis.org>
	 <20110617015919.832743148@goodmis.org>  <1311683108.24752.33.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 26 Jul 2011 08:35:32 -0400
Message-ID: <1311683732.3526.64.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 14:25 +0200, Peter Zijlstra wrote:
> On Thu, 2011-06-16 at 21:55 -0400, Steven Rostedt wrote:
> > +       /* For anything but wake ups, just return the task_cpu */
> > +       if (sd_flag != SD_BALANCE_WAKE || sd_flag != SD_BALANCE_FORK) 
> 
> So we call select_task_rq() with SD_BALANCE_{WAKE,EXEC,FORK}, 
> 
> 	(WAKE != WAKE -> 0 || WAKE != FORK -> 1) -> 1
> 	(EXEC != WAKE -> 1 ) -> 1
> 	(FORK != WAKE -> 1 ) -> 1
> 
> IOW, you never end up doing anything now.. surely you didn't mean that?!

Bah!

s/||/&&/

:-p

Thanks!

-- Steve


