Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab0LMGYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:24:23 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:24402 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096Ab0LMGWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:22:04 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: wg@grandegger.com, w.sang@pengutronix.de, chripell@fsfe.org,
        21cnbao@gmail.com, sameo@linux.intel.com,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net
Cc: qi.wang@intel.com, yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com, margie.foster@intel.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH net-next-2.6 v9 12/20] pch_can: Delete unnecessary/redundant code
Date: Mon, 13 Dec 2010 15:24:18 +0900
Message-Id: <1292221467-8039-12-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1292221467-8039-11-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1292221467-8039-1-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-2-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-3-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-4-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-5-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-6-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-7-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-8-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-9-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-10-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1292221467-8039-11-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete unnecessary/redundant code

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/net/can/pch_can.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index da8d37b..3540978 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -447,11 +447,6 @@ static void pch_can_release(struct pch_can_priv *priv)
 /* This function clears interrupt(s) from the CAN device. */
 static void pch_can_int_clr(struct pch_can_priv *priv, u32 mask)
 {
-	if (mask == PCH_STATUS_INT) {
-		ioread32(&priv->regs->stat);
-		return;
-	}
-
 	/* Clear interrupt for transmit object */
 	if ((mask >= PCH_RX_OBJ_START) && (mask <= PCH_RX_OBJ_END)) {
 		/* Setting CMASK for clearing the reception interrupts. */
@@ -512,8 +507,6 @@ static void pch_can_error(struct net_device *ndev, u32 status)
 		state = CAN_STATE_BUS_OFF;
 		cf->can_id |= CAN_ERR_BUSOFF;
 		can_bus_off(ndev);
-		pch_can_set_run_mode(priv, PCH_CAN_RUN);
-		dev_err(&ndev->dev, "%s -> Bus Off occurres.\n", __func__);
 	}
 
 	errc = ioread32(&priv->regs->errc);
@@ -747,7 +740,7 @@ static int pch_can_poll(struct napi_struct *napi, int quota)
 	if (!int_stat)
 		goto end;
 
-	if ((int_stat == PCH_STATUS_INT) && (quota > 0)) {
+	if (int_stat == PCH_STATUS_INT) {
 		reg_stat = ioread32(&priv->regs->stat);
 		if (reg_stat & (PCH_BUS_OFF | PCH_LEC_ALL)) {
 			if (reg_stat & PCH_BUS_OFF ||
@@ -933,10 +926,6 @@ static netdev_tx_t pch_xmit(struct sk_buff *skb, struct net_device *ndev)
 		priv->tx_obj++;
 	}
 
-	/* Reading the Msg Obj from the Msg RAM to the Interface register. */
-	iowrite32(PCH_CMASK_RX_TX_GET, &priv->regs->ifregs[1].cmask);
-	pch_can_rw_msg_obj(&priv->regs->ifregs[1].creq, tx_obj_no);
-
 	/* Setting the CMASK register. */
 	pch_can_bit_set(&priv->regs->ifregs[1].cmask, PCH_CMASK_ALL);
 
-- 
1.6.0.6

