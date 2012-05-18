Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab2ERQoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:44:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758587Ab2ERQdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:33:06 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC v26 61/66] edac: Don't add __func__ or __FILE__ for debugf[0-9] msgs
Date: Fri, 18 May 2012 13:32:48 -0300
Message-Id: <1337358773-6919-62-git-send-email-mchehab@redhat.com>
In-Reply-To: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
References: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The debug macro already adds that. Most of the work here was
made by this small script:

$f .=$_ while (<>);

$f =~ s/(debugf[0-9]\s*\(\s*)__FILE__\s*": /\1"/g;
$f =~ s/(debugf[0-9]\s*\(\s*)__FILE__\s*/\1/g;
$f =~ s/(debugf[0-9]\s*\(\s*)__FILE__\s*"MC: /\1"/g;

$f =~ s/(debugf[0-9]\s*\(\")\%s[\:\,\(\)]*\s*([^\"]*\s*[^\)]+)__func__\s*\,\s*/\1\2/g;
$f =~ s/(debugf[0-9]\s*\(\")\%s[\:\,\(\)]*\s*([^\"]*\s*[^\)]+),\s*__func__\s*\)/\1\2)/g;
$f =~ s/(debugf[0-9]\s*\(\"MC\:\s*)\%s[\:\,\(\)]*\s*([^\"]*\s*[^\)]+)__func__\s*\,\s*/\1\2/g;
$f =~ s/(debugf[0-9]\s*\(\"MC\:\s*)\%s[\:\,\(\)]*\s*([^\"]*\s*[^\)]+),\s*__func__\s*\)/\1\2)/g;

$f =~ s/\"MC\: \\n\"/"MC:\\n"/g;

print $f;

After running the script, manual cleanups were done to fix it the remaining
places.

While here, removed the __LINE__ on most places, as it doesn't actually give
useful info on most places.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/amd76x_edac.c       |   14 ++++----
 drivers/edac/cpc925_edac.c       |   24 ++++++-------
 drivers/edac/e752x_edac.c        |   34 +++++++++---------
 drivers/edac/e7xxx_edac.c        |   34 +++++++++---------
 drivers/edac/edac_device.c       |   28 +++++++-------
 drivers/edac/edac_device_sysfs.c |   71 ++++++++++++++++++-------------------
 drivers/edac/edac_mc.c           |   44 +++++++++++------------
 drivers/edac/edac_mc_sysfs.c     |   24 +++++-------
 drivers/edac/edac_module.c       |    2 +-
 drivers/edac/edac_pci.c          |   26 +++++++-------
 drivers/edac/edac_pci_sysfs.c    |   37 +++++++++----------
 drivers/edac/i3000_edac.c        |   22 ++++++------
 drivers/edac/i3200_edac.c        |   18 +++++-----
 drivers/edac/i5000_edac.c        |   25 ++++++-------
 drivers/edac/i5400_edac.c        |   24 ++++++-------
 drivers/edac/i7300_edac.c        |   14 +++----
 drivers/edac/i7core_edac.c       |   37 ++++++++------------
 drivers/edac/i82443bxgx_edac.c   |   26 +++++++-------
 drivers/edac/i82860_edac.c       |   18 +++++-----
 drivers/edac/i82875p_edac.c      |   22 ++++++------
 drivers/edac/i82975x_edac.c      |   24 ++++++------
 drivers/edac/mpc85xx_edac.c      |   22 ++++++------
 drivers/edac/mv64x60_edac.c      |   26 +++++++-------
 drivers/edac/r82600_edac.c       |   32 ++++++++---------
 drivers/edac/sb_edac.c           |   22 +++++------
 drivers/edac/x38_edac.c          |   18 +++++-----
 26 files changed, 331 insertions(+), 357 deletions(-)

diff --git a/drivers/edac/amd76x_edac.c b/drivers/edac/amd76x_edac.c
index bebdd49..601db57 100644
--- a/drivers/edac/amd76x_edac.c
+++ b/drivers/edac/amd76x_edac.c
@@ -180,7 +180,7 @@ static int amd76x_process_error_info(struct mem_ctl_info *mci,
 static void amd76x_check(struct mem_ctl_info *mci)
 {
 	struct amd76x_error_info info;
-	debugf3("%s()\n", __func__);
+	debugf3("\n");
 	amd76x_get_error_info(mci, &info);
 	amd76x_process_error_info(mci, &info, 1);
 }
@@ -241,7 +241,7 @@ static int amd76x_probe1(struct pci_dev *pdev, int dev_idx)
 	u32 ems_mode;
 	struct amd76x_error_info discard;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 	pci_read_config_dword(pdev, AMD76X_ECC_MODE_STATUS, &ems);
 	ems_mode = (ems >> 10) & 0x3;
 
@@ -256,7 +256,7 @@ static int amd76x_probe1(struct pci_dev *pdev, int dev_idx)
 	if (mci == NULL)
 		return -ENOMEM;
 
-	debugf0("%s(): mci = %p\n", __func__, mci);
+	debugf0("mci = %p\n", mci);
 	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_RDDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_EC | EDAC_FLAG_SECDED;
@@ -276,7 +276,7 @@ static int amd76x_probe1(struct pci_dev *pdev, int dev_idx)
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
 	if (edac_mc_add_mc(mci)) {
-		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
+		debugf3("failed edac_mc_add_mc()\n");
 		goto fail;
 	}
 
@@ -292,7 +292,7 @@ static int amd76x_probe1(struct pci_dev *pdev, int dev_idx)
 	}
 
 	/* get this far and it's successful */
-	debugf3("%s(): success\n", __func__);
+	debugf3("success\n");
 	return 0;
 
 fail:
@@ -304,7 +304,7 @@ fail:
 static int __devinit amd76x_init_one(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	/* don't need to call pci_enable_device() */
 	return amd76x_probe1(pdev, ent->driver_data);
@@ -322,7 +322,7 @@ static void __devexit amd76x_remove_one(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	if (amd76x_pci)
 		edac_pci_release_generic_ctl(amd76x_pci);
diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
index 534491d..fa39a78 100644
--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -316,13 +316,12 @@ static void get_total_mem(struct cpc925_mc_pdata *pdata)
 		reg += aw;
 		size = of_read_number(reg, sw);
 		reg += sw;
-		debugf1("%s: start 0x%lx, size 0x%lx\n", __func__,
-			start, size);
+		debugf1("start 0x%lx, size 0x%lx\n", start, size);
 		pdata->total_mem += size;
 	} while (reg < reg_end);
 
 	of_node_put(np);
-	debugf0("%s: total_mem 0x%lx\n", __func__, pdata->total_mem);
+	debugf0("total_mem 0x%lx\n", pdata->total_mem);
 }
 
 static void cpc925_init_csrows(struct mem_ctl_info *mci)
@@ -512,7 +511,7 @@ static void cpc925_mc_get_pfn(struct mem_ctl_info *mci, u32 mear,
 	*offset = pa & (PAGE_SIZE - 1);
 	*pfn = pa >> PAGE_SHIFT;
 
-	debugf0("%s: ECC physical address 0x%lx\n", __func__, pa);
+	debugf0("ECC physical address 0x%lx\n", pa);
 }
 
 static int cpc925_mc_find_channel(struct mem_ctl_info *mci, u16 syndrome)
@@ -852,8 +851,8 @@ static void cpc925_add_edac_devices(void __iomem *vbase)
 			goto err2;
 		}
 
-		debugf0("%s: Successfully added edac device for %s\n",
-			__func__, dev_info->ctl_name);
+		debugf0("Successfully added edac device for %s\n",
+			dev_info->ctl_name);
 
 		continue;
 
@@ -884,8 +883,8 @@ static void cpc925_del_edac_devices(void)
 		if (dev_info->exit)
 			dev_info->exit(dev_info);
 
-		debugf0("%s: Successfully deleted edac device for %s\n",
-			__func__, dev_info->ctl_name);
+		debugf0("Successfully deleted edac device for %s\n",
+			dev_info->ctl_name);
 	}
 }
 
@@ -900,7 +899,7 @@ static int cpc925_get_sdram_scrub_rate(struct mem_ctl_info *mci)
 	mscr = __raw_readl(pdata->vbase + REG_MSCR_OFFSET);
 	si = (mscr & MSCR_SI_MASK) >> MSCR_SI_SHIFT;
 
-	debugf0("%s, Mem Scrub Ctrl Register 0x%x\n", __func__, mscr);
+	debugf0("Mem Scrub Ctrl Register 0x%x\n", mscr);
 
 	if (((mscr & MSCR_SCRUB_MOD_MASK) != MSCR_BACKGR_SCRUB) ||
 	    (si == 0)) {
@@ -928,8 +927,7 @@ static int cpc925_mc_get_channels(void __iomem *vbase)
 	    ((mbcr & MBCR_64BITBUS_MASK) == 0))
 		dual = 1;
 
-	debugf0("%s: %s channel\n", __func__,
-		(dual > 0) ? "Dual" : "Single");
+	debugf0("%s channel\n", (dual > 0) ? "Dual" : "Single");
 
 	return dual;
 }
@@ -944,7 +942,7 @@ static int __devinit cpc925_probe(struct platform_device *pdev)
 	struct resource *r;
 	int res = 0, nr_channels;
 
-	debugf0("%s: %s platform device found!\n", __func__, pdev->name);
+	debugf0("%s platform device found!\n", pdev->name);
 
 	if (!devres_open_group(&pdev->dev, cpc925_probe, GFP_KERNEL)) {
 		res = -ENOMEM;
@@ -1026,7 +1024,7 @@ static int __devinit cpc925_probe(struct platform_device *pdev)
 	cpc925_add_edac_devices(vbase);
 
 	/* get this far and it's successful */
-	debugf0("%s: success\n", __func__);
+	debugf0("success\n");
 
 	res = 0;
 	goto out;
diff --git a/drivers/edac/e752x_edac.c b/drivers/edac/e752x_edac.c
index 7cde7f1..39c8997 100644
--- a/drivers/edac/e752x_edac.c
+++ b/drivers/edac/e752x_edac.c
@@ -309,7 +309,7 @@ static unsigned long ctl_page_to_phys(struct mem_ctl_info *mci,
 	u32 remap;
 	struct e752x_pvt *pvt = (struct e752x_pvt *)mci->pvt_info;
 
-	debugf3("%s()\n", __func__);
+	debugf3("\n");
 
 	if (page < pvt->tolm)
 		return page;
@@ -335,7 +335,7 @@ static void do_process_ce(struct mem_ctl_info *mci, u16 error_one,
 	int i;
 	struct e752x_pvt *pvt = (struct e752x_pvt *)mci->pvt_info;
 
-	debugf3("%s()\n", __func__);
+	debugf3("\n");
 
 	/* convert the addr to 4k page */
 	page = sec1_add >> (PAGE_SHIFT - 4);
@@ -394,7 +394,7 @@ static void do_process_ue(struct mem_ctl_info *mci, u16 error_one,
 	int row;
 	struct e752x_pvt *pvt = (struct e752x_pvt *)mci->pvt_info;
 
-	debugf3("%s()\n", __func__);
+	debugf3("\n");
 
 	if (error_one & 0x0202) {
 		error_2b = ded_add;
@@ -453,7 +453,7 @@ static inline void process_ue_no_info_wr(struct mem_ctl_info *mci,
 	if (!handle_error)
 		return;
 
-	debugf3("%s()\n", __func__);
+	debugf3("\n");
 	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
 			     -1, -1, -1,
 			     "e752x UE log memory write", "", NULL);
@@ -982,7 +982,7 @@ static void e752x_check(struct mem_ctl_info *mci)
 {
 	struct e752x_error_info info;
 
-	debugf3("%s()\n", __func__);
+	debugf3("\n");
 	e752x_get_error_info(mci, &info);
 	e752x_process_error_info(mci, &info, 1);
 }
@@ -1102,7 +1102,7 @@ static void e752x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 		pci_read_config_byte(pdev, E752X_DRB + index, &value);
 		/* convert a 128 or 64 MiB DRB to a page size. */
 		cumul_size = value << (25 + drc_drbg - PAGE_SHIFT);
-		debugf3("%s(): (%d) cumul_size 0x%x\n", __func__, index,
+		debugf3("(%d) cumul_size 0x%x\n", index,
 			cumul_size);
 		if (cumul_size == last_cumul_size)
 			continue;	/* not populated */
@@ -1270,7 +1270,7 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 	int drc_chan;		/* Number of channels 0=1chan,1=2chan */
 	struct e752x_error_info discard;
 
-	debugf0("%s(): mci\n", __func__);
+	debugf0("mci\n");
 	debugf0("Starting Probe1\n");
 
 	/* check to see if device 0 function 1 is enabled; if it isn't, we
@@ -1301,7 +1301,7 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 	if (mci == NULL)
 		return -ENOMEM;
 
-	debugf3("%s(): init mci\n", __func__);
+	debugf3("init mci\n");
 	mci->mtype_cap = MEM_FLAG_RDDR;
 	/* 3100 IMCH supports SECDEC only */
 	mci->edac_ctl_cap = (dev_idx == I3100) ? EDAC_FLAG_SECDED :
@@ -1311,7 +1311,7 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 	mci->mod_ver = E752X_REVISION;
 	mci->pdev = &pdev->dev;
 
-	debugf3("%s(): init pvt\n", __func__);
+	debugf3("init pvt\n");
 	pvt = (struct e752x_pvt *)mci->pvt_info;
 	pvt->dev_info = &e752x_devs[dev_idx];
 	pvt->mc_symmetric = ((ddrcsr & 0x10) != 0);
@@ -1321,7 +1321,7 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 		return -ENODEV;
 	}
 
-	debugf3("%s(): more mci init\n", __func__);
+	debugf3("more mci init\n");
 	mci->ctl_name = pvt->dev_info->ctl_name;
 	mci->dev_name = pci_name(pdev);
 	mci->edac_check = e752x_check;
@@ -1343,7 +1343,7 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 		mci->edac_cap = EDAC_FLAG_SECDED; /* the only mode supported */
 	else
 		mci->edac_cap |= EDAC_FLAG_NONE;
-	debugf3("%s(): tolm, remapbase, remaplimit\n", __func__);
+	debugf3("tolm, remapbase, remaplimit\n");
 
 	/* load the top of low memory, remap base, and remap limit vars */
 	pci_read_config_word(pdev, E752X_TOLM, &pci_data);
@@ -1360,7 +1360,7 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
 	if (edac_mc_add_mc(mci)) {
-		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
+		debugf3("failed edac_mc_add_mc()\n");
 		goto fail;
 	}
 
@@ -1378,7 +1378,7 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 	}
 
 	/* get this far and it's successful */
-	debugf3("%s(): success\n", __func__);
+	debugf3("success\n");
 	return 0;
 
 fail:
@@ -1394,7 +1394,7 @@ fail:
 static int __devinit e752x_init_one(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	/* wake up and enable device */
 	if (pci_enable_device(pdev) < 0)
@@ -1408,7 +1408,7 @@ static void __devexit e752x_remove_one(struct pci_dev *pdev)
 	struct mem_ctl_info *mci;
 	struct e752x_pvt *pvt;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	if (e752x_pci)
 		edac_pci_release_generic_ctl(e752x_pci);
@@ -1454,7 +1454,7 @@ static int __init e752x_init(void)
 {
 	int pci_rc;
 
-	debugf3("%s()\n", __func__);
+	debugf3("\n");
 
        /* Ensure that the OPSTATE is set correctly for POLL or NMI */
        opstate_init();
@@ -1465,7 +1465,7 @@ static int __init e752x_init(void)
 
 static void __exit e752x_exit(void)
 {
-	debugf3("%s()\n", __func__);
+	debugf3("\n");
 	pci_unregister_driver(&e752x_driver);
 }
 
diff --git a/drivers/edac/e7xxx_edac.c b/drivers/edac/e7xxx_edac.c
index c6c0eba..691d706 100644
--- a/drivers/edac/e7xxx_edac.c
+++ b/drivers/edac/e7xxx_edac.c
@@ -166,7 +166,7 @@ static const struct e7xxx_dev_info e7xxx_devs[] = {
 /* FIXME - is this valid for both SECDED and S4ECD4ED? */
 static inline int e7xxx_find_channel(u16 syndrome)
 {
-	debugf3("%s()\n", __func__);
+	debugf3("\n");
 
 	if ((syndrome & 0xff00) == 0)
 		return 0;
@@ -186,7 +186,7 @@ static unsigned long ctl_page_to_phys(struct mem_ctl_info *mci,
 	u32 remap;
 	struct e7xxx_pvt *pvt = (struct e7xxx_pvt *)mci->pvt_info;
 
-	debugf3("%s()\n", __func__);
+	debugf3("\n");
 
 	if ((page < pvt->tolm) ||
 		((page >= 0x100000) && (page < pvt->remapbase)))
@@ -208,7 +208,7 @@ static void process_ce(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
 	int row;
 	int channel;
 
-	debugf3("%s()\n", __func__);
+	debugf3("\n");
 	/* read the error address */
 	error_1b = info->dram_celog_add;
 	/* FIXME - should use PAGE_SHIFT */
@@ -225,7 +225,7 @@ static void process_ce(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
 
 static void process_ce_no_info(struct mem_ctl_info *mci)
 {
-	debugf3("%s()\n", __func__);
+	debugf3("\n");
 	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0, -1, -1, -1,
 			     "e7xxx CE log register overflow", "", NULL);
 }
@@ -235,7 +235,7 @@ static void process_ue(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
 	u32 error_2b, block_page;
 	int row;
 
-	debugf3("%s()\n", __func__);
+	debugf3("\n");
 	/* read the error address */
 	error_2b = info->dram_uelog_add;
 	/* FIXME - should use PAGE_SHIFT */
@@ -248,7 +248,7 @@ static void process_ue(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
 
 static void process_ue_no_info(struct mem_ctl_info *mci)
 {
-	debugf3("%s()\n", __func__);
+	debugf3("\n");
 
 	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0, -1, -1, -1,
 			     "e7xxx UE log register overflow", "", NULL);
@@ -334,7 +334,7 @@ static void e7xxx_check(struct mem_ctl_info *mci)
 {
 	struct e7xxx_error_info info;
 
-	debugf3("%s()\n", __func__);
+	debugf3("\n");
 	e7xxx_get_error_info(mci, &info);
 	e7xxx_process_error_info(mci, &info, 1);
 }
@@ -383,7 +383,7 @@ static void e7xxx_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 		pci_read_config_byte(pdev, E7XXX_DRB + index, &value);
 		/* convert a 64 or 32 MiB DRB to a page size. */
 		cumul_size = value << (25 + drc_drbg - PAGE_SHIFT);
-		debugf3("%s(): (%d) cumul_size 0x%x\n", __func__, index,
+		debugf3("(%d) cumul_size 0x%x\n", index,
 			cumul_size);
 		if (cumul_size == last_cumul_size)
 			continue;	/* not populated */
@@ -430,7 +430,7 @@ static int e7xxx_probe1(struct pci_dev *pdev, int dev_idx)
 	int drc_chan;
 	struct e7xxx_error_info discard;
 
-	debugf0("%s(): mci\n", __func__);
+	debugf0("mci\n");
 
 	pci_read_config_dword(pdev, E7XXX_DRC, &drc);
 
@@ -453,7 +453,7 @@ static int e7xxx_probe1(struct pci_dev *pdev, int dev_idx)
 	if (mci == NULL)
 		return -ENOMEM;
 
-	debugf3("%s(): init mci\n", __func__);
+	debugf3("init mci\n");
 	mci->mtype_cap = MEM_FLAG_RDDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED |
 		EDAC_FLAG_S4ECD4ED;
@@ -461,7 +461,7 @@ static int e7xxx_probe1(struct pci_dev *pdev, int dev_idx)
 	mci->mod_name = EDAC_MOD_STR;
 	mci->mod_ver = E7XXX_REVISION;
 	mci->pdev = &pdev->dev;
-	debugf3("%s(): init pvt\n", __func__);
+	debugf3("init pvt\n");
 	pvt = (struct e7xxx_pvt *)mci->pvt_info;
 	pvt->dev_info = &e7xxx_devs[dev_idx];
 	pvt->bridge_ck = pci_get_device(PCI_VENDOR_ID_INTEL,
@@ -474,14 +474,14 @@ static int e7xxx_probe1(struct pci_dev *pdev, int dev_idx)
 		goto fail0;
 	}
 
-	debugf3("%s(): more mci init\n", __func__);
+	debugf3("more mci init\n");
 	mci->ctl_name = pvt->dev_info->ctl_name;
 	mci->dev_name = pci_name(pdev);
 	mci->edac_check = e7xxx_check;
 	mci->ctl_page_to_phys = ctl_page_to_phys;
 	e7xxx_init_csrows(mci, pdev, dev_idx, drc);
 	mci->edac_cap |= EDAC_FLAG_NONE;
-	debugf3("%s(): tolm, remapbase, remaplimit\n", __func__);
+	debugf3("tolm, remapbase, remaplimit\n");
 	/* load the top of low memory, remap base, and remap limit vars */
 	pci_read_config_word(pdev, E7XXX_TOLM, &pci_data);
 	pvt->tolm = ((u32) pci_data) << 4;
@@ -500,7 +500,7 @@ static int e7xxx_probe1(struct pci_dev *pdev, int dev_idx)
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
 	if (edac_mc_add_mc(mci)) {
-		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
+		debugf3("failed edac_mc_add_mc()\n");
 		goto fail1;
 	}
 
@@ -516,7 +516,7 @@ static int e7xxx_probe1(struct pci_dev *pdev, int dev_idx)
 	}
 
 	/* get this far and it's successful */
-	debugf3("%s(): success\n", __func__);
+	debugf3("success\n");
 	return 0;
 
 fail1:
@@ -532,7 +532,7 @@ fail0:
 static int __devinit e7xxx_init_one(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	/* wake up and enable device */
 	return pci_enable_device(pdev) ?
@@ -544,7 +544,7 @@ static void __devexit e7xxx_remove_one(struct pci_dev *pdev)
 	struct mem_ctl_info *mci;
 	struct e7xxx_pvt *pvt;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	if (e7xxx_pci)
 		edac_pci_release_generic_ctl(e7xxx_pci);
diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
index cb397d9..ed46949 100644
--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -82,8 +82,8 @@ struct edac_device_ctl_info *edac_device_alloc_ctl_info(
 	void *pvt, *p;
 	int err;
 
-	debugf4("%s() instances=%d blocks=%d\n",
-		__func__, nr_instances, nr_blocks);
+	debugf4("instances=%d blocks=%d\n",
+		nr_instances, nr_blocks);
 
 	/* Calculate the size of memory we need to allocate AND
 	 * determine the offsets of the various item arrays
@@ -156,8 +156,8 @@ struct edac_device_ctl_info *edac_device_alloc_ctl_info(
 	/* Name of this edac device */
 	snprintf(dev_ctl->name,sizeof(dev_ctl->name),"%s",edac_device_name);
 
-	debugf4("%s() edac_dev=%p next after end=%p\n",
-		__func__, dev_ctl, pvt + sz_private );
+	debugf4("edac_dev=%p next after end=%p\n",
+		dev_ctl, pvt + sz_private );
 
 	/* Initialize every Instance */
 	for (instance = 0; instance < nr_instances; instance++) {
@@ -178,9 +178,9 @@ struct edac_device_ctl_info *edac_device_alloc_ctl_info(
 			snprintf(blk->name, sizeof(blk->name),
 				 "%s%d", edac_block_name, block+offset_value);
 
-			debugf4("%s() instance=%d inst_p=%p block=#%d "
+			debugf4("instance=%d inst_p=%p block=#%d "
 				"block_p=%p name='%s'\n",
-				__func__, instance, inst, block,
+				instance, inst, block,
 				blk, blk->name);
 
 			/* if there are NO attributes OR no attribute pointer
@@ -194,8 +194,8 @@ struct edac_device_ctl_info *edac_device_alloc_ctl_info(
 			attrib_p = &dev_attrib[block*nr_instances*nr_attrib];
 			blk->block_attributes = attrib_p;
 
-			debugf4("%s() THIS BLOCK_ATTRIB=%p\n",
-				__func__, blk->block_attributes);
+			debugf4("THIS BLOCK_ATTRIB=%p\n",
+				blk->block_attributes);
 
 			/* Initialize every user specified attribute in this
 			 * block with the data the caller passed in
@@ -214,9 +214,9 @@ struct edac_device_ctl_info *edac_device_alloc_ctl_info(
 
 				attrib->block = blk;	/* up link */
 
-				debugf4("%s() alloc-attrib=%p attrib_name='%s' "
+				debugf4("alloc-attrib=%p attrib_name='%s' "
 					"attrib-spec=%p spec-name=%s\n",
-					__func__, attrib, attrib->attr.name,
+					attrib, attrib->attr.name,
 					&attrib_spec[attr],
 					attrib_spec[attr].attr.name
 					);
@@ -273,7 +273,7 @@ static struct edac_device_ctl_info *find_edac_device_by_dev(struct device *dev)
 	struct edac_device_ctl_info *edac_dev;
 	struct list_head *item;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	list_for_each(item, &edac_device_list) {
 		edac_dev = list_entry(item, struct edac_device_ctl_info, link);
@@ -408,7 +408,7 @@ static void edac_device_workq_function(struct work_struct *work_req)
 void edac_device_workq_setup(struct edac_device_ctl_info *edac_dev,
 				unsigned msec)
 {
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	/* take the arg 'msec' and set it into the control structure
 	 * to used in the time period calculation
@@ -496,7 +496,7 @@ EXPORT_SYMBOL_GPL(edac_device_alloc_index);
  */
 int edac_device_add_device(struct edac_device_ctl_info *edac_dev)
 {
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 #ifdef CONFIG_EDAC_DEBUG
 	if (edac_debug_level >= 3)
@@ -570,7 +570,7 @@ struct edac_device_ctl_info *edac_device_del_device(struct device *dev)
 {
 	struct edac_device_ctl_info *edac_dev;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	mutex_lock(&device_ctls_mutex);
 
diff --git a/drivers/edac/edac_device_sysfs.c b/drivers/edac/edac_device_sysfs.c
index b4ea185..1cee83e 100644
--- a/drivers/edac/edac_device_sysfs.c
+++ b/drivers/edac/edac_device_sysfs.c
@@ -202,7 +202,7 @@ static void edac_device_ctrl_master_release(struct kobject *kobj)
 {
 	struct edac_device_ctl_info *edac_dev = to_edacdev(kobj);
 
-	debugf4("%s() control index=%d\n", __func__, edac_dev->dev_idx);
+	debugf4("control index=%d\n", edac_dev->dev_idx);
 
 	/* decrement the EDAC CORE module ref count */
 	module_put(edac_dev->owner);
@@ -233,12 +233,12 @@ int edac_device_register_sysfs_main_kobj(struct edac_device_ctl_info *edac_dev)
 	struct bus_type *edac_subsys;
 	int err;
 
-	debugf1("%s()\n", __func__);
+	debugf1("\n");
 
 	/* get the /sys/devices/system/edac reference */
 	edac_subsys = edac_get_sysfs_subsys();
 	if (edac_subsys == NULL) {
-		debugf1("%s() no edac_subsys error\n", __func__);
+		debugf1("no edac_subsys error\n");
 		err = -ENODEV;
 		goto err_out;
 	}
@@ -264,8 +264,8 @@ int edac_device_register_sysfs_main_kobj(struct edac_device_ctl_info *edac_dev)
 				   &edac_subsys->dev_root->kobj,
 				   "%s", edac_dev->name);
 	if (err) {
-		debugf1("%s()Failed to register '.../edac/%s'\n",
-			__func__, edac_dev->name);
+		debugf1("Failed to register '.../edac/%s'\n",
+			edac_dev->name);
 		goto err_kobj_reg;
 	}
 	kobject_uevent(&edac_dev->kobj, KOBJ_ADD);
@@ -274,8 +274,8 @@ int edac_device_register_sysfs_main_kobj(struct edac_device_ctl_info *edac_dev)
 	 * edac_device_unregister_sysfs_main_kobj() must be used
 	 */
 
-	debugf4("%s() Registered '.../edac/%s' kobject\n",
-		__func__, edac_dev->name);
+	debugf4("Registered '.../edac/%s' kobject\n",
+		edac_dev->name);
 
 	return 0;
 
@@ -296,9 +296,9 @@ err_out:
  */
 void edac_device_unregister_sysfs_main_kobj(struct edac_device_ctl_info *dev)
 {
-	debugf0("%s()\n", __func__);
-	debugf4("%s() name of kobject is: %s\n",
-		__func__, kobject_name(&dev->kobj));
+	debugf0("\n");
+	debugf4("name of kobject is: %s\n",
+		kobject_name(&dev->kobj));
 
 	/*
 	 * Unregister the edac device's kobject and
@@ -336,7 +336,7 @@ static void edac_device_ctrl_instance_release(struct kobject *kobj)
 {
 	struct edac_device_instance *instance;
 
-	debugf1("%s()\n", __func__);
+	debugf1("\n");
 
 	/* map from this kobj to the main control struct
 	 * and then dec the main kobj count
@@ -442,7 +442,7 @@ static void edac_device_ctrl_block_release(struct kobject *kobj)
 {
 	struct edac_device_block *block;
 
-	debugf1("%s()\n", __func__);
+	debugf1("\n");
 
 	/* get the container of the kobj */
 	block = to_block(kobj);
@@ -524,10 +524,10 @@ static int edac_device_create_block(struct edac_device_ctl_info *edac_dev,
 	struct edac_dev_sysfs_block_attribute *sysfs_attrib;
 	struct kobject *main_kobj;
 
-	debugf4("%s() Instance '%s' inst_p=%p  block '%s'  block_p=%p\n",
-		__func__, instance->name, instance, block->name, block);
-	debugf4("%s() block kobj=%p  block kobj->parent=%p\n",
-		__func__, &block->kobj, &block->kobj.parent);
+	debugf4("Instance '%s' inst_p=%p  block '%s'  block_p=%p\n",
+		instance->name, instance, block->name, block);
+	debugf4("block kobj=%p  block kobj->parent=%p\n",
+		&block->kobj, &block->kobj.parent);
 
 	/* init this block's kobject */
 	memset(&block->kobj, 0, sizeof(struct kobject));
@@ -546,8 +546,8 @@ static int edac_device_create_block(struct edac_device_ctl_info *edac_dev,
 				   &instance->kobj,
 				   "%s", block->name);
 	if (err) {
-		debugf1("%s() Failed to register instance '%s'\n",
-			__func__, block->name);
+		debugf1("Failed to register instance '%s'\n",
+			block->name);
 		kobject_put(main_kobj);
 		err = -ENODEV;
 		goto err_out;
@@ -560,9 +560,8 @@ static int edac_device_create_block(struct edac_device_ctl_info *edac_dev,
 	if (sysfs_attrib && block->nr_attribs) {
 		for (i = 0; i < block->nr_attribs; i++, sysfs_attrib++) {
 
-			debugf4("%s() creating block attrib='%s' "
+			debugf4("creating block attrib='%s' "
 				"attrib->%p to kobj=%p\n",
-				__func__,
 				sysfs_attrib->attr.name,
 				sysfs_attrib, &block->kobj);
 
@@ -647,14 +646,14 @@ static int edac_device_create_instance(struct edac_device_ctl_info *edac_dev,
 	err = kobject_init_and_add(&instance->kobj, &ktype_instance_ctrl,
 				   &edac_dev->kobj, "%s", instance->name);
 	if (err != 0) {
-		debugf2("%s() Failed to register instance '%s'\n",
-			__func__, instance->name);
+		debugf2("Failed to register instance '%s'\n",
+			instance->name);
 		kobject_put(main_kobj);
 		goto err_out;
 	}
 
-	debugf4("%s() now register '%d' blocks for instance %d\n",
-		__func__, instance->nr_blocks, idx);
+	debugf4("now register '%d' blocks for instance %d\n",
+		instance->nr_blocks, idx);
 
 	/* register all blocks of this instance */
 	for (i = 0; i < instance->nr_blocks; i++) {
@@ -670,8 +669,8 @@ static int edac_device_create_instance(struct edac_device_ctl_info *edac_dev,
 	}
 	kobject_uevent(&instance->kobj, KOBJ_ADD);
 
-	debugf4("%s() Registered instance %d '%s' kobject\n",
-		__func__, idx, instance->name);
+	debugf4("Registered instance %d '%s' kobject\n",
+		idx, instance->name);
 
 	return 0;
 
@@ -715,7 +714,7 @@ static int edac_device_create_instances(struct edac_device_ctl_info *edac_dev)
 	int i, j;
 	int err;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	/* iterate over creation of the instances */
 	for (i = 0; i < edac_dev->nr_instances; i++) {
@@ -817,12 +816,12 @@ int edac_device_create_sysfs(struct edac_device_ctl_info *edac_dev)
 	int err;
 	struct kobject *edac_kobj = &edac_dev->kobj;
 
-	debugf0("%s() idx=%d\n", __func__, edac_dev->dev_idx);
+	debugf0("idx=%d\n", edac_dev->dev_idx);
 
 	/*  go create any main attributes callers wants */
 	err = edac_device_add_main_sysfs_attributes(edac_dev);
 	if (err) {
-		debugf0("%s() failed to add sysfs attribs\n", __func__);
+		debugf0("failed to add sysfs attribs\n");
 		goto err_out;
 	}
 
@@ -832,8 +831,8 @@ int edac_device_create_sysfs(struct edac_device_ctl_info *edac_dev)
 	err = sysfs_create_link(edac_kobj,
 				&edac_dev->dev->kobj, EDAC_DEVICE_SYMLINK);
 	if (err) {
-		debugf0("%s() sysfs_create_link() returned err= %d\n",
-			__func__, err);
+		debugf0("sysfs_create_link() returned err= %d\n",
+			err);
 		goto err_remove_main_attribs;
 	}
 
@@ -843,14 +842,14 @@ int edac_device_create_sysfs(struct edac_device_ctl_info *edac_dev)
 	 */
 	err = edac_device_create_instances(edac_dev);
 	if (err) {
-		debugf0("%s() edac_device_create_instances() "
-			"returned err= %d\n", __func__, err);
+		debugf0("edac_device_create_instances() "
+			"returned err= %d\n", err);
 		goto err_remove_link;
 	}
 
 
-	debugf4("%s() create-instances done, idx=%d\n",
-		__func__, edac_dev->dev_idx);
+	debugf4("create-instances done, idx=%d\n",
+		edac_dev->dev_idx);
 
 	return 0;
 
@@ -873,7 +872,7 @@ err_out:
  */
 void edac_device_remove_sysfs(struct edac_device_ctl_info *edac_dev)
 {
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	/* remove any main attributes for this device */
 	edac_device_remove_main_sysfs_attributes(edac_dev);
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 2479831..8d7c380 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -245,18 +245,18 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 	layer = edac_align_ptr(&ptr, sizeof(*layer), n_layers);
 	for (i = 0; i < n_layers; i++) {
 		count *= layers[i].size;
-		debugf4("%s: errcount layer %d size %d\n", __func__, i, count);
+		debugf4("errcount layer %d size %d\n", i, count);
 		ce_per_layer[i] = edac_align_ptr(&ptr, sizeof(u32), count);
 		ue_per_layer[i] = edac_align_ptr(&ptr, sizeof(u32), count);
 		tot_errcount += 2 * count;
 	}
 
-	debugf4("%s: allocating %d error counters\n", __func__, tot_errcount);
+	debugf4("allocating %d error counters\n", tot_errcount);
 	pvt = edac_align_ptr(&ptr, sz_pvt, 1);
 	size = ((unsigned long)pvt) + sz_pvt;
 
-	debugf1("%s(): allocating %u bytes for mci data (%d %s, %d csrows/channels)\n",
-		__func__, size,
+	debugf1("allocating %u bytes for mci data (%d %s, %d csrows/channels)\n",
+		size,
 		tot_dimms,
 		per_rank ? "ranks" : "dimms",
 		tot_csrows * tot_channels);
@@ -325,7 +325,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 	memset(&pos, 0, sizeof(pos));
 	row = 0;
 	chn = 0;
-	debugf4("%s: initializing %d %s\n", __func__, tot_dimms,
+	debugf4("initializing %d %s\n", tot_dimms,
 		per_rank ? "ranks" : "dimms");
 	for (i = 0; i < tot_dimms; i++) {
 		chan = mci->csrows[row]->channels[chn];
@@ -339,8 +339,8 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 		mci->dimms[off] = dimm;
 		dimm->mci = mci;
 
-		debugf2("%s: %d: %s%i (%d:%d:%d): row %d, chan %d\n", __func__,
-			i, per_rank ? "rank" : "dimm", off,
+		debugf2("%d: %s%i (%d:%d:%d): row %d, chan %d\n", i,
+			per_rank ? "rank" : "dimm", off,
 			pos[0], pos[1], pos[2], row, chn);
 
 		/*
@@ -426,7 +426,7 @@ EXPORT_SYMBOL_GPL(edac_mc_alloc);
  */
 void edac_mc_free(struct mem_ctl_info *mci)
 {
-	debugf1("%s()\n", __func__);
+	debugf1("\n");
 
 	/* the mci instance is freed here, when the sysfs object is dropped */
 	edac_unregister_sysfs(mci);
@@ -446,7 +446,7 @@ struct mem_ctl_info *find_mci_by_dev(struct device *dev)
 	struct mem_ctl_info *mci;
 	struct list_head *item;
 
-	debugf3("%s()\n", __func__);
+	debugf3("\n");
 
 	list_for_each(item, &mc_devices) {
 		mci = list_entry(item, struct mem_ctl_info, link);
@@ -514,7 +514,7 @@ static void edac_mc_workq_function(struct work_struct *work_req)
  */
 static void edac_mc_workq_setup(struct mem_ctl_info *mci, unsigned msec)
 {
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	/* if this instance is not in the POLL state, then simply return */
 	if (mci->op_state != OP_RUNNING_POLL)
@@ -541,8 +541,7 @@ static void edac_mc_workq_teardown(struct mem_ctl_info *mci)
 
 	status = cancel_delayed_work(&mci->work);
 	if (status == 0) {
-		debugf0("%s() not canceled, flush the queue\n",
-			__func__);
+		debugf0("not canceled, flush the queue\n");
 
 		/* workq instance might be running, wait for it */
 		flush_workqueue(edac_workqueue);
@@ -689,7 +688,7 @@ EXPORT_SYMBOL(edac_mc_find);
 /* FIXME - should a warning be printed if no error detection? correction? */
 int edac_mc_add_mc(struct mem_ctl_info *mci)
 {
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 #ifdef CONFIG_EDAC_DEBUG
 	if (edac_debug_level >= 3)
@@ -760,7 +759,7 @@ struct mem_ctl_info *edac_mc_del_mc(struct device *dev)
 {
 	struct mem_ctl_info *mci;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	mutex_lock(&mem_ctls_mutex);
 
@@ -798,7 +797,7 @@ static void edac_mc_scrub_block(unsigned long page, unsigned long offset,
 	void *virt_addr;
 	unsigned long flags = 0;
 
-	debugf3("%s()\n", __func__);
+	debugf3("\n");
 
 	/* ECC error page was not in our memory. Ignore it. */
 	if (!pfn_valid(page))
@@ -828,7 +827,7 @@ int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci, unsigned long page)
 	struct csrow_info **csrows = mci->csrows;
 	int row, i, j, n;
 
-	debugf1("MC%d: %s(): 0x%lx\n", mci->mc_idx, __func__, page);
+	debugf1("MC%d: 0x%lx\n", mci->mc_idx, page);
 	row = -1;
 
 	for (i = 0; i < mci->nr_csrows; i++) {
@@ -841,8 +840,8 @@ int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci, unsigned long page)
 		if (n == 0)
 			continue;
 
-		debugf3("MC%d: %s(): first(0x%lx) page(0x%lx) last(0x%lx) "
-			"mask(0x%lx)\n", mci->mc_idx, __func__,
+		debugf3("MC%d: first(0x%lx) page(0x%lx) last(0x%lx) "
+			"mask(0x%lx)\n", mci->mc_idx,
 			csrow->first_page, page, csrow->last_page,
 			csrow->page_mask);
 
@@ -1046,7 +1045,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 	u32 grain;
 	bool enable_per_layer_report = false;
 
-	debugf3("MC%d: %s()\n", mci->mc_idx, __func__);
+	debugf3("MC%d\n", mci->mc_idx);
 
 	/*
 	 * Check if the event report is consistent and if the memory
@@ -1124,8 +1123,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			 * get csrow/channel of the DIMM, in order to allow
 			 * incrementing the compat API counters
 			 */
-			debugf4("%s: %s csrows map: (%d,%d)\n",
-				__func__,
+			debugf4("%s csrows map: (%d,%d)\n",
 				mci->mem_is_per_rank ? "rank" : "dimm",
 				dimm->csrow, dimm->cschannel);
 
@@ -1144,8 +1142,8 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 	if (!enable_per_layer_report) {
 		strcpy(label, "any memory");
 	} else {
-		debugf4("%s: csrow/channel to increment: (%d,%d)\n",
-			__func__, row, chan);
+		debugf4("csrow/channel to increment: (%d,%d)\n",
+			row, chan);
 		if (p == label)
 			strcpy(label, "unknown memory");
 		if (type == HW_EVENT_ERR_CORRECTED) {
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 87b8d7d..f72de8b 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -376,8 +376,7 @@ static int edac_create_csrow_object(struct mem_ctl_info *mci,
 	dev_set_name(&csrow->dev, "csrow%d", index);
 	dev_set_drvdata(&csrow->dev, csrow);
 
-	debugf0("%s(): creating (virtual) csrow node %s\n", __func__,
-		dev_name(&csrow->dev));
+	debugf0("creating (virtual) csrow node %s\n", dev_name(&csrow->dev));
 
 	err = device_add(&csrow->dev);
 	if (err < 0)
@@ -623,8 +622,7 @@ static int edac_create_dimm_object(struct mem_ctl_info *mci,
 
 	err =  device_add(&dimm->dev);
 
-	debugf0("%s(): creating rank/dimm device %s\n", __func__,
-		dev_name(&dimm->dev));
+	debugf0("creating rank/dimm device %s\n", dev_name(&dimm->dev));
 
 	return err;
 }
@@ -981,8 +979,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 	dev_set_drvdata(&mci->dev, mci);
 	pm_runtime_forbid(&mci->dev);
 
-	debugf0("%s(): creating device %s\n", __func__,
-		dev_name(&mci->dev));
+	debugf0("creating device %s\n", dev_name(&mci->dev));
 	err = device_add(&mci->dev);
 	if (err < 0) {
 		bus_unregister(&mci->bus);
@@ -999,8 +996,8 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 		if (dimm->nr_pages == 0)
 			continue;
 #ifdef CONFIG_EDAC_DEBUG
-		debugf1("%s creating dimm%d, located at ",
-			__func__, i);
+		debugf1("creating dimm%d, located at ",
+			i);
 		if (edac_debug_level >= 1) {
 			int lay;
 			for (lay = 0; lay < mci->n_layers; lay++)
@@ -1012,8 +1009,8 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 #endif
 		err = edac_create_dimm_object(mci, dimm, i);
 		if (err) {
-			debugf1("%s() failure: create dimm %d obj\n",
-				__func__, i);
+			debugf1("failure: create dimm %d obj\n",
+				i);
 			goto fail;
 		}
 	}
@@ -1051,7 +1048,7 @@ void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
 {
 	int i;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 #ifdef CONFIG_EDAC_DEBUG
 	debugfs_remove(mci->debugfs);
@@ -1064,8 +1061,7 @@ void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
 		struct dimm_info *dimm = mci->dimms[i];
 		if (dimm->nr_pages == 0)
 			continue;
-		debugf0("%s(): removing device %s\n", __func__,
-			dev_name(&dimm->dev));
+		debugf0("removing device %s\n", dev_name(&dimm->dev));
 		put_device(&dimm->dev);
 		device_del(&dimm->dev);
 	}
@@ -1105,7 +1101,7 @@ int __init edac_mc_sysfs_init(void)
 	/* get the /sys/devices/system/edac subsys reference */
 	edac_subsys = edac_get_sysfs_subsys();
 	if (edac_subsys == NULL) {
-		debugf1("%s() no edac_subsys\n", __func__);
+		debugf1("no edac_subsys\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/edac/edac_module.c b/drivers/edac/edac_module.c
index 8735a0d..9de2484 100644
--- a/drivers/edac/edac_module.c
+++ b/drivers/edac/edac_module.c
@@ -113,7 +113,7 @@ error:
  */
 static void __exit edac_exit(void)
 {
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	/* tear down the various subsystems */
 	edac_workqueue_teardown();
diff --git a/drivers/edac/edac_pci.c b/drivers/edac/edac_pci.c
index f1ac866..51dd4e0 100644
--- a/drivers/edac/edac_pci.c
+++ b/drivers/edac/edac_pci.c
@@ -45,7 +45,7 @@ struct edac_pci_ctl_info *edac_pci_alloc_ctl_info(unsigned int sz_pvt,
 	void *p = NULL, *pvt;
 	unsigned int size;
 
-	debugf1("%s()\n", __func__);
+	debugf1("\n");
 
 	pci = edac_align_ptr(&p, sizeof(*pci), 1);
 	pvt = edac_align_ptr(&p, 1, sz_pvt);
@@ -80,7 +80,7 @@ EXPORT_SYMBOL_GPL(edac_pci_alloc_ctl_info);
  */
 void edac_pci_free_ctl_info(struct edac_pci_ctl_info *pci)
 {
-	debugf1("%s()\n", __func__);
+	debugf1("\n");
 
 	edac_pci_remove_sysfs(pci);
 }
@@ -97,7 +97,7 @@ static struct edac_pci_ctl_info *find_edac_pci_by_dev(struct device *dev)
 	struct edac_pci_ctl_info *pci;
 	struct list_head *item;
 
-	debugf1("%s()\n", __func__);
+	debugf1("\n");
 
 	list_for_each(item, &edac_pci_list) {
 		pci = list_entry(item, struct edac_pci_ctl_info, link);
@@ -122,7 +122,7 @@ static int add_edac_pci_to_global_list(struct edac_pci_ctl_info *pci)
 	struct list_head *item, *insert_before;
 	struct edac_pci_ctl_info *rover;
 
-	debugf1("%s()\n", __func__);
+	debugf1("\n");
 
 	insert_before = &edac_pci_list;
 
@@ -226,7 +226,7 @@ static void edac_pci_workq_function(struct work_struct *work_req)
 	int msec;
 	unsigned long delay;
 
-	debugf3("%s() checking\n", __func__);
+	debugf3("checking\n");
 
 	mutex_lock(&edac_pci_ctls_mutex);
 
@@ -261,7 +261,7 @@ static void edac_pci_workq_function(struct work_struct *work_req)
 static void edac_pci_workq_setup(struct edac_pci_ctl_info *pci,
 				 unsigned int msec)
 {
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	INIT_DELAYED_WORK(&pci->work, edac_pci_workq_function);
 	queue_delayed_work(edac_workqueue, &pci->work,
@@ -276,7 +276,7 @@ static void edac_pci_workq_teardown(struct edac_pci_ctl_info *pci)
 {
 	int status;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	status = cancel_delayed_work(&pci->work);
 	if (status == 0)
@@ -293,7 +293,7 @@ static void edac_pci_workq_teardown(struct edac_pci_ctl_info *pci)
 void edac_pci_reset_delay_period(struct edac_pci_ctl_info *pci,
 				 unsigned long value)
 {
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	edac_pci_workq_teardown(pci);
 
@@ -333,7 +333,7 @@ EXPORT_SYMBOL_GPL(edac_pci_alloc_index);
  */
 int edac_pci_add_device(struct edac_pci_ctl_info *pci, int edac_idx)
 {
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	pci->pci_idx = edac_idx;
 	pci->start_time = jiffies;
@@ -393,7 +393,7 @@ struct edac_pci_ctl_info *edac_pci_del_device(struct device *dev)
 {
 	struct edac_pci_ctl_info *pci;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	mutex_lock(&edac_pci_ctls_mutex);
 
@@ -430,7 +430,7 @@ EXPORT_SYMBOL_GPL(edac_pci_del_device);
  */
 static void edac_pci_generic_check(struct edac_pci_ctl_info *pci)
 {
-	debugf4("%s()\n", __func__);
+	debugf4("\n");
 	edac_pci_do_parity_check();
 }
 
@@ -475,7 +475,7 @@ struct edac_pci_ctl_info *edac_pci_create_generic_ctl(struct device *dev,
 	pdata->edac_idx = edac_pci_idx++;
 
 	if (edac_pci_add_device(pci, pdata->edac_idx) > 0) {
-		debugf3("%s(): failed edac_pci_add_device()\n", __func__);
+		debugf3("failed edac_pci_add_device()\n");
 		edac_pci_free_ctl_info(pci);
 		return NULL;
 	}
@@ -491,7 +491,7 @@ EXPORT_SYMBOL_GPL(edac_pci_create_generic_ctl);
  */
 void edac_pci_release_generic_ctl(struct edac_pci_ctl_info *pci)
 {
-	debugf0("%s() pci mod=%s\n", __func__, pci->mod_name);
+	debugf0("pci mod=%s\n", pci->mod_name);
 
 	edac_pci_del_device(pci->dev);
 	edac_pci_free_ctl_info(pci);
diff --git a/drivers/edac/edac_pci_sysfs.c b/drivers/edac/edac_pci_sysfs.c
index 97f5064..6678216 100644
--- a/drivers/edac/edac_pci_sysfs.c
+++ b/drivers/edac/edac_pci_sysfs.c
@@ -78,7 +78,7 @@ static void edac_pci_instance_release(struct kobject *kobj)
 {
 	struct edac_pci_ctl_info *pci;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	/* Form pointer to containing struct, the pci control struct */
 	pci = to_instance(kobj);
@@ -161,7 +161,7 @@ static int edac_pci_create_instance_kobj(struct edac_pci_ctl_info *pci, int idx)
 	struct kobject *main_kobj;
 	int err;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	/* First bump the ref count on the top main kobj, which will
 	 * track the number of PCI instances we have, and thus nest
@@ -177,14 +177,14 @@ static int edac_pci_create_instance_kobj(struct edac_pci_ctl_info *pci, int idx)
 	err = kobject_init_and_add(&pci->kobj, &ktype_pci_instance,
 				   edac_pci_top_main_kobj, "pci%d", idx);
 	if (err != 0) {
-		debugf2("%s() failed to register instance pci%d\n",
-			__func__, idx);
+		debugf2("failed to register instance pci%d\n",
+			idx);
 		kobject_put(edac_pci_top_main_kobj);
 		goto error_out;
 	}
 
 	kobject_uevent(&pci->kobj, KOBJ_ADD);
-	debugf1("%s() Register instance 'pci%d' kobject\n", __func__, idx);
+	debugf1("Register instance 'pci%d' kobject\n", idx);
 
 	return 0;
 
@@ -201,7 +201,7 @@ error_out:
 static void edac_pci_unregister_sysfs_instance_kobj(
 			struct edac_pci_ctl_info *pci)
 {
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	/* Unregister the instance kobject and allow its release
 	 * function release the main reference count and then
@@ -317,7 +317,7 @@ static struct edac_pci_dev_attribute *edac_pci_attr[] = {
  */
 static void edac_pci_release_main_kobj(struct kobject *kobj)
 {
-	debugf0("%s() here to module_put(THIS_MODULE)\n", __func__);
+	debugf0("here to module_put(THIS_MODULE)\n");
 
 	kfree(kobj);
 
@@ -345,7 +345,7 @@ static int edac_pci_main_kobj_setup(void)
 	int err;
 	struct bus_type *edac_subsys;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	/* check and count if we have already created the main kobject */
 	if (atomic_inc_return(&edac_pci_sysfs_refcount) != 1)
@@ -356,7 +356,7 @@ static int edac_pci_main_kobj_setup(void)
 	 */
 	edac_subsys = edac_get_sysfs_subsys();
 	if (edac_subsys == NULL) {
-		debugf1("%s() no edac_subsys\n", __func__);
+		debugf1("no edac_subsys\n");
 		err = -ENODEV;
 		goto decrement_count_fail;
 	}
@@ -366,7 +366,7 @@ static int edac_pci_main_kobj_setup(void)
 	 * level main kobj for EDAC PCI
 	 */
 	if (!try_module_get(THIS_MODULE)) {
-		debugf1("%s() try_module_get() failed\n", __func__);
+		debugf1("try_module_get() failed\n");
 		err = -ENODEV;
 		goto mod_get_fail;
 	}
@@ -421,15 +421,14 @@ decrement_count_fail:
  */
 static void edac_pci_main_kobj_teardown(void)
 {
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	/* Decrement the count and only if no more controller instances
 	 * are connected perform the unregisteration of the top level
 	 * main kobj
 	 */
 	if (atomic_dec_return(&edac_pci_sysfs_refcount) == 0) {
-		debugf0("%s() called kobject_put on main kobj\n",
-			__func__);
+		debugf0("called kobject_put on main kobj\n");
 		kobject_put(edac_pci_top_main_kobj);
 	}
 	edac_put_sysfs_subsys();
@@ -446,7 +445,7 @@ int edac_pci_create_sysfs(struct edac_pci_ctl_info *pci)
 	int err;
 	struct kobject *edac_kobj = &pci->kobj;
 
-	debugf0("%s() idx=%d\n", __func__, pci->pci_idx);
+	debugf0("idx=%d\n", pci->pci_idx);
 
 	/* create the top main EDAC PCI kobject, IF needed */
 	err = edac_pci_main_kobj_setup();
@@ -460,8 +459,8 @@ int edac_pci_create_sysfs(struct edac_pci_ctl_info *pci)
 
 	err = sysfs_create_link(edac_kobj, &pci->dev->kobj, EDAC_PCI_SYMLINK);
 	if (err) {
-		debugf0("%s() sysfs_create_link() returned err= %d\n",
-			__func__, err);
+		debugf0("sysfs_create_link() returned err= %d\n",
+			err);
 		goto symlink_fail;
 	}
 
@@ -484,7 +483,7 @@ unregister_cleanup:
  */
 void edac_pci_remove_sysfs(struct edac_pci_ctl_info *pci)
 {
-	debugf0("%s() index=%d\n", __func__, pci->pci_idx);
+	debugf0("index=%d\n", pci->pci_idx);
 
 	/* Remove the symlink */
 	sysfs_remove_link(&pci->kobj, EDAC_PCI_SYMLINK);
@@ -496,7 +495,7 @@ void edac_pci_remove_sysfs(struct edac_pci_ctl_info *pci)
 	 * if this 'pci' is the last instance.
 	 * If it is, the main kobject will be unregistered as a result
 	 */
-	debugf0("%s() calling edac_pci_main_kobj_teardown()\n", __func__);
+	debugf0("calling edac_pci_main_kobj_teardown()\n");
 	edac_pci_main_kobj_teardown();
 }
 
@@ -671,7 +670,7 @@ void edac_pci_do_parity_check(void)
 {
 	int before_count;
 
-	debugf3("%s()\n", __func__);
+	debugf3("\n");
 
 	/* if policy has PCI check off, leave now */
 	if (!check_pci_errors)
diff --git a/drivers/edac/i3000_edac.c b/drivers/edac/i3000_edac.c
index 812213d..67975ba 100644
--- a/drivers/edac/i3000_edac.c
+++ b/drivers/edac/i3000_edac.c
@@ -275,7 +275,7 @@ static void i3000_check(struct mem_ctl_info *mci)
 {
 	struct i3000_error_info info;
 
-	debugf1("MC%d: %s()\n", mci->mc_idx, __func__);
+	debugf1("MC%d\n", mci->mc_idx);
 	i3000_get_error_info(mci, &info);
 	i3000_process_error_info(mci, &info, 1);
 }
@@ -322,7 +322,7 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 	unsigned long mchbar;
 	void __iomem *window;
 
-	debugf0("MC: %s()\n", __func__);
+	debugf0("MC:\n");
 
 	pci_read_config_dword(pdev, I3000_MCHBAR, (u32 *) & mchbar);
 	mchbar &= I3000_MCHBAR_MASK;
@@ -366,7 +366,7 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 	if (!mci)
 		return -ENOMEM;
 
-	debugf3("MC: %s(): init mci\n", __func__);
+	debugf3("MC: init mci\n");
 
 	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR2;
@@ -399,8 +399,8 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 		cumul_size = value << (I3000_DRB_SHIFT - PAGE_SHIFT);
 		if (interleaved)
 			cumul_size <<= 1;
-		debugf3("MC: %s(): (%d) cumul_size 0x%x\n",
-			__func__, i, cumul_size);
+		debugf3("MC: (%d) cumul_size 0x%x\n",
+			i, cumul_size);
 		if (cumul_size == last_cumul_size)
 			continue;
 
@@ -429,7 +429,7 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 
 	rc = -ENODEV;
 	if (edac_mc_add_mc(mci)) {
-		debugf3("MC: %s(): failed edac_mc_add_mc()\n", __func__);
+		debugf3("MC: failed edac_mc_add_mc()\n");
 		goto fail;
 	}
 
@@ -445,7 +445,7 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 	}
 
 	/* get this far and it's successful */
-	debugf3("MC: %s(): success\n", __func__);
+	debugf3("MC: success\n");
 	return 0;
 
 fail:
@@ -461,7 +461,7 @@ static int __devinit i3000_init_one(struct pci_dev *pdev,
 {
 	int rc;
 
-	debugf0("MC: %s()\n", __func__);
+	debugf0("MC:\n");
 
 	if (pci_enable_device(pdev) < 0)
 		return -EIO;
@@ -477,7 +477,7 @@ static void __devexit i3000_remove_one(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	if (i3000_pci)
 		edac_pci_release_generic_ctl(i3000_pci);
@@ -511,7 +511,7 @@ static int __init i3000_init(void)
 {
 	int pci_rc;
 
-	debugf3("MC: %s()\n", __func__);
+	debugf3("MC:\n");
 
        /* Ensure that the OPSTATE is set correctly for POLL or NMI */
        opstate_init();
@@ -552,7 +552,7 @@ fail0:
 
 static void __exit i3000_exit(void)
 {
-	debugf3("MC: %s()\n", __func__);
+	debugf3("MC:\n");
 
 	pci_unregister_driver(&i3000_driver);
 	if (!i3000_registered) {
diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index c5f0fb3..9698ca3 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -245,7 +245,7 @@ static void i3200_check(struct mem_ctl_info *mci)
 {
 	struct i3200_error_info info;
 
-	debugf1("MC%d: %s()\n", mci->mc_idx, __func__);
+	debugf1("MC%d\n", mci->mc_idx);
 	i3200_get_and_clear_error_info(mci, &info);
 	i3200_process_error_info(mci, &info);
 }
@@ -332,7 +332,7 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 	void __iomem *window;
 	struct i3200_priv *priv;
 
-	debugf0("MC: %s()\n", __func__);
+	debugf0("MC:\n");
 
 	window = i3200_map_mchbar(pdev);
 	if (!window)
@@ -352,7 +352,7 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 	if (!mci)
 		return -ENOMEM;
 
-	debugf3("MC: %s(): init mci\n", __func__);
+	debugf3("MC: init mci\n");
 
 	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR2;
@@ -403,12 +403,12 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 
 	rc = -ENODEV;
 	if (edac_mc_add_mc(mci)) {
-		debugf3("MC: %s(): failed edac_mc_add_mc()\n", __func__);
+		debugf3("MC: failed edac_mc_add_mc()\n");
 		goto fail;
 	}
 
 	/* get this far and it's successful */
-	debugf3("MC: %s(): success\n", __func__);
+	debugf3("MC: success\n");
 	return 0;
 
 fail:
@@ -424,7 +424,7 @@ static int __devinit i3200_init_one(struct pci_dev *pdev,
 {
 	int rc;
 
-	debugf0("MC: %s()\n", __func__);
+	debugf0("MC:\n");
 
 	if (pci_enable_device(pdev) < 0)
 		return -EIO;
@@ -441,7 +441,7 @@ static void __devexit i3200_remove_one(struct pci_dev *pdev)
 	struct mem_ctl_info *mci;
 	struct i3200_priv *priv;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	mci = edac_mc_del_mc(&pdev->dev);
 	if (!mci)
@@ -475,7 +475,7 @@ static int __init i3200_init(void)
 {
 	int pci_rc;
 
-	debugf3("MC: %s()\n", __func__);
+	debugf3("MC:\n");
 
 	/* Ensure that the OPSTATE is set correctly for POLL or NMI */
 	opstate_init();
@@ -516,7 +516,7 @@ fail0:
 
 static void __exit i3200_exit(void)
 {
-	debugf3("MC: %s()\n", __func__);
+	debugf3("MC:\n");
 
 	pci_unregister_driver(&i3200_driver);
 	if (!i3200_registered) {
diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index a7da4c7..4a5ca52 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -779,7 +779,7 @@ static void i5000_clear_error(struct mem_ctl_info *mci)
 static void i5000_check_error(struct mem_ctl_info *mci)
 {
 	struct i5000_error_info info;
-	debugf4("MC%d: %s: %s()\n", mci->mc_idx, __FILE__, __func__);
+	debugf4("MC%d\n", mci->mc_idx);
 	i5000_get_error_info(mci, &info);
 	i5000_process_error_info(mci, &info, 1);
 }
@@ -1363,9 +1363,8 @@ static int i5000_probe1(struct pci_dev *pdev, int dev_idx)
 	int num_channels;
 	int num_dimms_per_channel;
 
-	debugf0("MC: %s: %s(), pdev bus %u dev=0x%x fn=0x%x\n",
-		__FILE__, __func__,
-		pdev->bus->number,
+	debugf0("MC: %s(), pdev bus %u dev=0x%x fn=0x%x\n",
+		__FILE__, pdev->bus->number,
 		PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
 
 	/* We only are looking for func 0 of the set */
@@ -1388,8 +1387,8 @@ static int i5000_probe1(struct pci_dev *pdev, int dev_idx)
 	i5000_get_dimm_and_channel_counts(pdev, &num_dimms_per_channel,
 					&num_channels);
 
-	debugf0("MC: %s(): Number of Branches=2 Channels= %d  DIMMS= %d\n",
-		__func__, num_channels, num_dimms_per_channel);
+	debugf0("MC: Number of Branches=2 Channels= %d  DIMMS= %d\n",
+		num_channels, num_dimms_per_channel);
 
 	/* allocate a new MC control structure */
 
@@ -1406,7 +1405,7 @@ static int i5000_probe1(struct pci_dev *pdev, int dev_idx)
 	if (mci == NULL)
 		return -ENOMEM;
 
-	debugf0("MC: %s: %s(): mci = %p\n", __FILE__, __func__, mci);
+	debugf0("MC: %s(): mci = %p\n", __FILE__, mci);
 
 	mci->pdev = &pdev->dev;	/* record ptr  to the generic device */
 
@@ -1449,8 +1448,8 @@ static int i5000_probe1(struct pci_dev *pdev, int dev_idx)
 
 	/* add this new MC control structure to EDAC's list of MCs */
 	if (edac_mc_add_mc(mci)) {
-		debugf0("MC: %s: %s(): failed edac_mc_add_mc()\n",
-			__FILE__, __func__);
+		debugf0("MC: %s(): failed edac_mc_add_mc()\n",
+			__FILE__);
 		/* FIXME: perhaps some code should go here that disables error
 		 * reporting if we just enabled it
 		 */
@@ -1494,7 +1493,7 @@ static int __devinit i5000_init_one(struct pci_dev *pdev,
 {
 	int rc;
 
-	debugf0("MC: %s: %s()\n", __FILE__, __func__);
+	debugf0("MC: %s()\n", __FILE__);
 
 	/* wake up device */
 	rc = pci_enable_device(pdev);
@@ -1513,7 +1512,7 @@ static void __devexit i5000_remove_one(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 
-	debugf0("%s: %s()\n", __FILE__, __func__);
+	debugf0("%s()\n", __FILE__);
 
 	if (i5000_pci)
 		edac_pci_release_generic_ctl(i5000_pci);
@@ -1559,7 +1558,7 @@ static int __init i5000_init(void)
 {
 	int pci_rc;
 
-	debugf2("MC: %s: %s()\n", __FILE__, __func__);
+	debugf2("MC: %s()\n", __FILE__);
 
        /* Ensure that the OPSTATE is set correctly for POLL or NMI */
        opstate_init();
@@ -1575,7 +1574,7 @@ static int __init i5000_init(void)
  */
 static void __exit i5000_exit(void)
 {
-	debugf2("MC: %s: %s()\n", __FILE__, __func__);
+	debugf2("MC: %s()\n", __FILE__);
 	pci_unregister_driver(&i5000_driver);
 }
 
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 0570cf3..be1880d 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -700,7 +700,7 @@ static void i5400_clear_error(struct mem_ctl_info *mci)
 static void i5400_check_error(struct mem_ctl_info *mci)
 {
 	struct i5400_error_info info;
-	debugf4("MC%d: %s: %s()\n", mci->mc_idx, __FILE__, __func__);
+	debugf4("MC%d\n", mci->mc_idx);
 	i5400_get_error_info(mci, &info);
 	i5400_process_error_info(mci, &info);
 }
@@ -1203,8 +1203,7 @@ static int i5400_init_dimms(struct mem_ctl_info *mci)
 
 			size_mb =  pvt->dimm_info[slot][channel].megabytes;
 
-			debugf2("%s: dimm (branch %d channel %d slot %d): %d.%03d GB\n",
-				__func__,
+			debugf2("dimm (branch %d channel %d slot %d): %d.%03d GB\n",
 				channel / 2, channel % 2, slot,
 				size_mb / 1000, size_mb % 1000);
 
@@ -1270,9 +1269,8 @@ static int i5400_probe1(struct pci_dev *pdev, int dev_idx)
 	if (dev_idx >= ARRAY_SIZE(i5400_devs))
 		return -EINVAL;
 
-	debugf0("MC: %s: %s(), pdev bus %u dev=0x%x fn=0x%x\n",
-		__FILE__, __func__,
-		pdev->bus->number,
+	debugf0("MC: %s(), pdev bus %u dev=0x%x fn=0x%x\n",
+		__FILE__, pdev->bus->number,
 		PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
 
 	/* We only are looking for func 0 of the set */
@@ -1297,7 +1295,7 @@ static int i5400_probe1(struct pci_dev *pdev, int dev_idx)
 	if (mci == NULL)
 		return -ENOMEM;
 
-	debugf0("MC: %s: %s(): mci = %p\n", __FILE__, __func__, mci);
+	debugf0("MC: %s(): mci = %p\n", __FILE__, mci);
 
 	mci->pdev = &pdev->dev;	/* record ptr  to the generic device */
 
@@ -1340,8 +1338,8 @@ static int i5400_probe1(struct pci_dev *pdev, int dev_idx)
 
 	/* add this new MC control structure to EDAC's list of MCs */
 	if (edac_mc_add_mc(mci)) {
-		debugf0("MC: %s: %s(): failed edac_mc_add_mc()\n",
-			__FILE__, __func__);
+		debugf0("MC: %s(): failed edac_mc_add_mc()\n",
+			__FILE__);
 		/* FIXME: perhaps some code should go here that disables error
 		 * reporting if we just enabled it
 		 */
@@ -1385,7 +1383,7 @@ static int __devinit i5400_init_one(struct pci_dev *pdev,
 {
 	int rc;
 
-	debugf0("MC: %s: %s()\n", __FILE__, __func__);
+	debugf0("MC: %s()\n", __FILE__);
 
 	/* wake up device */
 	rc = pci_enable_device(pdev);
@@ -1404,7 +1402,7 @@ static void __devexit i5400_remove_one(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 
-	debugf0("%s: %s()\n", __FILE__, __func__);
+	debugf0("%s()\n", __FILE__);
 
 	if (i5400_pci)
 		edac_pci_release_generic_ctl(i5400_pci);
@@ -1450,7 +1448,7 @@ static int __init i5400_init(void)
 {
 	int pci_rc;
 
-	debugf2("MC: %s: %s()\n", __FILE__, __func__);
+	debugf2("MC: %s()\n", __FILE__);
 
 	/* Ensure that the OPSTATE is set correctly for POLL or NMI */
 	opstate_init();
@@ -1466,7 +1464,7 @@ static int __init i5400_init(void)
  */
 static void __exit i5400_exit(void)
 {
-	debugf2("MC: %s: %s()\n", __FILE__, __func__);
+	debugf2("MC: %s()\n", __FILE__);
 	pci_unregister_driver(&i5400_driver);
 }
 
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index db84456..20435ee 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -1032,8 +1032,7 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
 	if (rc == -EIO)
 		return rc;
 
-	debugf0("MC: " __FILE__ ": %s(), pdev bus %u dev=0x%x fn=0x%x\n",
-		__func__,
+	debugf0("MC: pdev bus %u dev=0x%x fn=0x%x\n",
 		pdev->bus->number,
 		PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
 
@@ -1055,7 +1054,7 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
 	if (mci == NULL)
 		return -ENOMEM;
 
-	debugf0("MC: " __FILE__ ": %s(): mci = %p\n", __func__, mci);
+	debugf0("MC: mci = %p\n", mci);
 
 	mci->pdev = &pdev->dev;	/* record ptr  to the generic device */
 
@@ -1099,8 +1098,7 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
 
 	/* add this new MC control structure to EDAC's list of MCs */
 	if (edac_mc_add_mc(mci)) {
-		debugf0("MC: " __FILE__
-			": %s(): failed edac_mc_add_mc()\n", __func__);
+		debugf0("MC: failed edac_mc_add_mc()\n");
 		/* FIXME: perhaps some code should go here that disables error
 		 * reporting if we just enabled it
 		 */
@@ -1142,7 +1140,7 @@ static void __devexit i7300_remove_one(struct pci_dev *pdev)
 	struct mem_ctl_info *mci;
 	char *tmp;
 
-	debugf0(__FILE__ ": %s()\n", __func__);
+	debugf0("\n");
 
 	if (i7300_pci)
 		edac_pci_release_generic_ctl(i7300_pci);
@@ -1189,7 +1187,7 @@ static int __init i7300_init(void)
 {
 	int pci_rc;
 
-	debugf2("MC: " __FILE__ ": %s()\n", __func__);
+	debugf2("\n");
 
 	/* Ensure that the OPSTATE is set correctly for POLL or NMI */
 	opstate_init();
@@ -1204,7 +1202,7 @@ static int __init i7300_init(void)
  */
 static void __exit i7300_exit(void)
 {
-	debugf2("MC: " __FILE__ ": %s()\n", __func__);
+	debugf2("\n");
 	pci_unregister_driver(&i7300_driver);
 }
 
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index c29944f..f851a43 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -824,7 +824,7 @@ static ssize_t i7core_inject_store_##param(			\
 	long value;						\
 	int rc;							\
 								\
-	debugf1("%s()\n", __func__);				\
+	debugf1("\n");				\
 	pvt = mci->pvt_info;					\
 								\
 	if (pvt->inject.enable)					\
@@ -852,7 +852,7 @@ static ssize_t i7core_inject_show_##param(			\
 	struct i7core_pvt *pvt;					\
 								\
 	pvt = mci->pvt_info;					\
-	debugf1("%s() pvt=%p\n", __func__, pvt);		\
+	debugf1("pvt=%p\n", pvt);		\
 	if (pvt->inject.param < 0)				\
 		return sprintf(data, "any\n");			\
 	else							\
@@ -1059,7 +1059,7 @@ static ssize_t i7core_show_counter_##param(			\
 	struct mem_ctl_info *mci = to_mci(dev);			\
 	struct i7core_pvt *pvt = mci->pvt_info;			\
 								\
-	debugf1("%s()\n", __func__);				\
+	debugf1("\n");				\
 	if (!pvt->ce_count_available || (pvt->is_registered))	\
 		return sprintf(data, "data unavailable\n");	\
 	return sprintf(data, "%lu\n",				\
@@ -1190,8 +1190,7 @@ static int i7core_create_sysfs_devices(struct mem_ctl_info *mci)
 	dev_set_name(pvt->addrmatch_dev, "inject_addrmatch");
 	dev_set_drvdata(pvt->addrmatch_dev, mci);
 
-	debugf1("%s(): creating %s\n", __func__,
-		dev_name(pvt->addrmatch_dev));
+	debugf1("creating %s\n", dev_name(pvt->addrmatch_dev));
 
 	rc = device_add(pvt->addrmatch_dev);
 	if (rc < 0)
@@ -1213,8 +1212,7 @@ static int i7core_create_sysfs_devices(struct mem_ctl_info *mci)
 		dev_set_name(pvt->chancounts_dev, "all_channel_counts");
 		dev_set_drvdata(pvt->chancounts_dev, mci);
 
-		debugf1("%s(): creating %s\n", __func__,
-			dev_name(pvt->chancounts_dev));
+		debugf1("creating %s\n", dev_name(pvt->chancounts_dev));
 
 		rc = device_add(pvt->chancounts_dev);
 		if (rc < 0)
@@ -1254,7 +1252,7 @@ static void i7core_put_devices(struct i7core_dev *i7core_dev)
 {
 	int i;
 
-	debugf0(__FILE__ ": %s()\n", __func__);
+	debugf0("\n");
 	for (i = 0; i < i7core_dev->n_devs; i++) {
 		struct pci_dev *pdev = i7core_dev->pdev[i];
 		if (!pdev)
@@ -1652,7 +1650,7 @@ static void i7core_udimm_check_mc_ecc_err(struct mem_ctl_info *mci)
 	int new0, new1, new2;
 
 	if (!pvt->pci_mcr[4]) {
-		debugf0("%s MCR registers not found\n", __func__);
+		debugf0("MCR registers not found\n");
 		return;
 	}
 
@@ -2190,8 +2188,7 @@ static void i7core_unregister_mci(struct i7core_dev *i7core_dev)
 	struct i7core_pvt *pvt;
 
 	if (unlikely(!mci || !mci->pvt_info)) {
-		debugf0("MC: " __FILE__ ": %s(): dev = %p\n",
-			__func__, &i7core_dev->pdev[0]->dev);
+		debugf0("MC: dev = %p\n", &i7core_dev->pdev[0]->dev);
 
 		i7core_printk(KERN_ERR, "Couldn't find mci handler\n");
 		return;
@@ -2199,8 +2196,7 @@ static void i7core_unregister_mci(struct i7core_dev *i7core_dev)
 
 	pvt = mci->pvt_info;
 
-	debugf0("MC: " __FILE__ ": %s(): mci = %p, dev = %p\n",
-		__func__, mci, &i7core_dev->pdev[0]->dev);
+	debugf0("MC: mci = %p, dev = %p\n", mci, &i7core_dev->pdev[0]->dev);
 
 	/* Disable scrubrate setting */
 	if (pvt->enable_scrub)
@@ -2241,8 +2237,7 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 	if (unlikely(!mci))
 		return -ENOMEM;
 
-	debugf0("MC: " __FILE__ ": %s(): mci = %p, dev = %p\n",
-		__func__, mci, &i7core_dev->pdev[0]->dev);
+	debugf0("MC: mci = %p, dev = %p\n", mci, &i7core_dev->pdev[0]->dev);
 
 	pvt = mci->pvt_info;
 	memset(pvt, 0, sizeof(*pvt));
@@ -2285,8 +2280,7 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 
 	/* add this new MC control structure to EDAC's list of MCs */
 	if (unlikely(edac_mc_add_mc(mci))) {
-		debugf0("MC: " __FILE__
-			": %s(): failed edac_mc_add_mc()\n", __func__);
+		debugf0("MC: failed edac_mc_add_mc()\n");
 		/* FIXME: perhaps some code should go here that disables error
 		 * reporting if we just enabled it
 		 */
@@ -2295,8 +2289,7 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 		goto fail0;
 	}
 	if (i7core_create_sysfs_devices(mci)) {
-		debugf0("MC: " __FILE__
-			": %s(): failed to create sysfs nodes\n", __func__);
+		debugf0("MC: failed to create sysfs nodes\n");
 		edac_mc_del_mc(mci->pdev);
 		rc = -EINVAL;
 		goto fail0;
@@ -2402,7 +2395,7 @@ static void __devexit i7core_remove(struct pci_dev *pdev)
 {
 	struct i7core_dev *i7core_dev;
 
-	debugf0(__FILE__ ": %s()\n", __func__);
+	debugf0("\n");
 
 	/*
 	 * we have a trouble here: pdev value for removal will be wrong, since
@@ -2451,7 +2444,7 @@ static int __init i7core_init(void)
 {
 	int pci_rc;
 
-	debugf2("MC: " __FILE__ ": %s()\n", __func__);
+	debugf2("\n");
 
 	/* Ensure that the OPSTATE is set correctly for POLL or NMI */
 	opstate_init();
@@ -2476,7 +2469,7 @@ static int __init i7core_init(void)
  */
 static void __exit i7core_exit(void)
 {
-	debugf2("MC: " __FILE__ ": %s()\n", __func__);
+	debugf2("\n");
 	pci_unregister_driver(&i7core_driver);
 }
 
diff --git a/drivers/edac/i82443bxgx_edac.c b/drivers/edac/i82443bxgx_edac.c
index 0f2751b..c43214f 100644
--- a/drivers/edac/i82443bxgx_edac.c
+++ b/drivers/edac/i82443bxgx_edac.c
@@ -178,7 +178,7 @@ static void i82443bxgx_edacmc_check(struct mem_ctl_info *mci)
 {
 	struct i82443bxgx_edacmc_error_info info;
 
-	debugf1("MC%d: %s: %s()\n", mci->mc_idx, __FILE__, __func__);
+	debugf1("MC%d\n", mci->mc_idx);
 	i82443bxgx_edacmc_get_error_info(mci, &info);
 	i82443bxgx_edacmc_process_error_info(mci, &info, 1);
 }
@@ -201,13 +201,13 @@ static void i82443bxgx_init_csrows(struct mem_ctl_info *mci,
 		dimm = csrow->channels[0]->dimm;
 
 		pci_read_config_byte(pdev, I82443BXGX_DRB + index, &drbar);
-		debugf1("MC%d: %s: %s() Row=%d DRB = %#0x\n",
-			mci->mc_idx, __FILE__, __func__, index, drbar);
+		debugf1("MC%d: Row=%d DRB = %#0x\n",
+			mci->mc_idx,index, drbar);
 		row_high_limit = ((u32) drbar << 23);
 		/* find the DRAM Chip Select Base address and mask */
-		debugf1("MC%d: %s: %s() Row=%d, "
+		debugf1("MC%d: Row=%d, "
 			"Boundary Address=%#0x, Last = %#0x\n",
-			mci->mc_idx, __FILE__, __func__, index, row_high_limit,
+			mci->mc_idx, index, row_high_limit,
 			row_high_limit_last);
 
 		/* 440GX goes to 2GB, represented with a DRB of 0. */
@@ -241,7 +241,7 @@ static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 	enum mem_type mtype;
 	enum edac_type edac_mode;
 
-	debugf0("MC: %s: %s()\n", __FILE__, __func__);
+	debugf0("MC: %s()\n", __FILE__);
 
 	/* Something is really hosed if PCI config space reads from
 	 * the MC aren't working.
@@ -259,7 +259,7 @@ static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 	if (mci == NULL)
 		return -ENOMEM;
 
-	debugf0("MC: %s: %s(): mci = %p\n", __FILE__, __func__, mci);
+	debugf0("MC: %s(): mci = %p\n", __FILE__, mci);
 	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_EDO | MEM_FLAG_SDR | MEM_FLAG_RDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_EC | EDAC_FLAG_SECDED;
@@ -305,8 +305,8 @@ static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 		edac_mode = EDAC_SECDED;
 		break;
 	default:
-		debugf0("%s(): Unknown/reserved ECC state "
-			"in NBXCFG register!\n", __func__);
+		debugf0("Unknown/reserved ECC state "
+			"in NBXCFG register!\n");
 		edac_mode = EDAC_UNKNOWN;
 		break;
 	}
@@ -330,7 +330,7 @@ static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 	mci->ctl_page_to_phys = NULL;
 
 	if (edac_mc_add_mc(mci)) {
-		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
+		debugf3("failed edac_mc_add_mc()\n");
 		goto fail;
 	}
 
@@ -345,7 +345,7 @@ static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 			__func__);
 	}
 
-	debugf3("MC: %s: %s(): success\n", __FILE__, __func__);
+	debugf3("MC: %s(): success\n", __FILE__);
 	return 0;
 
 fail:
@@ -361,7 +361,7 @@ static int __devinit i82443bxgx_edacmc_init_one(struct pci_dev *pdev,
 {
 	int rc;
 
-	debugf0("MC: %s: %s()\n", __FILE__, __func__);
+	debugf0("MC: %s()\n", __FILE__);
 
 	/* don't need to call pci_enable_device() */
 	rc = i82443bxgx_edacmc_probe1(pdev, ent->driver_data);
@@ -376,7 +376,7 @@ static void __devexit i82443bxgx_edacmc_remove_one(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 
-	debugf0("%s: %s()\n", __FILE__, __func__);
+	debugf0("%s()\n", __FILE__);
 
 	if (i82443bxgx_pci)
 		edac_pci_release_generic_ctl(i82443bxgx_pci);
diff --git a/drivers/edac/i82860_edac.c b/drivers/edac/i82860_edac.c
index 06a3c8d..d4ec21d 100644
--- a/drivers/edac/i82860_edac.c
+++ b/drivers/edac/i82860_edac.c
@@ -136,7 +136,7 @@ static void i82860_check(struct mem_ctl_info *mci)
 {
 	struct i82860_error_info info;
 
-	debugf1("MC%d: %s()\n", mci->mc_idx, __func__);
+	debugf1("MC%d\n", mci->mc_idx);
 	i82860_get_error_info(mci, &info);
 	i82860_process_error_info(mci, &info, 1);
 }
@@ -167,7 +167,7 @@ static void i82860_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev)
 		pci_read_config_word(pdev, I82860_GBA + index * 2, &value);
 		cumul_size = (value & I82860_GBA_MASK) <<
 			(I82860_GBA_SHIFT - PAGE_SHIFT);
-		debugf3("%s(): (%d) cumul_size 0x%x\n", __func__, index,
+		debugf3("(%d) cumul_size 0x%x\n", index,
 			cumul_size);
 
 		if (cumul_size == last_cumul_size)
@@ -210,7 +210,7 @@ static int i82860_probe1(struct pci_dev *pdev, int dev_idx)
 	if (!mci)
 		return -ENOMEM;
 
-	debugf3("%s(): init mci\n", __func__);
+	debugf3("init mci\n");
 	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
@@ -229,7 +229,7 @@ static int i82860_probe1(struct pci_dev *pdev, int dev_idx)
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
 	if (edac_mc_add_mc(mci)) {
-		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
+		debugf3("failed edac_mc_add_mc()\n");
 		goto fail;
 	}
 
@@ -245,7 +245,7 @@ static int i82860_probe1(struct pci_dev *pdev, int dev_idx)
 	}
 
 	/* get this far and it's successful */
-	debugf3("%s(): success\n", __func__);
+	debugf3("success\n");
 
 	return 0;
 
@@ -260,7 +260,7 @@ static int __devinit i82860_init_one(struct pci_dev *pdev,
 {
 	int rc;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 	i82860_printk(KERN_INFO, "i82860 init one\n");
 
 	if (pci_enable_device(pdev) < 0)
@@ -278,7 +278,7 @@ static void __devexit i82860_remove_one(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	if (i82860_pci)
 		edac_pci_release_generic_ctl(i82860_pci);
@@ -311,7 +311,7 @@ static int __init i82860_init(void)
 {
 	int pci_rc;
 
-	debugf3("%s()\n", __func__);
+	debugf3("\n");
 
        /* Ensure that the OPSTATE is set correctly for POLL or NMI */
        opstate_init();
@@ -352,7 +352,7 @@ fail0:
 
 static void __exit i82860_exit(void)
 {
-	debugf3("%s()\n", __func__);
+	debugf3("\n");
 
 	pci_unregister_driver(&i82860_driver);
 
diff --git a/drivers/edac/i82875p_edac.c b/drivers/edac/i82875p_edac.c
index fd77ecb..20b40a76 100644
--- a/drivers/edac/i82875p_edac.c
+++ b/drivers/edac/i82875p_edac.c
@@ -263,7 +263,7 @@ static void i82875p_check(struct mem_ctl_info *mci)
 {
 	struct i82875p_error_info info;
 
-	debugf1("MC%d: %s()\n", mci->mc_idx, __func__);
+	debugf1("MC%d\n", mci->mc_idx);
 	i82875p_get_error_info(mci, &info);
 	i82875p_process_error_info(mci, &info, 1);
 }
@@ -371,7 +371,7 @@ static void i82875p_init_csrows(struct mem_ctl_info *mci,
 
 		value = readb(ovrfl_window + I82875P_DRB + index);
 		cumul_size = value << (I82875P_DRB_SHIFT - PAGE_SHIFT);
-		debugf3("%s(): (%d) cumul_size 0x%x\n", __func__, index,
+		debugf3("(%d) cumul_size 0x%x\n", index,
 			cumul_size);
 		if (cumul_size == last_cumul_size)
 			continue;	/* not populated */
@@ -405,7 +405,7 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 	u32 nr_chans;
 	struct i82875p_error_info discard;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	ovrfl_pdev = pci_get_device(PCI_VEND_DEV(INTEL, 82875_6), NULL);
 
@@ -425,7 +425,7 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 		goto fail0;
 	}
 
-	debugf3("%s(): init mci\n", __func__);
+	debugf3("init mci\n");
 	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
@@ -436,7 +436,7 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 	mci->dev_name = pci_name(pdev);
 	mci->edac_check = i82875p_check;
 	mci->ctl_page_to_phys = NULL;
-	debugf3("%s(): init pvt\n", __func__);
+	debugf3("init pvt\n");
 	pvt = (struct i82875p_pvt *)mci->pvt_info;
 	pvt->ovrfl_pdev = ovrfl_pdev;
 	pvt->ovrfl_window = ovrfl_window;
@@ -447,7 +447,7 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
 	if (edac_mc_add_mc(mci)) {
-		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
+		debugf3("failed edac_mc_add_mc()\n");
 		goto fail1;
 	}
 
@@ -463,7 +463,7 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 	}
 
 	/* get this far and it's successful */
-	debugf3("%s(): success\n", __func__);
+	debugf3("success\n");
 	return 0;
 
 fail1:
@@ -484,7 +484,7 @@ static int __devinit i82875p_init_one(struct pci_dev *pdev,
 {
 	int rc;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 	i82875p_printk(KERN_INFO, "i82875p init one\n");
 
 	if (pci_enable_device(pdev) < 0)
@@ -503,7 +503,7 @@ static void __devexit i82875p_remove_one(struct pci_dev *pdev)
 	struct mem_ctl_info *mci;
 	struct i82875p_pvt *pvt = NULL;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	if (i82875p_pci)
 		edac_pci_release_generic_ctl(i82875p_pci);
@@ -549,7 +549,7 @@ static int __init i82875p_init(void)
 {
 	int pci_rc;
 
-	debugf3("%s()\n", __func__);
+	debugf3("\n");
 
        /* Ensure that the OPSTATE is set correctly for POLL or NMI */
        opstate_init();
@@ -592,7 +592,7 @@ fail0:
 
 static void __exit i82875p_exit(void)
 {
-	debugf3("%s()\n", __func__);
+	debugf3("\n");
 
 	i82875p_remove_one(mci_pdev);
 	pci_dev_put(mci_pdev);
diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index 4d239ab..91b9e33 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -331,7 +331,7 @@ static void i82975x_check(struct mem_ctl_info *mci)
 {
 	struct i82975x_error_info info;
 
-	debugf1("MC%d: %s()\n", mci->mc_idx, __func__);
+	debugf1("MC%d\n", mci->mc_idx);
 	i82975x_get_error_info(mci, &info);
 	i82975x_process_error_info(mci, &info, 1);
 }
@@ -406,7 +406,7 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 		 */
 		if (csrow->nr_channels > 1)
 			cumul_size <<= 1;
-		debugf3("%s(): (%d) cumul_size 0x%x\n", __func__, index,
+		debugf3("(%d) cumul_size 0x%x\n", index,
 			cumul_size);
 
 		nr_pages = cumul_size - last_cumul_size;
@@ -489,11 +489,11 @@ static int i82975x_probe1(struct pci_dev *pdev, int dev_idx)
 	u8 c1drb[4];
 #endif
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	pci_read_config_dword(pdev, I82975X_MCHBAR, &mchbar);
 	if (!(mchbar & 1)) {
-		debugf3("%s(): failed, MCHBAR disabled!\n", __func__);
+		debugf3("failed, MCHBAR disabled!\n");
 		goto fail0;
 	}
 	mchbar &= 0xffffc000;	/* bits 31:14 used for 16K window */
@@ -558,7 +558,7 @@ static int i82975x_probe1(struct pci_dev *pdev, int dev_idx)
 		goto fail1;
 	}
 
-	debugf3("%s(): init mci\n", __func__);
+	debugf3("init mci\n");
 	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR2;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
@@ -569,7 +569,7 @@ static int i82975x_probe1(struct pci_dev *pdev, int dev_idx)
 	mci->dev_name = pci_name(pdev);
 	mci->edac_check = i82975x_check;
 	mci->ctl_page_to_phys = NULL;
-	debugf3("%s(): init pvt\n", __func__);
+	debugf3("init pvt\n");
 	pvt = (struct i82975x_pvt *) mci->pvt_info;
 	pvt->mch_window = mch_window;
 	i82975x_init_csrows(mci, pdev, mch_window);
@@ -578,12 +578,12 @@ static int i82975x_probe1(struct pci_dev *pdev, int dev_idx)
 
 	/* finalize this instance of memory controller with edac core */
 	if (edac_mc_add_mc(mci)) {
-		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
+		debugf3("failed edac_mc_add_mc()\n");
 		goto fail2;
 	}
 
 	/* get this far and it's successful */
-	debugf3("%s(): success\n", __func__);
+	debugf3("success\n");
 	return 0;
 
 fail2:
@@ -601,7 +601,7 @@ static int __devinit i82975x_init_one(struct pci_dev *pdev,
 {
 	int rc;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	if (pci_enable_device(pdev) < 0)
 		return -EIO;
@@ -619,7 +619,7 @@ static void __devexit i82975x_remove_one(struct pci_dev *pdev)
 	struct mem_ctl_info *mci;
 	struct i82975x_pvt *pvt;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	mci = edac_mc_del_mc(&pdev->dev);
 	if (mci  == NULL)
@@ -655,7 +655,7 @@ static int __init i82975x_init(void)
 {
 	int pci_rc;
 
-	debugf3("%s()\n", __func__);
+	debugf3("\n");
 
        /* Ensure that the OPSTATE is set correctly for POLL or NMI */
        opstate_init();
@@ -697,7 +697,7 @@ fail0:
 
 static void __exit i82975x_exit(void)
 {
-	debugf3("%s()\n", __func__);
+	debugf3("\n");
 
 	pci_unregister_driver(&i82975x_driver);
 
diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 0db6f1e..e01c678 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -280,7 +280,7 @@ static int __devinit mpc85xx_pci_err_probe(struct platform_device *op)
 	out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_DR, ~0);
 
 	if (edac_pci_add_device(pci, pdata->edac_idx) > 0) {
-		debugf3("%s(): failed edac_pci_add_device()\n", __func__);
+		debugf3("failed edac_pci_add_device()\n");
 		goto err;
 	}
 
@@ -303,7 +303,7 @@ static int __devinit mpc85xx_pci_err_probe(struct platform_device *op)
 	}
 
 	devres_remove_group(&op->dev, mpc85xx_pci_err_probe);
-	debugf3("%s(): success\n", __func__);
+	debugf3("success\n");
 	printk(KERN_INFO EDAC_MOD_STR " PCI err registered\n");
 
 	return 0;
@@ -321,7 +321,7 @@ static int mpc85xx_pci_err_remove(struct platform_device *op)
 	struct edac_pci_ctl_info *pci = dev_get_drvdata(&op->dev);
 	struct mpc85xx_pci_pdata *pdata = pci->pvt_info;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_CAP_DR,
 		 orig_pci_err_cap_dr);
@@ -582,7 +582,7 @@ static int __devinit mpc85xx_l2_err_probe(struct platform_device *op)
 	pdata->edac_idx = edac_dev_idx++;
 
 	if (edac_device_add_device(edac_dev) > 0) {
-		debugf3("%s(): failed edac_device_add_device()\n", __func__);
+		debugf3("failed edac_device_add_device()\n");
 		goto err;
 	}
 
@@ -610,7 +610,7 @@ static int __devinit mpc85xx_l2_err_probe(struct platform_device *op)
 
 	devres_remove_group(&op->dev, mpc85xx_l2_err_probe);
 
-	debugf3("%s(): success\n", __func__);
+	debugf3("success\n");
 	printk(KERN_INFO EDAC_MOD_STR " L2 err registered\n");
 
 	return 0;
@@ -628,7 +628,7 @@ static int mpc85xx_l2_err_remove(struct platform_device *op)
 	struct edac_device_ctl_info *edac_dev = dev_get_drvdata(&op->dev);
 	struct mpc85xx_l2_pdata *pdata = edac_dev->pvt_info;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	if (edac_op_state == EDAC_OPSTATE_INT) {
 		out_be32(pdata->l2_vbase + MPC85XX_L2_ERRINTEN, 0);
@@ -1037,7 +1037,7 @@ static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 		goto err;
 	}
 
-	debugf3("%s(): init mci\n", __func__);
+	debugf3("init mci\n");
 	mci->mtype_cap = MEM_FLAG_RDDR | MEM_FLAG_RDDR2 |
 	    MEM_FLAG_DDR | MEM_FLAG_DDR2;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
@@ -1063,13 +1063,13 @@ static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 	out_be32(pdata->mc_vbase + MPC85XX_MC_ERR_DETECT, ~0);
 
 	if (edac_mc_add_mc(mci)) {
-		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
+		debugf3("failed edac_mc_add_mc()\n");
 		goto err;
 	}
 
 	if (mpc85xx_create_sysfs_attributes(mci)) {
 		edac_mc_del_mc(mci->pdev);
-		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
+		debugf3("failed edac_mc_add_mc()\n");
 		goto err;
 	}
 
@@ -1103,7 +1103,7 @@ static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 	}
 
 	devres_remove_group(&op->dev, mpc85xx_mc_err_probe);
-	debugf3("%s(): success\n", __func__);
+	debugf3("success\n");
 	printk(KERN_INFO EDAC_MOD_STR " MC err registered\n");
 
 	return 0;
@@ -1121,7 +1121,7 @@ static int mpc85xx_mc_err_remove(struct platform_device *op)
 	struct mem_ctl_info *mci = dev_get_drvdata(&op->dev);
 	struct mpc85xx_mc_pdata *pdata = mci->pvt_info;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	if (edac_op_state == EDAC_OPSTATE_INT) {
 		out_be32(pdata->mc_vbase + MPC85XX_MC_ERR_INT_EN, 0);
diff --git a/drivers/edac/mv64x60_edac.c b/drivers/edac/mv64x60_edac.c
index 3a58ba9..25851ef 100644
--- a/drivers/edac/mv64x60_edac.c
+++ b/drivers/edac/mv64x60_edac.c
@@ -169,7 +169,7 @@ static int __devinit mv64x60_pci_err_probe(struct platform_device *pdev)
 		 MV64X60_PCIx_ERR_MASK_VAL);
 
 	if (edac_pci_add_device(pci, pdata->edac_idx) > 0) {
-		debugf3("%s(): failed edac_pci_add_device()\n", __func__);
+		debugf3("failed edac_pci_add_device()\n");
 		goto err;
 	}
 
@@ -194,7 +194,7 @@ static int __devinit mv64x60_pci_err_probe(struct platform_device *pdev)
 	devres_remove_group(&pdev->dev, mv64x60_pci_err_probe);
 
 	/* get this far and it's successful */
-	debugf3("%s(): success\n", __func__);
+	debugf3("success\n");
 
 	return 0;
 
@@ -210,7 +210,7 @@ static int mv64x60_pci_err_remove(struct platform_device *pdev)
 {
 	struct edac_pci_ctl_info *pci = platform_get_drvdata(pdev);
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	edac_pci_del_device(&pdev->dev);
 
@@ -336,7 +336,7 @@ static int __devinit mv64x60_sram_err_probe(struct platform_device *pdev)
 	pdata->edac_idx = edac_dev_idx++;
 
 	if (edac_device_add_device(edac_dev) > 0) {
-		debugf3("%s(): failed edac_device_add_device()\n", __func__);
+		debugf3("failed edac_device_add_device()\n");
 		goto err;
 	}
 
@@ -363,7 +363,7 @@ static int __devinit mv64x60_sram_err_probe(struct platform_device *pdev)
 	devres_remove_group(&pdev->dev, mv64x60_sram_err_probe);
 
 	/* get this far and it's successful */
-	debugf3("%s(): success\n", __func__);
+	debugf3("success\n");
 
 	return 0;
 
@@ -379,7 +379,7 @@ static int mv64x60_sram_err_remove(struct platform_device *pdev)
 {
 	struct edac_device_ctl_info *edac_dev = platform_get_drvdata(pdev);
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	edac_device_del_device(&pdev->dev);
 	edac_device_free_ctl_info(edac_dev);
@@ -531,7 +531,7 @@ static int __devinit mv64x60_cpu_err_probe(struct platform_device *pdev)
 	pdata->edac_idx = edac_dev_idx++;
 
 	if (edac_device_add_device(edac_dev) > 0) {
-		debugf3("%s(): failed edac_device_add_device()\n", __func__);
+		debugf3("failed edac_device_add_device()\n");
 		goto err;
 	}
 
@@ -558,7 +558,7 @@ static int __devinit mv64x60_cpu_err_probe(struct platform_device *pdev)
 	devres_remove_group(&pdev->dev, mv64x60_cpu_err_probe);
 
 	/* get this far and it's successful */
-	debugf3("%s(): success\n", __func__);
+	debugf3("success\n");
 
 	return 0;
 
@@ -574,7 +574,7 @@ static int mv64x60_cpu_err_remove(struct platform_device *pdev)
 {
 	struct edac_device_ctl_info *edac_dev = platform_get_drvdata(pdev);
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	edac_device_del_device(&pdev->dev);
 	edac_device_free_ctl_info(edac_dev);
@@ -766,7 +766,7 @@ static int __devinit mv64x60_mc_err_probe(struct platform_device *pdev)
 		goto err2;
 	}
 
-	debugf3("%s(): init mci\n", __func__);
+	debugf3("init mci\n");
 	mci->mtype_cap = MEM_FLAG_RDDR | MEM_FLAG_DDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
 	mci->edac_cap = EDAC_FLAG_SECDED;
@@ -790,7 +790,7 @@ static int __devinit mv64x60_mc_err_probe(struct platform_device *pdev)
 	out_le32(pdata->mc_vbase + MV64X60_SDRAM_ERR_ECC_CNTL, ctl);
 
 	if (edac_mc_add_mc(mci)) {
-		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
+		debugf3("failed edac_mc_add_mc()\n");
 		goto err;
 	}
 
@@ -815,7 +815,7 @@ static int __devinit mv64x60_mc_err_probe(struct platform_device *pdev)
 	}
 
 	/* get this far and it's successful */
-	debugf3("%s(): success\n", __func__);
+	debugf3("success\n");
 
 	return 0;
 
@@ -831,7 +831,7 @@ static int mv64x60_mc_err_remove(struct platform_device *pdev)
 {
 	struct mem_ctl_info *mci = platform_get_drvdata(pdev);
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	edac_mc_del_mc(&pdev->dev);
 	edac_mc_free(mci);
diff --git a/drivers/edac/r82600_edac.c b/drivers/edac/r82600_edac.c
index 445c9ff..872c3b9 100644
--- a/drivers/edac/r82600_edac.c
+++ b/drivers/edac/r82600_edac.c
@@ -205,7 +205,7 @@ static void r82600_check(struct mem_ctl_info *mci)
 {
 	struct r82600_error_info info;
 
-	debugf1("MC%d: %s()\n", mci->mc_idx, __func__);
+	debugf1("MC%d\n", mci->mc_idx);
 	r82600_get_error_info(mci, &info);
 	r82600_process_error_info(mci, &info, 1);
 }
@@ -236,13 +236,13 @@ static void r82600_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 		/* find the DRAM Chip Select Base address and mask */
 		pci_read_config_byte(pdev, R82600_DRBA + index, &drbar);
 
-		debugf1("%s() Row=%d DRBA = %#0x\n", __func__, index, drbar);
+		debugf1("Row=%d DRBA = %#0x\n", index, drbar);
 
 		row_high_limit = ((u32) drbar << 24);
 /*		row_high_limit = ((u32)drbar << 24) | 0xffffffUL; */
 
-		debugf1("%s() Row=%d, Boundary Address=%#0x, Last = %#0x\n",
-			__func__, index, row_high_limit, row_high_limit_last);
+		debugf1("Row=%d, Boundary Address=%#0x, Last = %#0x\n",
+			index, row_high_limit, row_high_limit_last);
 
 		/* Empty row [p.57] */
 		if (row_high_limit == row_high_limit_last)
@@ -277,14 +277,13 @@ static int r82600_probe1(struct pci_dev *pdev, int dev_idx)
 	u32 sdram_refresh_rate;
 	struct r82600_error_info discard;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 	pci_read_config_byte(pdev, R82600_DRAMC, &dramcr);
 	pci_read_config_dword(pdev, R82600_EAP, &eapr);
 	scrub_disabled = eapr & BIT(31);
 	sdram_refresh_rate = dramcr & (BIT(0) | BIT(1));
-	debugf2("%s(): sdram refresh rate = %#0x\n", __func__,
-		sdram_refresh_rate);
-	debugf2("%s(): DRAMC register = %#0x\n", __func__, dramcr);
+	debugf2("sdram refresh rate = %#0x\n", sdram_refresh_rate);
+	debugf2("DRAMC register = %#0x\n", dramcr);
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
 	layers[0].size = R82600_NR_CSROWS;
 	layers[0].is_virt_csrow = true;
@@ -295,7 +294,7 @@ static int r82600_probe1(struct pci_dev *pdev, int dev_idx)
 	if (mci == NULL)
 		return -ENOMEM;
 
-	debugf0("%s(): mci = %p\n", __func__, mci);
+	debugf0("mci = %p\n", mci);
 	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_RDDR | MEM_FLAG_DDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_EC | EDAC_FLAG_SECDED;
@@ -311,8 +310,8 @@ static int r82600_probe1(struct pci_dev *pdev, int dev_idx)
 
 	if (ecc_enabled(dramcr)) {
 		if (scrub_disabled)
-			debugf3("%s(): mci = %p - Scrubbing disabled! EAP: "
-				"%#0x\n", __func__, mci, eapr);
+			debugf3("mci = %p - Scrubbing disabled! EAP: "
+				"%#0x\n", mci, eapr);
 	} else
 		mci->edac_cap = EDAC_FLAG_NONE;
 
@@ -329,15 +328,14 @@ static int r82600_probe1(struct pci_dev *pdev, int dev_idx)
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
 	if (edac_mc_add_mc(mci)) {
-		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
+		debugf3("failed edac_mc_add_mc()\n");
 		goto fail;
 	}
 
 	/* get this far and it's successful */
 
 	if (disable_hardware_scrub) {
-		debugf3("%s(): Disabling Hardware Scrub (scrub on error)\n",
-			__func__);
+		debugf3("Disabling Hardware Scrub (scrub on error)\n");
 		pci_write_bits32(pdev, R82600_EAP, BIT(31), BIT(31));
 	}
 
@@ -352,7 +350,7 @@ static int r82600_probe1(struct pci_dev *pdev, int dev_idx)
 			__func__);
 	}
 
-	debugf3("%s(): success\n", __func__);
+	debugf3("success\n");
 	return 0;
 
 fail:
@@ -364,7 +362,7 @@ fail:
 static int __devinit r82600_init_one(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	/* don't need to call pci_enable_device() */
 	return r82600_probe1(pdev, ent->driver_data);
@@ -374,7 +372,7 @@ static void __devexit r82600_remove_one(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	if (r82600_pci)
 		edac_pci_release_generic_ctl(r82600_pci);
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index efa4883..96efa49 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1064,7 +1064,7 @@ static void sbridge_put_devices(struct sbridge_dev *sbridge_dev)
 {
 	int i;
 
-	debugf0(__FILE__ ": %s()\n", __func__);
+	debugf0("\n");
 	for (i = 0; i < sbridge_dev->n_devs; i++) {
 		struct pci_dev *pdev = sbridge_dev->pdev[i];
 		if (!pdev)
@@ -1592,8 +1592,7 @@ static void sbridge_unregister_mci(struct sbridge_dev *sbridge_dev)
 	struct sbridge_pvt *pvt;
 
 	if (unlikely(!mci || !mci->pvt_info)) {
-		debugf0("MC: " __FILE__ ": %s(): dev = %p\n",
-			__func__, &sbridge_dev->pdev[0]->dev);
+		debugf0("MC: dev = %p\n", &sbridge_dev->pdev[0]->dev);
 
 		sbridge_printk(KERN_ERR, "Couldn't find mci handler\n");
 		return;
@@ -1601,8 +1600,8 @@ static void sbridge_unregister_mci(struct sbridge_dev *sbridge_dev)
 
 	pvt = mci->pvt_info;
 
-	debugf0("MC: " __FILE__ ": %s(): mci = %p, dev = %p\n",
-		__func__, mci, &sbridge_dev->pdev[0]->dev);
+	debugf0("MC: mci = %p, dev = %p\n",
+		mci, &sbridge_dev->pdev[0]->dev);
 
 	mce_unregister_decode_chain(&sbridge_mce_dec);
 
@@ -1640,8 +1639,8 @@ static int sbridge_register_mci(struct sbridge_dev *sbridge_dev)
 	if (unlikely(!mci))
 		return -ENOMEM;
 
-	debugf0("MC: " __FILE__ ": %s(): mci = %p, dev = %p\n",
-		__func__, mci, &sbridge_dev->pdev[0]->dev);
+	debugf0("MC: mci = %p, dev = %p\n",
+		mci, &sbridge_dev->pdev[0]->dev);
 
 	pvt = mci->pvt_info;
 	memset(pvt, 0, sizeof(*pvt));
@@ -1676,8 +1675,7 @@ static int sbridge_register_mci(struct sbridge_dev *sbridge_dev)
 
 	/* add this new MC control structure to EDAC's list of MCs */
 	if (unlikely(edac_mc_add_mc(mci))) {
-		debugf0("MC: " __FILE__
-			": %s(): failed edac_mc_add_mc()\n", __func__);
+		debugf0("MC: failed edac_mc_add_mc()\n");
 		rc = -EINVAL;
 		goto fail0;
 	}
@@ -1755,7 +1753,7 @@ static void __devexit sbridge_remove(struct pci_dev *pdev)
 {
 	struct sbridge_dev *sbridge_dev;
 
-	debugf0(__FILE__ ": %s()\n", __func__);
+	debugf0("\n");
 
 	/*
 	 * we have a trouble here: pdev value for removal will be wrong, since
@@ -1804,7 +1802,7 @@ static int __init sbridge_init(void)
 {
 	int pci_rc;
 
-	debugf2("MC: " __FILE__ ": %s()\n", __func__);
+	debugf2("\n");
 
 	/* Ensure that the OPSTATE is set correctly for POLL or NMI */
 	opstate_init();
@@ -1826,7 +1824,7 @@ static int __init sbridge_init(void)
  */
 static void __exit sbridge_exit(void)
 {
-	debugf2("MC: " __FILE__ ": %s()\n", __func__);
+	debugf2("\n");
 	pci_unregister_driver(&sbridge_driver);
 }
 
diff --git a/drivers/edac/x38_edac.c b/drivers/edac/x38_edac.c
index ae699be..70c7454 100644
--- a/drivers/edac/x38_edac.c
+++ b/drivers/edac/x38_edac.c
@@ -243,7 +243,7 @@ static void x38_check(struct mem_ctl_info *mci)
 {
 	struct x38_error_info info;
 
-	debugf1("MC%d: %s()\n", mci->mc_idx, __func__);
+	debugf1("MC%d\n", mci->mc_idx);
 	x38_get_and_clear_error_info(mci, &info);
 	x38_process_error_info(mci, &info);
 }
@@ -331,7 +331,7 @@ static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 	bool stacked;
 	void __iomem *window;
 
-	debugf0("MC: %s()\n", __func__);
+	debugf0("MC:\n");
 
 	window = x38_map_mchbar(pdev);
 	if (!window)
@@ -352,7 +352,7 @@ static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 	if (!mci)
 		return -ENOMEM;
 
-	debugf3("MC: %s(): init mci\n", __func__);
+	debugf3("MC: init mci\n");
 
 	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR2;
@@ -402,12 +402,12 @@ static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 
 	rc = -ENODEV;
 	if (edac_mc_add_mc(mci)) {
-		debugf3("MC: %s(): failed edac_mc_add_mc()\n", __func__);
+		debugf3("MC: failed edac_mc_add_mc()\n");
 		goto fail;
 	}
 
 	/* get this far and it's successful */
-	debugf3("MC: %s(): success\n", __func__);
+	debugf3("MC: success\n");
 	return 0;
 
 fail:
@@ -423,7 +423,7 @@ static int __devinit x38_init_one(struct pci_dev *pdev,
 {
 	int rc;
 
-	debugf0("MC: %s()\n", __func__);
+	debugf0("MC:\n");
 
 	if (pci_enable_device(pdev) < 0)
 		return -EIO;
@@ -439,7 +439,7 @@ static void __devexit x38_remove_one(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 
-	debugf0("%s()\n", __func__);
+	debugf0("\n");
 
 	mci = edac_mc_del_mc(&pdev->dev);
 	if (!mci)
@@ -472,7 +472,7 @@ static int __init x38_init(void)
 {
 	int pci_rc;
 
-	debugf3("MC: %s()\n", __func__);
+	debugf3("MC:\n");
 
 	/* Ensure that the OPSTATE is set correctly for POLL or NMI */
 	opstate_init();
@@ -513,7 +513,7 @@ fail0:
 
 static void __exit x38_exit(void)
 {
-	debugf3("MC: %s()\n", __func__);
+	debugf3("MC:\n");
 
 	pci_unregister_driver(&x38_driver);
 	if (!x38_registered) {
-- 
1.7.8

