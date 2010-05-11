Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161Ab0EKNad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 09:30:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40127 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756908Ab0EKNac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 09:30:32 -0400
X-Authority-Analysis: v=1.1 cv=GuuPm/R9MDBdMhOgsQZYzj+bBK5woo0X8cuc0sTVRtI= c=1 sm=0 a=SSFxOwRvCusA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=7d_E57ReAAAA:8 a=FrnrjfBQz4aWZdQfCjsA:9 a=hioD9iauXAMR3Zk0mu4A:7 a=bu827zggH1xBhAvqdUEnTSaPJbMA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=D6-X0JM3zdQA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 10/10 -v3][RFC] tracing: Combine event filter_active
 and enable into single flags field
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20100511033026.GA28162@Krystal>
References: <20100511030020.837892321@goodmis.org>
	 <20100511030911.927339838@goodmis.org>  <20100511033026.GA28162@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 11 May 2010 09:30:28 -0400
Message-ID: <1273584628.22438.4501.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 23:30 -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > The filter_active and enable both use an int (4 bytes each) to
> > set a single flag. We can save 4 bytes per event by combining the
> > two into a single integer.
> > 

> I would also comment about flags read-side:
> 
>  * Flags are read concurrently without locking.

That can go in outside this patch set. As we discussed before, the
filter_active which does the same today as flags does here also has the
issue you are concerned with. IOW, this issue has nothing to do with
this patch set, because the issue existed before the patch set and has
not changed after the patch set.

The comment should also be in Documentation, not here, since it would
affect users more than the developers.

> 
> Besides that minor nit, the whole patchset has my
> 
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Thanks!  I'll get an official release ready.

-- Steve


