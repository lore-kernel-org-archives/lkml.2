Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758Ab1KRLkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 06:40:47 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:37727 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757132Ab1KRLgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 06:36:01 -0500
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
Date: Fri, 18 Nov 2011 16:39:44 +0530
Message-Id: <20111118110944.10512.1822.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH v7 3.2-rc2 16/30] uprobes: Introduce uprobe_task_arch_info structure.
x-cbid: 11111801-5140-0000-0000-00000047BB3F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


uprobe_task_arch_info structure helps save and restore architecture
specific artifacts at the probehit/singlestep/original instruction
restore time.

Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 include/linux/uprobes.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 0882223..c1378a9 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -31,6 +31,7 @@ struct vm_area_struct;
 #else
 typedef u8 uprobe_opcode_t;
 struct uprobe_arch_info {};
+struct uprobe_task_arch_info {};	/* arch specific task info */
 #define MAX_UINSN_BYTES 4
 #endif
 
@@ -84,6 +85,7 @@ struct uprobe_task {
 	unsigned long vaddr;
 
 	enum uprobe_task_state state;
+	struct uprobe_task_arch_info tskinfo;
 
 	struct uprobe *active_uprobe;
 };

