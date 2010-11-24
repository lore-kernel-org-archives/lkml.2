Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab0KXI6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:58:01 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57848 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab0KXI6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:58:00 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, kernel@pengutronix.de,
        Arjan van de Ven <arjan@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/6] ARM: add some KERN_CONT markers to continuation lines
Date: Wed, 24 Nov 2010 09:57:45 +0100
Message-Id: <1290589070-854-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20101124085645.GW4693@pengutronix.de>
References: <20101124085645.GW4693@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/arm/mm/fault-armv.c |    4 ++--
 arch/arm/mm/init.c       |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mm/fault-armv.c b/arch/arm/mm/fault-armv.c
index 83e59f8..c8fb352 100644
--- a/arch/arm/mm/fault-armv.c
+++ b/arch/arm/mm/fault-armv.c
@@ -258,9 +258,9 @@ void __init check_writebuffer_bugs(void)
 	}
 
 	if (v) {
-		printk("failed, %s\n", reason);
+		printk(KERN_CONT "failed, %s\n", reason);
 		shared_pte_mask = L_PTE_MT_UNCACHED;
 	} else {
-		printk("ok\n");
+		printk(KERN_CONT "ok\n");
 	}
 }
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 5164069..947663a 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -549,9 +549,9 @@ void __init mem_init(void)
 		unsigned long pages = memblock_region_memory_end_pfn(reg) -
 			memblock_region_memory_base_pfn(reg);
 		num_physpages += pages;
-		printk(" %ldMB", pages >> (20 - PAGE_SHIFT));
+		printk(KERN_CONT " %ldMB", pages >> (20 - PAGE_SHIFT));
 	}
-	printk(" = %luMB total\n", num_physpages >> (20 - PAGE_SHIFT));
+	printk(KERN_CONT " = %luMB total\n", num_physpages >> (20 - PAGE_SHIFT));
 
 	printk(KERN_NOTICE "Memory: %luk/%luk available, %luk reserved, %luK highmem\n",
 		nr_free_pages() << (PAGE_SHIFT-10),
-- 
1.7.2.3

