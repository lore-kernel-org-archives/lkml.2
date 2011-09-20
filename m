Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab1ITMRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 08:17:01 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:39254 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088Ab1ITMQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 08:16:59 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 20 Sep 2011 17:33:15 +0530
Message-Id: <20110920120315.25326.58862.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH v5 3.1.0-rc4-tip 16/26]   uprobes: Introduce uprobe_task_arch_info structure.
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
index fa7eaba..30576fa 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -31,6 +31,7 @@ struct vm_area_struct;
 #else
 typedef u8 uprobe_opcode_t;
 struct uprobe_arch_info {};
+struct uprobe_task_arch_info {};	/* arch specific task info */
 #define MAX_UINSN_BYTES 4
 #endif
 
@@ -86,6 +87,7 @@ struct uprobe_task {
 	unsigned long vaddr;
 
 	enum uprobe_task_state state;
+	struct uprobe_task_arch_info tskinfo;
 
 	struct uprobe *active_uprobe;
 };
