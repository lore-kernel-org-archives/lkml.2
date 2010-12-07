Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab0LGLJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 06:09:20 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:34366 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752505Ab0LGLJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 06:09:18 -0500
Message-ID: <4CFE1685.5090208@dsn.okisemi.com>
Date: Tue, 07 Dec 2010 20:12:05 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Wolfgang Grandegger <wg@grandegger.com>, socketcan-core@lists.berlios.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
CC: qi.wang@intel.com, yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com, margie.foster@intel.com
Subject: [PATCH net-next-2.6 v8 19/20] CAN : Add setting TEC/REC statistics
 processing
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add setting TEC/REC statistics processing.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/net/can/pch_can.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index dcd8f00..4697b1c 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -568,6 +568,9 @@ static void pch_can_error(struct net_device *ndev, u32 status)
 		break;
 	}
 
+	cf->data[6] = errc & PCH_TEC;
+	cf->data[7] = (errc & PCH_REC) >> 8;
+
 	priv->can.state = state;
 	netif_rx(skb);
 
-- 
1.6.0.6
