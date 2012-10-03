Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048Ab2JCPU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:20:29 -0400
Received: from zmc.proxad.net ([212.27.53.206]:36936 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932518Ab2JCPNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:13:52 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Kelvin Cheung <keguang.zhang@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/25] MIPS: Loongson 1B: use ehci-platform instead of ehci-ls1x.
Date: Wed,  3 Oct 2012 17:02:57 +0200
Message-Id: <1349276601-8371-3-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349276601-8371-1-git-send-email-florian@openwrt.org>
References: <1349276601-8371-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Loongson 1B EHCI driver does nothing more than what the EHCI platform
driver already does, so use the generic implementation.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 arch/mips/configs/ls1b_defconfig      |    1 +
 arch/mips/loongson1/common/platform.c |    8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/mips/configs/ls1b_defconfig b/arch/mips/configs/ls1b_defconfig
index 80cff8b..7eb7554 100644
--- a/arch/mips/configs/ls1b_defconfig
+++ b/arch/mips/configs/ls1b_defconfig
@@ -76,6 +76,7 @@ CONFIG_HID_GENERIC=m
 CONFIG_USB=y
 CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
 CONFIG_USB_EHCI_HCD=y
+CONFIG_USB_EHCI_HCD_PLATFORM=y
 # CONFIG_USB_EHCI_TT_NEWSCHED is not set
 CONFIG_USB_STORAGE=m
 CONFIG_USB_SERIAL=m
diff --git a/arch/mips/loongson1/common/platform.c b/arch/mips/loongson1/common/platform.c
index e92d59c..2874bf2 100644
--- a/arch/mips/loongson1/common/platform.c
+++ b/arch/mips/loongson1/common/platform.c
@@ -13,6 +13,7 @@
 #include <linux/phy.h>
 #include <linux/serial_8250.h>
 #include <linux/stmmac.h>
+#include <linux/usb/ehci_pdriver.h>
 #include <asm-generic/sizes.h>
 
 #include <loongson1.h>
@@ -107,13 +108,18 @@ static struct resource ls1x_ehci_resources[] = {
 	},
 };
 
+static struct usb_ehci_pdata ls1x_ehci_pdata = {
+	.port_power_off	= 1,
+};
+
 struct platform_device ls1x_ehci_device = {
-	.name		= "ls1x-ehci",
+	.name		= "ehci-platform",
 	.id		= -1,
 	.num_resources	= ARRAY_SIZE(ls1x_ehci_resources),
 	.resource	= ls1x_ehci_resources,
 	.dev		= {
 		.dma_mask = &ls1x_ehci_dmamask,
+		.platform_data = &ls1x_ehci_pdata,
 	},
 };
 
-- 
1.7.9.5

