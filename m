Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab2AaGhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 01:37:22 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42277 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab2AaGhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 01:37:19 -0500
From: "Devendra.Naga" <devendra.aaru@gmail.com>
To: <Larry.Finger@lwfinger.net>, <chaoming_li@realsil.com.cn>,
        <linville@tuxdriver.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Devendra.Naga" <devendra.aaru@gmail.com>
Subject: [PATCH] rtlwifi: remove return in _rtl_pci_switch_clk_req
Date: Tue, 31 Jan 2012 01:28:15 -0500
Message-Id: <1327991295-6258-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Devendra.Naga" <devendra.aaru@gmail.com>

the return value from _rtl_pci_switch_clk_req is not used by any of its callers.

Signed-off-by: Devendra.Naga <devendra.aaru@gmail.com>
---
 drivers/net/wireless/rtlwifi/pci.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 5cb2199..9a01909 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -198,7 +198,7 @@ static bool _rtl_pci_platform_switch_device_pci_aspm(
 }
 
 /*When we set 0x01 to enable clk request. Set 0x0 to disable clk req.*/
-static bool _rtl_pci_switch_clk_req(struct ieee80211_hw *hw, u8 value)
+static void _rtl_pci_switch_clk_req(struct ieee80211_hw *hw, u8 value)
 {
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
@@ -207,8 +207,6 @@ static bool _rtl_pci_switch_clk_req(struct ieee80211_hw *hw, u8 value)
 
 	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192SE)
 		udelay(100);
-
-	return true;
 }
 
 /*Disable RTL8192SE ASPM & Disable Pci Bridge ASPM*/
-- 
1.7.5.4

