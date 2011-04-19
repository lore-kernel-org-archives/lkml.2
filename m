Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab1DSF5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 01:57:08 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41699 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab1DSF5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 01:57:06 -0400
Date: Tue, 19 Apr 2011 11:13:25 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2.6.39-rc1-tip 14/26] 14: x86: x86 specific probe
 handling
Message-ID: <20110419054325.GA10698@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
 <20110401143517.15455.88373.sendpatchset@localhost6.localdomain6>
 <1303145700.32491.891.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1303145700.32491.891.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-04-18 18:55:00]:

> On Fri, 2011-04-01 at 20:05 +0530, Srikar Dronamraju wrote:
> > +/*
> > + * @reg: reflects the saved state of the task
> > + * @vaddr: the virtual address to jump to.
> > + * Return 0 on success or a -ve number on error.
> > + */
> > +void set_ip(struct pt_regs *regs, unsigned long vaddr)
> > +{
> > +       regs->ip = vaddr;
> > +} 
> 
> Since we have the cross-architecture function:
> instruction_pointer(struct pt_regs*) to read the thing, this ought to be
> called set_instruction_pointer(struct pt_regs*, unsigned long) or
> somesuch.

Okay, will rename set_ip to set_instruction_pointer.

