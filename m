Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab1AYN4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:56:01 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59938 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab1AYN4A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:56:00 -0500
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 13/20] 13: x86: x86 specific probe
 handling
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Linux-mm <linux-mm@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20101216095947.23751.75003.sendpatchset@localhost6.localdomain6>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
	 <20101216095947.23751.75003.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 Jan 2011 14:56:22 +0100
Message-ID: <1295963783.28776.1061.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 15:29 +0530, Srikar Dronamraju wrote:
> 
> +void arch_uprobe_enable_sstep(struct pt_regs *regs)
> +{
> +       /*
> +        * Enable single-stepping by
> +        * - Set TF on stack
> +        * - Set TIF_SINGLESTEP: Guarantees that TF is set when
> +        *      returning to user mode.
> +        *  - Indicate that TF is set by us.
> +        */
> +       regs->flags |= X86_EFLAGS_TF;
> +       set_thread_flag(TIF_SINGLESTEP);
> +       set_thread_flag(TIF_FORCED_TF);
> +}
> +
> +void arch_uprobe_disable_sstep(struct pt_regs *regs)
> +{
> +       /* Disable single-stepping by clearing what we set */
> +       clear_thread_flag(TIF_SINGLESTEP);
> +       clear_thread_flag(TIF_FORCED_TF);
> +       regs->flags &= ~X86_EFLAGS_TF;
> +} 

Why not use the code from arch/x86/kernel/step.c?
