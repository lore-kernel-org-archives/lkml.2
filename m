Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab1CRTN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 15:13:57 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:37855 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818Ab1CRTNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 15:13:51 -0400
Date: Sat, 19 Mar 2011 00:37:05 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Roland McGrath <roland@hack.frob.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2.6.38-rc8-tip 6/20] 6: x86: analyze instruction and
 determine fixups.
Message-ID: <20110318190705.GC31152@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
 <20110314133507.27435.71382.sendpatchset@localhost6.localdomain6>
 <alpine.LFD.2.00.1103151529130.2787@localhost6.localdomain6>
 <20110318182457.GA24048@linux.vnet.ibm.com>
 <20110318183629.2AB052C286@topped-with-meat.com>
 <20110318184922.GA31152@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110318184922.GA31152@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Srikar Dronamraju <srikar@linux.vnet.ibm.com> [2011-03-19 00:19:22]:

> * Roland McGrath <roland@hack.frob.com> [2011-03-18 11:36:29]:
> 
> > > handle_riprel_insn() returns 0 if the instruction is not rip-relative
> > > returns 1 if its rip-relative but can use XOL slots.
> > > returns -1 if its rip-relative but cannot use XOL.
> > > 
> > > We dont see any instructions that are rip-relative and cannot use XOL.
> > > so the check and return are redundant and I will remove that in the next
> > > patch.
> > 
> > How is that?  You can only adjust a rip-relative instruction correctly if
> > the instruction copy is within 2GB of the original target address, which
> > cannot be presumed to always be the case in user address space layout
> > (unlike the kernel).
> > 
> 
> So we rewrite the copy of instruction (stored in XOL) such that it
> accesses its memory operand indirectly thro a scratch register.
> The contents of the scratch register are stored before singlestep and
> restored later.
> 
> Can you please tell us if this doesnt work?
> 

Infact we have tested using rip-relative addresses and it has
worked very well. So we have verified that it does work. Can you
please tell us why you dont think this works?

-- 
Thanks and Regards
Srikar
