Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab2DPUkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:40:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751Ab2DPUkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:40:22 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Mark Gross <mark.gross@intel.com>,
        Jason Uhlenkott <juhlenko@akamai.com>,
        Tim Small <tim@buttersideup.com>,
        Ranganathan Desikan <ravi@jetztechnologies.com>,
        "Arvind R." <arvino55@gmail.com>, Olof Johansson <olof@lixom.net>,
        Egor Martovetsky <egor@pasemi.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Michal Marek <mmarek@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ericsson.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Josh Boyer <jwboyer@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [EDAC ABI v13 07/25] edac: Rename the parent dev to pdev
Date: Mon, 16 Apr 2012 17:38:31 -0300
Message-Id: <1334608729-30803-8-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As EDAC doesn't use struct device itself, it created a parent dev
pointer called as "pdev".  Now that we'll be converting it to use
struct device, instead of struct devsys, this needs to be fixed.

No functional changes.

Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Mark Gross <mark.gross@intel.com>
Cc: Jason Uhlenkott <juhlenko@akamai.com>
Cc: Tim Small <tim@buttersideup.com>
Cc: Ranganathan Desikan <ravi@jetztechnologies.com>
Cc: "Arvind R." <arvino55@gmail.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Egor Martovetsky <egor@pasemi.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Joe Perches <joe@perches.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hitoshi Mitake <h.mitake@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Niklas Söderlund" <niklas.soderlund@ericsson.com>
Cc: Shaohui Xie <Shaohui.Xie@freescale.com>
Cc: Josh Boyer <jwboyer@gmail.com>
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/amd64_edac.c      |    2 +-
 drivers/edac/amd76x_edac.c     |    4 ++--
 drivers/edac/cell_edac.c       |   12 ++++++------
 drivers/edac/cpc925_edac.c     |    2 +-
 drivers/edac/e752x_edac.c      |    2 +-
 drivers/edac/e7xxx_edac.c      |    2 +-
 drivers/edac/edac_mc.c         |    8 ++++----
 drivers/edac/edac_mc_sysfs.c   |    2 +-
 drivers/edac/i3000_edac.c      |    4 ++--
 drivers/edac/i3200_edac.c      |    6 +++---
 drivers/edac/i5000_edac.c      |    2 +-
 drivers/edac/i5100_edac.c      |    2 +-
 drivers/edac/i5400_edac.c      |    2 +-
 drivers/edac/i7300_edac.c      |    2 +-
 drivers/edac/i7core_edac.c     |    4 ++--
 drivers/edac/i82443bxgx_edac.c |    4 ++--
 drivers/edac/i82860_edac.c     |    4 ++--
 drivers/edac/i82875p_edac.c    |    4 ++--
 drivers/edac/i82975x_edac.c    |    4 ++--
 drivers/edac/mpc85xx_edac.c    |    4 ++--
 drivers/edac/mv64x60_edac.c    |    2 +-
 drivers/edac/pasemi_edac.c     |    6 +++---
 drivers/edac/ppc4xx_edac.c     |    8 ++++----
 drivers/edac/r82600_edac.c     |    4 ++--
 drivers/edac/sb_edac.c         |    4 ++--
 drivers/edac/tile_edac.c       |    4 ++--
 drivers/edac/x38_edac.c        |    6 +++---
 include/linux/edac.h           |    2 +-
 28 files changed, 56 insertions(+), 56 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 445ff03..b26fc06 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2572,7 +2572,7 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 		goto err_siblings;
 
 	mci->pvt_info = pvt;
-	mci->dev = &pvt->F2->dev;
+	mci->pdev = &pvt->F2->dev;
 
 	setup_mci_misc_attrs(mci, fam_type);
 
