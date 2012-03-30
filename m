Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936768Ab2C3XBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:01:53 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:42716 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934789Ab2C3XBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 19:01:45 -0400
Message-Id: <201203302301.q2UN1hj1011357@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 30 Mar 2012 18:58:37 -0400
Subject: [PATCH] edac: say "TILEGx" not "TILEPro" for the tilegx edac driver
To: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
X-OriginalArrivalTime: 30 Mar 2012 23:01:43.0553 (UTC) FILETIME=[131D8710:01CD0EC9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just an aesthetic change but it was silly to say TILEPro
when booting up on the tilegx architecture.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 drivers/edac/tile_edac.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/tile_edac.c b/drivers/edac/tile_edac.c
index 1d5cf06..e99d009 100644
--- a/drivers/edac/tile_edac.c
+++ b/drivers/edac/tile_edac.c
@@ -145,7 +145,11 @@ static int __devinit tile_edac_mc_probe(struct platform_device *pdev)
 	mci->edac_ctl_cap = EDAC_FLAG_SECDED;
 
 	mci->mod_name = DRV_NAME;
+#ifdef __tilegx__
+	mci->ctl_name = "TILEGx_Memory_Controller";
+#else
 	mci->ctl_name = "TILEPro_Memory_Controller";
+#endif
 	mci->dev_name = dev_name(&pdev->dev);
 	mci->edac_check = tile_edac_check;
 
-- 
1.6.5.2

