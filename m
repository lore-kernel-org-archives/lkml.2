Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab1GHF7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:59:41 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45956 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab1GHF7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:59:38 -0400
From: Tommy Lin <tommy.lin.1101@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Anton Vorontsov <avorontsov@mvista.com>
Cc: linux-kernel@vger.kernel.org, Tommy Lin <tommy.lin@caviumnetworks.com>
Subject: [PATCH 1/2] arch: arm: Correct the dependency of HAVE_ARM_TWD
Date: Fri,  8 Jul 2011 13:59:23 +0800
Message-Id: <1310104763-12948-1-git-send-email-tommy.lin@caviumnetworks.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original mpcore_wdt config dependency is as follow:
MPCORE_WATCHDOG -> HAVE_ARM_TWD -> SMP -> (CPU_V6K || CPU_V7)
This patch will remove SMP and made the dependency as follow:
MPCORE_WATCHDOG -> HAVE_ARM_TWD -> (CPU_V6K || CPU_V7)

The MPCore watchdog (and timer) can be found at ARM11 MPCore (CPU_V6K) and
Cortex A9 MPCore (CPU_V7). The dependency between MPCORE_WATCHDOG and
(CPU_V6K || CPUV7) is necessary, but the dependency of SMP is redundant.
The MPCore watchdog should function normally even SMP is not turned on with
ARM11 or Cortex A9 CPU.

Signed-off-by: Tommy Lin <tommy.lin@caviumnetworks.com>
---
 arch/arm/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 3262b15..c148326 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1353,7 +1353,7 @@ config HAVE_ARM_SCU
 
 config HAVE_ARM_TWD
 	bool
-	depends on SMP
+	depends on CPU_V6K || CPU_V7
 	select TICK_ONESHOT
 	help
 	  This options enables support for the ARM timer and watchdog unit
-- 
1.7.6

