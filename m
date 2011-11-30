Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673Ab1K3QVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 11:21:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47562 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757620Ab1K3QVP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 11:21:15 -0500
Message-ID: <1322670031.2921.286.camel@twins>
Subject: Re: [PATCH RFC 0/5] uprobes: kill xol vma
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>
Date: Wed, 30 Nov 2011 17:20:31 +0100
In-Reply-To: <91601168bd8039233da8d91a07560f20.squirrel@www.firstfloor.org>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
	 <20111128190614.GA4602@redhat.com>
	 <20111129103040.GF13445@linux.vnet.ibm.com>
	 <20111129182643.GB7339@redhat.com>
	 <91601168bd8039233da8d91a07560f20.squirrel@www.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 17:15 +0100, Andi Kleen wrote:
> >  static unsigned char
> > -uprobe_xol_slots[UPROBES_XOL_SLOT_BYTES][NR_CPUS] __page_aligned_bss;
> > +uprobe_xol_slots[NR_CPUS][UPROBES_XOL_SLOT_BYTES] __page_aligned_bss;
> 
> NR_CPUS arrays are basically always wrong.
> 
> Use per cpu data.

Doesn't really work here, you'd know if you'd read the patches. What we
could do though is do a UPROBES_XOL_SLOT_BYTES * nr_cpu_ids bootmem
allocation or so.
