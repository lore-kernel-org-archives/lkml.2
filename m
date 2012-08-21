Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab2HUSqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 14:46:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33367 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab2HUSpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 14:45:20 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 5/8] netdev: octeon_mgmt: Set the parent device.
Date: Tue, 21 Aug 2012 11:45:09 -0700
Message-Id: <1345574712-21444-6-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1345574712-21444-1-git-send-email-ddaney.cavm@gmail.com>
References: <1345574712-21444-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

This establishes useful links in sysfs.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 drivers/net/ethernet/octeon/octeon_mgmt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/octeon/octeon_mgmt.c b/drivers/net/ethernet/octeon/octeon_mgmt.c
index cf06cf2..3bae01f 100644
--- a/drivers/net/ethernet/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/octeon/octeon_mgmt.c
@@ -1446,6 +1446,8 @@ static int __devinit octeon_mgmt_probe(struct platform_device *pdev)
 	if (netdev == NULL)
 		return -ENOMEM;
 
+	SET_NETDEV_DEV(netdev, &pdev->dev);
+
 	dev_set_drvdata(&pdev->dev, netdev);
 	p = netdev_priv(netdev);
 	netif_napi_add(netdev, &p->napi, octeon_mgmt_napi_poll,
-- 
1.7.11.4

