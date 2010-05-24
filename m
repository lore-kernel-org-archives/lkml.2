Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab0EXF1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 01:27:44 -0400
Received: from ozlabs.org ([203.10.76.45]:56564 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360Ab0EXF1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 01:27:41 -0400
Date: Mon, 24 May 2010 14:29:58 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] perf, trace: Remove IRQ-disable from
 perf/tracepoint interaction
Message-ID: <20100524042958.GA10628@drongo>
References: <20100521090201.326791353@chello.nl>
 <20100521090710.419716197@chello.nl>
 <20100523121159.GB3194@brick.ozlabs.ibm.com>
 <1274638587.1674.1729.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274638587.1674.1729.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 23, 2010 at 08:16:27PM +0200, Peter Zijlstra wrote:

> On Sun, 2010-05-23 at 22:11 +1000, Paul Mackerras wrote:
> > This is breaking on powerpc -- we don't have a "flags" element in
> > struct pt_regs.  What is it trying to do?  Get the interrupt enable
> > state, as local_irq_save(flags) would provide?
> 
> Yes, I fouled that up.
> 
> On x86 perf_arch_fetch_caller_regs() stores pt_regs::flags, which is the
> same as used in local_save_flags().
> 
> So to avoid another local_save_flags() for the ftrace code, I wanted to
> reuse it, and totally forgot the !x86 side of things.
> 
> Possibly we could remove the local_save_flags() from the
> perf_arch_fetch_caller_regs() as I'm not sure we actually use
> pt_regs::flags (Frederic?) and leave the ftrace thing to use
> local_save_flags().
> 
> Something like:

Yes, that works -- at least, it compiles and seems to run. :)

Acked-by: Paul Mackerras <paulus@samba.org>

Paul.
