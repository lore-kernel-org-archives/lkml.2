Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab1K2ScT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 13:32:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755383Ab1K2ScT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 13:32:19 -0500
Date: Tue, 29 Nov 2011 19:26:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
Message-ID: <20111129182643.GB7339@redhat.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com> <20111128190614.GA4602@redhat.com> <20111129103040.GF13445@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129103040.GF13445@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29, Srikar Dronamraju wrote:
>
> I will apply your patches and test and let you know how it goes. (in a day
> or two).

Thanks! please note that 3/5 is wrong, I sent the updated version.
Or you can add the fix below.

Oleg.

--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -1144,7 +1144,7 @@ bool __weak can_skip_xol(struct pt_regs *regs, struct uprobe *u)
 }
 
 static unsigned char
-uprobe_xol_slots[UPROBES_XOL_SLOT_BYTES][NR_CPUS] __page_aligned_bss;
+uprobe_xol_slots[NR_CPUS][UPROBES_XOL_SLOT_BYTES] __page_aligned_bss;
 
 void __weak set_xol_ip(struct pt_regs *regs)
 {

