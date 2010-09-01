Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab0IAX0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 19:26:16 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14053 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab0IAX0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 19:26:15 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6092"; a="53073418"
From: Gregory Bean <gbean@codeaurora.org>
To: dwalker@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH] msm: Featurize gpiomux.
Date: Wed,  1 Sep 2010 16:26:12 -0700
Message-Id: <1283383572-15635-1-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Featurize gpiomux so that systems like 7x00 which do not wish to use it
do not have to be saddled with the configuration tables.

Signed-off-by: Gregory Bean <gbean@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig   |    5 +++++
 arch/arm/mach-msm/gpiomux.h |   20 ++++++++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 4e79580..f09ffef 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -18,6 +18,7 @@ config ARCH_MSM7X30
 	select MSM_VIC
 	select CPU_V7
 	select MSM_REMOTE_SPINLOCK_DEKKERS
+	select MSM_GPIOMUX
 
 config ARCH_QSD8X50
 	bool "QSD8X50"
@@ -26,6 +27,7 @@ config ARCH_QSD8X50
 	select MSM_VIC
 	select CPU_V7
 	select MSM_REMOTE_SPINLOCK_LDREX
+	select MSM_GPIOMUX
 endchoice
 
 config MSM_SOC_REV_A
@@ -106,6 +108,9 @@ config MSM_SMD_PKG3
 config MSM_SMD
 	bool
 
+config MSM_GPIOMUX
+	bool
+
 config MSM_V2_TLMM
 	bool
 endif
diff --git a/arch/arm/mach-msm/gpiomux.h b/arch/arm/mach-msm/gpiomux.h
index bb0acf0..b178d9c 100644
--- a/arch/arm/mach-msm/gpiomux.h
+++ b/arch/arm/mach-msm/gpiomux.h
@@ -18,6 +18,7 @@
 #define __ARCH_ARM_MACH_MSM_GPIOMUX_H
 
 #include <linux/bitops.h>
+#include <linux/errno.h>
 
 #if defined(CONFIG_MSM_V2_TLMM)
 #include "gpiomux-v2.h"
@@ -60,6 +61,8 @@ enum {
 	GPIOMUX_CTL_MASK = GPIOMUX_VALID,
 };
 
+#ifdef CONFIG_MSM_GPIOMUX
+
 /* Each architecture must provide its own instance of this table.
  * To avoid having gpiomux manage any given gpio, one or both of
  * the entries can avoid setting GPIOMUX_VALID - the absence
@@ -90,5 +93,22 @@ int msm_gpiomux_write(unsigned gpio,
  * should use msm_gpiomux_write.
  */
 void __msm_gpiomux_write(unsigned gpio, gpiomux_config_t val);
+#else
+static inline int __must_check msm_gpiomux_get(unsigned gpio)
+{
+	return -ENOSYS;
+}
 
+static inline int msm_gpiomux_put(unsigned gpio)
+{
+	return -ENOSYS;
+}
+
+static inline int msm_gpiomux_write(unsigned gpio,
+				    gpiomux_config_t active,
+				    gpiomux_config_t suspended)
+{
+	return -ENOSYS;
+}
+#endif
 #endif
-- 
1.7.0.4

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
