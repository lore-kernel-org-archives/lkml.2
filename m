Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab1K3QPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 11:15:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42609 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757124Ab1K3QPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 11:15:12 -0500
Message-ID: <91601168bd8039233da8d91a07560f20.squirrel@www.firstfloor.org>
In-Reply-To: <20111129182643.GB7339@redhat.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
    <20111128190614.GA4602@redhat.com>
    <20111129103040.GF13445@linux.vnet.ibm.com>
    <20111129182643.GB7339@redhat.com>
Date: Wed, 30 Nov 2011 17:15:10 +0100
Subject: Re: [PATCH RFC 0/5] uprobes: kill xol vma
From: "Andi Kleen" <andi@firstfloor.org>
To: "Oleg Nesterov" <oleg@redhat.com>
Cc: "Srikar Dronamraju" <srikar@linux.vnet.ibm.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "LKML" <linux-kernel@vger.kernel.org>, "Linux-mm" <linux-mm@kvack.org>,
        "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
        "Christoph Hellwig" <hch@infradead.org>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        "Roland McGrath" <roland@hack.frob.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Masami Hiramatsu" <masami.hiramatsu.pt@hitachi.com>,
        "Arnaldo Carvalho de Melo" <acme@infradead.org>,
        "Anton Arapov" <anton@redhat.com>,
        "Ananth N Mavinakayanahalli" <ananth@in.ibm.com>,
        "Jim Keniston" <jkenisto@linux.vnet.ibm.com>,
        "Stephen Wilson" <wilsons@start.ca>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  static unsigned char
> -uprobe_xol_slots[UPROBES_XOL_SLOT_BYTES][NR_CPUS] __page_aligned_bss;
> +uprobe_xol_slots[NR_CPUS][UPROBES_XOL_SLOT_BYTES] __page_aligned_bss;

NR_CPUS arrays are basically always wrong.

Use per cpu data.

-Andi

