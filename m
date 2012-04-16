Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab2DPUWC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:22:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754754Ab2DPUVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:21:54 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [EDAC_ABI PATCH v13 26/26] edac: Remove the legacy EDAC ABI
Date: Mon, 16 Apr 2012 17:21:45 -0300
Message-Id: <1334607705-30320-27-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334607705-30320-1-git-send-email-mchehab@redhat.com>
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607705-30320-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all drivers got converted to use the new ABI, we can
drop the old one.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/amd64_edac.c      |    2 +-
 drivers/edac/amd76x_edac.c     |    2 +-
 drivers/edac/cell_edac.c       |    2 +-
 drivers/edac/cpc925_edac.c     |    2 +-
 drivers/edac/e752x_edac.c      |    2 +-
 drivers/edac/e7xxx_edac.c      |    2 +-
 drivers/edac/edac_core.h       |   78 +---------------------------------------
 drivers/edac/edac_mc.c         |   53 +--------------------------
 drivers/edac/i3000_edac.c      |    2 +-
 drivers/edac/i3200_edac.c      |    2 +-
 drivers/edac/i5000_edac.c      |    2 +-
 drivers/edac/i5100_edac.c      |    2 +-
 drivers/edac/i5400_edac.c      |    2 +-
 drivers/edac/i7300_edac.c      |    2 +-
 drivers/edac/i7core_edac.c     |    2 +-
 drivers/edac/i82443bxgx_edac.c |    2 +-
 drivers/edac/i82860_edac.c     |    2 +-
 drivers/edac/i82875p_edac.c    |    2 +-
 drivers/edac/i82975x_edac.c    |    2 +-
 drivers/edac/mpc85xx_edac.c    |    2 +-
 drivers/edac/mv64x60_edac.c    |    2 +-
 drivers/edac/pasemi_edac.c     |    2 +-
 drivers/edac/ppc4xx_edac.c     |    2 +-
 drivers/edac/r82600_edac.c     |    2 +-
 drivers/edac/sb_edac.c         |    2 +-
 drivers/edac/tile_edac.c       |    2 +-
 drivers/edac/x38_edac.c        |    2 +-
 27 files changed, 27 insertions(+), 154 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index c4182e4..445ff03 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2567,7 +2567,7 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = pvt->channel_count;
 	layers[1].is_csrow = false;
-	mci = new_edac_mc_alloc(nid, ARRAY_SIZE(layers), layers, false, 0);
+	mci = edac_mc_alloc(nid, ARRAY_SIZE(layers), layers, false, 0);
 	if (!mci)
 		goto err_siblings;
 
diff --git a/drivers/edac/amd76x_edac.c b/drivers/edac/amd76x_edac.c
index fd9ab44..0184e90 100644
--- a/drivers/edac/amd76x_edac.c
+++ b/drivers/edac/amd76x_edac.c
@@ -251,7 +251,7 @@ static int amd76x_probe1(struct pci_dev *pdev, int dev_idx)
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = 1;
 	layers[1].is_csrow = false;
-	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
 
 	if (mci == NULL)
 		return -ENOMEM;
diff --git a/drivers/edac/cell_edac.c b/drivers/edac/cell_edac.c
index 4cfd22a..39616a3 100644
--- a/drivers/edac/cell_edac.c
+++ b/drivers/edac/cell_edac.c
@@ -204,7 +204,7 @@ static int __devinit cell_edac_probe(struct platform_device *pdev)
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = num_chans;
 	layers[1].is_csrow = false;
