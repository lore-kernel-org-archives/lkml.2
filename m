Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab1KRLeD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 06:34:03 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:52815 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab1KRLeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 06:34:00 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
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
Date: Fri, 18 Nov 2011 16:37:43 +0530
Message-Id: <20111118110743.10512.50949.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH v7 3.2-rc2 6/30] uprobes: define fixups.
x-cbid: 11111811-2000-0000-0000-0000021C8282
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


During the first insertion of a probepoint, instruction is analyzed for
fixups and cached in the per-uprobe struct. On a probehit, the cached
fixup is used. Fixup analysis and caching is done in arch-specific
code.

Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 include/linux/uprobes.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index fa2b663..dd308fa 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -33,6 +33,17 @@ struct vm_area_struct;
 #define MAX_UINSN_BYTES 4
 #endif
 
+#define uprobe_opcode_sz sizeof(uprobe_opcode_t)
+
+/* Post-execution fixups.  Some architectures may define others. */
+
+/* No fixup needed */
+#define UPROBES_FIX_NONE	0x0
+/* Adjust IP back to vicinity of actual insn */
+#define UPROBES_FIX_IP	0x1
+/* Adjust the return address of a call insn */
+#define UPROBES_FIX_CALL	0x2
+
 struct uprobe_consumer {
 	int (*handler)(struct uprobe_consumer *self, struct pt_regs *regs);
 	/*
@@ -53,6 +64,7 @@ struct uprobe {
 	struct inode		*inode;		/* Also hold a ref to inode */
 	loff_t			offset;
 	int			copy;
+	u16			fixups;
 	u8			insn[MAX_UINSN_BYTES];
 };
 

