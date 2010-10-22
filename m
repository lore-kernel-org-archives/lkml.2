Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab0JVSa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:30:58 -0400
Received: from kroah.org ([198.145.64.141]:37776 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758929Ab0JVSZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:27 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Subject: [PATCH 08/31] pch_phub: fix build warnings
Date: Fri, 22 Oct 2010 11:24:53 -0700
Message-Id: <1287771916-15016-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes up all of the build warnings for the pch_phub driver.

Cc: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/pch_phub.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index ed56e4f..744b804 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -546,7 +546,7 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 	int retval;
 
 	int ret;
-	unsigned int rom_size;
+	ssize_t rom_size;
 	struct pch_phub_reg *chip;
 
 	chip = kzalloc(sizeof(struct pch_phub_reg), GFP_KERNEL);
@@ -580,8 +580,8 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 		goto err_pci_iomap;
 	}
 	dev_dbg(&pdev->dev, "%s : pci_iomap SUCCESS and value "
-		"in pch_phub_base_address variable is 0x%08x\n", __func__,
-		(unsigned int)chip->pch_phub_base_address);
+		"in pch_phub_base_address variable is %p\n", __func__,
+		chip->pch_phub_base_address);
 	chip->pch_phub_extrom_base_address = pci_map_rom(pdev, &rom_size);
 
 	if (chip->pch_phub_extrom_base_address == 0) {
@@ -591,8 +591,8 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 	}
 	dev_dbg(&pdev->dev, "%s : "
 		"pci_map_rom SUCCESS and value in "
-		"pch_phub_extrom_base_address variable is 0x%08x\n", __func__,
-		(unsigned int)chip->pch_phub_extrom_base_address);
+		"pch_phub_extrom_base_address variable is %p\n", __func__,
+		chip->pch_phub_extrom_base_address);
 
 	pci_set_drvdata(pdev, chip);
 
-- 
1.7.2

