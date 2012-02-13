Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab2BMBOu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 20:14:50 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39946 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab2BMBOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 20:14:48 -0500
Message-ID: <1329095679.3066.1.camel@phoenix>
Subject: [PATCH] mlx4: Fix kcalloc parameters swapped
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>, netdev@vger.kernel.org
Date: Mon, 13 Feb 2012 09:14:39 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first parameter should be "number of elements" and the second parameter
should be "element size".

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx4/eq.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/eq.c b/drivers/net/ethernet/mellanox/mlx4/eq.c
index 55d7bd4..8fa41f3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/eq.c
@@ -815,8 +815,9 @@ int mlx4_init_eq_table(struct mlx4_dev *dev)
 	int err;
 	int i;
 
-	priv->eq_table.uar_map = kcalloc(sizeof *priv->eq_table.uar_map,
-					 mlx4_num_eq_uar(dev), GFP_KERNEL);
+	priv->eq_table.uar_map = kcalloc(mlx4_num_eq_uar(dev),
+					 sizeof *priv->eq_table.uar_map,
+					 GFP_KERNEL);
 	if (!priv->eq_table.uar_map) {
 		err = -ENOMEM;
 		goto err_out_free;
-- 
1.7.5.4



