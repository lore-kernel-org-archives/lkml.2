Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab1K1TtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:49:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:59624 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1K1TtK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:49:10 -0500
Message-ID: <1322509712.2921.158.camel@twins>
Subject: Re: [PATCH 3/5] uprobes: introduce uprobe_xol_slots[NR_CPUS]
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
Date: Mon, 28 Nov 2011 20:48:32 +0100
In-Reply-To: <20111128190714.GD4602@redhat.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
	 <20111128190614.GA4602@redhat.com> <20111128190714.GD4602@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 20:07 +0100, Oleg Nesterov wrote:
> +       UPROBE_XOL_FIRST_PAGE = UPROBE_XOL_LAST_PAGE
> +                             + NR_CPUS * UPROBES_XOL_SLOT_BYTES / PAGE_SIZE, 

I think that wants to be: 
	+ DIV_ROUND_UP(NR_CPUS * UPROBES_XOL_SLOT_BYTES, PAGE_SIZE);

otherwise you'll end up with 0 pages for UP and the sort.
