Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab1KRLe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 06:34:28 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:57143 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426Ab1KRLe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 06:34:26 -0500
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
Date: Fri, 18 Nov 2011 16:37:53 +0530
Message-Id: <20111118110753.10512.37918.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH v7 3.2-rc2 7/30] uprobes: uprobes arch info
x-cbid: 11111801-6102-0000-0000-000000322951
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce per uprobe arch info structure.
Used to store arch specific details. For example: details to handle
Rip relative instructions in X86_64.

Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 include/linux/uprobes.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index dd308fa..44f28dc 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -29,7 +29,7 @@ struct vm_area_struct;
 #ifdef CONFIG_ARCH_SUPPORTS_UPROBES
 #include <asm/uprobes.h>
 #else
-
+struct uprobe_arch_info {};
 #define MAX_UINSN_BYTES 4
 #endif
 
@@ -60,6 +60,7 @@ struct uprobe {
 	atomic_t		ref;
 	struct rw_semaphore	consumer_rwsem;
 	struct list_head	pending_list;
+	struct uprobe_arch_info arch_info;
 	struct uprobe_consumer	*consumers;
 	struct inode		*inode;		/* Also hold a ref to inode */
 	loff_t			offset;

