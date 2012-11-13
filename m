Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab2KMVLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 16:11:44 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:49574 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755857Ab2KMVLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 16:11:43 -0500
X-Greylist: delayed 795 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Nov 2012 16:11:42 EST
From: Simon Marchi <simon.marchi@polymtl.ca>
To: cmetcalf@tilera.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Simon Marchi <simon.marchi@polymtl.ca>
Subject: [PATCH] tilegx: request_irq with a non-null device name
Date: Tue, 13 Nov 2012 15:58:20 -0500
Message-Id: <1352840300-27814-1-git-send-email-simon.marchi@polymtl.ca>
X-Mailer: git-send-email 1.7.1
X-Poly-FromMTA: ([132.207.72.18]) at Tue, 13 Nov 2012 20:58:21 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simply makes the tilegx net driver call request_irq with a
non-null name. It makes the output in /proc/interrupts more obvious, but
also helps tools that don't expect to find null there.

Signed-off-by: Simon Marchi <simon.marchi@polymtl.ca>
---
 drivers/net/ethernet/tile/tilegx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/tile/tilegx.c b/drivers/net/ethernet/tile/tilegx.c
index 4e98100..66e025a 100644
--- a/drivers/net/ethernet/tile/tilegx.c
+++ b/drivers/net/ethernet/tile/tilegx.c
@@ -917,7 +917,7 @@ static int tile_net_setup_interrupts(struct net_device *dev)
 	ingress_irq = rc;
 	tile_irq_activate(ingress_irq, TILE_IRQ_PERCPU);
 	rc = request_irq(ingress_irq, tile_net_handle_ingress_irq,
-			 0, NULL, NULL);
+			 0, "tile_net", NULL);
 	if (rc != 0) {
 		netdev_err(dev, "request_irq failed: %d\n", rc);
 		destroy_irq(ingress_irq);
-- 
1.7.1

