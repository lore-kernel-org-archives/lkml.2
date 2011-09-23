Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab1IWLHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 07:07:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:59143 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab1IWLHl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 07:07:41 -0400
Subject: Re: [PATCH 21/21] tracing: Add optional percpu buffers for
 trace_printk()
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 23 Sep 2011 13:07:11 +0200
References: <20110922220935.537134016@goodmis.org>
	 <20110922221030.111078233@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316776031.9084.4.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 13:02 +0200, Peter Zijlstra wrote:
> On Thu, 2011-09-22 at 18:09 -0400, Steven Rostedt wrote:
> > 
> > Currently, trace_printk() uses a single buffer to write into
> > to calculate the size and format needed to save the trace. To
> > do this safely in an SMP environment, a spin_lock() is taken
> > to only allow one writer at a time to the buffer. But this could
> > also affect what is being traced, and add synchronization that
> > would not be there otherwise. 
> 
> so trace_printk() isn't NMI safe? #$%@^%@@$%@

better to make all of trace_printk() depend on that extra config, there
is absolutely 0 point in having a broken and fully serialized trace
'fail^wfeature'.
