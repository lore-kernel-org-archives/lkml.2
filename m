Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab0DETHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 15:07:10 -0400
Received: from mail.perches.com ([173.55.12.10]:1365 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756082Ab0DETFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 15:05:50 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/11] drivers/edac/amd: Rename dev_info to adi
Date: Mon,  5 Apr 2010 12:05:35 -0700
Message-Id: <9a1b66589a7de3fd1075cc2a038bf6fccdf7fc61.1270493677.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
In-Reply-To: <20100304232928.2e45bdd1.akpm@linux-foundation.org>
References: <20100304232928.2e45bdd1.akpm@linux-foundation.org>
In-Reply-To: <cover.1270493677.git.joe@perches.com>
References: <cover.1270493677.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a macro called dev_info that prints struct device specific
information.  Having variables with the same name can be confusing and
prevents conversion of the macro to a function.

Rename the existing dev_info variables to something else in preparation
to converting the dev_info macro to a function.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/edac/amd8111_edac.c |   88 +++++++++++++++++++++---------------------
 drivers/edac/amd8131_edac.c |   86 +++++++++++++++++++++---------------------
 2 files changed, 87 insertions(+), 87 deletions(-)

diff --git a/drivers/edac/amd8111_edac.c b/drivers/edac/amd8111_edac.c
index 35b78d0..48770c7 100644
--- a/drivers/edac/amd8111_edac.c
+++ b/drivers/edac/amd8111_edac.c
@@ -243,10 +243,10 @@ static int at_compat_reg_broken;
 #define LEGACY_NR_PORTS	1
 
 /* device-specific methods for amd8111 LPC Bridge device */
