Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab1ABHZI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:25:08 -0500
Received: from mail.windriver.com ([147.11.1.11]:36826 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab1ABHZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:02 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Paul Fertser <fercerpav@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 208/260] b44: fix carrier detection on bind
Date: Sun,  2 Jan 2011 02:18:24 -0500
Message-Id: <1293952756-15010-209-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:58.0042 (UTC) FILETIME=[052123A0:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Fertser <fercerpav@gmail.com>

commit bcf64aa379fcadd074449cbf0c049da70071b06f upstream.

For carrier detection to work properly when binding the driver with a cable
unplugged, netif_carrier_off() should be called after register_netdev(),
not before.

Signed-off-by: Paul Fertser <fercerpav@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/b44.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/b44.c b/drivers/net/b44.c
index 69d9f3d..7a4d680 100644
--- a/drivers/net/b44.c
+++ b/drivers/net/b44.c
@@ -2170,8 +2170,6 @@ static int __devinit b44_init_one(struct ssb_device *sdev,
 	dev->irq = sdev->irq;
 	SET_ETHTOOL_OPS(dev, &b44_ethtool_ops);
 
-	netif_carrier_off(dev);
-
 	err = ssb_bus_powerup(sdev->bus, 0);
 	if (err) {
 		dev_err(sdev->dev,
@@ -2211,6 +2209,8 @@ static int __devinit b44_init_one(struct ssb_device *sdev,
 		goto err_out_powerdown;
 	}
 
+	netif_carrier_off(dev);
+
 	ssb_set_drvdata(sdev, dev);
 
 	/* Chip reset provides power to the b44 MAC & PCI cores, which
-- 
1.7.3.3

