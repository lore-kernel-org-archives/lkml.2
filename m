Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803Ab0JZCxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:53:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757266Ab0JZCxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:53:22 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 02/43] MN10300: BUG to BUG_ON changes
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Stoyan Gaydarov <stoyboyker@gmail.com>
Date: Tue, 26 Oct 2010 03:53:12 +0100
Message-ID: <20101026025312.23512.69535.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stoyan Gaydarov <stoyboyker@gmail.com>

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/kernel/irq.c                      |    3 +--
 arch/mn10300/mm/init.c                         |    3 +--
 arch/mn10300/mm/misalignment.c                 |    3 +--
 arch/mn10300/unit-asb2303/include/unit/timex.h |    3 +--
 arch/mn10300/unit-asb2305/include/unit/timex.h |    3 +--
 5 files changed, 5 insertions(+), 10 deletions(-)


diff --git a/arch/mn10300/kernel/irq.c b/arch/mn10300/kernel/irq.c
index e2d5ed8..b5b970d 100644
--- a/arch/mn10300/kernel/irq.c
+++ b/arch/mn10300/kernel/irq.c
@@ -159,8 +159,7 @@ asmlinkage void do_IRQ(void)
 	int irq;
 
 	sp = current_stack_pointer();
-	if (sp - (sp & ~(THREAD_SIZE - 1)) < STACK_WARN)
-		BUG();
+	BUG_ON(sp - (sp & ~(THREAD_SIZE - 1)) < STACK_WARN);
 
 	/* make sure local_irq_enable() doesn't muck up the interrupt priority
 	 * setting in EPSW */
diff --git a/arch/mn10300/mm/init.c b/arch/mn10300/mm/init.c
index 6e6bc0e..f86c283 100644
--- a/arch/mn10300/mm/init.c
+++ b/arch/mn10300/mm/init.c
@@ -84,8 +84,7 @@ void __init mem_init(void)
 	int codesize, reservedpages, datasize, initsize;
 	int tmp;
 
-	if (!mem_map)
-		BUG();
+	BUG_ON(!mem_map);
 
 #define START_PFN	(contig_page_data.bdata->node_min_pfn)
 #define MAX_LOW_PFN	(contig_page_data.bdata->node_low_pfn)
diff --git a/arch/mn10300/mm/misalignment.c b/arch/mn10300/mm/misalignment.c
index 6dffbf9..eef989c 100644
--- a/arch/mn10300/mm/misalignment.c
+++ b/arch/mn10300/mm/misalignment.c
@@ -449,8 +449,7 @@ found_opcode:
 	       regs->pc, opcode, pop->opcode, pop->params[0], pop->params[1]);
 
 	tmp = format_tbl[pop->format].opsz;
-	if (tmp > noc)
-		BUG(); /* match was less complete than it ought to have been */
+	BUG_ON(tmp > noc); /* match was less complete than it ought to have been */
 
 	if (tmp < noc) {
 		tmp = noc - tmp;
diff --git a/arch/mn10300/unit-asb2303/include/unit/timex.h b/arch/mn10300/unit-asb2303/include/unit/timex.h
index f206b63..88cd96b 100644
--- a/arch/mn10300/unit-asb2303/include/unit/timex.h
+++ b/arch/mn10300/unit-asb2303/include/unit/timex.h
@@ -50,8 +50,7 @@ static inline void startup_jiffies_counter(void)
 			md = TM0MD_SRC_IOCLK_32;
 			rate = MN10300_JCCLK / 32 / HZ;
 
-			if (rate > TMJCBR_MAX)
-				BUG();
+			BUG_ON(rate > TMJCBR_MAX);
 		}
 	}
 
diff --git a/arch/mn10300/unit-asb2305/include/unit/timex.h b/arch/mn10300/unit-asb2305/include/unit/timex.h
index d1c72d5..0860186 100644
--- a/arch/mn10300/unit-asb2305/include/unit/timex.h
+++ b/arch/mn10300/unit-asb2305/include/unit/timex.h
@@ -50,8 +50,7 @@ static inline void startup_jiffies_counter(void)
 			md = TM0MD_SRC_IOCLK_32;
 			rate = MN10300_JCCLK / 32 / HZ;
 
-			if (rate > TMJCBR_MAX)
-				BUG();
+			BUG_ON(rate > TMJCBR_MAX);
 		}
 	}
 

