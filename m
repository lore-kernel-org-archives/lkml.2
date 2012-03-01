Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965003Ab2CAT20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:28:26 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43743 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964994Ab2CAT1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:27:33 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of alan@signal11.us designates 10.236.181.233 as permitted sender) smtp.mail=alan@signal11.us
MIME-Version: 1.0
From: Alan Ott <alan@signal11.us>
To: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 7/8] ARM: tegra: export usb phy symbols
Date: Thu,  1 Mar 2012 14:26:49 -0500
Message-Id: <1330630010-11241-8-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1330630010-11241-1-git-send-email-alan@signal11.us>
References: <1330630010-11241-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The ehci driver can be a module, so the functions provided
by the tegra platform code used by ehci-tegra need to
be exported.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-tegra/usb_phy.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/usb_phy.c b/arch/arm/mach-tegra/usb_phy.c
index 37576a7..3c45264 100644
--- a/arch/arm/mach-tegra/usb_phy.c
+++ b/arch/arm/mach-tegra/usb_phy.c
@@ -730,6 +730,7 @@ err0:
 	kfree(phy);
 	return ERR_PTR(err);
 }
+EXPORT_SYMBOL_GPL(tegra_usb_phy_open);
 
 int tegra_usb_phy_power_on(struct tegra_usb_phy *phy)
 {
@@ -738,6 +739,7 @@ int tegra_usb_phy_power_on(struct tegra_usb_phy *phy)
 	else
 		return utmi_phy_power_on(phy);
 }
+EXPORT_SYMBOL_GPL(tegra_usb_phy_power_on);
 
 void tegra_usb_phy_power_off(struct tegra_usb_phy *phy)
 {
@@ -746,18 +748,21 @@ void tegra_usb_phy_power_off(struct tegra_usb_phy *phy)
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
@@ -765,24 +770,28 @@ void tegra_ehci_phy_restore_start(struct tegra_usb_phy *phy,
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
@@ -794,3 +803,4 @@ void tegra_usb_phy_close(struct tegra_usb_phy *phy)
 	clk_put(phy->pll_u);
 	kfree(phy);
 }
+EXPORT_SYMBOL_GPL(tegra_usb_phy_close);
-- 
1.7.0.4