-	mci = new_edac_mc_alloc(pdev->id, ARRAY_SIZE(layers), layers, false,
+	mci = edac_mc_alloc(pdev->id, ARRAY_SIZE(layers), layers, false,
 			    sizeof(struct cell_edac_priv));
 	if (mci == NULL)
 		return -ENOMEM;
diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
index adbeb13..caaae0d 100644
--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -982,7 +982,7 @@ static int __devinit cpc925_probe(struct platform_device *pdev)
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = nr_channels;
 	layers[1].is_csrow = false;
-	mci = new_edac_mc_alloc(edac_mc_idx, ARRAY_SIZE(layers), layers, false,
+	mci = edac_mc_alloc(edac_mc_idx, ARRAY_SIZE(layers), layers, false,
 			    sizeof(struct cpc925_mc_pdata));
 	if (!mci) {
 		cpc925_printk(KERN_ERR, "No memory for mem_ctl_info\n");
diff --git a/drivers/edac/e752x_edac.c b/drivers/edac/e752x_edac.c
index 7b6ce11..5f20a8e 100644
--- a/drivers/edac/e752x_edac.c
+++ b/drivers/edac/e752x_edac.c
@@ -1278,7 +1278,7 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = drc_chan + 1;
 	layers[1].is_csrow = false;
-	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
 			    false, sizeof(*pvt));
 	if (mci == NULL)
 		return -ENOMEM;
diff --git a/drivers/edac/e7xxx_edac.c b/drivers/edac/e7xxx_edac.c
index 9380f8a..54a6666 100644
--- a/drivers/edac/e7xxx_edac.c
+++ b/drivers/edac/e7xxx_edac.c
@@ -447,7 +447,7 @@ static int e7xxx_probe1(struct pci_dev *pdev, int dev_idx)
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = drc_chan + 1;
 	layers[1].is_csrow = false;
-	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
 	if (mci == NULL)
 		return -ENOMEM;
 
diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index 7201bb1..8aadd83 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -447,9 +447,7 @@ static inline void pci_write_bits32(struct pci_dev *pdev, int offset,
 
 #endif				/* CONFIG_PCI */
 
-struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
-				   unsigned nr_chans, int edac_index);
-struct mem_ctl_info *new_edac_mc_alloc(unsigned edac_index,
+struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 				   unsigned n_layers,
 				   struct edac_mc_layer *layers,
 				   bool rev_order,
@@ -461,18 +459,6 @@ extern struct mem_ctl_info *find_mci_by_dev(struct device *dev);
 extern struct mem_ctl_info *edac_mc_del_mc(struct device *dev);
 extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,
 				      unsigned long page);
-
-/*
- * The no info errors are used when error overflows are reported.
- * There are a limited number of error logging registers that can
- * be exausted.  When all registers are exhausted and an additional
- * error occurs then an error overflow register records that an
- * error occurred and the type of error, but doesn't have any
- * further information.  The ce/ue versions make for cleaner
- * reporting logic and function interface - reduces conditional
- * statement clutter and extra function arguments.
- */
-
 void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			  struct mem_ctl_info *mci,
 			  const unsigned long page_frame_number,
@@ -485,68 +471,6 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			  const char *other_detail,
 			  const void *mcelog);
 
-static inline void edac_mc_handle_ce(struct mem_ctl_info *mci,
-			      unsigned long page_frame_number,
-			      unsigned long offset_in_page,
-			      unsigned long syndrome, int row, int channel,
-			      const char *msg)
-{
-	 edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
-			      page_frame_number, offset_in_page, syndrome,
-		              row, channel, -1, msg, NULL, NULL);
-}
-
-static inline void edac_mc_handle_ce_no_info(struct mem_ctl_info *mci,
-				      const char *msg)
-{
-	 edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
-			      0, 0, 0, -1, -1, -1, msg, NULL, NULL);
-}
-
-static inline void edac_mc_handle_ue(struct mem_ctl_info *mci,
-			      unsigned long page_frame_number,
-			      unsigned long offset_in_page, int row,
-			      const char *msg)
-{
-	 edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
-			      page_frame_number, offset_in_page, 0,
-		              row, -1, -1, msg, NULL, NULL);
-}
-
-static inline void edac_mc_handle_ue_no_info(struct mem_ctl_info *mci,
-				      const char *msg)
-{
-	 edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
-			      0, 0, 0, -1, -1, -1, msg, NULL, NULL);
-}
-
-static inline void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
-					 unsigned int csrow,
-					 unsigned int channel0,
-					 unsigned int channel1,
-					 char *msg)
-{
-	/*
-	 *FIXME: The error can also be at channel1 (e. g. at the second
-	 *	  channel of the same branch). The fix is to push
-	 *	  edac_mc_handle_error() call into each driver
-	 */
-	 edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
-			      0, 0, 0,
-		              csrow, channel0, -1, msg, NULL, NULL);
-}
-
-static inline void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
-					 unsigned int csrow,
-					 unsigned int channel, char *msg)
-{
-	 edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
-			      0, 0, 0,
-		              csrow, channel, -1, msg, NULL, NULL);
-}
-
-
-
 /*
  * edac_device APIs
  */
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index f231c54..f5be026 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -189,7 +189,7 @@ void *edac_align_ptr(void **p, unsigned size, int quant)
  *	NULL allocation failed
  *	struct mem_ctl_info pointer
  */
