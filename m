Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab1K2Hvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 02:51:40 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53679 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab1K2Hvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 02:51:39 -0500
Date: Tue, 29 Nov 2011 13:19:48 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Subject: Re: [PATCH v7 3.2-rc2 9/30] uprobes: Background page replacement.
Message-ID: <20111129074948.GB13445@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
 <20111118110823.10512.74338.sendpatchset@srdronam.in.ibm.com>
 <1322489609.2921.132.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1322489609.2921.132.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112907-9360-0000-0000-0000010E186D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-11-28 15:13:29]:

> On Fri, 2011-11-18 at 16:38 +0530, Srikar Dronamraju wrote:
> > +/**
> > + * is_bkpt_insn - check if instruction is breakpoint instruction.
> > + * @insn: instruction to be checked.
> > + * Default implementation of is_bkpt_insn
> > + * Returns true if @insn is a breakpoint instruction.
> > + */
> > +bool __weak is_bkpt_insn(u8 *insn)
> > +{
> > +       return (insn[0] == UPROBES_BKPT_INSN);
> >  } 
> 
> This seems wrong, UPROBES_BKPT_INSN basically defined to be of
> uprobe_opcode_t type, not u8.
> 
> So:
> 
> bool __weak is_bkpt_insn(uprobe_opcode_t *insn)
> {
> 	return *insn == UPROBE_BKPT_INSN;
> }
> 
> seems like the right way to write this.
> 

Agree, will fix this. 
Thanks for bringing this up.

-- 
Thanks and Regards
Srikar