-static void amd8111_lpc_bridge_init(struct amd8111_dev_info *dev_info)
+static void amd8111_lpc_bridge_init(struct amd8111_dev_info *adi)
 {
 	u8 val8;
-	struct pci_dev *dev = dev_info->dev;
+	struct pci_dev *dev = adi->dev;
 
 	/* First clear REG_AT_COMPAT[SERR, IOCHK] if necessary */
 	legacy_io_res = request_region(REG_AT_COMPAT, LEGACY_NR_PORTS,
@@ -280,7 +280,7 @@ static void amd8111_lpc_bridge_init(struct amd8111_dev_info *dev_info)
 		edac_pci_write_byte(dev, REG_IO_CTRL_1, val8);
 }
 
-static void amd8111_lpc_bridge_exit(struct amd8111_dev_info *dev_info)
+static void amd8111_lpc_bridge_exit(struct amd8111_dev_info *adi)
 {
 	if (legacy_io_res)
 		release_region(REG_AT_COMPAT, LEGACY_NR_PORTS);
@@ -288,15 +288,15 @@ static void amd8111_lpc_bridge_exit(struct amd8111_dev_info *dev_info)
 
 static void amd8111_lpc_bridge_check(struct edac_device_ctl_info *edac_dev)
 {
-	struct amd8111_dev_info *dev_info = edac_dev->pvt_info;
-	struct pci_dev *dev = dev_info->dev;
+	struct amd8111_dev_info *adi = edac_dev->pvt_info;
+	struct pci_dev *dev = adi->dev;
 	u8 val8;
 
 	edac_pci_read_byte(dev, REG_IO_CTRL_1, &val8);
 	if (val8 & IO_CTRL_1_CLEAR_MASK) {
 		printk(KERN_INFO
 			"Error(s) in IO control register on %s device\n",
-			dev_info->ctl_name);
+			adi->ctl_name);
 		printk(KERN_INFO "LPC ERR: %d, PW2LPC: %d\n",
 			(val8 & IO_CTRL_1_LPC_ERR) != 0,
 			(val8 & IO_CTRL_1_PW2LPC) != 0);
@@ -349,25 +349,25 @@ static struct amd8111_pci_info amd8111_pcis[] = {
 static int amd8111_dev_probe(struct pci_dev *dev,
 				const struct pci_device_id *id)
 {
-	struct amd8111_dev_info *dev_info = &amd8111_devices[id->driver_data];
+	struct amd8111_dev_info *adi = &amd8111_devices[id->driver_data];
 
-	dev_info->dev = pci_get_device(PCI_VENDOR_ID_AMD,
-					dev_info->err_dev, NULL);
+	adi->dev = pci_get_device(PCI_VENDOR_ID_AMD,
+					adi->err_dev, NULL);
 
-	if (!dev_info->dev) {
+	if (!adi->dev) {
 		printk(KERN_ERR "EDAC device not found:"
 			"vendor %x, device %x, name %s\n",
-			PCI_VENDOR_ID_AMD, dev_info->err_dev,
-			dev_info->ctl_name);
+			PCI_VENDOR_ID_AMD, adi->err_dev,
+			adi->ctl_name);
 		return -ENODEV;
 	}
 
-	if (pci_enable_device(dev_info->dev)) {
-		pci_dev_put(dev_info->dev);
+	if (pci_enable_device(adi->dev)) {
+		pci_dev_put(adi->dev);
 		printk(KERN_ERR "failed to enable:"
 			"vendor %x, device %x, name %s\n",
-			PCI_VENDOR_ID_AMD, dev_info->err_dev,
-			dev_info->ctl_name);
+			PCI_VENDOR_ID_AMD, adi->err_dev,
+			adi->ctl_name);
 		return -ENODEV;
 	}
 
@@ -376,61 +376,61 @@ static int amd8111_dev_probe(struct pci_dev *dev,
 	 * edac_device_ctl_info, but make use of existing
 	 * one instead.
 	*/
-	dev_info->edac_idx = edac_device_alloc_index();
-	dev_info->edac_dev =
-		edac_device_alloc_ctl_info(0, dev_info->ctl_name, 1,
+	adi->edac_idx = edac_device_alloc_index();
+	adi->edac_dev =
+		edac_device_alloc_ctl_info(0, adi->ctl_name, 1,
 					   NULL, 0, 0,
-					   NULL, 0, dev_info->edac_idx);
-	if (!dev_info->edac_dev)
+					   NULL, 0, adi->edac_idx);
+	if (!adi->edac_dev)
 		return -ENOMEM;
 
-	dev_info->edac_dev->pvt_info = dev_info;
-	dev_info->edac_dev->dev = &dev_info->dev->dev;
-	dev_info->edac_dev->mod_name = AMD8111_EDAC_MOD_STR;
-	dev_info->edac_dev->ctl_name = dev_info->ctl_name;
-	dev_info->edac_dev->dev_name = dev_name(&dev_info->dev->dev);
+	adi->edac_dev->pvt_info = adi;
+	adi->edac_dev->dev = &adi->dev->dev;
+	adi->edac_dev->mod_name = AMD8111_EDAC_MOD_STR;
+	adi->edac_dev->ctl_name = adi->ctl_name;
+	adi->edac_dev->dev_name = dev_name(&adi->dev->dev);
 
 	if (edac_op_state == EDAC_OPSTATE_POLL)
-		dev_info->edac_dev->edac_check = dev_info->check;
+		adi->edac_dev->edac_check = adi->check;
 
-	if (dev_info->init)
-		dev_info->init(dev_info);
+	if (adi->init)
+		adi->init(adi);
 
-	if (edac_device_add_device(dev_info->edac_dev) > 0) {
+	if (edac_device_add_device(adi->edac_dev) > 0) {
 		printk(KERN_ERR "failed to add edac_dev for %s\n",
-			dev_info->ctl_name);
-		edac_device_free_ctl_info(dev_info->edac_dev);
+			adi->ctl_name);
+		edac_device_free_ctl_info(adi->edac_dev);
 		return -ENODEV;
 	}
 
 	printk(KERN_INFO "added one edac_dev on AMD8111 "
 		"vendor %x, device %x, name %s\n",
-		PCI_VENDOR_ID_AMD, dev_info->err_dev,
-		dev_info->ctl_name);
+		PCI_VENDOR_ID_AMD, adi->err_dev,
+		adi->ctl_name);
 
 	return 0;
 }
 
 static void amd8111_dev_remove(struct pci_dev *dev)
 {
-	struct amd8111_dev_info *dev_info;
+	struct amd8111_dev_info *adi;
 
-	for (dev_info = amd8111_devices; dev_info->err_dev; dev_info++)
-		if (dev_info->dev->device == dev->device)
+	for (adi = amd8111_devices; adi->err_dev; adi++)
+		if (adi->dev->device == dev->device)
 			break;
 
-	if (!dev_info->err_dev)	/* should never happen */
+	if (!adi->err_dev)	/* should never happen */
 		return;
 
-	if (dev_info->edac_dev) {
-		edac_device_del_device(dev_info->edac_dev->dev);
-		edac_device_free_ctl_info(dev_info->edac_dev);
+	if (adi->edac_dev) {
+		edac_device_del_device(adi->edac_dev->dev);
+		edac_device_free_ctl_info(adi->edac_dev);
 	}
 
-	if (dev_info->exit)
-		dev_info->exit(dev_info);
+	if (adi->exit)
+		adi->exit(adi);
 
-	pci_dev_put(dev_info->dev);
+	pci_dev_put(adi->dev);
 }
 
 static int amd8111_pci_probe(struct pci_dev *dev,
diff --git a/drivers/edac/amd8131_edac.c b/drivers/edac/amd8131_edac.c
index b432d60..fbf8d1b 100644
--- a/drivers/edac/amd8131_edac.c
+++ b/drivers/edac/amd8131_edac.c
@@ -90,10 +90,10 @@ static struct amd8131_dev_info amd8131_devices[] = {
 	{.inst = NO_BRIDGE,},
 };
 
-static void amd8131_pcix_init(struct amd8131_dev_info *dev_info)
+static void amd8131_pcix_init(struct amd8131_dev_info *adi)
 {
 	u32 val32;
-	struct pci_dev *dev = dev_info->dev;
+	struct pci_dev *dev = adi->dev;
 
 	/* First clear error detection flags */
 	edac_pci_read_dword(dev, REG_MEM_LIM, &val32);
@@ -141,10 +141,10 @@ static void amd8131_pcix_init(struct amd8131_dev_info *dev_info)
 	edac_pci_write_dword(dev, REG_LNK_CTRL_B, val32);
 }
 
-static void amd8131_pcix_exit(struct amd8131_dev_info *dev_info)
+static void amd8131_pcix_exit(struct amd8131_dev_info *adi)
 {
 	u32 val32;
-	struct pci_dev *dev = dev_info->dev;
+	struct pci_dev *dev = adi->dev;
 
 	/* Disable SERR, PERR and DTSE Error detection */
 	edac_pci_read_dword(dev, REG_INT_CTLR, &val32);
@@ -169,15 +169,15 @@ static void amd8131_pcix_exit(struct amd8131_dev_info *dev_info)
 
 static void amd8131_pcix_check(struct edac_pci_ctl_info *edac_dev)
 {
-	struct amd8131_dev_info *dev_info = edac_dev->pvt_info;
-	struct pci_dev *dev = dev_info->dev;
+	struct amd8131_dev_info *adi = edac_dev->pvt_info;
+	struct pci_dev *dev = adi->dev;
 	u32 val32;
 
 	/* Check PCI-X Bridge Memory Base-Limit Register for errors */
 	edac_pci_read_dword(dev, REG_MEM_LIM, &val32);
 	if (val32 & MEM_LIMIT_MASK) {
 		printk(KERN_INFO "Error(s) in mem limit register "
-			"on %s bridge\n", dev_info->ctl_name);
+			"on %s bridge\n", adi->ctl_name);
 		printk(KERN_INFO "DPE: %d, RSE: %d, RMA: %d\n"
 			"RTA: %d, STA: %d, MDPE: %d\n",
 			val32 & MEM_LIMIT_DPE,
@@ -197,7 +197,7 @@ static void amd8131_pcix_check(struct edac_pci_ctl_info *edac_dev)
 	edac_pci_read_dword(dev, REG_INT_CTLR, &val32);
 	if (val32 & INT_CTLR_DTS) {
 		printk(KERN_INFO "Error(s) in interrupt and control register "
-			"on %s bridge\n", dev_info->ctl_name);
+			"on %s bridge\n", adi->ctl_name);
 		printk(KERN_INFO "DTS: %d\n", val32 & INT_CTLR_DTS);
 
 		val32 |= INT_CTLR_DTS;
@@ -210,7 +210,7 @@ static void amd8131_pcix_check(struct edac_pci_ctl_info *edac_dev)
 	edac_pci_read_dword(dev, REG_LNK_CTRL_A, &val32);
 	if (val32 & LNK_CTRL_CRCERR_A) {
 		printk(KERN_INFO "Error(s) in link conf and control register "
-			"on %s bridge\n", dev_info->ctl_name);
+			"on %s bridge\n", adi->ctl_name);
 		printk(KERN_INFO "CRCERR: %d\n", val32 & LNK_CTRL_CRCERR_A);
 
 		val32 |= LNK_CTRL_CRCERR_A;
@@ -223,7 +223,7 @@ static void amd8131_pcix_check(struct edac_pci_ctl_info *edac_dev)
 	edac_pci_read_dword(dev, REG_LNK_CTRL_B, &val32);
 	if (val32 & LNK_CTRL_CRCERR_B) {
 		printk(KERN_INFO "Error(s) in link conf and control register "
-			"on %s bridge\n", dev_info->ctl_name);
+			"on %s bridge\n", adi->ctl_name);
 		printk(KERN_INFO "CRCERR: %d\n", val32 & LNK_CTRL_CRCERR_B);
 
 		val32 |= LNK_CTRL_CRCERR_B;
@@ -248,28 +248,28 @@ static struct amd8131_info amd8131_chipset = {
  */
 static int amd8131_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	struct amd8131_dev_info *dev_info;
+	struct amd8131_dev_info *adi;
 
-	for (dev_info = amd8131_chipset.devices; dev_info->inst != NO_BRIDGE;
-		dev_info++)
-		if (dev_info->devfn == dev->devfn)
+	for (adi = amd8131_chipset.devices; adi->inst != NO_BRIDGE;
+		adi++)
+		if (adi->devfn == dev->devfn)
 			break;
 
-	if (dev_info->inst == NO_BRIDGE) /* should never happen */
+	if (adi->inst == NO_BRIDGE) /* should never happen */
 		return -ENODEV;
 
 	/*
 	 * We can't call pci_get_device() as we are used to do because
 	 * there are 4 of them but pci_dev_get() instead.
 	 */
-	dev_info->dev = pci_dev_get(dev);
+	adi->dev = pci_dev_get(dev);
 
-	if (pci_enable_device(dev_info->dev)) {
-		pci_dev_put(dev_info->dev);
+	if (pci_enable_device(adi->dev)) {
+		pci_dev_put(adi->dev);
 		printk(KERN_ERR "failed to enable:"
 			"vendor %x, device %x, devfn %x, name %s\n",
 			PCI_VENDOR_ID_AMD, amd8131_chipset.err_dev,
-			dev_info->devfn, dev_info->ctl_name);
+			adi->devfn, adi->ctl_name);
 		return -ENODEV;
 	}
 
@@ -278,59 +278,59 @@ static int amd8131_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	 * edac_pci_ctl_info, but make use of existing
 	 * one instead.
 	 */
-	dev_info->edac_idx = edac_pci_alloc_index();
-	dev_info->edac_dev = edac_pci_alloc_ctl_info(0, dev_info->ctl_name);
-	if (!dev_info->edac_dev)
+	adi->edac_idx = edac_pci_alloc_index();
+	adi->edac_dev = edac_pci_alloc_ctl_info(0, adi->ctl_name);
+	if (!adi->edac_dev)
 		return -ENOMEM;
 
-	dev_info->edac_dev->pvt_info = dev_info;
-	dev_info->edac_dev->dev = &dev_info->dev->dev;
-	dev_info->edac_dev->mod_name = AMD8131_EDAC_MOD_STR;
-	dev_info->edac_dev->ctl_name = dev_info->ctl_name;
-	dev_info->edac_dev->dev_name = dev_name(&dev_info->dev->dev);
+	adi->edac_dev->pvt_info = adi;
+	adi->edac_dev->dev = &adi->dev->dev;
+	adi->edac_dev->mod_name = AMD8131_EDAC_MOD_STR;
+	adi->edac_dev->ctl_name = adi->ctl_name;
+	adi->edac_dev->dev_name = dev_name(&adi->dev->dev);
 
 	if (edac_op_state == EDAC_OPSTATE_POLL)
-		dev_info->edac_dev->edac_check = amd8131_chipset.check;
+		adi->edac_dev->edac_check = amd8131_chipset.check;
 
 	if (amd8131_chipset.init)
-		amd8131_chipset.init(dev_info);
+		amd8131_chipset.init(adi);
 
-	if (edac_pci_add_device(dev_info->edac_dev, dev_info->edac_idx) > 0) {
+	if (edac_pci_add_device(adi->edac_dev, adi->edac_idx) > 0) {
 		printk(KERN_ERR "failed edac_pci_add_device() for %s\n",
-			dev_info->ctl_name);
-		edac_pci_free_ctl_info(dev_info->edac_dev);
+			adi->ctl_name);
+		edac_pci_free_ctl_info(adi->edac_dev);
 		return -ENODEV;
 	}
 
 	printk(KERN_INFO "added one device on AMD8131 "
 		"vendor %x, device %x, devfn %x, name %s\n",
 		PCI_VENDOR_ID_AMD, amd8131_chipset.err_dev,
-		dev_info->devfn, dev_info->ctl_name);
+		adi->devfn, adi->ctl_name);
 
 	return 0;
 }
 
 static void amd8131_remove(struct pci_dev *dev)
 {
-	struct amd8131_dev_info *dev_info;
+	struct amd8131_dev_info *adi;
 
-	for (dev_info = amd8131_chipset.devices; dev_info->inst != NO_BRIDGE;
-		dev_info++)
-		if (dev_info->devfn == dev->devfn)
+	for (adi = amd8131_chipset.devices; adi->inst != NO_BRIDGE;
+		adi++)
+		if (adi->devfn == dev->devfn)
 			break;
 
-	if (dev_info->inst == NO_BRIDGE) /* should never happen */
+	if (adi->inst == NO_BRIDGE) /* should never happen */
 		return;
 
-	if (dev_info->edac_dev) {
-		edac_pci_del_device(dev_info->edac_dev->dev);
-		edac_pci_free_ctl_info(dev_info->edac_dev);
+	if (adi->edac_dev) {
+		edac_pci_del_device(adi->edac_dev->dev);
+		edac_pci_free_ctl_info(adi->edac_dev);
 	}
 
 	if (amd8131_chipset.exit)
-		amd8131_chipset.exit(dev_info);
+		amd8131_chipset.exit(adi);
 
-	pci_dev_put(dev_info->dev);
+	pci_dev_put(adi->dev);
 }
 
 static const struct pci_device_id amd8131_edac_pci_tbl[] = {
-- 
1.7.0.3.311.g6a6955

