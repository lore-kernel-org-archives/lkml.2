Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603Ab0DPTQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 15:16:53 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:35891 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758551Ab0DPTQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 15:16:50 -0400
From: Dinh.Nguyen@freescale.com
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
       grant.likely@secretlab.ca, bryan.wu@canonical.com,
       amit.kucheria@canonical.com, r.herring@freescale.com,
       Jun.Li@freescale.com, xiao-lizhang@freescale.com,
       Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv4 2.6.34-rc4 3/7] mxc: Add new defines for USB HW register bits on Freescale SoCs.
Date: Fri, 16 Apr 2010 14:16:07 -0500
Message-Id: <1271445371-18501-3-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1271445371-18501-2-git-send-email-Dinh.Nguyen@freescale.com>
References: <1271445371-18501-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1271445371-18501-2-git-send-email-Dinh.Nguyen@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

This patch adds new register bit defines for the USB HW on Freescale
SoCs.

This patch applies to 2.6.34-rc4.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/plat-mxc/include/mach/mxc_ehci.h |   48 +++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-mxc/include/mach/mxc_ehci.h b/arch/arm/plat-mxc/include/mach/mxc_ehci.h
index 4b9b836..c5b1e7b 100644
--- a/arch/arm/plat-mxc/include/mach/mxc_ehci.h
+++ b/arch/arm/plat-mxc/include/mach/mxc_ehci.h
@@ -1,6 +1,30 @@
 #ifndef __INCLUDE_ASM_ARCH_MXC_EHCI_H
 #define __INCLUDE_ASM_ARCH_MXC_EHCI_H
 
+#define USBOTG_OFFSET			0
+#define USBH1_OFFSET			0x200
+#define USBH2_OFFSET			0x400
+#define USBH3_OFFSET			0x600
+#define USBOTHER_REGS_OFFSET	0x800
+
+#define USBCMD_OFFSET			0x140
+
+#define ULPI_VIEWPORT_OFFSET	0x170
+#define PORTSC_OFFSET		0x184
+#define USBMODE_OFFSET		0x1a8
+#define USBMODE_CM_HOST		3
+
+#define USBCTRL_OFFSET					0
+#define USB_PHY_CTR_FUNC_OFFSET		0x8
+#define USB_PHY_CTR_FUNC2_OFFSET		0xc
+#define USB_CTRL_1_OFFSET				0x10
+
+
+/* USBCMD */
+#define UCMD_RUN_STOP           (1 << 0)        /* controller run/stop */
+#define UCMD_RESET		(1 << 1)	/* controller reset */
+#define UCMD_ITC_NO_THRESHOLD		(~(0xff << 16))	/* Interrupt Threshold Control */
+
 /* values for portsc field */
 #define MXC_EHCI_PHY_LOW_POWER_SUSPEND	(1 << 23)
 #define MXC_EHCI_FORCE_FS		(1 << 24)
@@ -26,6 +50,30 @@
 #define MXC_EHCI_IPPUE_DOWN		(1 << 8)
 #define MXC_EHCI_IPPUE_UP		(1 << 9)
 
+/* USB_CTRL */
+#define UCTRL_OUIE		(1 << 28)	/* OTG ULPI intr enable */
+#define UCTRL_OWIE		(1 << 27)	/* OTG wakeup intr enable */
+#define UCTRL_OBPVAL_RXDP	(1 << 26)	/* OTG RxDp status in bypass mode */
+#define UCTRL_OBPVAL_RXDM	(1 << 25)	/* OTG RxDm status in bypass mode */
+#define UCTRL_OPM		(1 << 24)	/* OTG power mask */
+#define UCTRL_H1UIE		(1 << 12)	/* Host1 ULPI interrupt enable */
+#define UCTRL_H1WIE		(1 << 11)	/* HOST1 wakeup intr enable */
+#define UCTRL_H1PM		(1 <<  8)		/* HOST1 power mask */
+
+/* USB_PHY_CTRL_FUNC */
+#define USB_UTMI_PHYCTRL_OC_DIS	(1 << 8)	/* OTG Disable Overcurrent Event */
+#define USB_UH1_OC_DIS	(1 << 5)		/* UH1 Disable Overcurrent Event */
+
+/* USB_CTRL_1 */
+#define USB_CTRL_UH1_EXT_CLK_EN			(1 << 25)
+#define USB_CTRL_UH2_EXT_CLK_EN			(1 << 26)
+
+/* USB_PHY_CTRL_FUNC2*/
+#define USB_UTMI_PHYCTRL2_PLLDIV_MASK		0x3
+#define USB_UTMI_PHYCTRL2_PLLDIV_SHIFT		0
+#define USB_UTMI_PHYCTRL2_HSDEVSEL_MASK		0x3
+#define USB_UTMI_PHYCTRL2_HSDEVSEL_SHIFT	19
+
 struct mxc_usbh_platform_data {
 	int (*init)(struct platform_device *pdev);
 	int (*exit)(struct platform_device *pdev);
-- 
1.6.0.4

