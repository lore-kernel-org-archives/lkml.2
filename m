Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab1AaEfD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 23:35:03 -0500
Received: from mail.perches.com ([173.55.12.10]:3492 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab1AaEfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 23:35:00 -0500
Subject: [PATCH] ata: pata: Convert pr_*(DRV_NAME ...) to pr_fmt/pr_<level>
From: Joe Perches <joe@perches.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <201101310359.p0V3x41L010660@hera.kernel.org>
References: <201101310359.p0V3x41L010660@hera.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 Jan 2011 20:34:58 -0800
Message-ID: <1296448498.4131.22.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 40d69ba029c8d5de51aaeb5358999266c482d00a
("pata_hpt{37x|3x2n}: use pr_*(DRV_NAME ...) instead of printk(KERN_* ...)")
used pr_<level>.

Add #define pr_fmt and remove DRV_NAME.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ata/pata_hpt366.c  |    5 +++--
 drivers/ata/pata_hpt37x.c  |   21 +++++++++++----------
 drivers/ata/pata_hpt3x2n.c |   11 ++++++-----
 3 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index 538ec38..dd8fbb9 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -14,6 +14,7 @@
  *	Look into engine reset on timeout errors. Should not be required.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -160,8 +161,8 @@ static int hpt_dma_blacklisted(const struct ata_device *dev, char *modestr,
 
 	while (list[i] != NULL) {
 		if (!strcmp(list[i], model_num)) {
-			pr_warning(DRV_NAME ": %s is not supported for %s.\n",
-				   modestr, list[i]);
+			pr_warn("%s is not supported for %s\n",
+				modestr, list[i]);
 			return 1;
 		}
 		i++;
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index 4c5b518..0615026 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -14,6 +14,8 @@
  *	Look into engine reset on timeout errors. Should not be	required.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -229,8 +231,8 @@ static int hpt_dma_blacklisted(const struct ata_device *dev, char *modestr,
 
 	while (list[i] != NULL) {
 		if (!strcmp(list[i], model_num)) {
-			pr_warning(DRV_NAME ": %s is not supported for %s.\n",
-				   modestr, list[i]);
+			pr_warn("%s is not supported for %s\n",
+				modestr, list[i]);
 			return 1;
 		}
 		i++;
@@ -863,8 +865,8 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 			chip_table = &hpt372;
 			break;
 		default:
-			pr_err(DRV_NAME ": Unknown HPT366 subtype, "
-			       "please report (%d).\n", rev);
+			pr_err("Unknown HPT366 subtype, please report (%d)\n",
+			       rev);
 			return -ENODEV;
 		}
 		break;
@@ -904,8 +906,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 			*ppi = &info_hpt374_fn1;
 		break;
 	default:
-		pr_err(DRV_NAME ": PCI table is bogus, please report (%d).\n",
-		       dev->device);
+		pr_err("PCI table is bogus, please report (%d)\n", dev->device);
 		return -ENODEV;
 	}
 	/* Ok so this is a chip we support */
@@ -953,7 +954,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		u8 sr;
 		u32 total = 0;
 
-		pr_warning(DRV_NAME ": BIOS has not set timing clocks.\n");
+		pr_warn("BIOS has not set timing clocks\n");
 
 		/* This is the process the HPT371 BIOS is reported to use */
 		for (i = 0; i < 128; i++) {
@@ -1009,7 +1010,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 					       (f_high << 16) | f_low | 0x100);
 		}
 		if (adjust == 8) {
-			pr_err(DRV_NAME ": DPLL did not stabilize!\n");
+			pr_err("DPLL did not stabilize!\n");
 			return -ENODEV;
 		}
 		if (dpll == 3)
@@ -1017,7 +1018,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		else
 			private_data = (void *)hpt37x_timings_50;
 
-		pr_info(DRV_NAME ": bus clock %dMHz, using %dMHz DPLL.\n",
+		pr_info("bus clock %dMHz, using %dMHz DPLL\n",
 			MHz[clock_slot], MHz[dpll]);
 	} else {
 		private_data = (void *)chip_table->clocks[clock_slot];
@@ -1032,7 +1033,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		if (clock_slot < 2 && ppi[0] == &info_hpt370a)
 			ppi[0] = &info_hpt370a_33;
 
-		pr_info(DRV_NAME ": %s using %dMHz bus clock.\n",
+		pr_info("%s using %dMHz bus clock\n",
 			chip_table->name, MHz[clock_slot]);
 	}
 
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index eca68ca..2c11d06 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -15,6 +15,8 @@
  *	Work out best PLL policy
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -418,7 +420,7 @@ static int hpt3x2n_pci_clock(struct pci_dev *pdev)
 		u16 sr;
 		u32 total = 0;
 
-		pr_warning(DRV_NAME ": BIOS clock data not set.\n");
+		pr_warn("BIOS clock data not set\n");
 
 		/* This is the process the HPT371 BIOS is reported to use */
 		for (i = 0; i < 128; i++) {
@@ -528,8 +530,7 @@ hpt372n:
 		ppi[0] = &info_hpt372n;
 		break;
 	default:
-		pr_err(DRV_NAME ": PCI table is bogus, please report (%d).\n",
-		       dev->device);
+		pr_err("PCI table is bogus, please report (%d)\n", dev->device);
 		return -ENODEV;
 	}
 
@@ -578,11 +579,11 @@ hpt372n:
 		pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low);
 	}
 	if (adjust == 8) {
-		pr_err(DRV_NAME ": DPLL did not stabilize!\n");
+		pr_err("DPLL did not stabilize!\n");
 		return -ENODEV;
 	}
 
-	pr_info(DRV_NAME ": bus clock %dMHz, using 66MHz DPLL.\n", pci_mhz);
+	pr_info("bus clock %dMHz, using 66MHz DPLL\n", pci_mhz);
 
 	/*
 	 * Set our private data up. We only need a few flags


