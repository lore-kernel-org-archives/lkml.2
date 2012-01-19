Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab2ASBIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 20:08:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33226 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab2ASBIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 20:08:23 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Denis Turischev <denis@compulab.co.il>
Cc: linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH] pch_phub: add message to notify installing pch_phub
Date: Thu, 19 Jan 2012 10:07:47 +0900
Message-Id: <1326935267-4077-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, a user who wants to install pch_phub, the user can't know whether
the driver is installed or not from log of kernel ring buffer.
Of course, though seeing sysfs files, the user can know the installing,
kernel message is useful better than seeing sysfs files.

So, this patch adds logs.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/misc/pch_phub.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index 10fc478..c2beb13 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -746,6 +746,7 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 		iowrite32(0x25, chip->pch_phub_base_address + 0x44);
 		chip->pch_opt_rom_start_address = PCH_PHUB_ROM_START_ADDR_EG20T;
 		chip->pch_mac_start_address = PCH_PHUB_MAC_START_ADDR_EG20T;
+		dev_info(&pdev->dev, "Intel EG20T PCH PacketHub\n");
 	} else if (id->driver_data == 2) { /* ML7213 IOH */
 		retval = sysfs_create_bin_file(&pdev->dev.kobj, &pch_bin_attr);
 		if (retval)
@@ -759,6 +760,7 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 		iowrite32(0x000affa0, chip->pch_phub_base_address + 0x14);
 		chip->pch_opt_rom_start_address =\
 						 PCH_PHUB_ROM_START_ADDR_ML7213;
+		dev_info(&pdev->dev, "LAPIS Semiconductor ML7213 PacketHub\n");
 	} else if (id->driver_data == 3) { /* ML7223 IOH Bus-m*/
 		/* set the prefech value
 		 * Device8(GbE)
@@ -769,6 +771,8 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 		chip->pch_opt_rom_start_address =\
 						 PCH_PHUB_ROM_START_ADDR_ML7223;
 		chip->pch_mac_start_address = PCH_PHUB_MAC_START_ADDR_ML7223;
+		dev_info(&pdev->dev,
+			 "LAPIS Semiconductor ML7223[Bus-m] PacketHub\n");
 	} else if (id->driver_data == 4) { /* ML7223 IOH Bus-n*/
 		retval = sysfs_create_file(&pdev->dev.kobj,
 					   &dev_attr_pch_mac.attr);
@@ -786,6 +790,8 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 		chip->pch_opt_rom_start_address =\
 						 PCH_PHUB_ROM_START_ADDR_ML7223;
 		chip->pch_mac_start_address = PCH_PHUB_MAC_START_ADDR_ML7223;
+		dev_info(&pdev->dev,
+			 "LAPIS Semiconductor ML7223[Bus-n] PacketHub\n");
 	} else if (id->driver_data == 5) { /* ML7831 */
 		retval = sysfs_create_file(&pdev->dev.kobj,
 					   &dev_attr_pch_mac.attr);
@@ -802,6 +808,7 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 		iowrite32(0x25, chip->pch_phub_base_address + 0x44);
 		chip->pch_opt_rom_start_address = PCH_PHUB_ROM_START_ADDR_EG20T;
 		chip->pch_mac_start_address = PCH_PHUB_MAC_START_ADDR_EG20T;
+		dev_info(&pdev->dev, "LAPIS Semiconductor ML7831 PacketHub\n");
 	}
 
 	chip->ioh_type = id->driver_data;
-- 
1.7.4.4

