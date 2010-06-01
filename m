Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab0FADXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:23:33 -0400
Received: from mail.perches.com ([173.55.12.10]:2478 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566Ab0FADX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:23:29 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Subject: [PATCH 10/21] drivers/net/gianfar.c: Remove unnecessary kmalloc casts
Date: Mon, 31 May 2010 20:23:12 -0700
Message-Id: <787b5a04a6f7f854b0809c4358671d3d69f70efc.1275360951.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
In-Reply-To: <cover.1275360951.git.joe@perches.com>
References: <cover.1275360951.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/gianfar.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
index 1830f31..ab54821 100644
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -681,8 +681,8 @@ static int gfar_of_init(struct of_device *ofdev, struct net_device **pdev)
 		priv->rx_queue[i] = NULL;
 
 	for (i = 0; i < priv->num_tx_queues; i++) {
-		priv->tx_queue[i] =  (struct gfar_priv_tx_q *)kzalloc(
-				sizeof (struct gfar_priv_tx_q), GFP_KERNEL);
+		priv->tx_queue[i] = kzalloc(sizeof(struct gfar_priv_tx_q),
+					    GFP_KERNEL);
 		if (!priv->tx_queue[i]) {
 			err = -ENOMEM;
 			goto tx_alloc_failed;
@@ -694,8 +694,8 @@ static int gfar_of_init(struct of_device *ofdev, struct net_device **pdev)
 	}
 
 	for (i = 0; i < priv->num_rx_queues; i++) {
-		priv->rx_queue[i] = (struct gfar_priv_rx_q *)kzalloc(
-					sizeof (struct gfar_priv_rx_q), GFP_KERNEL);
+		priv->rx_queue[i] = kzalloc(sizeof(struct gfar_priv_rx_q),
+					    GFP_KERNEL);
 		if (!priv->rx_queue[i]) {
 			err = -ENOMEM;
 			goto rx_alloc_failed;
-- 
1.7.0.3.311.g6a6955

