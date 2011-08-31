Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab1HaQSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 12:18:17 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:40800 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab1HaQSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 12:18:13 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.13 with qID p7VGI8at013209, This message is released by code: ctlocs8528
From: Hayes Wang <hayeswang@realtek.com>
To: <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 1/3] r8169: fix WOL setting for 8105 and 8111EVL
Date: Thu, 1 Sep 2011 00:17:57 +0800
X-BOX-Message-Id: p7VGI8at013209
Message-ID: <1314807479-1552-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.7.6
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

8105, 8111E, and 8111EVL need enable RxConfig bit 1 ~ 3 for supporting
wake on lan.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/ethernet/realtek/r8169.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 1cf8c3c..96e003a 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -3416,8 +3416,11 @@ static void r8168_pll_power_down(struct rtl8169_private *tp)
 		rtl_writephy(tp, 0x1f, 0x0000);
 		rtl_writephy(tp, MII_BMCR, 0x0000);
 
-		if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
-		    tp->mac_version == RTL_GIGA_MAC_VER_33)
+		if (tp->mac_version == RTL_GIGA_MAC_VER_29 ||
+		    tp->mac_version == RTL_GIGA_MAC_VER_30 ||
+		    tp->mac_version == RTL_GIGA_MAC_VER_32 ||
+		    tp->mac_version == RTL_GIGA_MAC_VER_33 ||
+		    tp->mac_version == RTL_GIGA_MAC_VER_34)
 			RTL_W32(RxConfig, RTL_R32(RxConfig) | AcceptBroadcast |
 				AcceptMulticast | AcceptMyPhys);
 		return;
-- 
1.7.6

