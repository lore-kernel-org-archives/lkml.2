Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab1KOIJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 03:09:56 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54109 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab1KOIJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 03:09:55 -0500
Date: Tue, 15 Nov 2011 13:14:06 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>
Subject: Re: [PATCH v6 3.2-rc1 28/28]   uprobes: introduce
 UTASK_SSTEP_TRAPPED logic
Message-ID: <20111115074406.GE4243@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20111110183725.11361.57827.sendpatchset@srdronam.in.ibm.com>
 <20111110184307.11361.8163.sendpatchset@srdronam.in.ibm.com>
 <20111114163953.GA29399@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111114163953.GA29399@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11111508-6078-0000-0000-00000466C387
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > +void __weak abort_xol(struct pt_regs *regs, struct uprobe_task *utask)
> > +{
> > +	set_instruction_pointer(regs, utask->vaddr);
> > +}
> 
> OK, this is fine on 32bit. But X86_64 should also handle
> UPROBES_FIX_RIP_AX/CX?
> 
> IOW, shouldn't we also do
> 
> 	if (uprobe->fixups & UPROBES_FIX_RIP_AX)
> 		regs->ax = tskinfo->saved_scratch_register;
> 	else if (uprobe->fixups & UPROBES_FIX_RIP_CX)
> 		regs->cx = tskinfo->saved_scratch_register;
> 
> on 64bit?

Yes, we should be doing this on x86_64. Since abort_xol is a weak
function, I will have x86_64 specific abort_xol.

-- 
Thanks and Regards
Srikar

