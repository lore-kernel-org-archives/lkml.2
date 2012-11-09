Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab2KIOU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 09:20:58 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:46843 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047Ab2KIOUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 09:20:47 -0500
From: ciminaghi@gnudd.com
To: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com,
        broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 09/10] drivers/mfd/sta2x11-mfd: add defines for some sta2x11 sctl registers
Date: Fri,  9 Nov 2012 15:20:00 +0100
Message-Id: <1352470801-2418-10-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352470801-2418-1-git-send-email-ciminaghi@gnudd.com>
References: <1352470801-2418-1-git-send-email-ciminaghi@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

These are required for the clock infrastructure code to properly configure
and control the sta2x11 PLLs.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---
 include/linux/mfd/sta2x11-mfd.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/mfd/sta2x11-mfd.h b/include/linux/mfd/sta2x11-mfd.h
index 08cad95..9a855ac 100644
--- a/include/linux/mfd/sta2x11-mfd.h
+++ b/include/linux/mfd/sta2x11-mfd.h
@@ -246,8 +246,29 @@ u32 sta2x11_sctl_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val)
 #define SCTL_SCCTL		0x00	/* System controller control register */
 #define SCTL_ARMCFG		0x04	/* ARM configuration register */
 #define SCTL_SCPLLCTL		0x08	/* PLL control status register */
+
+#define SCTL_SCPLLCTL_AUDIO_PLL_PD	     BIT(1)
+#define SCTL_SCPLLCTL_FRAC_CONTROL	     BIT(3)
+#define SCTL_SCPLLCTL_STRB_BYPASS	     BIT(6)
+#define SCTL_SCPLLCTL_STRB_INPUT	     BIT(8)
+
 #define SCTL_SCPLLFCTRL		0x0c	/* PLL frequency control register */
+
+#define SCTL_SCPLLFCTRL_AUDIO_PLL_NDIV_MASK	0xff
+#define SCTL_SCPLLFCTRL_AUDIO_PLL_NDIV_SHIFT	  10
+#define SCTL_SCPLLFCTRL_AUDIO_PLL_IDF_MASK	   7
+#define SCTL_SCPLLFCTRL_AUDIO_PLL_IDF_SHIFT	  21
+#define SCTL_SCPLLFCTRL_AUDIO_PLL_ODF_MASK	   7
+#define SCTL_SCPLLFCTRL_AUDIO_PLL_ODF_SHIFT	  18
+#define SCTL_SCPLLFCTRL_DITHER_DISABLE_MASK     0x03
+#define SCTL_SCPLLFCTRL_DITHER_DISABLE_SHIFT       4
+
+
 #define SCTL_SCRESFRACT		0x10	/* PLL fractional input register */
+
+#define SCTL_SCRESFRACT_MASK	0x0000ffff
+
+
 #define SCTL_SCRESCTRL1		0x14	/* Peripheral reset control 1 */
 #define SCTL_SCRESXTRL2		0x18	/* Peripheral reset control 2 */
 #define SCTL_SCPEREN0		0x1c	/* Peripheral clock enable register 0 */
-- 
1.7.10.4

