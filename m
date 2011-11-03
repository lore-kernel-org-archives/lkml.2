Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934256Ab1KCRBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:01:42 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14736 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934085Ab1KCRBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:01:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 03 Nov 2011 10:01:04 -0700
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
Subject: [PATCH 1/3] ARM: ARCH_NR_GPIO: Make ARCH_NR_GPIO a Kconfig variable
Date: Thu, 3 Nov 2011 19:00:45 +0200
Message-ID: <1320339647-30255-2-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1320339647-30255-1-git-send-email-pdeschrijver@nvidia.com>
References: <1320339647-30255-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change ARCH_NR_GPIO into a Kconfig variable as suggested by Russel King. This
makes ARCH_NR_GPIO single zImage friendly. The default value for tegra is
defined as well.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/Kconfig            |    9 +++++++++
 arch/arm/include/asm/gpio.h |    4 ++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 7e8ffe7..924f685 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1507,6 +1507,15 @@ config LOCAL_TIMERS
 	  accounting to be spread across the timer interval, preventing a
 	  "thundering herd" at every timer tick.
 
+config ARCH_NR_GPIO
+	int
+	default 1024 if ARCH_TEGRA
+	default 0
+	help
+	  Maximum number of GPIOs in the system.
+
+	  If unsure, leave the default value.
+
 source kernel/Kconfig.preempt
 
 config HZ
diff --git a/arch/arm/include/asm/gpio.h b/arch/arm/include/asm/gpio.h
index 11ad0bf..7151753 100644
--- a/arch/arm/include/asm/gpio.h
+++ b/arch/arm/include/asm/gpio.h
@@ -1,6 +1,10 @@
 #ifndef _ARCH_ARM_GPIO_H
 #define _ARCH_ARM_GPIO_H
 
+#if CONFIG_ARCH_NR_GPIO > 0
+#define ARCH_NR_GPIO CONFIG_ARCH_NR_GPIO
+#endif
+
 /* not all ARM platforms necessarily support this API ... */
 #include <mach/gpio.h>
 
-- 
1.7.7.rc0.72.g4b5ea.dirty

