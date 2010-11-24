Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab0KXPjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 10:39:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39695 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751580Ab0KXPjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 10:39:47 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] asm-generic: Raise default NR_IRQS when using sparse IRQs
Date: Wed, 24 Nov 2010 15:39:16 +0000
Message-Id: <1290613156-861-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than have each platform using sparse IRQs pick a suitably large
NR_IRQS for use with sparse IRQs make the default exceptionally high
when they are enabled.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/asm-generic/irq.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/irq.h b/include/asm-generic/irq.h
index b90ec0b..a76bea2 100644
--- a/include/asm-generic/irq.h
+++ b/include/asm-generic/irq.h
@@ -4,11 +4,15 @@
 /*
  * NR_IRQS is the upper bound of how many interrupts can be handled
  * in the platform. It is used to size the static irq_map array,
- * so don't make it too big.
+ * so don't make it too big unless we're using sparse IRQs.
  */
 #ifndef NR_IRQS
+#ifdef CONFIG_SPARSE_IRQ
+#define NR_IRQS 0x7fffffff
+#else
 #define NR_IRQS 64
 #endif
+#endif
 
 static inline int irq_canonicalize(int irq)
 {
-- 
1.7.1

