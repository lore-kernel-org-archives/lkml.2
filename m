Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab1LGNjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 08:39:36 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:64172 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab1LGNhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 08:37:23 -0500
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH v2 3/8][NET] fec.c: prevent dobule restart of interface on FDX/HDX change
Date: Wed,  7 Dec 2011 14:37:15 +0100
Message-Id: <0b92136d69e509a6ce49b526e1834f0ec90b04a4.1323256319.git.LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <6c28f25c5c6d2f88d0985ce361c5e16f19db27d0.1323256319.git.LW@KARO-electronics.de>
References: <cover.1323256319.git.LW@KARO-electronics.de>
 <bd4415514fa0b40ece04d56b3ac4f549e79d87d7.1323256319.git.LW@KARO-electronics.de>
 <6c28f25c5c6d2f88d0985ce361c5e16f19db27d0.1323256319.git.LW@KARO-electronics.de>
In-Reply-To: <cover.1323256319.git.LW@KARO-electronics.de>
References: <cover.1323256319.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upon detection of a FDX/HDX change the interface is restarted twice.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/net/ethernet/freescale/fec.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.c b/drivers/net/ethernet/freescale/fec.c
index 65ee506..7ef408f 100644
--- a/drivers/net/ethernet/freescale/fec.c
+++ b/drivers/net/ethernet/freescale/fec.c
@@ -865,6 +865,8 @@ static void fec_enet_adjust_link(struct net_device *ndev)
 	if (phy_dev->link) {
 		if (fep->full_duplex != phy_dev->duplex) {
 			fec_restart(ndev, phy_dev->duplex);
+			/* prevent unnecessary second fec_restart() below */
+			fep->link = phy_dev->link;
 			status_change = 1;
 		}
 	}
-- 
1.5.6.5

