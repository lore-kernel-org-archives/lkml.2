Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934288Ab1KCRBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:01:51 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14806 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934260Ab1KCRBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:01:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 03 Nov 2011 10:01:05 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        David Brown <davidb@codeaurora.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-sh@vger.kernel.org>
Subject: [PATCH 3/3] ARM: mach-ux500 Use CONFIG_ARCH_NR_GPIO
Date: Thu, 3 Nov 2011 19:00:47 +0200
Message-ID: <1320339647-30255-4-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1320339647-30255-1-git-send-email-pdeschrijver@nvidia.com>
References: <1320339647-30255-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add default value for CONFIG_ARCH_NR_GPIO to Kconfig and remove the definition
in gpio.h. We can't remove gpio.h yet as asm/gpio.h still includes it.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/Kconfig                        |    1 +
 arch/arm/mach-ux500/include/mach/gpio.h |    5 -----
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index b9cfa99..8da1f5f 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1510,6 +1510,7 @@ config LOCAL_TIMERS
 config ARCH_NR_GPIO
 	int
 	default 1024 if ARCH_SHMOBILE || ARCH_TEGRA
+	default 350 if ARCH_U8500
 	default 0
 	help
 	  Maximum number of GPIOs in the system.
diff --git a/arch/arm/mach-ux500/include/mach/gpio.h b/arch/arm/mach-ux500/include/mach/gpio.h
index 7389df9..c01ef66 100644
--- a/arch/arm/mach-ux500/include/mach/gpio.h
+++ b/arch/arm/mach-ux500/include/mach/gpio.h
@@ -1,10 +1,5 @@
 #ifndef __ASM_ARCH_GPIO_H
 #define __ASM_ARCH_GPIO_H
 
-/*
- * 288 (#267 is the highest one actually hooked up) onchip GPIOs, plus enough
- * room for a couple of GPIO expanders.
- */
-#define ARCH_NR_GPIOS	350
 
 #endif /* __ASM_ARCH_GPIO_H */
-- 
1.7.7.rc0.72.g4b5ea.dirty

