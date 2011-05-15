Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983Ab1EOLfE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 07:35:04 -0400
Received: from londo.lunn.ch ([80.238.139.98]:59473 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759536Ab1EOLfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 07:35:02 -0400
From: Andrew Lunn <andrew@lunn.ch>
To: kernel@wantstofly.org, nico@fluxnic.net
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        saeed.bishara@gmail.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCHv2 04/15] [kirkwood] Add support for RTC interrupts which allows RTC alarms.
Date: Sun, 15 May 2011 13:32:43 +0200
Message-Id: <1305459174-25517-5-git-send-email-andrew@lunn.ch>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
References: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested using the test program in Documentation/rtc.txt

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 arch/arm/mach-kirkwood/common.c            |    2 +-
 arch/arm/mach-kirkwood/include/mach/irqs.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-kirkwood/common.c b/arch/arm/mach-kirkwood/common.c
index b77050e..f6868fc 100644
--- a/arch/arm/mach-kirkwood/common.c
+++ b/arch/arm/mach-kirkwood/common.c
@@ -328,7 +328,7 @@ void __init kirkwood_nand_init_rnb(struct mtd_partition *parts, int nr_parts,
  ****************************************************************************/
 static void __init kirkwood_rtc_init(void)
 {
-	orion_rtc_init(RTC_PHYS_BASE, NO_IRQ);
+	orion_rtc_init(RTC_PHYS_BASE, IRQ_KIRKWOOD_RTC);
 }
 
 
diff --git a/arch/arm/mach-kirkwood/include/mach/irqs.h b/arch/arm/mach-kirkwood/include/mach/irqs.h
index 9da2eb5..2bf8161 100644
--- a/arch/arm/mach-kirkwood/include/mach/irqs.h
+++ b/arch/arm/mach-kirkwood/include/mach/irqs.h
@@ -51,6 +51,7 @@
 #define IRQ_KIRKWOOD_GPIO_HIGH_16_23	41
 #define IRQ_KIRKWOOD_GE00_ERR	46
 #define IRQ_KIRKWOOD_GE01_ERR	47
+#define IRQ_KIRKWOOD_RTC        53
 
 /*
  * KIRKWOOD General Purpose Pins
-- 
1.7.4.4