diff --git a/drivers/edac/amd76x_edac.c b/drivers/edac/amd76x_edac.c
index 0184e90..9a34c5f 100644
--- a/drivers/edac/amd76x_edac.c
+++ b/drivers/edac/amd76x_edac.c
@@ -105,7 +105,7 @@ static void amd76x_get_error_info(struct mem_ctl_info *mci,
 {
 	struct pci_dev *pdev;
 
-	pdev = to_pci_dev(mci->dev);
+	pdev = to_pci_dev(mci->pdev);
 	pci_read_config_dword(pdev, AMD76X_ECC_MODE_STATUS,
 			&info->ecc_mode_status);
 
@@ -257,7 +257,7 @@ static int amd76x_probe1(struct pci_dev *pdev, int dev_idx)
 		return -ENOMEM;
 
 	debugf0("%s(): mci = %p\n", __func__, mci);
-	mci->dev = &pdev->dev;
+	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_RDDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_EC | EDAC_FLAG_SECDED;
 	mci->edac_cap = ems_mode ?
diff --git a/drivers/edac/cell_edac.c b/drivers/edac/cell_edac.c
index 39616a3..9e53917 100644
--- a/drivers/edac/cell_edac.c
+++ b/drivers/edac/cell_edac.c
@@ -36,7 +36,7 @@ static void cell_edac_count_ce(struct mem_ctl_info *mci, int chan, u64 ar)
 	struct csrow_info		*csrow = &mci->csrows[0];
 	unsigned long			address, pfn, offset, syndrome;
 
-	dev_dbg(mci->dev, "ECC CE err on node %d, channel %d, ar = 0x%016llx\n",
+	dev_dbg(mci->pdev, "ECC CE err on node %d, channel %d, ar = 0x%016llx\n",
 		priv->node, chan, ar);
 
 	/* Address decoding is likely a bit bogus, to dbl check */
@@ -59,7 +59,7 @@ static void cell_edac_count_ue(struct mem_ctl_info *mci, int chan, u64 ar)
 	struct csrow_info		*csrow = &mci->csrows[0];
 	unsigned long			address, pfn, offset;
 
-	dev_dbg(mci->dev, "ECC UE err on node %d, channel %d, ar = 0x%016llx\n",
+	dev_dbg(mci->pdev, "ECC UE err on node %d, channel %d, ar = 0x%016llx\n",
 		priv->node, chan, ar);
 
 	/* Address decoding is likely a bit bogus, to dbl check */
@@ -83,7 +83,7 @@ static void cell_edac_check(struct mem_ctl_info *mci)
 	fir = in_be64(&priv->regs->mic_fir);
 #ifdef DEBUG
 	if (fir != priv->prev_fir) {
-		dev_dbg(mci->dev, "fir change : 0x%016lx\n", fir);
+		dev_dbg(mci->pdev, "fir change : 0x%016lx\n", fir);
 		priv->prev_fir = fir;
 	}
 #endif
@@ -119,7 +119,7 @@ static void cell_edac_check(struct mem_ctl_info *mci)
 		mb();	/* sync up */
 #ifdef DEBUG
 		fir = in_be64(&priv->regs->mic_fir);
-		dev_dbg(mci->dev, "fir clear  : 0x%016lx\n", fir);
+		dev_dbg(mci->pdev, "fir clear  : 0x%016lx\n", fir);
 #endif
 	}
 }
@@ -155,7 +155,7 @@ static void __devinit cell_edac_init_csrows(struct mem_ctl_info *mci)
 			dimm->edac_mode = EDAC_SECDED;
 			dimm->nr_pages = nr_pages / csrow->nr_channels;
 		}
-		dev_dbg(mci->dev,
+		dev_dbg(mci->pdev,
 			"Initialized on node %d, chanmask=0x%x,"
 			" first_page=0x%lx, nr_pages=0x%x\n",
 			priv->node, priv->chanmask,
@@ -212,7 +212,7 @@ static int __devinit cell_edac_probe(struct platform_device *pdev)
 	priv->regs = regs;
 	priv->node = pdev->id;
 	priv->chanmask = chanmask;
-	mci->dev = &pdev->dev;
+	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_XDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_EC | EDAC_FLAG_SECDED;
 	mci->edac_cap = EDAC_FLAG_EC | EDAC_FLAG_SECDED;
diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
index caaae0d..78881b1 100644
--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -995,7 +995,7 @@ static int __devinit cpc925_probe(struct platform_device *pdev)
 	pdata->edac_idx = edac_mc_idx++;
 	pdata->name = pdev->name;
 
-	mci->dev = &pdev->dev;
+	mci->pdev = &pdev->dev;
 	platform_set_drvdata(pdev, mci);
 	mci->dev_name = dev_name(&pdev->dev);
 	mci->mtype_cap = MEM_FLAG_RDDR | MEM_FLAG_DDR;
diff --git a/drivers/edac/e752x_edac.c b/drivers/edac/e752x_edac.c
index d9431eb..9b252dd 100644
--- a/drivers/edac/e752x_edac.c
+++ b/drivers/edac/e752x_edac.c
@@ -1309,7 +1309,7 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 	/* FIXME - what if different memory types are in different csrows? */
 	mci->mod_name = EDAC_MOD_STR;
 	mci->mod_ver = E752X_REVISION;
-	mci->dev = &pdev->dev;
+	mci->pdev = &pdev->dev;
 
 	debugf3("%s(): init pvt\n", __func__);
 	pvt = (struct e752x_pvt *)mci->pvt_info;
diff --git a/drivers/edac/e7xxx_edac.c b/drivers/edac/e7xxx_edac.c
index 54a6666..dba87a7 100644
--- a/drivers/edac/e7xxx_edac.c
+++ b/drivers/edac/e7xxx_edac.c
@@ -458,7 +458,7 @@ static int e7xxx_probe1(struct pci_dev *pdev, int dev_idx)
 	/* FIXME - what if different memory types are in different csrows? */
 	mci->mod_name = EDAC_MOD_STR;
 	mci->mod_ver = E7XXX_REVISION;
-	mci->dev = &pdev->dev;
+	mci->pdev = &pdev->dev;
 	debugf3("%s(): init pvt\n", __func__);
 	pvt = (struct e7xxx_pvt *)mci->pvt_info;
 	pvt->dev_info = &e7xxx_devs[dev_idx];
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 002e6b6..c1af3d7 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -91,7 +91,7 @@ static void edac_mc_dump_mci(struct mem_ctl_info *mci)
 		mci->nr_csrows, mci->csrows);
 	debugf3("\tmci->nr_dimms = %d, dimns = %p\n",
 		mci->tot_dimms, mci->dimms);
-	debugf3("\tdev = %p\n", mci->dev);
+	debugf3("\tdev = %p\n", mci->pdev);
 	debugf3("\tmod_name:ctl_name = %s:%s\n", mci->mod_name, mci->ctl_name);
 	debugf3("\tpvt_info = %p\n\n", mci->pvt_info);
 }
@@ -425,7 +425,7 @@ struct mem_ctl_info *find_mci_by_dev(struct device *dev)
 	list_for_each(item, &mc_devices) {
 		mci = list_entry(item, struct mem_ctl_info, link);
 
-		if (mci->dev == dev)
+		if (mci->pdev == dev)
 			return mci;
 	}
 
@@ -577,7 +577,7 @@ static int add_mc_to_global_list(struct mem_ctl_info *mci)
 
 	insert_before = &mc_devices;
 
-	p = find_mci_by_dev(mci->dev);
+	p = find_mci_by_dev(mci->pdev);
 	if (unlikely(p != NULL))
 		goto fail0;
 
@@ -599,7 +599,7 @@ static int add_mc_to_global_list(struct mem_ctl_info *mci)
 
 fail0:
 	edac_printk(KERN_WARNING, EDAC_MC,
-		"%s (%s) %s %s already assigned %d\n", dev_name(p->dev),
+		"%s (%s) %s %s already assigned %d\n", dev_name(p->pdev),
 		edac_dev_name(mci), p->mod_name, p->ctl_name, p->mc_idx);
 	return 1;
 
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index cfeb92c..c0dde23 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -916,7 +916,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 	INIT_LIST_HEAD(&mci->grp_kobj_list);
 
 	/* create a symlink for the device */
-	err = sysfs_create_link(kobj_mci, &mci->dev->kobj,
+	err = sysfs_create_link(kobj_mci, &mci->pdev->kobj,
 				EDAC_DEVICE_SYMLINK);
 	if (err) {
 		debugf1("%s() failure to create symlink\n", __func__);
diff --git a/drivers/edac/i3000_edac.c b/drivers/edac/i3000_edac.c
index 2032d198..2ee50ab 100644
--- a/drivers/edac/i3000_edac.c
+++ b/drivers/edac/i3000_edac.c
@@ -194,7 +194,7 @@ static void i3000_get_error_info(struct mem_ctl_info *mci,
 {
 	struct pci_dev *pdev;
 
-	pdev = to_pci_dev(mci->dev);
+	pdev = to_pci_dev(mci->pdev);
 
 	/*
 	 * This is a mess because there is no atomic way to read all the
@@ -368,7 +368,7 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 
 	debugf3("MC: %s(): init mci\n", __func__);
 
-	mci->dev = &pdev->dev;
+	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR2;
 
 	mci->edac_ctl_cap = EDAC_FLAG_SECDED;
diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index 9a35487..798fb65 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -159,7 +159,7 @@ static void i3200_clear_error_info(struct mem_ctl_info *mci)
 {
 	struct pci_dev *pdev;
 
-	pdev = to_pci_dev(mci->dev);
+	pdev = to_pci_dev(mci->pdev);
 
 	/*
 	 * Clear any error bits.
@@ -176,7 +176,7 @@ static void i3200_get_and_clear_error_info(struct mem_ctl_info *mci,
 	struct i3200_priv *priv = mci->pvt_info;
 	void __iomem *window = priv->window;
 
-	pdev = to_pci_dev(mci->dev);
+	pdev = to_pci_dev(mci->pdev);
 
 	/*
 	 * This is a mess because there is no atomic way to read all the
@@ -354,7 +354,7 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 
 	debugf3("MC: %s(): init mci\n", __func__);
 
-	mci->dev = &pdev->dev;
+	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR2;
 
 	mci->edac_ctl_cap = EDAC_FLAG_SECDED;
diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index 659a868..60ed0ce 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -1412,7 +1412,7 @@ static int i5000_probe1(struct pci_dev *pdev, int dev_idx)
 	kobject_get(&mci->edac_mci_kobj);
 	debugf0("MC: %s: %s(): mci = %p\n", __FILE__, __func__, mci);
 
-	mci->dev = &pdev->dev;	/* record ptr  to the generic device */
+	mci->pdev = &pdev->dev;	/* record ptr  to the generic device */
 
 	pvt = mci->pvt_info;
 	pvt->system_address = pdev;	/* Record this device in our private */
diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index fda60f8..11aba5e 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -943,7 +943,7 @@ static int __devinit i5100_init_one(struct pci_dev *pdev,
 		goto bail_disable_ch1;
 	}
 
-	mci->dev = &pdev->dev;
+	mci->pdev = &pdev->dev;
 
 	priv = mci->pvt_info;
 	priv->ranksperchan = ranksperch;
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 5debda9..a16a2b5 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -1300,7 +1300,7 @@ static int i5400_probe1(struct pci_dev *pdev, int dev_idx)
 
 	debugf0("MC: %s: %s(): mci = %p\n", __FILE__, __func__, mci);
 
-	mci->dev = &pdev->dev;	/* record ptr  to the generic device */
+	mci->pdev = &pdev->dev;	/* record ptr  to the generic device */
 
 	pvt = mci->pvt_info;
 	pvt->system_address = pdev;	/* Record this device in our private */
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 0ff0b26..57f264d 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -1061,7 +1061,7 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
 
 	debugf0("MC: " __FILE__ ": %s(): mci = %p\n", __func__, mci);
 
-	mci->dev = &pdev->dev;	/* record ptr  to the generic device */
+	mci->pdev = &pdev->dev;	/* record ptr  to the generic device */
 
 	pvt = mci->pvt_info;
 	pvt->pci_dev_16_0_fsb_ctlr = pdev;	/* Record this device in our private */
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 42775c4..7f81a04 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -2119,7 +2119,7 @@ static void i7core_unregister_mci(struct i7core_dev *i7core_dev)
 	i7core_pci_ctl_release(pvt);
 
 	/* Remove MC sysfs nodes */
-	edac_mc_del_mc(mci->dev);
+	edac_mc_del_mc(mci->pdev);
 
 	debugf1("%s: free mci struct\n", mci->ctl_name);
 	kfree(mci->ctl_name);
@@ -2185,7 +2185,7 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 	/* Get dimm basic config */
 	get_dimm_config(mci);
 	/* record ptr to the generic device */
-	mci->dev = &i7core_dev->pdev[0]->dev;
+	mci->pdev = &i7core_dev->pdev[0]->dev;
 	/* Set the function pointer to an actual operation function */
 	mci->edac_check = i7core_check_error;
 
diff --git a/drivers/edac/i82443bxgx_edac.c b/drivers/edac/i82443bxgx_edac.c
index 23a0b5d..4c572545 100644
--- a/drivers/edac/i82443bxgx_edac.c
+++ b/drivers/edac/i82443bxgx_edac.c
@@ -124,7 +124,7 @@ static void i82443bxgx_edacmc_get_error_info(struct mem_ctl_info *mci,
 				*info)
 {
 	struct pci_dev *pdev;
-	pdev = to_pci_dev(mci->dev);
+	pdev = to_pci_dev(mci->pdev);
 	pci_read_config_dword(pdev, I82443BXGX_EAP, &info->eap);
 	if (info->eap & I82443BXGX_EAP_OFFSET_SBE)
 		/* Clear error to allow next error to be reported [p.61] */
@@ -260,7 +260,7 @@ static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 		return -ENOMEM;
 
 	debugf0("MC: %s: %s(): mci = %p\n", __FILE__, __func__, mci);
-	mci->dev = &pdev->dev;
+	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_EDO | MEM_FLAG_SDR | MEM_FLAG_RDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_EC | EDAC_FLAG_SECDED;
 	pci_read_config_byte(pdev, I82443BXGX_DRAMC, &dramc);
diff --git a/drivers/edac/i82860_edac.c b/drivers/edac/i82860_edac.c
index b49b3b5..16a54bb 100644
--- a/drivers/edac/i82860_edac.c
+++ b/drivers/edac/i82860_edac.c
@@ -67,7 +67,7 @@ static void i82860_get_error_info(struct mem_ctl_info *mci,
 {
 	struct pci_dev *pdev;
 
-	pdev = to_pci_dev(mci->dev);
+	pdev = to_pci_dev(mci->pdev);
 
 	/*
 	 * This is a mess because there is no atomic way to read all the
@@ -211,7 +211,7 @@ static int i82860_probe1(struct pci_dev *pdev, int dev_idx)
 		return -ENOMEM;
 
 	debugf3("%s(): init mci\n", __func__);
-	mci->dev = &pdev->dev;
+	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
 	/* I"m not sure about this but I think that all RDRAM is SECDED */
diff --git a/drivers/edac/i82875p_edac.c b/drivers/edac/i82875p_edac.c
index c2c82c3..8de9250 100644
--- a/drivers/edac/i82875p_edac.c
+++ b/drivers/edac/i82875p_edac.c
@@ -189,7 +189,7 @@ static void i82875p_get_error_info(struct mem_ctl_info *mci,
 {
 	struct pci_dev *pdev;
 
-	pdev = to_pci_dev(mci->dev);
+	pdev = to_pci_dev(mci->pdev);
 
 	/*
 	 * This is a mess because there is no atomic way to read all the
@@ -430,7 +430,7 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 	kobject_get(&mci->edac_mci_kobj);
 
 	debugf3("%s(): init mci\n", __func__);
-	mci->dev = &pdev->dev;
+	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
 	mci->edac_cap = EDAC_FLAG_UNKNOWN;
diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index c7db489..ae2a857 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -241,7 +241,7 @@ static void i82975x_get_error_info(struct mem_ctl_info *mci,
 {
 	struct pci_dev *pdev;
 
-	pdev = to_pci_dev(mci->dev);
+	pdev = to_pci_dev(mci->pdev);
 
 	/*
 	 * This is a mess because there is no atomic way to read all the
@@ -562,7 +562,7 @@ static int i82975x_probe1(struct pci_dev *pdev, int dev_idx)
 	}
 
 	debugf3("%s(): init mci\n", __func__);
-	mci->dev = &pdev->dev;
+	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR2;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
 	mci->edac_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index a7f1ff1..6146ab7 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -990,9 +990,9 @@ static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 	pdata = mci->pvt_info;
 	pdata->name = "mpc85xx_mc_err";
 	pdata->irq = NO_IRQ;
-	mci->dev = &op->dev;
+	mci->pdev = &op->dev;
 	pdata->edac_idx = edac_mc_idx++;
-	dev_set_drvdata(mci->dev, mci);
+	dev_set_drvdata(mci->pdev, mci);
 	mci->ctl_name = pdata->name;
 	mci->dev_name = pdata->name;
 
diff --git a/drivers/edac/mv64x60_edac.c b/drivers/edac/mv64x60_edac.c
index a32e9b6..ef0e710 100644
--- a/drivers/edac/mv64x60_edac.c
+++ b/drivers/edac/mv64x60_edac.c
@@ -724,7 +724,7 @@ static int __devinit mv64x60_mc_err_probe(struct platform_device *pdev)
 	}
 
 	pdata = mci->pvt_info;
-	mci->dev = &pdev->dev;
+	mci->pdev = &pdev->dev;
 	platform_set_drvdata(pdev, mci);
 	pdata->name = "mv64x60_mc_err";
 	pdata->irq = NO_IRQ;
diff --git a/drivers/edac/pasemi_edac.c b/drivers/edac/pasemi_edac.c
index caf17c8..47542e7 100644
--- a/drivers/edac/pasemi_edac.c
+++ b/drivers/edac/pasemi_edac.c
@@ -74,7 +74,7 @@ static int system_mmc_id;
 
 static u32 pasemi_edac_get_error_info(struct mem_ctl_info *mci)
 {
-	struct pci_dev *pdev = to_pci_dev(mci->dev);
+	struct pci_dev *pdev = to_pci_dev(mci->pdev);
 	u32 tmp;
 
 	pci_read_config_dword(pdev, MCDEBUG_ERRSTA,
@@ -95,7 +95,7 @@ static u32 pasemi_edac_get_error_info(struct mem_ctl_info *mci)
 
 static void pasemi_edac_process_error_info(struct mem_ctl_info *mci, u32 errsta)
 {
-	struct pci_dev *pdev = to_pci_dev(mci->dev);
+	struct pci_dev *pdev = to_pci_dev(mci->pdev);
 	u32 errlog1a;
 	u32 cs;
 
@@ -225,7 +225,7 @@ static int __devinit pasemi_edac_probe(struct pci_dev *pdev,
 		MCCFG_ERRCOR_ECC_GEN_EN |
 		MCCFG_ERRCOR_ECC_CRR_EN;
 
-	mci->dev = &pdev->dev;
+	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR | MEM_FLAG_RDDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_EC | EDAC_FLAG_SECDED;
 	mci->edac_cap = (errcor & MCCFG_ERRCOR_ECC_GEN_EN) ?
diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index 89e3147..3917b0f 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -1027,9 +1027,9 @@ ppc4xx_edac_mc_init(struct mem_ctl_info *mci,
 
 	/* Initial driver pointers and private data */
 
-	mci->dev		= &op->dev;
+	mci->pdev		= &op->dev;
 
-	dev_set_drvdata(mci->dev, mci);
+	dev_set_drvdata(mci->pdev, mci);
 
 	pdata			= mci->pvt_info;
 
@@ -1334,7 +1334,7 @@ static int __devinit ppc4xx_edac_probe(struct platform_device *op)
 	return 0;
 
  fail1:
-	edac_mc_del_mc(mci->dev);
+	edac_mc_del_mc(mci->pdev);
 
  fail:
 	edac_mc_free(mci);
@@ -1368,7 +1368,7 @@ ppc4xx_edac_remove(struct platform_device *op)
 
 	dcr_unmap(pdata->dcr_host, SDRAM_DCR_RESOURCE_LEN);
 
-	edac_mc_del_mc(mci->dev);
+	edac_mc_del_mc(mci->pdev);
 	edac_mc_free(mci);
 
 	return 0;
diff --git a/drivers/edac/r82600_edac.c b/drivers/edac/r82600_edac.c
index fe060db..10464c5 100644
--- a/drivers/edac/r82600_edac.c
+++ b/drivers/edac/r82600_edac.c
@@ -140,7 +140,7 @@ static void r82600_get_error_info(struct mem_ctl_info *mci,
 {
 	struct pci_dev *pdev;
 
-	pdev = to_pci_dev(mci->dev);
+	pdev = to_pci_dev(mci->pdev);
 	pci_read_config_dword(pdev, R82600_EAP, &info->eapr);
 
 	if (info->eapr & BIT(0))
@@ -296,7 +296,7 @@ static int r82600_probe1(struct pci_dev *pdev, int dev_idx)
 		return -ENOMEM;
 
 	debugf0("%s(): mci = %p\n", __func__, mci);
-	mci->dev = &pdev->dev;
+	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_RDDR | MEM_FLAG_DDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_EC | EDAC_FLAG_SECDED;
 	/* FIXME try to work out if the chip leads have been used for COM2
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index ad27e27..ff07f34 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1612,7 +1612,7 @@ static void sbridge_unregister_mci(struct sbridge_dev *sbridge_dev)
 	mce_unregister_decode_chain(&sbridge_mce_dec);
 
 	/* Remove MC sysfs nodes */
-	edac_mc_del_mc(mci->dev);
+	edac_mc_del_mc(mci->pdev);
 
 	debugf1("%s: free mci struct\n", mci->ctl_name);
 	kfree(mci->ctl_name);
@@ -1677,7 +1677,7 @@ static int sbridge_register_mci(struct sbridge_dev *sbridge_dev)
 	get_memory_layout(mci);
 
 	/* record ptr to the generic device */
-	mci->dev = &sbridge_dev->pdev[0]->dev;
+	mci->pdev = &sbridge_dev->pdev[0]->dev;
 
 	/* add this new MC control structure to EDAC's list of MCs */
 	if (unlikely(edac_mc_add_mc(mci))) {
diff --git a/drivers/edac/tile_edac.c b/drivers/edac/tile_edac.c
index 3e878bf..32cb2c7 100644
--- a/drivers/edac/tile_edac.c
+++ b/drivers/edac/tile_edac.c
@@ -69,7 +69,7 @@ static void tile_edac_check(struct mem_ctl_info *mci)
 
 	/* Check if the current error count is different from the saved one. */
 	if (mem_error.sbe_count != priv->ce_count) {
-		dev_dbg(mci->dev, "ECC CE err on node %d\n", priv->node);
+		dev_dbg(mci->pdev, "ECC CE err on node %d\n", priv->node);
 		priv->ce_count = mem_error.sbe_count;
 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     0, 0, 0,
@@ -149,7 +149,7 @@ static int __devinit tile_edac_mc_probe(struct platform_device *pdev)
 	priv->node = pdev->id;
 	priv->hv_devhdl = hv_devhdl;
 
-	mci->dev = &pdev->dev;
+	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR2;
 	mci->edac_ctl_cap = EDAC_FLAG_SECDED;
 
diff --git a/drivers/edac/x38_edac.c b/drivers/edac/x38_edac.c
index 996d548..dde47e9 100644
--- a/drivers/edac/x38_edac.c
+++ b/drivers/edac/x38_edac.c
@@ -151,7 +151,7 @@ static void x38_clear_error_info(struct mem_ctl_info *mci)
 {
 	struct pci_dev *pdev;
 
-	pdev = to_pci_dev(mci->dev);
+	pdev = to_pci_dev(mci->pdev);
 
 	/*
 	 * Clear any error bits.
@@ -172,7 +172,7 @@ static void x38_get_and_clear_error_info(struct mem_ctl_info *mci,
 	struct pci_dev *pdev;
 	void __iomem *window = mci->pvt_info;
 
-	pdev = to_pci_dev(mci->dev);
+	pdev = to_pci_dev(mci->pdev);
 
 	/*
 	 * This is a mess because there is no atomic way to read all the
@@ -354,7 +354,7 @@ static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 
 	debugf3("MC: %s(): init mci\n", __func__);
 
-	mci->dev = &pdev->dev;
+	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR2;
 
 	mci->edac_ctl_cap = EDAC_FLAG_SECDED;
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 6d8c394..ffb189b 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -546,7 +546,7 @@ struct mem_ctl_info {
 	 * unique.  dev pointer should be sufficiently unique, but
 	 * BUS:SLOT.FUNC numbers may not be unique.
 	 */
-	struct device *dev;
+	struct device *pdev;
 	const char *mod_name;
 	const char *mod_ver;
 	const char *ctl_name;
-- 
1.7.8

