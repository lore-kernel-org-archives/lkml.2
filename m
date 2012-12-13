Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336Ab2LMOXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:23:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45012 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933277Ab2LMONd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:13:33 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nathan Walp <faceprint@faceprint.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 206/241] r8169: allow multicast packets on sub-8168f chipset.
Date: Thu, 13 Dec 2012 11:59:31 -0200
Message-Id: <1355407206-17100-207-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Walp <faceprint@faceprint.com>

commit 0481776b7a70f09acf7d9d97c288c3a8403fbfe4 upstream.

RTL_GIGA_MAC_VER_35 includes no multicast hardware filter.

Signed-off-by: Nathan Walp <faceprint@faceprint.com>
Suggested-by: Hayes Wang <hayeswang@realtek.com>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/ethernet/realtek/r8169.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index eb81da4..e19e1f1 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -4271,6 +4271,9 @@ static void rtl_set_rx_mode(struct net_device *dev)
 		mc_filter[1] = swab32(data);
 	}
 
+	if (tp->mac_version == RTL_GIGA_MAC_VER_35)
+		mc_filter[1] = mc_filter[0] = 0xffffffff;
+
 	RTL_W32(MAR0 + 4, mc_filter[1]);
 	RTL_W32(MAR0 + 0, mc_filter[0]);
 
-- 
1.7.9.5

