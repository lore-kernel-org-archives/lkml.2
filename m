Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab1K1OOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:14:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:54905 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab1K1OOL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:14:11 -0500
Message-ID: <1322489609.2921.132.camel@twins>
Subject: Re: [PATCH v7 3.2-rc2 9/30] uprobes: Background page replacement.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
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
Date: Mon, 28 Nov 2011 15:13:29 +0100
In-Reply-To: <20111118110823.10512.74338.sendpatchset@srdronam.in.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
	 <20111118110823.10512.74338.sendpatchset@srdronam.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 16:38 +0530, Srikar Dronamraju wrote:
> +/**
> + * is_bkpt_insn - check if instruction is breakpoint instruction.
> + * @insn: instruction to be checked.
> + * Default implementation of is_bkpt_insn
> + * Returns true if @insn is a breakpoint instruction.
> + */
> +bool __weak is_bkpt_insn(u8 *insn)
> +{
> +       return (insn[0] == UPROBES_BKPT_INSN);
>  } 

This seems wrong, UPROBES_BKPT_INSN basically defined to be of
uprobe_opcode_t type, not u8.

So:

bool __weak is_bkpt_insn(uprobe_opcode_t *insn)
{
	return *insn == UPROBE_BKPT_INSN;
}

seems like the right way to write this.

