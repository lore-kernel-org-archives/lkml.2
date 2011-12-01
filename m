Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab1LAFyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 00:54:21 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48366 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866Ab1LAFyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 00:54:17 -0500
Date: Thu, 1 Dec 2011 11:22:11 +0530
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
Subject: Re: [PATCH v7 3.2-rc2 8/30] x86: analyze instruction and determine
 fixups.
Message-ID: <20111201055211.GD18380@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
 <20111118110808.10512.72719.sendpatchset@srdronam.in.ibm.com>
 <20111130185751.GA8160@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111130185751.GA8160@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11120105-3534-0000-0000-00000327F0A3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2011-11-30 19:57:51]:

> On 11/18, Srikar Dronamraju wrote:
> >
> > +static void handle_riprel_insn(struct mm_struct *mm, struct uprobe *uprobe,
> > +							struct insn *insn)
> > +{
> > [...snip...]
> > +	if (insn->immediate.nbytes) {
> > +		cursor++;
> > +		memmove(cursor, cursor + insn->displacement.nbytes,
> > +						insn->immediate.nbytes);
> > +	}
> > +	return;
> > +}
> 
> Of course I don not understand this code. But it seems that it can
> rewrite uprobe->insn ?
> 

Yes, we do rewrite the instruction for the RIP relative instructions. 
But the first byte is still intact.

> If yes, don't we need to save the original insn for unregister_uprobe?

When we unregister, we just put back the least opcode size which
happens to be the first byte for x86.

-- 
Thanks and Regards
Srikar

