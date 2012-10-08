Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab2JHNQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 09:16:26 -0400
Received: from zmc.proxad.net ([212.27.53.206]:33268 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563Ab2JHNOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 09:14:51 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 26/32 v2] USB: move common alchemy USB routines to arch/mips/alchemy/common.c
Date: Mon,  8 Oct 2012 15:11:40 +0200
Message-Id: <1349701906-16481-27-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349701906-16481-1-git-send-email-florian@openwrt.org>
References: <1349701906-16481-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A previous patch converted the Alchemy platform to use the OHCI and EHCI
platform drivers. As a result, all the common logic to handle USB present in
drivers/usb/host/alchemy-common.c has no reason to remain here, so we move it
to arch/mips/alchemy/common/usb.c which is a more appropriate place. This
change was suggested by Manuel Lauss.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
Changes in v2:
- rebased against greg's latest usb-next

 arch/mips/alchemy/common/Makefile                  |    2 +-
 .../mips/alchemy/common/usb.c                      |    0
 drivers/usb/host/Makefile                          |    1 -
 3 files changed, 1 insertion(+), 2 deletions(-)
 rename drivers/usb/host/alchemy-common.c => arch/mips/alchemy/common/usb.c (100%)

diff --git a/arch/mips/alchemy/common/Makefile b/arch/mips/alchemy/common/Makefile
index 407ebc0..cb83d8d 100644
--- a/arch/mips/alchemy/common/Makefile
+++ b/arch/mips/alchemy/common/Makefile
@@ -6,7 +6,7 @@
 #
 
 obj-y += prom.o time.o clocks.o platform.o power.o setup.o \
-	sleeper.o dma.o dbdma.o vss.o irq.o
+	sleeper.o dma.o dbdma.o vss.o irq.o usb.o
 
 # optional gpiolib support
 ifeq ($(CONFIG_ALCHEMY_GPIO_INDIRECT),)
diff --git a/drivers/usb/host/alchemy-common.c b/arch/mips/alchemy/common/usb.c
similarity index 100%
rename from drivers/usb/host/alchemy-common.c
rename to arch/mips/alchemy/common/usb.c
diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index 9e0a89c..332ed89 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -40,6 +40,5 @@ obj-$(CONFIG_USB_HWA_HCD)	+= hwa-hc.o
 obj-$(CONFIG_USB_IMX21_HCD)	+= imx21-hcd.o
 obj-$(CONFIG_USB_FSL_MPH_DR_OF)	+= fsl-mph-dr-of.o
 obj-$(CONFIG_USB_OCTEON2_COMMON) += octeon2-common.o
-obj-$(CONFIG_MIPS_ALCHEMY)	+= alchemy-common.o
 obj-$(CONFIG_USB_HCD_BCMA)	+= bcma-hcd.o
 obj-$(CONFIG_USB_HCD_SSB)	+= ssb-hcd.o
-- 
1.7.9.5

