Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab0K2TRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:17:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43217 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750977Ab0K2TRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:17:38 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] asm-generic: Raise default NR_IRQS when using sparse IRQs
Date: Mon, 29 Nov 2010 19:17:32 +0000
Message-Id: <1291058252-26398-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than have each platform using sparse IRQs pick a suitably large
NR_IRQS for use with sparse IRQs make the default high when they are
enabled.  We pick 64k as there is still a bitmap of IRQs that is
allocated statically, and as we all know 64k should be enough for
anyone.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/asm-generic/irq.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/irq.h b/include/asm-generic/irq.h
index b90ec0b..0d95650 100644
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
+#define NR_IRQS 0xffff
+#else
 #define NR_IRQS 64
 #endif
+#endif
 
 static inline int irq_canonicalize(int irq)
 {
-- 
1.7.1

