Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab1K1T61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:58:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:59809 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab1K1T60 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:58:26 -0500
Message-ID: <1322510277.2921.164.camel@twins>
Subject: Re: [PATCH RFC 0/5] uprobes: kill xol vma
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
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
Date: Mon, 28 Nov 2011 20:57:57 +0100
In-Reply-To: <20111128190614.GA4602@redhat.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
	 <20111128190614.GA4602@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 20:06 +0100, Oleg Nesterov wrote:
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

I very much like this approach! I think the provided implementation
might have some issues, but yeah, using fixmaps and a __switch_to_xtra
hook to provide per task slots seems very nice indeed!
