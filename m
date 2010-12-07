Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab0LGLFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 06:05:33 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:18283 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755360Ab0LGLFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 06:05:32 -0500
Message-ID: <4CFE15A2.5010601@dsn.okisemi.com>
Date: Tue, 07 Dec 2010 20:08:18 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Wolfgang Grandegger <wg@grandegger.com>, socketcan-core@lists.berlios.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
CC: qi.wang@intel.com, yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com, margie.foster@intel.com
Subject: [PATCH net-next-2.6 v8 10/20] CAN : Replace netdev_dbg instead of
 dev_dbg partly
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For easy to readable, use netdev_dbg instead of dev_dbg partly

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/net/can/pch_can.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index 293be51..0093a01 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -222,7 +222,7 @@ static void pch_can_set_run_mode(struct pch_can_priv *priv,
 		break;
 
 	default:
-		dev_err(&priv->ndev->dev, "%s -> Invalid Mode.\n", __func__);
+		netdev_err(priv->ndev, "%s -> Invalid Mode.\n", __func__);
 		break;
 	}
 }
@@ -275,7 +275,7 @@ static void pch_can_set_int_enables(struct pch_can_priv *priv,
 		break;
 
 	default:
-		dev_err(&priv->ndev->dev, "Invalid interrupt number.\n");
+		netdev_err(priv->ndev, "Invalid interrupt number.\n");
 		break;
 	}
 }
@@ -528,7 +528,7 @@ static void pch_can_error(struct net_device *ndev, u32 status)
 			cf->data[1] |= CAN_ERR_CRTL_RX_WARNING;
 		if ((errc & PCH_TEC) > 96)
 			cf->data[1] |= CAN_ERR_CRTL_TX_WARNING;
-		dev_warn(&ndev->dev,
+		netdev_dbg(ndev,
 			"%s -> Error Counter is more than 96.\n", __func__);
 	}
 	/* Error passive interrupt. */
@@ -540,7 +540,7 @@ static void pch_can_error(struct net_device *ndev, u32 status)
 			cf->data[1] |= CAN_ERR_CRTL_RX_PASSIVE;
 		if ((errc & PCH_TEC) > 127)
 			cf->data[1] |= CAN_ERR_CRTL_TX_PASSIVE;
-		dev_err(&ndev->dev,
+		netdev_dbg(ndev,
 			"%s -> CAN controller is ERROR PASSIVE .\n", __func__);
 	}
 
@@ -859,10 +859,10 @@ static int pch_can_open(struct net_device *ndev)
 
 	retval = pci_enable_msi(priv->dev);
 	if (retval) {
-		dev_info(&ndev->dev, "PCH CAN opened without MSI\n");
+		netdev_err(ndev, "PCH CAN opened without MSI\n");
 		priv->use_msi = 0;
 	} else {
-		dev_info(&ndev->dev, "PCH CAN opened with MSI\n");
+		netdev_err(ndev, "PCH CAN opened with MSI\n");
 		priv->use_msi = 1;
 	}
 
@@ -870,14 +870,14 @@ static int pch_can_open(struct net_device *ndev)
 	retval = request_irq(priv->dev->irq, pch_can_interrupt, IRQF_SHARED,
 			     ndev->name, ndev);
 	if (retval) {
-		dev_err(&ndev->dev, "request_irq failed.\n");
+		netdev_err(ndev, "request_irq failed.\n");
 		goto req_irq_err;
 	}
 
 	/* Open common can device */
 	retval = open_candev(ndev);
 	if (retval) {
-		dev_err(ndev->dev.parent, "open_candev() failed %d\n", retval);
+		netdev_err(ndev, "open_candev() failed %d\n", retval);
 		goto err_open_candev;
 	}
 
-- 
1.6.0.6
