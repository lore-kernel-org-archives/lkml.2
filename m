Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1IWLCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 07:02:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53111 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab1IWLC3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 07:02:29 -0400
Subject: Re: [PATCH 21/21] tracing: Add optional percpu buffers for
 trace_printk()
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 23 Sep 2011 13:02:02 +0200
In-Reply-To: <20110922221030.111078233@goodmis.org>
References: <20110922220935.537134016@goodmis.org>
	 <20110922221030.111078233@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316775722.9084.2.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-22 at 18:09 -0400, Steven Rostedt wrote:
> 
> Currently, trace_printk() uses a single buffer to write into
> to calculate the size and format needed to save the trace. To
> do this safely in an SMP environment, a spin_lock() is taken
> to only allow one writer at a time to the buffer. But this could
> also affect what is being traced, and add synchronization that
> would not be there otherwise. 

so trace_printk() isn't NMI safe? #$%@^%@@$%@
