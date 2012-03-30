Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966387Ab2C3Vev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:34:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38694 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966295Ab2C3Vcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:32:48 -0400
X-Sasl-enc: Pkg7dRYde/oz8gpiBpj/LdxD5/6qXlVx6oL89cXtqTEs 1333143166
X-Mailbox-Line: From gregkh@linuxfoundation.org Fri Mar 30 12:49:01 2012
Message-Id: <20120330194901.094873801@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:51:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stephen Warren <swarren@wwwdotorg.org>
Subject: [ 174/175] ARM: tegra: Fix device tree AUXDATA for USB/EHCI
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@wwwdotorg.org>

commit 8c3ec84102d171a24f050a086bfc546e9de93f9f upstream.

Commit 4a53f4e "USB: ehci-tegra: add probing through device tree" added
AUXDATA for Tegra's USB/EHCI controller. However, it pointed the platform
data at a location containing the address of the intended platform data,
rather than the platform data itself. This change fixes that.

Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-tegra/board-dt-tegra20.c |    6 +++---
 arch/arm/mach-tegra/devices.c          |    7 +++----
 arch/arm/mach-tegra/devices.h          |    5 +++++
 3 files changed, 11 insertions(+), 7 deletions(-)

--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@ -68,11 +68,11 @@ struct of_dev_auxdata tegra20_auxdata_lo
 	OF_DEV_AUXDATA("nvidia,tegra20-i2s", TEGRA_I2S2_BASE, "tegra-i2s.1", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-das", TEGRA_APB_MISC_DAS_BASE, "tegra-das", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-ehci", TEGRA_USB_BASE, "tegra-ehci.0",
-		       &tegra_ehci1_device.dev.platform_data),
+		       &tegra_ehci1_pdata),
 	OF_DEV_AUXDATA("nvidia,tegra20-ehci", TEGRA_USB2_BASE, "tegra-ehci.1",
-		       &tegra_ehci2_device.dev.platform_data),
+		       &tegra_ehci2_pdata),
 	OF_DEV_AUXDATA("nvidia,tegra20-ehci", TEGRA_USB3_BASE, "tegra-ehci.2",
-		       &tegra_ehci3_device.dev.platform_data),
+		       &tegra_ehci3_pdata),
 	{}
 };
 
--- a/arch/arm/mach-tegra/devices.c
+++ b/arch/arm/mach-tegra/devices.c
@@ -23,7 +23,6 @@
 #include <linux/fsl_devices.h>
 #include <linux/serial_8250.h>
 #include <linux/i2c-tegra.h>
-#include <linux/platform_data/tegra_usb.h>
 #include <asm/pmu.h>
 #include <mach/irqs.h>
 #include <mach/iomap.h>
@@ -446,18 +445,18 @@ static struct tegra_ulpi_config tegra_eh
 	.clk = "cdev2",
 };
 
-static struct tegra_ehci_platform_data tegra_ehci1_pdata = {
+struct tegra_ehci_platform_data tegra_ehci1_pdata = {
 	.operating_mode = TEGRA_USB_OTG,
 	.power_down_on_bus_suspend = 1,
 };
 
-static struct tegra_ehci_platform_data tegra_ehci2_pdata = {
+struct tegra_ehci_platform_data tegra_ehci2_pdata = {
 	.phy_config = &tegra_ehci2_ulpi_phy_config,
 	.operating_mode = TEGRA_USB_HOST,
 	.power_down_on_bus_suspend = 1,
 };
 
-static struct tegra_ehci_platform_data tegra_ehci3_pdata = {
+struct tegra_ehci_platform_data tegra_ehci3_pdata = {
 	.operating_mode = TEGRA_USB_HOST,
 	.power_down_on_bus_suspend = 1,
 };
--- a/arch/arm/mach-tegra/devices.h
+++ b/arch/arm/mach-tegra/devices.h
@@ -20,6 +20,11 @@
 #define __MACH_TEGRA_DEVICES_H
 
 #include <linux/platform_device.h>
+#include <linux/platform_data/tegra_usb.h>
+
+extern struct tegra_ehci_platform_data tegra_ehci1_pdata;
+extern struct tegra_ehci_platform_data tegra_ehci2_pdata;
+extern struct tegra_ehci_platform_data tegra_ehci3_pdata;
 
 extern struct platform_device tegra_gpio_device;
 extern struct platform_device tegra_pinmux_device;


