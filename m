Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310Ab1IBJtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 05:49:50 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:57148 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933142Ab1IBJtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 05:49:40 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.13 with qID p829nYHs008316, This message is released by code: ctlocs8528
From: Hayes Wang <hayeswang@realtek.com>
To: <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v4 3/4] r8169: fix the reset setting for 8111evl
Date: Fri, 2 Sep 2011 17:49:12 +0800
X-BOX-Message-Id: p829nYHs008316
Message-ID: <1314956953-1568-3-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314956953-1568-1-git-send-email-hayeswang@realtek.com>
References: <1314956953-1568-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtl8111evl should stop any TLP requirement before resetting by
enabling register 0x37 bit 7.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/ethernet/realtek/r8169.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index db5ab2c..175c769 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -3997,6 +3997,7 @@ static void rtl8169_hw_reset(struct rtl8169_private *tp)
 		while (RTL_R8(TxPoll) & NPQ)
 			udelay(20);
 	} else if (tp->mac_version == RTL_GIGA_MAC_VER_34) {
+		RTL_W8(ChipCmd, RTL_R8(ChipCmd) | StopReq);
 		while (!(RTL_R32(TxConfig) & TXCFG_EMPTY))
 			udelay(100);
 	} else {
-- 
1.7.6

