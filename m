Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab0FAN32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 09:29:28 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45648 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401Ab0FAN3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 09:29:22 -0400
From: Borislav Petkov <bp@amd64.org>
To: <mingo@elte.hu>, <norsk5@yahoo.com>
Cc: <hpa@zytor.com>, <tglx@linutronix.de>, <linux-edac@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/6] edac: Remove EDAC_DEBUG_VERBOSE
Date: Tue,  1 Jun 2010 15:29:27 +0200
Message-Id: <1275398971-12439-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275398971-12439-1-git-send-email-bp@amd64.org>
References: <1275398971-12439-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This option differs from EDAC_DEBUG only by printing the file and
line of where the debug statement is placed, which contains unneeded
information. So remove it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/Kconfig     |    8 --------
 drivers/edac/edac_core.h |   15 ---------------
 2 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 55c9c59..5a8a569 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -39,14 +39,6 @@ config EDAC_DEBUG
 	  there're four debug levels (x=0,1,2,3 from low to high).
 	  Usually you should select 'N'.
 
-config EDAC_DEBUG_VERBOSE
-	bool "More verbose debugging"
-	depends on EDAC_DEBUG
-	help
-	  This option makes debugging information more verbose.
-	  Source file name and line number where debugging message
-	  printed will be added to debugging message.
-
  config EDAC_DECODE_MCE
 	tristate "Decode MCEs in human-readable form (only on AMD for now)"
 	depends on CPU_SUP_AMD && X86_MCE
diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index 001b2e7..2efd8f7 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -49,21 +49,15 @@
 #define edac_printk(level, prefix, fmt, arg...) \
 	printk(level "EDAC " prefix ": " fmt, ##arg)
 
-#define edac_printk_verbose(level, prefix, fmt, arg...) \
-	printk(level "EDAC " prefix ": " "in %s, line at %d: " fmt,	\
-	       __FILE__, __LINE__, ##arg)
-
 #define edac_mc_printk(mci, level, fmt, arg...) \
 	printk(level "EDAC MC%d: " fmt, mci->mc_idx, ##arg)
 
 #define edac_mc_chipset_printk(mci, level, prefix, fmt, arg...) \
 	printk(level "EDAC " prefix " MC%d: " fmt, mci->mc_idx, ##arg)
 
-/* edac_device printk */
 #define edac_device_printk(ctl, level, fmt, arg...) \
 	printk(level "EDAC DEVICE%d: " fmt, ctl->dev_idx, ##arg)
 
-/* edac_pci printk */
 #define edac_pci_printk(ctl, level, fmt, arg...) \
 	printk(level "EDAC PCI%d: " fmt, ctl->pci_idx, ##arg)
 
@@ -76,21 +70,12 @@
 extern int edac_debug_level;
 extern const char *edac_mem_types[];
 
-#ifndef CONFIG_EDAC_DEBUG_VERBOSE
 #define edac_debug_printk(level, fmt, arg...)                           \
 	do {                                                            \
 		if (level <= edac_debug_level)                          \
 			edac_printk(KERN_DEBUG, EDAC_DEBUG,		\
 				    "%s: " fmt, __func__, ##arg);	\
 	} while (0)
-#else  /* CONFIG_EDAC_DEBUG_VERBOSE */
-#define edac_debug_printk(level, fmt, arg...)                            \
-	do {                                                             \
-		if (level <= edac_debug_level)                           \
-			edac_printk_verbose(KERN_DEBUG, EDAC_DEBUG, fmt, \
-					    ##arg);			\
-	} while (0)
-#endif
 
 #define debugf0( ... ) edac_debug_printk(0, __VA_ARGS__ )
 #define debugf1( ... ) edac_debug_printk(1, __VA_ARGS__ )
-- 
1.7.1

