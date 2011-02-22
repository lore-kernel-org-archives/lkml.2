Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab1BVGoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 01:44:34 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:51554 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab1BVGoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 01:44:14 -0500
From: Hayes Wang <hayeswang@realtek.com>
To: <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH 3/5] r8169: fix the wrong parameter of point address
Date: Tue, 22 Feb 2011 14:41:55 +0800
X-BOX-Message-Id: p1M6i428013284
Message-ID: <1298356917-486-3-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1298356917-486-1-git-send-email-hayeswang@realtek.com>
References: <1298356917-486-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct the parameter of rtl8168_oob_notify. It results in the
wrong point address and influences RTL8168DP.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/r8169.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 5d89f89..ff66aa6 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -629,8 +629,9 @@ static void ocp_write(struct rtl8169_private *tp, u8 mask, u16 reg, u32 data)
 	}
 }
 
-static void rtl8168_oob_notify(void __iomem *ioaddr, u8 cmd)
+static void rtl8168_oob_notify(struct rtl8169_private *tp, u8 cmd)
 {
+	void __iomem *ioaddr = tp->mmio_addr;
 	int i;
 
 	RTL_W8(ERIDR, cmd);
@@ -642,7 +643,7 @@ static void rtl8168_oob_notify(void __iomem *ioaddr, u8 cmd)
 			break;
 	}
 
-	ocp_write(ioaddr, 0x1, 0x30, 0x00000001);
+	ocp_write(tp, 0x1, 0x30, 0x00000001);
 }
 
 #define OOB_CMD_RESET		0x00
-- 
1.7.3.2

