Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab1DASE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 14:04:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37979 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755089Ab1DASEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 14:04:22 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 5/9] gma500: prune more unused fields
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 01 Apr 2011 18:41:40 +0100
Message-ID: <20110401174135.18112.12122.stgit@localhost.localdomain>
In-Reply-To: <20110401173554.18112.67483.stgit@localhost.localdomain>
References: <20110401173554.18112.67483.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_drv.c |   13 ----
 drivers/staging/gma500/psb_drv.h |  134 --------------------------------------
 2 files changed, 0 insertions(+), 147 deletions(-)

diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 0262977..518b0fb 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -181,11 +181,6 @@ static struct drm_ioctl_desc psb_ioctls[] = {
 
 };
 
-static void psb_set_uopt(struct drm_psb_uopt *uopt)
-{
-	return;
-}
-
 static void psb_lastclose(struct drm_device *dev)
 {
 	return;
@@ -589,16 +584,8 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 
 	dev_priv->dev = dev;
 
-	mutex_init(&dev_priv->temp_mem);
-	mutex_init(&dev_priv->cmdbuf_mutex);
-	mutex_init(&dev_priv->reset_mutex);
-	spin_lock_init(&dev_priv->reloc_lock);
-
-	DRM_INIT_WAITQUEUE(&dev_priv->rel_mapped_queue);
-
 	dev->dev_private = (void *) dev_priv;
 	dev_priv->chipset = chipset;
-	psb_set_uopt(&dev_priv->uopt);
 
 	PSB_DEBUG_INIT("Mapping MMIO\n");
 	resource_start = pci_resource_start(dev->pdev, PSB_MMIO_RESOURCE);
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 8c1eceb..7d07c97 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -228,28 +228,11 @@ struct psb_intel_opregion {
 	int enabled;
 };
 
-/*
- *User options.
- */
-
-struct drm_psb_uopt {
-	int pad; /*keep it here in case we use it in future*/
-};
-
 struct drm_psb_private {
-	/*
-	 * DSI info.
-	 */
-	void * dbi_dsr_info;
-	void * dsi_configs[2];
-
 	struct drm_device *dev;
-	struct vm_operations_struct *ttm_vm_ops;
 
 	unsigned long chipset;
 
-	struct drm_psb_uopt uopt;
-
 	struct psb_gtt *pg;
 
 	/*GTT Memory manager*/
@@ -270,7 +253,6 @@ struct drm_psb_private {
 
 	uint32_t vdc_irq_mask;
 	uint32_t pipestat[PSB_NUM_PIPE];
-	bool vblanksEnabledForFlips;
 
 	spinlock_t irqmask_lock;
 
@@ -287,23 +269,6 @@ struct drm_psb_private {
 	 *Memory managers
 	 */
 
-	int have_tt;
-	int have_mem_mmu;
-	struct mutex temp_mem;
-
-	/*
-	 *Relocation buffer mapping.
-	 */
-
-	spinlock_t reloc_lock;
-	unsigned int rel_mapped_pages;
-	wait_queue_head_t rel_mapped_queue;
-
-	/*
-	 *SAREA
-	 */
-	struct drm_psb_sarea *sarea_priv;
-
 	/*
 	*OSPM info
 	*/
@@ -468,92 +433,11 @@ struct drm_psb_private {
 	uint32_t saveOVC_OGAMC4;
 	uint32_t saveOVC_OGAMC5;
 
-	/*
-	 * extra MDFLD Register state
-	 */
-	uint32_t saveHDMIPHYMISCCTL;
-	uint32_t saveHDMIB_CONTROL;
-	uint32_t saveDSPCCNTR;
-	uint32_t savePIPECCONF;
-	uint32_t savePIPECSRC;
-	uint32_t saveHTOTAL_C;
-	uint32_t saveHBLANK_C;
-	uint32_t saveHSYNC_C;
-	uint32_t saveVTOTAL_C;
-	uint32_t saveVBLANK_C;
-	uint32_t saveVSYNC_C;
-	uint32_t saveDSPCSTRIDE;
-	uint32_t saveDSPCSIZE;
-	uint32_t saveDSPCPOS;
-	uint32_t saveDSPCSURF;
-	uint32_t saveDSPCLINOFF;
-	uint32_t saveDSPCTILEOFF;
-	uint32_t saveDSPCCURSOR_CTRL;
-	uint32_t saveDSPCCURSOR_BASE;
-	uint32_t saveDSPCCURSOR_POS;
-	uint32_t save_palette_c[256];
-	uint32_t saveOV_OVADD_C;
-	uint32_t saveOV_OGAMC0_C;
-	uint32_t saveOV_OGAMC1_C;
-	uint32_t saveOV_OGAMC2_C;
-	uint32_t saveOV_OGAMC3_C;
-	uint32_t saveOV_OGAMC4_C;
-	uint32_t saveOV_OGAMC5_C;
-
-	/* DSI reg save */
-	uint32_t saveDEVICE_READY_REG;
-	uint32_t saveINTR_EN_REG;
-	uint32_t saveDSI_FUNC_PRG_REG;
-	uint32_t saveHS_TX_TIMEOUT_REG;
-	uint32_t saveLP_RX_TIMEOUT_REG;
-	uint32_t saveTURN_AROUND_TIMEOUT_REG;
-	uint32_t saveDEVICE_RESET_REG;
-	uint32_t saveDPI_RESOLUTION_REG;
-	uint32_t saveHORIZ_SYNC_PAD_COUNT_REG;
-	uint32_t saveHORIZ_BACK_PORCH_COUNT_REG;
-	uint32_t saveHORIZ_FRONT_PORCH_COUNT_REG;
-	uint32_t saveHORIZ_ACTIVE_AREA_COUNT_REG;
-	uint32_t saveVERT_SYNC_PAD_COUNT_REG;
-	uint32_t saveVERT_BACK_PORCH_COUNT_REG;
-	uint32_t saveVERT_FRONT_PORCH_COUNT_REG;
-	uint32_t saveHIGH_LOW_SWITCH_COUNT_REG;
-	uint32_t saveINIT_COUNT_REG;
-	uint32_t saveMAX_RET_PAK_REG;
-	uint32_t saveVIDEO_FMT_REG;
-	uint32_t saveEOT_DISABLE_REG;
-	uint32_t saveLP_BYTECLK_REG;
-	uint32_t saveHS_LS_DBI_ENABLE_REG;
-	uint32_t saveTXCLKESC_REG;
-	uint32_t saveDPHY_PARAM_REG;
-	uint32_t saveMIPI_CONTROL_REG;
-	uint32_t saveMIPI;
-	uint32_t saveMIPI_C;
-	void (*init_drvIC)(struct drm_device *dev);
-	void (*dsi_prePowerState)(struct drm_device *dev);
-	void (*dsi_postPowerState)(struct drm_device *dev);
-
-	/* DPST Register Save */
-	uint32_t saveHISTOGRAM_INT_CONTROL_REG;
-	uint32_t saveHISTOGRAM_LOGIC_CONTROL_REG;
-	uint32_t savePWM_CONTROL_LOGIC;
-
 	/* MSI reg save */
-
 	uint32_t msi_addr;
 	uint32_t msi_data;
 
 	/*
-	 *Scheduling.
-	 */
-
-	struct mutex reset_mutex;
-	struct mutex cmdbuf_mutex;
-	/*uint32_t ta_mem_pages;
-	struct psb_ta_mem *ta_mem;
-	int force_ta_mem_load;*/
-	atomic_t val_seq;
-
-	/*
 	 * LID-Switch
 	 */
 	spinlock_t lid_lock;
@@ -566,8 +450,6 @@ struct drm_psb_private {
 	 *Watchdog
 	 */
 
-	int timer_available;
-
 	uint32_t apm_reg;
 	uint16_t apm_base;
 
@@ -583,27 +465,11 @@ struct drm_psb_private {
 };
 
 
-struct psb_file_data {	/* TODO: Audit this, remove the indirection and set
-			   it up properly in open/postclose  ACFIXME */
-	void *priv;
-};
-
-struct psb_fpriv {
-	struct ttm_object_file *tfile;
-};
-
 struct psb_mmu_driver;
 
 extern int drm_crtc_probe_output_modes(struct drm_device *dev, int, int);
 extern int drm_pick_crtcs(struct drm_device *dev);
 
-static inline struct psb_fpriv *psb_fpriv(struct drm_file *file_priv)
-{
-	struct psb_file_data *pvr_file_priv
-			= (struct psb_file_data *)file_priv->driver_priv;
-	return (struct psb_fpriv *) pvr_file_priv->priv;
-}
-
 static inline struct drm_psb_private *psb_priv(struct drm_device *dev)
 {
 	return (struct drm_psb_private *) dev->dev_private;

