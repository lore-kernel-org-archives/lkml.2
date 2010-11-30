Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab0K3EgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 23:36:00 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:34347 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753034Ab0K3Ef7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 23:35:59 -0500
Message-ID: <4CF47F0F.9000604@dsn.okisemi.com>
Date: Tue, 30 Nov 2010 13:35:27 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Wolfgang Grandegger <wg@grandegger.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        Barry Song <21cnbao@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
CC: qi.wang@intel.com, yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com, margie.foster@intel.com
Subject: [PATCH net-next-2.6 v6 14/20] can: EG20T PCH: Fix miss-setting status
 issue
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify miss-setting status issue at suspend.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/net/can/pch_can.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index b57b505..1009d9b 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -1073,7 +1073,7 @@ static int pch_can_suspend(struct pci_dev *pdev, pm_message_t state)
 	pch_can_set_run_mode(priv, PCH_CAN_STOP);
 
 	/* Indicate that we are aboutto/in suspend */
-	priv->can.state = CAN_STATE_SLEEPING;
+	priv->can.state = CAN_STATE_STOPPED;
 
 	/* Waiting for all transmission to complete. */
 	while (counter) {
-- 
1.6.0.6

