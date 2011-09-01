Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab1IAGyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 02:54:35 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:60663 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab1IAGyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 02:54:19 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.13 with qID p816sCxt030440, This message is released by code: ctlocs8528
From: Hayes Wang <hayeswang@realtek.com>
To: <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v2 1/4] r8169: fix WOL setting for 8105 and 8111EVL
Date: Thu, 1 Sep 2011 14:53:51 +0800
X-BOX-Message-Id: p816sCxt030440
Message-ID: <1314860034-3911-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.7.6
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtl8105, rtl8111E, and rtl8111evl need enable RxConfig bit 1 ~ 3
for supporting wake on lan.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/ethernet/realtek/r8169.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 1cf8c3c..764c98e 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -3322,6 +3322,11 @@ static void r810x_pll_power_down(struct rtl8169_private *tp)
 	if (__rtl8169_get_wol(tp) & WAKE_ANY) {
 		rtl_writephy(tp, 0x1f, 0x0000);
 		rtl_writephy(tp, MII_BMCR, 0x0000);
+
+		if (tp->mac_version == RTL_GIGA_MAC_VER_29 ||
+		    tp->mac_version == RTL_GIGA_MAC_VER_30)
+			RTL_W32(RxConfig, RTL_R32(RxConfig) | AcceptBroadcast |
+				AcceptMulticast | AcceptMyPhys);
 		return;
 	}
 
@@ -3417,7 +3422,8 @@ static void r8168_pll_power_down(struct rtl8169_private *tp)
 		rtl_writephy(tp, MII_BMCR, 0x0000);
 
 		if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
-		    tp->mac_version == RTL_GIGA_MAC_VER_33)
+		    tp->mac_version == RTL_GIGA_MAC_VER_33 ||
+		    tp->mac_version == RTL_GIGA_MAC_VER_34)
 			RTL_W32(RxConfig, RTL_R32(RxConfig) | AcceptBroadcast |
 				AcceptMulticast | AcceptMyPhys);
 		return;
-- 
1.7.6

