Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab1BHJ1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 04:27:49 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:30994 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752670Ab1BHJ1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 04:27:47 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: wg@grandegger.com, socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 3/3] pch_can: fix module reload issue with MSI
Date: Tue,  8 Feb 2011 18:29:03 +0900
Message-Id: <1297157343-3213-3-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1297157343-3213-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1297157343-3213-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, in case reload pch_can,
pch_can not to be able to catch interrupt.

The cause is bus-master is not set in pch_can.
Thus, add enabling bus-master processing.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/net/can/pch_can.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index 342d514..7d8bc12 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -1238,6 +1238,7 @@ static int __devinit pch_can_probe(struct pci_dev *pdev,
 		priv->use_msi = 0;
 	} else {
 		netdev_err(ndev, "PCH CAN opened with MSI\n");
+		pci_set_master(pdev);
 		priv->use_msi = 1;
 	}
 
-- 
1.7.3.4

