Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab2D3F7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 01:59:09 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:43504 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165Ab2D3F7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 01:59:05 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Doug Thompson <dougthompson@xmission.com>
Cc: kernel-janitors@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/edac/i3200_edac.c: add missing iounmap
Date: Mon, 30 Apr 2012 07:58:58 +0200
Message-Id: <1335765538-30399-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Add iounmap in the case where window has already been allocated.
Reorganize the error handling code at the end of the function so that if is
not needed.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/edac/i3200_edac.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index 046808c..55c4336 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -338,8 +338,10 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 
 	mci = edac_mc_alloc(sizeof(struct i3200_priv), I3200_RANKS,
 		nr_channels, 0);
-	if (!mci)
-		return -ENOMEM;
+	if (!mci) {
+		rc = -ENOMEM;
+		goto fail_alloc;
+	}
 
 	debugf3("MC: %s(): init mci\n", __func__);
 
@@ -404,9 +406,9 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 	return 0;
 
 fail:
+	edac_mc_free(mci);
+fail_alloc:
 	iounmap(window);
-	if (mci)
-		edac_mc_free(mci);
 
 	return rc;
 }

