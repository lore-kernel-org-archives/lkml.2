Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab1KNQpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 11:45:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036Ab1KNQpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 11:45:15 -0500
Date: Mon, 14 Nov 2011 17:39:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
Message-ID: <20111114163953.GA29399@redhat.com>
References: <20111110183725.11361.57827.sendpatchset@srdronam.in.ibm.com> <20111110184307.11361.8163.sendpatchset@srdronam.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111110184307.11361.8163.sendpatchset@srdronam.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11, Srikar Dronamraju wrote:
>
> +void __weak abort_xol(struct pt_regs *regs, struct uprobe_task *utask)
> +{
> +	set_instruction_pointer(regs, utask->vaddr);
> +}

OK, this is fine on 32bit. But X86_64 should also handle
UPROBES_FIX_RIP_AX/CX?

IOW, shouldn't we also do

	if (uprobe->fixups & UPROBES_FIX_RIP_AX)
		regs->ax = tskinfo->saved_scratch_register;
	else if (uprobe->fixups & UPROBES_FIX_RIP_CX)
		regs->cx = tskinfo->saved_scratch_register;

on 64bit?

Oleg.

