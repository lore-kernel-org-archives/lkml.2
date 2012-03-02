Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380Ab2CBU6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 15:58:51 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46793 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759364Ab2CBU6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 15:58:43 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of alan@signal11.us designates 10.236.136.33 as permitted sender) smtp.mail=alan@signal11.us
MIME-Version: 1.0
From: Alan Ott <alan@signal11.us>
To: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Ott <alan@signal11.us>
Subject: [PATCH v2 6/6] ARM: tegra: export usb phy symbols
Date: Fri,  2 Mar 2012 15:58:42 -0500
Message-Id: <1330721922-8861-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The ehci driver can be a module, so the functions provided
by the tegra platform code used by ehci-tegra need to
be exported.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alan Ott <alan@signal11.us>
---
 arch/arm/mach-tegra/usb_phy.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/usb_phy.c b/arch/arm/mach-tegra/usb_phy.c
index 37576a7..6091cf3 100644
--- a/arch/arm/mach-tegra/usb_phy.c
+++ b/arch/arm/mach-tegra/usb_phy.c
@@ -22,6 +22,7 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/err.h>
+#include <linux/export.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/gpio.h>
@@ -730,6 +731,7 @@ err0:
 	kfree(phy);
 	return ERR_PTR(err);
 }
+EXPORT_SYMBOL_GPL(tegra_usb_phy_open);
 
 int tegra_usb_phy_power_on(struct tegra_usb_phy *phy)
 {
@@ -738,6 +740,7 @@ int tegra_usb_phy_power_on(struct tegra_usb_phy *phy)
 	else
 		return utmi_phy_power_on(phy);
 }
+EXPORT_SYMBOL_GPL(tegra_usb_phy_power_on);
 
 void tegra_usb_phy_power_off(struct tegra_usb_phy *phy)
 {
@@ -746,18 +749,21 @@ void tegra_usb_phy_power_off(struct tegra_usb_phy *phy)
 	else
 		utmi_phy_power_off(phy);
 }
+EXPORT_SYMBOL_GPL(tegra_usb_phy_power_off);
 
 void tegra_usb_phy_preresume(struct tegra_usb_phy *phy)
 {
 	if (!phy_is_ulpi(phy))
 		utmi_phy_preresume(phy);
 }
+EXPORT_SYMBOL_GPL(tegra_usb_phy_preresume);
 
 void tegra_usb_phy_postresume(struct tegra_usb_phy *phy)
 {
 	if (!phy_is_ulpi(phy))
 		utmi_phy_postresume(phy);
 }
+EXPORT_SYMBOL_GPL(tegra_usb_phy_postresume);
 
 void tegra_ehci_phy_restore_start(struct tegra_usb_phy *phy,
 				 enum tegra_usb_phy_port_speed port_speed)
@@ -765,24 +771,28 @@ void tegra_ehci_phy_restore_start(struct tegra_usb_phy *phy,
 	if (!phy_is_ulpi(phy))
 		utmi_phy_restore_start(phy, port_speed);
 }
+EXPORT_SYMBOL_GPL(tegra_ehci_phy_restore_start);
 
 void tegra_ehci_phy_restore_end(struct tegra_usb_phy *phy)
 {
 	if (!phy_is_ulpi(phy))
 		utmi_phy_restore_end(phy);
 }
+EXPORT_SYMBOL_GPL(tegra_ehci_phy_restore_end);
 
 void tegra_usb_phy_clk_disable(struct tegra_usb_phy *phy)
 {
 	if (!phy_is_ulpi(phy))
 		utmi_phy_clk_disable(phy);
 }
+EXPORT_SYMBOL_GPL(tegra_usb_phy_clk_disable);
 
 void tegra_usb_phy_clk_enable(struct tegra_usb_phy *phy)
 {
 	if (!phy_is_ulpi(phy))
 		utmi_phy_clk_enable(phy);
 }
+EXPORT_SYMBOL_GPL(tegra_usb_phy_clk_enable);
 
 void tegra_usb_phy_close(struct tegra_usb_phy *phy)
 {
@@ -794,3 +804,4 @@ void tegra_usb_phy_close(struct tegra_usb_phy *phy)
 	clk_put(phy->pll_u);
 	kfree(phy);
 }
+EXPORT_SYMBOL_GPL(tegra_usb_phy_close);
-- 
1.7.0.4

