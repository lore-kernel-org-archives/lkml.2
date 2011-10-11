Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab1JKR6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:58:16 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:48465 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab1JKR6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:58:15 -0400
Date: Tue, 11 Oct 2011 23:08:40 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 26/26]   uprobes: queue signals while
 thread is singlestepping.
Message-ID: <20111011173840.GE16268@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
 <20110920120517.25326.57657.sendpatchset@srdronam.in.ibm.com>
 <1317128626.15383.61.camel@twins>
 <20110927131213.GE3685@linux.vnet.ibm.com>
 <20111005180139.GA5704@redhat.com>
 <20111006054710.GB17591@linux.vnet.ibm.com>
 <20111007165828.GA32319@redhat.com>
 <20111010122556.GB16268@linux.vnet.ibm.com>
 <20111010182535.GA6934@redhat.com>
 <20111011172422.GA7878@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111011172422.GA7878@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > HOWEVER! I simply do not know what should we do if the probed insn
> > is something like asm("1:; jmp 1b;"). IIUC, in this sstep_complete()
> > never returns true. The patch also adds the fatal_signal_pending()
> > check to make this task killlable, but the problem is: whatever we do,
> > I do not think it is correct to disable/delay the signals in this case.
> > With any approach.
> >
> > What do you think? Maybe we should simply disallow to probe such insns?
> 
> Or. Could you explain why we can't simply remove the
> "if (vaddr == current->utask->xol_vaddr)" check from sstep_complete() ?


Yes, we could remove the check and rely on just the DIE_DEBUG to say
that singlestep has occurred. This was mostly needed when we were not
handling signals on singlestep.

> In some sense, imho this looks more correct for "rep" or jmp/call self.
> The task will trap again on the same (original) address, and
> handler_chain() will be called to notify the consumers.
> 
> But. I am really, really ignorant in this area, I am almost sure this
> is not that simple.
> 

Thats being modest.

-- 
Thanks and Regards
Srikar
