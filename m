Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab0L0L1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 06:27:15 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:30127 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753531Ab0L0L1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 06:27:14 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 2/3] spi_topcliff_pch: change calling function order correctly in remove
Date: Mon, 27 Dec 2010 20:23:46 +0900
Message-Id: <1293449027-3219-2-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1293449027-3219-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1293449027-3219-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/spi/spi_topcliff_pch.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi_topcliff_pch.c b/drivers/spi/spi_topcliff_pch.c
index 18e077b..a796eaf 100644
--- a/drivers/spi/spi_topcliff_pch.c
+++ b/drivers/spi/spi_topcliff_pch.c
@@ -1166,21 +1166,21 @@ static void pch_spi_remove(struct pci_dev *pdev)
 		spin_unlock(&board_dat->data[i]->lock);
 	}
 
-	/* Free resources allocated for PCH SPI */
-	pch_spi_free_resources(board_dat);
-
 	/* Unregister SPI master */
 	for (i = 0; i < board_dat->num; i++)
 		spi_unregister_master(board_dat->data[i]->master);
 
-	/* free memory for private data */
-	kfree(board_dat);
+	/* Free resources allocated for PCH SPI */
+	pch_spi_free_resources(board_dat);
 
 	pci_set_drvdata(pdev, NULL);
 
 	/* disable PCI device */
 	pci_disable_device(pdev);
 
+	/* free memory for private data */
+	kfree(board_dat);
+
 	dev_dbg(&pdev->dev, "%s invoked pci_disable_device\n", __func__);
 }
 
-- 
1.6.0.6

