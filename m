Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab0LGB15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 20:27:57 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45255 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab0LGB14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 20:27:56 -0500
From: Fernando Guzman Lugo <fernando.lugo@ti.com>
To: <linux@arm.linux.org.uk>, <fujita.tomonori@lab.ntt.co.jp>,
        <linux-arm-kernel@lists.infradead.org>, <Hiroshi.DOYU@nokia.com>,
        <linux-kernel@vger.kernel.org>
Cc: <omar.ramirez@ti.com>, <bshah@ti.com>, <vpasam@ti.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: [PATCH] ARM: Add Kconfig entry for SG chain support
Date: Mon,  6 Dec 2010 19:40:36 -0600
Message-Id: <1291686036-32562-1-git-send-email-fernando.lugo@ti.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a entry to make possible SG chaining under ARM
architecture.

Tidspbridge driver needs SG chaining, however SG chain has not
been tested under all platforms. Adding this option OMAP
platform can enable it and if other platforms have issues they
would not enable it.

This patch is base on this discussion:

http://marc.info/?l=linux-arm-kernel&m=129166415415541&w=2

Signed-off-by: Fernando Guzman Lugo <fernando.lugo@ti.com>
---
 arch/arm/Kconfig                   |    6 ++++++
 arch/arm/include/asm/scatterlist.h |    4 ++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index dd944bd..f5cfd42 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1017,6 +1017,12 @@ config CPU_HAS_PMU
 	default y
 	bool
 
+config ARM_SG_CHAIN
+	bool "Enable SG chain support"
+	default n
+	help
+	  Enable support for SG chaining for ARM
+
 if !MMU
 source "arch/arm/Kconfig-nommu"
 endif
diff --git a/arch/arm/include/asm/scatterlist.h b/arch/arm/include/asm/scatterlist.h
index 2f87870..eab7c4f 100644
--- a/arch/arm/include/asm/scatterlist.h
+++ b/arch/arm/include/asm/scatterlist.h
@@ -5,4 +5,8 @@
 #include <asm/types.h>
 #include <asm-generic/scatterlist.h>
 
+#ifdef CONFIG_ARM_SG_CHAIN
+#define ARCH_HAS_SG_CHAIN
+#endif
+
 #endif /* _ASMARM_SCATTERLIST_H */
-- 
1.6.3.3

