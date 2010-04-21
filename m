Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623Ab0DUEmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 00:42:32 -0400
Received: from mail.perches.com ([173.55.12.10]:1594 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab0DUEmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 00:42:31 -0400
Subject: [PATCH] drivers/edac: Convert logging messages direct uses of
 __FILE__ to %s, __FILE
From: Joe Perches <joe@perches.com>
To: Doug Thompson <dougthompson@xmission.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Tim Small <tim@buttersideup.com>
Cc: bluesmoke-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Apr 2010 21:42:29 -0700
Message-ID: <1271824949.1730.254.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduces text by eliminating multiple __FILE__ uses.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/edac/i5000_edac.c      |   20 ++++++++++----------
 drivers/edac/i5400_edac.c      |   20 ++++++++++----------
 drivers/edac/i82443bxgx_edac.c |   20 ++++++++++----------
 3 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index adc10a2..996c1bd 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -774,7 +774,7 @@ static void i5000_clear_error(struct mem_ctl_info *mci)
 static void i5000_check_error(struct mem_ctl_info *mci)
 {
 	struct i5000_error_info info;
-	debugf4("MC%d: " __FILE__ ": %s()\n", mci->mc_idx, __func__);
+	debugf4("MC%d: %s: %s()\n", mci->mc_idx, __FILE__, __func__);
 	i5000_get_error_info(mci, &info);
 	i5000_process_error_info(mci, &info, 1);
 }
@@ -1353,8 +1353,8 @@ static int i5000_probe1(struct pci_dev *pdev, int dev_idx)
 	int num_dimms_per_channel;
 	int num_csrows;
 
-	debugf0("MC: " __FILE__ ": %s(), pdev bus %u dev=0x%x fn=0x%x\n",
-		__func__,
+	debugf0("MC: %s: %s(), pdev bus %u dev=0x%x fn=0x%x\n",
+		__FILE__, __func__,
 		pdev->bus->number,
 		PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
 
@@ -1389,7 +1389,7 @@ static int i5000_probe1(struct pci_dev *pdev, int dev_idx)
 		return -ENOMEM;
 
 	kobject_get(&mci->edac_mci_kobj);
-	debugf0("MC: " __FILE__ ": %s(): mci = %p\n", __func__, mci);
+	debugf0("MC: %s: %s(): mci = %p\n", __FILE__, __func__, mci);
 
 	mci->dev = &pdev->dev;	/* record ptr  to the generic device */
 
@@ -1432,8 +1432,8 @@ static int i5000_probe1(struct pci_dev *pdev, int dev_idx)
 
 	/* add this new MC control structure to EDAC's list of MCs */
 	if (edac_mc_add_mc(mci)) {
-		debugf0("MC: " __FILE__
-			": %s(): failed edac_mc_add_mc()\n", __func__);
+		debugf0("MC: %s: %s(): failed edac_mc_add_mc()\n",
+			__FILE__, __func__);
 		/* FIXME: perhaps some code should go here that disables error
 		 * reporting if we just enabled it
 		 */
@@ -1478,7 +1478,7 @@ static int __devinit i5000_init_one(struct pci_dev *pdev,
 {
 	int rc;
 
-	debugf0("MC: " __FILE__ ": %s()\n", __func__);
+	debugf0("MC: %s: %s()\n", __FILE__, __func__);
 
 	/* wake up device */
 	rc = pci_enable_device(pdev);
@@ -1497,7 +1497,7 @@ static void __devexit i5000_remove_one(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 
-	debugf0(__FILE__ ": %s()\n", __func__);
+	debugf0("%s: %s()\n", __FILE__, __func__);
 
 	if (i5000_pci)
 		edac_pci_release_generic_ctl(i5000_pci);
@@ -1544,7 +1544,7 @@ static int __init i5000_init(void)
 {
 	int pci_rc;
 
-	debugf2("MC: " __FILE__ ": %s()\n", __func__);
+	debugf2("MC: %s: %s()\n", __FILE__, __func__);
 
        /* Ensure that the OPSTATE is set correctly for POLL or NMI */
        opstate_init();
@@ -1560,7 +1560,7 @@ static int __init i5000_init(void)
  */
 static void __exit i5000_exit(void)
 {
-	debugf2("MC: " __FILE__ ": %s()\n", __func__);
+	debugf2("MC: %s: %s()\n", __FILE__, __func__);
 	pci_unregister_driver(&i5000_driver);
 }
 
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index f99d106..010c1d6 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -694,7 +694,7 @@ static void i5400_clear_error(struct mem_ctl_info *mci)
 static void i5400_check_error(struct mem_ctl_info *mci)
 {
 	struct i5400_error_info info;
-	debugf4("MC%d: " __FILE__ ": %s()\n", mci->mc_idx, __func__);
+	debugf4("MC%d: %s: %s()\n", mci->mc_idx, __FILE__, __func__);
 	i5400_get_error_info(mci, &info);
 	i5400_process_error_info(mci, &info);
 }
@@ -1227,8 +1227,8 @@ static int i5400_probe1(struct pci_dev *pdev, int dev_idx)
 	if (dev_idx >= ARRAY_SIZE(i5400_devs))
 		return -EINVAL;
 
-	debugf0("MC: " __FILE__ ": %s(), pdev bus %u dev=0x%x fn=0x%x\n",
-		__func__,
+	debugf0("MC: %s: %s(), pdev bus %u dev=0x%x fn=0x%x\n",
+		__FILE__, __func__,
 		pdev->bus->number,
 		PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
 
@@ -1256,7 +1256,7 @@ static int i5400_probe1(struct pci_dev *pdev, int dev_idx)
 	if (mci == NULL)
 		return -ENOMEM;
 
-	debugf0("MC: " __FILE__ ": %s(): mci = %p\n", __func__, mci);
+	debugf0("MC: %s: %s(): mci = %p\n", __FILE__, __func__, mci);
 
 	mci->dev = &pdev->dev;	/* record ptr  to the generic device */
 
@@ -1299,8 +1299,8 @@ static int i5400_probe1(struct pci_dev *pdev, int dev_idx)
 
 	/* add this new MC control structure to EDAC's list of MCs */
 	if (edac_mc_add_mc(mci)) {
-		debugf0("MC: " __FILE__
-			": %s(): failed edac_mc_add_mc()\n", __func__);
+		debugf0("MC: %s: %s(): failed edac_mc_add_mc()\n",
+			__FILE__, __func__);
 		/* FIXME: perhaps some code should go here that disables error
 		 * reporting if we just enabled it
 		 */
@@ -1344,7 +1344,7 @@ static int __devinit i5400_init_one(struct pci_dev *pdev,
 {
 	int rc;
 
-	debugf0("MC: " __FILE__ ": %s()\n", __func__);
+	debugf0("MC: %s: %s()\n", __FILE__, __func__);
 
 	/* wake up device */
 	rc = pci_enable_device(pdev);
@@ -1363,7 +1363,7 @@ static void __devexit i5400_remove_one(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 
-	debugf0(__FILE__ ": %s()\n", __func__);
+	debugf0("%s: %s()\n", __FILE__, __func__);
 
 	if (i5400_pci)
 		edac_pci_release_generic_ctl(i5400_pci);
@@ -1409,7 +1409,7 @@ static int __init i5400_init(void)
 {
 	int pci_rc;
 
-	debugf2("MC: " __FILE__ ": %s()\n", __func__);
+	debugf2("MC: %s: %s()\n", __FILE__, __func__);
 
 	/* Ensure that the OPSTATE is set correctly for POLL or NMI */
 	opstate_init();
@@ -1425,7 +1425,7 @@ static int __init i5400_init(void)
  */
 static void __exit i5400_exit(void)
 {
-	debugf2("MC: " __FILE__ ": %s()\n", __func__);
+	debugf2("MC: %s: %s()\n", __FILE__, __func__);
 	pci_unregister_driver(&i5400_driver);
 }
 
diff --git a/drivers/edac/i82443bxgx_edac.c b/drivers/edac/i82443bxgx_edac.c
index 7f3884f..f3c2200 100644
--- a/drivers/edac/i82443bxgx_edac.c
+++ b/drivers/edac/i82443bxgx_edac.c
@@ -178,7 +178,7 @@ static void i82443bxgx_edacmc_check(struct mem_ctl_info *mci)
 {
 	struct i82443bxgx_edacmc_error_info info;
 
-	debugf1("MC%d: " __FILE__ ": %s()\n", mci->mc_idx, __func__);
+	debugf1("MC%d: %s: %s()\n", mci->mc_idx, __FILE__, __func__);
 	i82443bxgx_edacmc_get_error_info(mci, &info);
 	i82443bxgx_edacmc_process_error_info(mci, &info, 1);
 }
@@ -198,13 +198,13 @@ static void i82443bxgx_init_csrows(struct mem_ctl_info *mci,
 	for (index = 0; index < mci->nr_csrows; index++) {
 		csrow = &mci->csrows[index];
 		pci_read_config_byte(pdev, I82443BXGX_DRB + index, &drbar);
-		debugf1("MC%d: " __FILE__ ": %s() Row=%d DRB = %#0x\n",
-			mci->mc_idx, __func__, index, drbar);
+		debugf1("MC%d: %s: %s() Row=%d DRB = %#0x\n",
+			mci->mc_idx, __FILE__, __func__, index, drbar);
 		row_high_limit = ((u32) drbar << 23);
 		/* find the DRAM Chip Select Base address and mask */
-		debugf1("MC%d: " __FILE__ ": %s() Row=%d, "
+		debugf1("MC%d: %s: %s() Row=%d, "
 			"Boundry Address=%#0x, Last = %#0x \n",
-			mci->mc_idx, __func__, index, row_high_limit,
+			mci->mc_idx, __FILE__, __func__, index, row_high_limit,
 			row_high_limit_last);
 
 		/* 440GX goes to 2GB, represented with a DRB of 0. */
@@ -237,7 +237,7 @@ static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 	enum mem_type mtype;
 	enum edac_type edac_mode;
 
-	debugf0("MC: " __FILE__ ": %s()\n", __func__);
+	debugf0("MC: %s: %s()\n", __FILE__, __func__);
 
 	/* Something is really hosed if PCI config space reads from
 	 * the MC aren't working.
@@ -250,7 +250,7 @@ static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 	if (mci == NULL)
 		return -ENOMEM;
 
-	debugf0("MC: " __FILE__ ": %s(): mci = %p\n", __func__, mci);
+	debugf0("MC: %s: %s(): mci = %p\n", __FILE__, __func__, mci);
 	mci->dev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_EDO | MEM_FLAG_SDR | MEM_FLAG_RDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_EC | EDAC_FLAG_SECDED;
@@ -336,7 +336,7 @@ static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 			__func__);
 	}
 
-	debugf3("MC: " __FILE__ ": %s(): success\n", __func__);
+	debugf3("MC: %s: %s(): success\n", __FILE__, __func__);
 	return 0;
 
 fail:
@@ -352,7 +352,7 @@ static int __devinit i82443bxgx_edacmc_init_one(struct pci_dev *pdev,
 {
 	int rc;
 
-	debugf0("MC: " __FILE__ ": %s()\n", __func__);
+	debugf0("MC: %s: %s()\n", __FILE__, __func__);
 
 	/* don't need to call pci_device_enable() */
 	rc = i82443bxgx_edacmc_probe1(pdev, ent->driver_data);
@@ -367,7 +367,7 @@ static void __devexit i82443bxgx_edacmc_remove_one(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 
-	debugf0(__FILE__ ": %s()\n", __func__);
+	debugf0("%s: %s()\n", __FILE__, __func__);
 
 	if (i82443bxgx_pci)
 		edac_pci_release_generic_ctl(i82443bxgx_pci);


