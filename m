Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab1K2Kce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 05:32:34 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:56848 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab1K2Kca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 05:32:30 -0500
Date: Tue, 29 Nov 2011 16:00:40 +0530
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
Subject: Re: [PATCH RFC 0/5] uprobes: kill xol vma
Message-ID: <20111129103040.GF13445@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
 <20111128190614.GA4602@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111128190614.GA4602@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112910-3270-0000-0000-00000232FDD2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On top of this series, not for inclusion yet, just to explain what
> I mean. May be someone can test it ;)
> 
> This series kills xol_vma. Instead we use the per_cpu-like xol slots.
> 
> This is much more simple and efficient. And this of course solves
> many problems we currently have with xol_vma.
> 
> For example, we simply can not trust it. We do not know what actually
> we are going to execute in UTASK_SSTEP mode. An application can unmap
> this area and then do mmap(PROT_EXEC|PROT_WRITE, MAP_FIXED) to fool
> uprobes.
> 
> The only disadvantage is that this adds a bit more arch-dependant
> code.
> 
> The main question, can this work? I know very little in this area.
> And I am not sure if this can be ported to other architectures.

Nice idea. I think this will help us in implementing boosted uprobes if
tweak a bit.  (i.e having a jump after the actual instruction that gets
us back to the actual instruction stream). The current method of using a
first cum-first-serve slot reservation doesnt work for booster because
we have had to clear the slot in the post processing. 

I will apply your patches and test and let you know how it goes. (in a day
or two).

-- 
Thanks and Regards
Srikar

