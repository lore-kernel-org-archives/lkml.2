Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab2D3FrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 01:47:01 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:37048 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510Ab2D3FrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 01:47:00 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Doug Thompson <dougthompson@xmission.com>
Cc: kernel-janitors@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/edac/i82875p_edac.c: eliminate double definition
Date: Mon, 30 Apr 2012 07:46:52 +0200
Message-Id: <1335764812-29927-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The first thing that i82875p_setup_overfl_dev does is overwrite the value
of ovrfl_pdev and perform the same call to pci_get_device as is done here.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/edac/i82875p_edac.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/edac/i82875p_edac.c b/drivers/edac/i82875p_edac.c
index 10f15d8..22ecc54 100644
--- a/drivers/edac/i82875p_edac.c
+++ b/drivers/edac/i82875p_edac.c
@@ -391,8 +391,6 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 
 	debugf0("%s()\n", __func__);
 
-	ovrfl_pdev = pci_get_device(PCI_VEND_DEV(INTEL, 82875_6), NULL);
-
 	if (i82875p_setup_overfl_dev(pdev, &ovrfl_pdev, &ovrfl_window))
 		return -ENODEV;
 	drc = readl(ovrfl_window + I82875P_DRC);

