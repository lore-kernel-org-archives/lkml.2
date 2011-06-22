Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab1FVKQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 06:16:16 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:13132 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab1FVKQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 06:16:13 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LN6SIX-02-27U-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <arnd@arndb.de>,
        <davidb@codeaurora.org>, <dwmw2@infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-pci@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/2] iommu: Move iommu Kconfig entries to submenu
Date: Wed, 22 Jun 2011 12:16:45 +0200
Message-ID: <1308737806-2658-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308737806-2658-1-git-send-email-joerg.roedel@amd.com>
References: <1307742947-32118-1-git-send-email-ohad@wizery.com>
 <1308737806-2658-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For better navigation this patch moves the drivers/iommu
drivers into its own submenu in Kconfig.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/Kconfig |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index e2a5f14..b57b3fa 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -2,6 +2,17 @@
 config IOMMU_API
 	bool
 
+menuconfig IOMMU_SUPPORT
+	bool "IOMMU Hardware Support"
+	default y
+	---help---
+	  Say Y here if you want to compile device drivers for IO Memory
+	  Management Units into the kernel. These devices usually allow to
+	  remap DMA requests and/or remap interrupts from other devices on the
+	  system.
+
+if IOMMU_SUPPORT
+
 # MSM IOMMU support
 config MSM_IOMMU
 	bool "MSM IOMMU Support"
@@ -95,3 +106,5 @@ config INTR_REMAP
 	  Supports Interrupt remapping for IO-APIC and MSI devices.
 	  To use x2apic mode in the CPU's which support x2APIC enhancements or
 	  to support platforms with CPU's having > 8 bit APIC ID, say Y.
+
+endif # IOMMU_SUPPORT
-- 
1.7.4.1


