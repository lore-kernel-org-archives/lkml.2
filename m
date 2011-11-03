Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934329Ab1KCRC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:02:28 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14821 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934261Ab1KCRBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:01:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 03 Nov 2011 10:01:04 -0700
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
Subject: [PATCH 2/3] ARM: mach-shmobile: Use CONFIG_ARCH_NR_GPIO
Date: Thu, 3 Nov 2011 19:00:46 +0200
Message-ID: <1320339647-30255-3-git-send-email-pdeschrijver@nvidia.com>
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
in gpio.h.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/Kconfig                           |    2 +-
 arch/arm/mach-shmobile/include/mach/gpio.h |    2 --
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 924f685..b9cfa99 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1509,7 +1509,7 @@ config LOCAL_TIMERS
 
 config ARCH_NR_GPIO
 	int
-	default 1024 if ARCH_TEGRA
+	default 1024 if ARCH_SHMOBILE || ARCH_TEGRA
 	default 0
 	help
 	  Maximum number of GPIOs in the system.
diff --git a/arch/arm/mach-shmobile/include/mach/gpio.h b/arch/arm/mach-shmobile/include/mach/gpio.h
index 7bf0890..de795b4 100644
--- a/arch/arm/mach-shmobile/include/mach/gpio.h
+++ b/arch/arm/mach-shmobile/include/mach/gpio.h
@@ -12,8 +12,6 @@
 
 #include <linux/kernel.h>
 #include <linux/errno.h>
-
-#define ARCH_NR_GPIOS 1024
 #include <linux/sh_pfc.h>
 
 #ifdef CONFIG_GPIOLIB
-- 
1.7.7.rc0.72.g4b5ea.dirty

