Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab2BTKvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 05:51:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49460 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab2BTKvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 05:51:17 -0500
Date: Mon, 20 Feb 2012 11:50:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jkenisto@us.ibm.com, a.p.zijlstra@chello.nl, ananth@in.ibm.com,
        anton@redhat.com, masami.hiramatsu.pt@hitachi.com, acme@infradead.org,
        tglx@linutronix.de, oleg@redhat.com
Subject: Re: [tip:perf/uprobes] uprobes/core: Clean up, refactor and improve
 the code
Message-ID: <20120220105041.GA24200@elte.hu>
References: <tip-ewbwhb8o6navvllsauu7k07p@git.kernel.org>
 <20120217104958.GA21998@elte.hu>
 <20120220092540.GB22680@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120220092540.GB22680@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

> >  - uprobe->insn[] needs to move from struct uprobe to
> >    uprobe->arch.insn
> > 
> >  - The uprobes_arch_*() method(s) should be passed a
> >    'struct arch_uprobe *', not a 'struct uprobe *'.
> > 
> >  - Once this is done, 'struct uprobe' can move to the head of 
> >    kernel/uprobes.c, without any ugly #ifdefs and wrappery - 
> >    that code only compiles if uprobes are enabled and if the 
> >    architecture supports it.
> > 
> >  - asm/uprobes.h defines 'struct arch_uprobe' and the arch 
> >    method(s) - nothing else.
> > 
> >  - write_opcode() and any similar functions should be renamed to 
> >    the arch_uprobes_write_opcode() pattern
> 
> Currently the kernel/uprobes.c code handles insn as arch 
> agnostic in some cases and uses arch specific stuff for 
> analysis, verification and to set up fixups. The analysis, 
> verification, and fixups is only done at the probe insertion 
> only.
> 
> The copy_insn code, write_opcode is mostly arch agnostic 
> except for the maximum length of any supported instruction for 
> that architecture. If we move the insn to arch_uprobe, then we 
> would have to duplicate this code in arch specific files to do 
> the copying of the instruction. (not only at 
> registration/unregistration times and also at probe hit time 
> to copy into the slot).

Is there any reason why the core kernel uprobes.c code could not 
use uprobe->arch.insn directly?

It's in the architecture specific structure, mainly to 
encapsulate architecture-accessible fields and isolate low-level 
functionality from high-level one. This does not preclude the 
high-level code from using that field though.

Obviously every uprobes supporting architecture would have to 
define an 'insn' field in their 'struct arch_uprobe'.

Thanks,

	Ingo
