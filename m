Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab1GFH6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 03:58:55 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:45959 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab1GFH6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 03:58:49 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.11 with qID p667wiYe003443
From: Hayes Wang <hayeswang@realtek.com>
To: <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v2 6/7] r8169: fix wake on lan setting for non-8111E
Date: Wed, 6 Jul 2011 15:58:07 +0800
X-BOX-Message-Id: p667wiYe003443
Message-ID: <1309939088-31994-6-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1309939088-31994-1-git-send-email-hayeswang@realtek.com>
References: <1309939088-31994-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only 8111E needs enable RxConfig bit 0 ~ 3 when suspending or
shutdowning when supporting wake on lan.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/r8169.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 6bfabe2..8551848 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -3390,8 +3390,10 @@ static void r8168_pll_power_down(struct rtl8169_private *tp)
 		rtl_writephy(tp, 0x1f, 0x0000);
 		rtl_writephy(tp, MII_BMCR, 0x0000);
 
-		RTL_W32(RxConfig, RTL_R32(RxConfig) |
-			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
+		if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
+		    tp->mac_version == RTL_GIGA_MAC_VER_33)
+			RTL_W32(RxConfig, RTL_R32(RxConfig) | AcceptBroadcast |
+				AcceptMulticast | AcceptMyPhys);
 		return;
 	}
 
-- 
1.7.3.2