-struct mem_ctl_info *new_edac_mc_alloc(unsigned edac_index,
+struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 				   unsigned n_layers,
 				   struct edac_mc_layer *layers,
 				   bool rev_order,
@@ -370,57 +370,6 @@ struct mem_ctl_info *new_edac_mc_alloc(unsigned edac_index,
 	 */
 	return mci;
 }
-EXPORT_SYMBOL_GPL(new_edac_mc_alloc);
-
-/**
- * edac_mc_alloc: Allocate and partially fills a struct mem_ctl_info structure
- * @edac_index:		Memory controller number
- * @n_layers:		Nu
-mber of layers at the MC hierarchy
- * layers:		Describes each layer as seen by the Memory Controller
- * @rev_order:		Fills csrows/cs channels at the reverse order
- * @size_pvt:		size of private storage needed
- *
- *
- * FIXME: drivers handle multi-rank memories on different ways: on some
- * drivers, one multi-rank memory is mapped as one DIMM, while, on others,
- * a single multi-rank DIMM would be mapped into several "dimms".
- *
- * Non-csrow based drivers (like FB-DIMM and RAMBUS ones) will likely report
- * such DIMMS properly, but the CSROWS-based ones will likely do the wrong
- * thing, as two chip select values are used for dual-rank memories (and 4, for
- * quad-rank ones). I suspect that this issue could be solved inside the EDAC
- * core for SDRAM memories, but it requires further study at JEDEC JESD 21C.
- *
- * In summary, solving this issue is not easy, as it requires a lot of testing.
- *
- * Everything is kmalloc'ed as one big chunk - more efficient.
- * Only can be used if all structures have the same lifetime - otherwise
- * you have to allocate and initialize your own structures.
- *
- * Use edac_mc_free() to free mc structures allocated by this function.
- *
- * Returns:
- *	NULL allocation failed
- *	struct mem_ctl_info pointer
- */
-
-struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
-				   unsigned nr_chans, int edac_index)
-{
-	unsigned n_layers = 2;
-	struct edac_mc_layer layers[n_layers];
-
-	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
-	layers[0].size = nr_csrows;
-	layers[0].is_csrow = true;
-	layers[1].type = EDAC_MC_LAYER_CHANNEL;
-	layers[1].size = nr_chans;
-	layers[1].is_csrow = false;
-
-	return new_edac_mc_alloc(edac_index, ARRAY_SIZE(layers), layers,
-			  false, sz_pvt);
-}
 EXPORT_SYMBOL_GPL(edac_mc_alloc);
 
 /**
diff --git a/drivers/edac/i3000_edac.c b/drivers/edac/i3000_edac.c
index 9b2c561..2032d198 100644
--- a/drivers/edac/i3000_edac.c
+++ b/drivers/edac/i3000_edac.c
@@ -362,7 +362,7 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = nr_channels;
 	layers[1].is_csrow = false;
-	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
 	if (!mci)
 		return -ENOMEM;
 
diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index c926ff0..9a35487 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -347,7 +347,7 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = nr_channels;
 	layers[1].is_csrow = false;
-	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
 			    false, sizeof(struct i3200_priv));
 	if (!mci)
 		return -ENOMEM;
diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index 18b2532..1691cdd 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -1396,7 +1396,7 @@ static int i5000_probe1(struct pci_dev *pdev, int dev_idx)
 	layers[2].type = EDAC_MC_LAYER_SLOT;
 	layers[2].size = num_dimms_per_channel;
 	layers[2].is_csrow = true;
-	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
 
 	if (mci == NULL)
 		return -ENOMEM;
diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index ec5de18..fda60f8 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -936,7 +936,7 @@ static int __devinit i5100_init_one(struct pci_dev *pdev,
 	layers[1].type = EDAC_MC_LAYER_SLOT;
 	layers[1].size = ranksperch;
 	layers[1].is_csrow = true;
-	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
 			    false, sizeof(*priv));
 	if (!mci) {
 		ret = -ENOMEM;
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 029c557..3aa2a1e 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -1280,7 +1280,7 @@ static int i5400_probe1(struct pci_dev *pdev, int dev_idx)
 	layers[2].type = EDAC_MC_LAYER_SLOT;
 	layers[2].size = DIMMS_PER_CHANNEL;
 	layers[2].is_csrow = true;
-	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
 
 	if (mci == NULL)
 		return -ENOMEM;
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 6e762f5..0ff0b26 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -1054,7 +1054,7 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
 	layers[2].type = EDAC_MC_LAYER_SLOT;
 	layers[2].size = MAX_SLOTS;
 	layers[2].is_csrow = true;
-	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
 
 	if (mci == NULL)
 		return -ENOMEM;
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 8bcee03..72553dd 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -2147,7 +2147,7 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 	layers[1].type = EDAC_MC_LAYER_SLOT;
 	layers[1].size = MAX_DIMMS;
 	layers[1].is_csrow = true;
-	mci = new_edac_mc_alloc(i7core_dev->socket, ARRAY_SIZE(layers), layers,
+	mci = edac_mc_alloc(i7core_dev->socket, ARRAY_SIZE(layers), layers,
 			    false, sizeof(*pvt));
 	if (unlikely(!mci))
 		return -ENOMEM;
diff --git a/drivers/edac/i82443bxgx_edac.c b/drivers/edac/i82443bxgx_edac.c
index 00aa186..23a0b5d 100644
--- a/drivers/edac/i82443bxgx_edac.c
+++ b/drivers/edac/i82443bxgx_edac.c
@@ -255,7 +255,7 @@ static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = I82443BXGX_NR_CHANS;
 	layers[1].is_csrow = false;
-	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
 	if (mci == NULL)
 		return -ENOMEM;
 
diff --git a/drivers/edac/i82860_edac.c b/drivers/edac/i82860_edac.c
index 26d91ba..b49b3b5 100644
--- a/drivers/edac/i82860_edac.c
+++ b/drivers/edac/i82860_edac.c
@@ -206,7 +206,7 @@ static int i82860_probe1(struct pci_dev *pdev, int dev_idx)
 	layers[1].type = EDAC_MC_LAYER_SLOT;
 	layers[1].size = 8;
 	layers[1].is_csrow = true;
-	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
 	if (!mci)
 		return -ENOMEM;
 
diff --git a/drivers/edac/i82875p_edac.c b/drivers/edac/i82875p_edac.c
index 4259c4a..c2c82c3 100644
--- a/drivers/edac/i82875p_edac.c
+++ b/drivers/edac/i82875p_edac.c
@@ -420,7 +420,7 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = nr_chans;
 	layers[1].is_csrow = false;
-	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
 	if (!mci) {
 		rc = -ENOMEM;
 		goto fail0;
diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index bfd632c..c7db489 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -555,7 +555,7 @@ static int i82975x_probe1(struct pci_dev *pdev, int dev_idx)
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = I82975X_NR_CSROWS(chans);
 	layers[1].is_csrow = false;
-	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
 	if (!mci) {
 		rc = -ENOMEM;
 		goto fail1;
diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 87a9baa..a7f1ff1 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -980,7 +980,7 @@ static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = 1;
 	layers[1].is_csrow = false;
-	mci = new_edac_mc_alloc(edac_mc_idx, ARRAY_SIZE(layers), layers, false,
+	mci = edac_mc_alloc(edac_mc_idx, ARRAY_SIZE(layers), layers, false,
 			    sizeof(*pdata));
 	if (!mci) {
 		devres_release_group(&op->dev, mpc85xx_mc_err_probe);
diff --git a/drivers/edac/mv64x60_edac.c b/drivers/edac/mv64x60_edac.c
index f294da7..a32e9b6 100644
--- a/drivers/edac/mv64x60_edac.c
+++ b/drivers/edac/mv64x60_edac.c
@@ -715,7 +715,7 @@ static int __devinit mv64x60_mc_err_probe(struct platform_device *pdev)
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = 1;
 	layers[1].is_csrow = false;
-	mci = new_edac_mc_alloc(edac_mc_idx, ARRAY_SIZE(layers), layers, false,
+	mci = edac_mc_alloc(edac_mc_idx, ARRAY_SIZE(layers), layers, false,
 			    sizeof(struct mv64x60_mc_pdata));
 	if (!mci) {
 		printk(KERN_ERR "%s: No memory for CPU err\n", __func__);
diff --git a/drivers/edac/pasemi_edac.c b/drivers/edac/pasemi_edac.c
index addf893..caf17c8 100644
--- a/drivers/edac/pasemi_edac.c
+++ b/drivers/edac/pasemi_edac.c
@@ -215,7 +215,7 @@ static int __devinit pasemi_edac_probe(struct pci_dev *pdev,
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = PASEMI_EDAC_NR_CHANS;
 	layers[1].is_csrow = false;
-	mci = new_edac_mc_alloc(system_mmc_id++, ARRAY_SIZE(layers), layers, false,
+	mci = edac_mc_alloc(system_mmc_id++, ARRAY_SIZE(layers), layers, false,
 			    0);
 	if (mci == NULL)
 		return -ENOMEM;
diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index 482161e..89e3147 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -1291,7 +1291,7 @@ static int __devinit ppc4xx_edac_probe(struct platform_device *op)
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = ppc4xx_edac_nr_chans;
 	layers[1].is_csrow = false;
-	mci = new_edac_mc_alloc(ppc4xx_edac_instance, ARRAY_SIZE(layers), layers,
+	mci = edac_mc_alloc(ppc4xx_edac_instance, ARRAY_SIZE(layers), layers,
 			    false, sizeof(struct ppc4xx_edac_pdata));
 	if (mci == NULL) {
 		ppc4xx_edac_printk(KERN_ERR, "%s: "
diff --git a/drivers/edac/r82600_edac.c b/drivers/edac/r82600_edac.c
index ca64939..fe060db 100644
--- a/drivers/edac/r82600_edac.c
+++ b/drivers/edac/r82600_edac.c
@@ -291,7 +291,7 @@ static int r82600_probe1(struct pci_dev *pdev, int dev_idx)
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = R82600_NR_CHANS;
 	layers[1].is_csrow = false;
-	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
 	if (mci == NULL)
 		return -ENOMEM;
 
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index dc6a306..b253675 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1640,7 +1640,7 @@ static int sbridge_register_mci(struct sbridge_dev *sbridge_dev)
 	layers[1].type = EDAC_MC_LAYER_SLOT;
 	layers[1].size = MAX_DIMMS;
 	layers[1].is_csrow = true;
-	mci = new_edac_mc_alloc(sbridge_dev->mc, ARRAY_SIZE(layers), layers,
+	mci = edac_mc_alloc(sbridge_dev->mc, ARRAY_SIZE(layers), layers,
 			    false, sizeof(*pvt));
 
 	if (unlikely(!mci))
diff --git a/drivers/edac/tile_edac.c b/drivers/edac/tile_edac.c
index 0e4d628..3e878bf 100644
--- a/drivers/edac/tile_edac.c
+++ b/drivers/edac/tile_edac.c
@@ -141,7 +141,7 @@ static int __devinit tile_edac_mc_probe(struct platform_device *pdev)
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = TILE_EDAC_NR_CHANS;
 	layers[1].is_csrow = false;
-	mci = new_edac_mc_alloc(pdev->id, ARRAY_SIZE(layers), layers, false,
+	mci = edac_mc_alloc(pdev->id, ARRAY_SIZE(layers), layers, false,
 			    sizeof(struct tile_edac_priv));
 	if (mci == NULL)
 		return -ENOMEM;
diff --git a/drivers/edac/x38_edac.c b/drivers/edac/x38_edac.c
index f715269..996d548 100644
--- a/drivers/edac/x38_edac.c
+++ b/drivers/edac/x38_edac.c
@@ -348,7 +348,7 @@ static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = x38_channel_num;
 	layers[1].is_csrow = false;
-	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
 	if (!mci)
 		return -ENOMEM;
 
-- 
1.7.8

