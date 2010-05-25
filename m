Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700Ab0EYAWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 20:22:30 -0400
Received: from ozlabs.org ([203.10.76.45]:58686 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932335Ab0EYAW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 20:22:29 -0400
Date: Tue, 25 May 2010 10:22:21 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf changes
Message-ID: <20100525002221.GA30395@drongo>
References: <20100524192531.GA15614@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100524192531.GA15614@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 09:25:31PM +0200, Ingo Molnar wrote:

> Please pull the latest perf-core-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-core-for-linus
> 
> Most of these changes are fixes and dead code removal, but 
> also a set of optimizations and a series of tracing 
> size-optimization bits that we kept pending because they 
> conflicted with the previous push - and some TUI 
> enhancements.

...

> Peter Zijlstra (16):
>       perf/ftrace: Optimize perf/tracepoint interaction for single events
>       perf: Optimize buffer placement by allocating buffers NUMA aware
>       perf: Disallow mmap() on per-task inherited events
>       perf: Optimize the perf_output() path by removing IRQ-disables
>       perf: Optimize the hotpath by converting the perf output buffer to local_t
>       perf: Optimize perf_output_*() by avoiding local_xchg()
>       perf, trace: Optimize tracepoints by removing IRQ-disable from perf/tracepoint interaction

This commit breaks all non-x86 architectures by adding a reference to
regs->flags in generic code.  I mentioned this on lkml (with cc to
Ingo and Peter), and Peter has a further patch that fixes the problem,
which isn't in this pull.

So Linus, please don't do this pull just yet, until we get this extra
patch merged.

Paul.
