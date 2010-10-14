Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab0JNVSh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:18:37 -0400
Received: from king.tilera.com ([72.1.168.226]:52853 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756112Ab0JNVQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:16:12 -0400
Message-Id: <13c9d5a6309763a494f7c3ed5aa45fb473985fd7.1287090286.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1287090280.git.cmetcalf@tilera.com>
References: <cover.1287090280.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 14 Oct 2010 15:12:55 -0400
Subject: [PATCH 03/14] arch/tile: properly export __mb_incoherent for modules
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
X-OriginalArrivalTime: 14 Oct 2010 21:16:11.0809 (UTC) FILETIME=[06ED5110:01CB6BE5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/system.h |    5 ++++-
 arch/tile/lib/exports.c        |    3 +++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/tile/include/asm/system.h b/arch/tile/include/asm/system.h
index f749be3..96779c8 100644
--- a/arch/tile/include/asm/system.h
+++ b/arch/tile/include/asm/system.h
@@ -89,6 +89,10 @@
 #define get_cycles_low() __insn_mfspr(SPR_CYCLE)   /* just get all 64 bits */
 #endif
 
+#if !CHIP_HAS_MF_WAITS_FOR_VICTIMS()
+int __mb_incoherent(void);  /* Helper routine for mb_incoherent(). */
+#endif
+
 /* Fence to guarantee visibility of stores to incoherent memory. */
 static inline void
 mb_incoherent(void)
@@ -97,7 +101,6 @@ mb_incoherent(void)
 
 #if !CHIP_HAS_MF_WAITS_FOR_VICTIMS()
 	{
-		int __mb_incoherent(void);
 #if CHIP_HAS_TILE_WRITE_PENDING()
 		const unsigned long WRITE_TIMEOUT_CYCLES = 400;
 		unsigned long start = get_cycles_low();
diff --git a/arch/tile/lib/exports.c b/arch/tile/lib/exports.c
index ce5dbf5..1509c55 100644
--- a/arch/tile/lib/exports.c
+++ b/arch/tile/lib/exports.c
@@ -45,6 +45,9 @@ EXPORT_SYMBOL(__copy_from_user_zeroing);
 EXPORT_SYMBOL(__copy_in_user_inatomic);
 #endif
 
+/* arch/tile/lib/mb_incoherent.S */
+EXPORT_SYMBOL(__mb_incoherent);
+
 /* hypervisor glue */
 #include <hv/hypervisor.h>
 EXPORT_SYMBOL(hv_dev_open);
-- 
1.6.5.2

