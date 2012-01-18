Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab2ARJMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:12:35 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:58988 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab2ARJMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:12:31 -0500
Date: Wed, 18 Jan 2012 14:32:32 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Anton Arapov <anton@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH v9 3.2 2/9] uprobes: handle breakpoint and signal step
 exception.
Message-ID: <20120118090232.GE15447@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120110114821.17610.9188.sendpatchset@srdronam.in.ibm.com>
 <20120110114842.17610.27081.sendpatchset@srdronam.in.ibm.com>
 <20120118083906.GA4697@bandura.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120118083906.GA4697@bandura.brq.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12011809-6148-0000-0000-000002B77535
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Srikar,
> 
>   Can we use existing SET_IP() instead of set_instruction_pointer() ?
> 

Oleg had already commented about this in one his uprobes reviews.

The GET_IP/SET_IP available in include/asm-generic/ptrace.h doesnt work
on all archs. Atleast it doesnt work on powerpc when I tried it.

Also most archs define instruction_pointer(). So I thought (rather Peter
Zijlstra suggested the name set_instruction_pointer())
set_instruction_pointer was a better bet than SET_IP. I 

Also I dont see any usage for SET_IP/GET_IP.

May be we should have something like this in
include/asm-generic/ptrace.h

#ifdef instruction_pointer
#define GET_IP(regs)		(instruction_pointer(regs))

#define set_instruction_pointer(regs, val) (instruction_pointer(regs) = (val))

#define SET_IP(regs, val)	(set_instruction_pointer(regs,val))

#endif

or should we do away with GET_IP/SET_IP esp since there are no many
users?

-- 
Thanks and Regards
Srikar

