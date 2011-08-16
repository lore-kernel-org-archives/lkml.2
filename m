Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab1HPTfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 15:35:05 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55544 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab1HPTfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 15:35:00 -0400
From: Akshay Joshi <me@akshayjoshi.com>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Akshay Joshi <me@akshayjoshi.com>
Subject: [PATCH] Drivers: i915: Fix all space related issues.
Date: Tue, 16 Aug 2011 15:34:10 -0400
Message-Id: <1313523255-13629-1-git-send-email-me@akshayjoshi.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various issues involved with the space character were generating
warnings in the checkpatch.pl file. This patch removes most of those
warnings.

Signed-off-by: Akshay Joshi <me@akshayjoshi.com>
---
 drivers/gpu/drm/i915/dvo_ch7017.c       |    2 +-
 drivers/gpu/drm/i915/dvo_ch7xxx.c       |    4 +-
 drivers/gpu/drm/i915/dvo_ivch.c         |    6 +-
 drivers/gpu/drm/i915/dvo_sil164.c       |    2 +-
 drivers/gpu/drm/i915/dvo_tfp410.c       |   14 +-
 drivers/gpu/drm/i915/i915_debugfs.c     |   38 +-
 drivers/gpu/drm/i915/i915_dma.c         |   44 ++--
 drivers/gpu/drm/i915/i915_drv.c         |   16 +-
 drivers/gpu/drm/i915/i915_drv.h         |   70 ++--
 drivers/gpu/drm/i915/i915_gem.c         |   12 +-
 drivers/gpu/drm/i915/i915_gem_debug.c   |    2 +-
 drivers/gpu/drm/i915/i915_gem_evict.c   |    2 +-
 drivers/gpu/drm/i915/i915_irq.c         |    6 +-
 drivers/gpu/drm/i915/i915_mem.c         |   14 +-
 drivers/gpu/drm/i915/i915_reg.h         |    8 +-
 drivers/gpu/drm/i915/i915_suspend.c     |    8 +-
 drivers/gpu/drm/i915/i915_trace.h       |   46 ++--
 drivers/gpu/drm/i915/intel_acpi.c       |    2 +-
 drivers/gpu/drm/i915/intel_bios.c       |    4 +-
 drivers/gpu/drm/i915/intel_bios.h       |    2 +-
 drivers/gpu/drm/i915/intel_crt.c        |    2 +-
 drivers/gpu/drm/i915/intel_display.c    |  222 ++++++------
 drivers/gpu/drm/i915/intel_dp.c         |   26 +-
 drivers/gpu/drm/i915/intel_drv.h        |   12 +-
 drivers/gpu/drm/i915/intel_opregion.c   |   90 +++---
 drivers/gpu/drm/i915/intel_overlay.c    |  146 ++++----
 drivers/gpu/drm/i915/intel_panel.c      |    6 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c |   76 ++--
 drivers/gpu/drm/i915/intel_ringbuffer.h |    8 +-
 drivers/gpu/drm/i915/intel_sdvo.c       |  228 +++++++-------
 drivers/gpu/drm/i915/intel_sdvo_regs.h  |  558 +++++++++++++++---------------
 drivers/gpu/drm/i915/intel_tv.c         |   58 ++--
 32 files changed, 867 insertions(+), 867 deletions(-)

diff --git a/drivers/gpu/drm/i915/dvo_ch7017.c b/drivers/gpu/drm/i915/dvo_ch7017.c
index d3e8c54..1ca799a 100644
--- a/drivers/gpu/drm/i915/dvo_ch7017.c
+++ b/drivers/gpu/drm/i915/dvo_ch7017.c
@@ -227,7 +227,7 @@ static bool ch7017_init(struct intel_dvo_device *dvo,
 	default:
 		DRM_DEBUG_KMS("ch701x not detected, got %d: from %s "
 			      "slave %d.\n",
-			      val, adapter->name,dvo->slave_addr);
+			      val, adapter->name, dvo->slave_addr);
 		goto fail;
 	}
 
diff --git a/drivers/gpu/drm/i915/dvo_ch7xxx.c b/drivers/gpu/drm/i915/dvo_ch7xxx.c
index 7eaa94e..4a03660 100644
--- a/drivers/gpu/drm/i915/dvo_ch7xxx.c
+++ b/drivers/gpu/drm/i915/dvo_ch7xxx.c
@@ -111,7 +111,7 @@ static char *ch7xxx_get_id(uint8_t vid)
 /** Reads an 8 bit register */
 static bool ch7xxx_readb(struct intel_dvo_device *dvo, int addr, uint8_t *ch)
 {
-	struct ch7xxx_priv *ch7xxx= dvo->dev_priv;
+	struct ch7xxx_priv *ch7xxx = dvo->dev_priv;
 	struct i2c_adapter *adapter = dvo->i2c_bus;
 	u8 out_buf[2];
 	u8 in_buf[2];
@@ -303,7 +303,7 @@ static void ch7xxx_dump_regs(struct intel_dvo_device *dvo)
 
 	for (i = 0; i < CH7xxx_NUM_REGS; i++) {
 		uint8_t val;
-		if ((i % 8) == 0 )
+		if ((i % 8) == 0)
 			DRM_LOG_KMS("\n %02X: ", i);
 		ch7xxx_readb(dvo, i, &val);
 		DRM_LOG_KMS("%02X ", val);
diff --git a/drivers/gpu/drm/i915/dvo_ivch.c b/drivers/gpu/drm/i915/dvo_ivch.c
index a12ed94..04f2893 100644
--- a/drivers/gpu/drm/i915/dvo_ivch.c
+++ b/drivers/gpu/drm/i915/dvo_ivch.c
@@ -344,8 +344,8 @@ static void ivch_mode_set(struct intel_dvo_device *dvo,
 			   (adjusted_mode->hdisplay - 1)) >> 2;
 		y_ratio = (((mode->vdisplay - 1) << 16) /
 			   (adjusted_mode->vdisplay - 1)) >> 2;
-		ivch_write (dvo, VR42, x_ratio);
-		ivch_write (dvo, VR41, y_ratio);
+		ivch_write(dvo, VR42, x_ratio);
+		ivch_write(dvo, VR41, y_ratio);
 	} else {
 		vr01 &= ~VR01_PANEL_FIT_ENABLE;
 		vr40 &= ~VR40_CLOCK_GATING_ENABLE;
@@ -410,7 +410,7 @@ static void ivch_destroy(struct intel_dvo_device *dvo)
 	}
 }
 
-struct intel_dvo_dev_ops ivch_ops= {
+struct intel_dvo_dev_ops ivch_ops = {
 	.init = ivch_init,
 	.dpms = ivch_dpms,
 	.mode_valid = ivch_mode_valid,
diff --git a/drivers/gpu/drm/i915/dvo_sil164.c b/drivers/gpu/drm/i915/dvo_sil164.c
index e4b4091..a0b13a6 100644
--- a/drivers/gpu/drm/i915/dvo_sil164.c
+++ b/drivers/gpu/drm/i915/dvo_sil164.c
@@ -104,7 +104,7 @@ static bool sil164_readb(struct intel_dvo_device *dvo, int addr, uint8_t *ch)
 
 static bool sil164_writeb(struct intel_dvo_device *dvo, int addr, uint8_t ch)
 {
-	struct sil164_priv *sil= dvo->dev_priv;
+	struct sil164_priv *sil = dvo->dev_priv;
 	struct i2c_adapter *adapter = dvo->i2c_bus;
 	uint8_t out_buf[2];
 	struct i2c_msg msg = {
diff --git a/drivers/gpu/drm/i915/dvo_tfp410.c b/drivers/gpu/drm/i915/dvo_tfp410.c
index 8ab2855..aa2cd3e 100644
--- a/drivers/gpu/drm/i915/dvo_tfp410.c
+++ b/drivers/gpu/drm/i915/dvo_tfp410.c
@@ -56,7 +56,7 @@
 #define TFP410_CTL_2_MDI	(1<<0)
 
 #define TFP410_CTL_3		0x0A
-#define TFP410_CTL_3_DK_MASK 	(0x7<<5)
+#define TFP410_CTL_3_DK_MASK	(0x7<<5)
 #define TFP410_CTL_3_DK		(1<<5)
 #define TFP410_CTL_3_DKEN	(1<<4)
 #define TFP410_CTL_3_CTL_MASK	(0x7<<1)
@@ -225,12 +225,12 @@ static void tfp410_mode_set(struct intel_dvo_device *dvo,
 			    struct drm_display_mode *mode,
 			    struct drm_display_mode *adjusted_mode)
 {
-    /* As long as the basics are set up, since we don't have clock dependencies
-     * in the mode setup, we can just leave the registers alone and everything
-     * will work fine.
-     */
-    /* don't do much */
-    return;
+	/* As long as the basics are set up, since we don't have clock dependencies
+	* in the mode setup, we can just leave the registers alone and everything
+	* will work fine.
+	*/
+	/* don't do much */
+	return;
 }
 
 /* set the tfp410 power state */
diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index 3c395a5..8e95d66 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -98,12 +98,12 @@ static const char *get_pin_flag(struct drm_i915_gem_object *obj)
 
 static const char *get_tiling_flag(struct drm_i915_gem_object *obj)
 {
-    switch (obj->tiling_mode) {
-    default:
-    case I915_TILING_NONE: return " ";
-    case I915_TILING_X: return "X";
-    case I915_TILING_Y: return "Y";
-    }
+	switch (obj->tiling_mode) {
+	default:
+	case I915_TILING_NONE: return " ";
+	case I915_TILING_X: return "X";
+	case I915_TILING_Y: return "Y";
+	}
 }
 
 static const char *cache_level_str(int type)
@@ -217,7 +217,7 @@ static int i915_gem_object_list_info(struct seq_file *m, void *data)
 			++mappable_count; \
 		} \
 	} \
-} while(0)
+} while (0)
 
 static int i915_gem_object_info(struct seq_file *m, void* data)
 {
@@ -1293,12 +1293,12 @@ i915_wedged_read(struct file *filp,
 	char buf[80];
 	int len;
 
-	len = snprintf(buf, sizeof (buf),
+	len = snprintf(buf, sizeof(buf),
 		       "wedged :  %d\n",
 		       atomic_read(&dev_priv->mm.wedged));
 
-	if (len > sizeof (buf))
-		len = sizeof (buf);
+	if (len > sizeof(buf))
+		len = sizeof(buf);
 
 	return simple_read_from_buffer(ubuf, max, ppos, buf, len);
 }
@@ -1314,7 +1314,7 @@ i915_wedged_write(struct file *filp,
 	int val = 1;
 
 	if (cnt > 0) {
-		if (cnt > sizeof (buf) - 1)
+		if (cnt > sizeof(buf) - 1)
 			return -EINVAL;
 
 		if (copy_from_user(buf, ubuf, cnt))
@@ -1357,11 +1357,11 @@ i915_max_freq_read(struct file *filp,
 	char buf[80];
 	int len;
 
-	len = snprintf(buf, sizeof (buf),
+	len = snprintf(buf, sizeof(buf),
 		       "max freq: %d\n", dev_priv->max_delay * 50);
 
-	if (len > sizeof (buf))
-		len = sizeof (buf);
+	if (len > sizeof(buf))
+		len = sizeof(buf);
 
 	return simple_read_from_buffer(ubuf, max, ppos, buf, len);
 }
@@ -1378,7 +1378,7 @@ i915_max_freq_write(struct file *filp,
 	int val = 1;
 
 	if (cnt > 0) {
-		if (cnt > sizeof (buf) - 1)
+		if (cnt > sizeof(buf) - 1)
 			return -EINVAL;
 
 		if (copy_from_user(buf, ubuf, cnt))
@@ -1432,12 +1432,12 @@ i915_cache_sharing_read(struct file *filp,
 	snpcr = I915_READ(GEN6_MBCUNIT_SNPCR);
 	mutex_unlock(&dev_priv->dev->struct_mutex);
 
-	len = snprintf(buf, sizeof (buf),
+	len = snprintf(buf, sizeof(buf),
 		       "%d\n", (snpcr & GEN6_MBC_SNPCR_MASK) >>
 		       GEN6_MBC_SNPCR_SHIFT);
 
-	if (len > sizeof (buf))
-		len = sizeof (buf);
+	if (len > sizeof(buf))
+		len = sizeof(buf);
 
 	return simple_read_from_buffer(ubuf, max, ppos, buf, len);
 }
@@ -1455,7 +1455,7 @@ i915_cache_sharing_write(struct file *filp,
 	int val = 1;
 
 	if (cnt > 0) {
-		if (cnt > sizeof (buf) - 1)
+		if (cnt > sizeof(buf) - 1)
 			return -EINVAL;
 
 		if (copy_from_user(buf, ubuf, cnt))
diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 8a3942c..d76da38 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -884,7 +884,7 @@ static int i915_get_bridge_dev(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
-	dev_priv->bridge_dev = pci_get_bus_and_slot(0, PCI_DEVFN(0,0));
+	dev_priv->bridge_dev = pci_get_bus_and_slot(0, PCI_DEVFN(0, 0));
 	if (!dev_priv->bridge_dev) {
 		DRM_ERROR("bridge device not found\n");
 		return -1;
@@ -1730,10 +1730,10 @@ static DEFINE_SPINLOCK(mchdev_lock);
  */
 unsigned long i915_read_mch_val(void)
 {
-  	struct drm_i915_private *dev_priv;
+	struct drm_i915_private *dev_priv;
 	unsigned long chipset_val, graphics_val, ret = 0;
 
-  	spin_lock(&mchdev_lock);
+	spin_lock(&mchdev_lock);
 	if (!i915_mch_dev)
 		goto out_unlock;
 	dev_priv = i915_mch_dev;
@@ -1744,9 +1744,9 @@ unsigned long i915_read_mch_val(void)
 	ret = chipset_val + graphics_val;
 
 out_unlock:
-  	spin_unlock(&mchdev_lock);
+	spin_unlock(&mchdev_lock);
 
-  	return ret;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(i915_read_mch_val);
 
@@ -1757,10 +1757,10 @@ EXPORT_SYMBOL_GPL(i915_read_mch_val);
  */
 bool i915_gpu_raise(void)
 {
-  	struct drm_i915_private *dev_priv;
+	struct drm_i915_private *dev_priv;
 	bool ret = true;
 
-  	spin_lock(&mchdev_lock);
+	spin_lock(&mchdev_lock);
 	if (!i915_mch_dev) {
 		ret = false;
 		goto out_unlock;
@@ -1771,9 +1771,9 @@ bool i915_gpu_raise(void)
 		dev_priv->max_delay--;
 
 out_unlock:
-  	spin_unlock(&mchdev_lock);
+	spin_unlock(&mchdev_lock);
 
-  	return ret;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(i915_gpu_raise);
 
@@ -1785,10 +1785,10 @@ EXPORT_SYMBOL_GPL(i915_gpu_raise);
  */
 bool i915_gpu_lower(void)
 {
-  	struct drm_i915_private *dev_priv;
+	struct drm_i915_private *dev_priv;
 	bool ret = true;
 
-  	spin_lock(&mchdev_lock);
+	spin_lock(&mchdev_lock);
 	if (!i915_mch_dev) {
 		ret = false;
 		goto out_unlock;
@@ -1799,9 +1799,9 @@ bool i915_gpu_lower(void)
 		dev_priv->max_delay++;
 
 out_unlock:
-  	spin_unlock(&mchdev_lock);
+	spin_unlock(&mchdev_lock);
 
-  	return ret;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(i915_gpu_lower);
 
@@ -1812,10 +1812,10 @@ EXPORT_SYMBOL_GPL(i915_gpu_lower);
  */
 bool i915_gpu_busy(void)
 {
-  	struct drm_i915_private *dev_priv;
+	struct drm_i915_private *dev_priv;
 	bool ret = false;
 
-  	spin_lock(&mchdev_lock);
+	spin_lock(&mchdev_lock);
 	if (!i915_mch_dev)
 		goto out_unlock;
 	dev_priv = i915_mch_dev;
@@ -1823,9 +1823,9 @@ bool i915_gpu_busy(void)
 	ret = dev_priv->busy;
 
 out_unlock:
-  	spin_unlock(&mchdev_lock);
+	spin_unlock(&mchdev_lock);
 
-  	return ret;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(i915_gpu_busy);
 
@@ -1837,10 +1837,10 @@ EXPORT_SYMBOL_GPL(i915_gpu_busy);
  */
 bool i915_gpu_turbo_disable(void)
 {
-  	struct drm_i915_private *dev_priv;
+	struct drm_i915_private *dev_priv;
 	bool ret = true;
 
-  	spin_lock(&mchdev_lock);
+	spin_lock(&mchdev_lock);
 	if (!i915_mch_dev) {
 		ret = false;
 		goto out_unlock;
@@ -1853,9 +1853,9 @@ bool i915_gpu_turbo_disable(void)
 		ret = false;
 
 out_unlock:
-  	spin_unlock(&mchdev_lock);
+	spin_unlock(&mchdev_lock);
 
-  	return ret;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(i915_gpu_turbo_disable);
 
@@ -1948,7 +1948,7 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 
 	agp_size = dev_priv->mm.gtt->gtt_mappable_entries << PAGE_SHIFT;
 
-        dev_priv->mm.gtt_mapping =
+	dev_priv->mm.gtt_mapping =
 		io_mapping_create_wc(dev->agp->base, agp_size);
 	if (dev_priv->mm.gtt_mapping == NULL) {
 		ret = -EIO;
diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index ce045a8..b79c6f1 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -294,7 +294,7 @@ MODULE_DEVICE_TABLE(pci, pciidlist);
 #define INTEL_PCH_CPT_DEVICE_ID_TYPE	0x1c00
 #define INTEL_PCH_PPT_DEVICE_ID_TYPE	0x1e00
 
-void intel_detect_pch (struct drm_device *dev)
+void intel_detect_pch(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct pci_dev *pch;
@@ -377,7 +377,7 @@ void gen6_gt_force_wake_put(struct drm_i915_private *dev_priv)
 
 void __gen6_gt_wait_for_fifo(struct drm_i915_private *dev_priv)
 {
-	if (dev_priv->gt_fifo_count < GT_FIFO_NUM_RESERVED_ENTRIES ) {
+	if (dev_priv->gt_fifo_count < GT_FIFO_NUM_RESERVED_ENTRIES) {
 		int loop = 500;
 		u32 fifo = I915_READ_NOTRACE(GT_FIFO_FREE_ENTRIES);
 		while (fifo <= GT_FIFO_NUM_RESERVED_ENTRIES && loop--) {
@@ -770,12 +770,12 @@ static int i915_pm_poweroff(struct device *dev)
 }
 
 static const struct dev_pm_ops i915_pm_ops = {
-     .suspend = i915_pm_suspend,
-     .resume = i915_pm_resume,
-     .freeze = i915_pm_freeze,
-     .thaw = i915_pm_thaw,
-     .poweroff = i915_pm_poweroff,
-     .restore = i915_pm_resume,
+	.suspend = i915_pm_suspend,
+	.resume = i915_pm_resume,
+	.freeze = i915_pm_freeze,
+	.thaw = i915_pm_thaw,
+	.poweroff = i915_pm_poweroff,
+	.restore = i915_pm_resume,
 };
 
 static struct vm_operations_struct i915_gem_vm_ops = {
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 7916bd9..32de06f 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -226,26 +226,26 @@ struct drm_i915_display_funcs {
 
 struct intel_device_info {
 	u8 gen;
-	u8 is_mobile : 1;
-	u8 is_i85x : 1;
-	u8 is_i915g : 1;
-	u8 is_i945gm : 1;
-	u8 is_g33 : 1;
-	u8 need_gfx_hws : 1;
-	u8 is_g4x : 1;
-	u8 is_pineview : 1;
-	u8 is_broadwater : 1;
-	u8 is_crestline : 1;
-	u8 is_ivybridge : 1;
-	u8 has_fbc : 1;
-	u8 has_pipe_cxsr : 1;
-	u8 has_hotplug : 1;
-	u8 cursor_needs_physical : 1;
-	u8 has_overlay : 1;
-	u8 overlay_needs_physical : 1;
-	u8 supports_tv : 1;
-	u8 has_bsd_ring : 1;
-	u8 has_blt_ring : 1;
+	u8 is_mobile:1;
+	u8 is_i85x:1;
+	u8 is_i915g:1;
+	u8 is_i945gm:1;
+	u8 is_g33:1;
+	u8 need_gfx_hws:1;
+	u8 is_g4x:1;
+	u8 is_pineview:1;
+	u8 is_broadwater:1;
+	u8 is_crestline:1;
+	u8 is_ivybridge:1;
+	u8 has_fbc:1;
+	u8 has_pipe_cxsr:1;
+	u8 has_hotplug:1;
+	u8 cursor_needs_physical:1;
+	u8 has_overlay:1;
+	u8 overlay_needs_physical:1;
+	u8 supports_tv:1;
+	u8 has_bsd_ring:1;
+	u8 has_blt_ring:1;
 };
 
 enum no_fbc_reason {
@@ -759,19 +759,19 @@ struct drm_i915_gem_object {
 	 * (has pending rendering), and is not set if it's on inactive (ready
 	 * to be unbound).
 	 */
-	unsigned int active : 1;
+	unsigned int active:1;
 
 	/**
 	 * This is set if the object has been written to since last bound
 	 * to the GTT
 	 */
-	unsigned int dirty : 1;
+	unsigned int dirty:1;
 
 	/**
 	 * This is set if the object has been written to since the last
 	 * GPU flush.
 	 */
-	unsigned int pending_gpu_write : 1;
+	unsigned int pending_gpu_write:1;
 
 	/**
 	 * Fence register bits (if any) for this object.  Will be set
@@ -780,18 +780,18 @@ struct drm_i915_gem_object {
 	 *
 	 * Size: 4 bits for 16 fences + sign (for FENCE_REG_NONE)
 	 */
-	signed int fence_reg : 5;
+	signed int fence_reg:5;
 
 	/**
 	 * Advice: are the backing pages purgeable?
 	 */
-	unsigned int madv : 2;
+	unsigned int madv:2;
 
 	/**
 	 * Current tiling mode for the object.
 	 */
-	unsigned int tiling_mode : 2;
-	unsigned int tiling_changed : 1;
+	unsigned int tiling_mode:2;
+	unsigned int tiling_changed:1;
 
 	/** How many users have pinned this object in GTT space. The following
 	 * users can each hold at most one reference: pwrite/pread, pin_ioctl
@@ -802,22 +802,22 @@ struct drm_i915_gem_object {
 	 *
 	 * In the worst case this is 1 + 1 + 1 + 2*2 = 7. That would fit into 3
 	 * bits with absolutely no headroom. So use 4 bits. */
-	unsigned int pin_count : 4;
+	unsigned int pin_count:4;
 #define DRM_I915_GEM_OBJECT_MAX_PIN_COUNT 0xf
 
 	/**
 	 * Is the object at the current location in the gtt mappable and
 	 * fenceable? Used to avoid costly recalculations.
 	 */
-	unsigned int map_and_fenceable : 1;
+	unsigned int map_and_fenceable:1;
 
 	/**
 	 * Whether the current gtt mapping needs to be mappable (and isn't just
 	 * mappable by accident). Track pin and fault separate for a more
 	 * accurate mappable working set.
 	 */
-	unsigned int fault_mappable : 1;
-	unsigned int pin_mappable : 1;
+	unsigned int fault_mappable:1;
+	unsigned int pin_mappable:1;
 
 	/*
 	 * Is the GPU currently using a fence to access this buffer,
@@ -1056,7 +1056,7 @@ i915_enable_pipestat(drm_i915_private_t *dev_priv, int pipe, u32 mask);
 void
 i915_disable_pipestat(drm_i915_private_t *dev_priv, int pipe, u32 mask);
 
-void intel_enable_asle (struct drm_device *dev);
+void intel_enable_asle(struct drm_device *dev);
 
 #ifdef CONFIG_DEBUG_FS
 extern void i915_destroy_error_state(struct drm_device *dev);
@@ -1146,7 +1146,7 @@ int i915_gem_dumb_create(struct drm_file *file_priv,
 int i915_gem_mmap_gtt(struct drm_file *file_priv, struct drm_device *dev,
 		      uint32_t handle, uint64_t *offset);
 int i915_gem_dumb_destroy(struct drm_file *file_priv, struct drm_device *dev,
-			  uint32_t handle);			  
+			  uint32_t handle);
 /**
  * Returns true if seq1 is later than seq2.
  */
@@ -1303,8 +1303,8 @@ extern void intel_disable_fbc(struct drm_device *dev);
 extern bool ironlake_set_drps(struct drm_device *dev, u8 val);
 extern void ironlake_enable_rc6(struct drm_device *dev);
 extern void gen6_set_rps(struct drm_device *dev, u8 val);
-extern void intel_detect_pch (struct drm_device *dev);
-extern int intel_trans_dp_port_sel (struct drm_crtc *crtc);
+extern void intel_detect_pch(struct drm_device *dev);
+extern int intel_trans_dp_port_sel(struct drm_crtc *crtc);
 
 /* overlay */
 #ifdef CONFIG_DEBUG_FS
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index a546a71..179642e 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -179,7 +179,7 @@ i915_gem_get_aperture_ioctl(struct drm_device *dev, void *data,
 	mutex_unlock(&dev->struct_mutex);
 
 	args->aper_size = dev_priv->mm.gtt_total;
-	args->aper_available_size = args->aper_size -pinned;
+	args->aper_available_size = args->aper_size - pinned;
 
 	return 0;
 }
@@ -1856,7 +1856,7 @@ void i915_gem_reset(struct drm_device *dev)
 	 * lost bo to the inactive list.
 	 */
 	while (!list_empty(&dev_priv->mm.flushing_list)) {
-		obj= list_first_entry(&dev_priv->mm.flushing_list,
+		obj = list_first_entry(&dev_priv->mm.flushing_list,
 				      struct drm_i915_gem_object,
 				      mm_list);
 
@@ -1922,7 +1922,7 @@ i915_gem_retire_requests_ring(struct intel_ring_buffer *ring)
 	while (!list_empty(&ring->active_list)) {
 		struct drm_i915_gem_object *obj;
 
-		obj= list_first_entry(&ring->active_list,
+		obj = list_first_entry(&ring->active_list,
 				      struct drm_i915_gem_object,
 				      ring_list);
 
@@ -2882,7 +2882,7 @@ i915_gem_object_bind_to_gtt(struct drm_i915_gem_object *obj,
 
 	fenceable =
 		obj->gtt_space->size == fence_size &&
-		(obj->gtt_space->start & (fence_alignment -1)) == 0;
+		(obj->gtt_space->start & (fence_alignment - 1)) == 0;
 
 	mappable =
 		obj->gtt_offset + obj->base.size <= dev_priv->mm.gtt_mappable_end;
@@ -3598,7 +3598,7 @@ i915_gem_busy_ioctl(struct drm_device *dev, void *data,
 			 */
 			request = kzalloc(sizeof(*request), GFP_KERNEL);
 			if (request)
-				ret = i915_add_request(obj->ring, NULL,request);
+				ret = i915_add_request(obj->ring, NULL, request);
 			else
 				ret = -ENOMEM;
 		}
@@ -3623,7 +3623,7 @@ int
 i915_gem_throttle_ioctl(struct drm_device *dev, void *data,
 			struct drm_file *file_priv)
 {
-    return i915_gem_ring_throttle(dev, file_priv);
+	return i915_gem_ring_throttle(dev, file_priv);
 }
 
 int
diff --git a/drivers/gpu/drm/i915/i915_gem_debug.c b/drivers/gpu/drm/i915/i915_gem_debug.c
index 8da1899..ac90875 100644
--- a/drivers/gpu/drm/i915/i915_gem_debug.c
+++ b/drivers/gpu/drm/i915/i915_gem_debug.c
@@ -72,7 +72,7 @@ i915_verify_lists(struct drm_device *dev)
 			break;
 		} else if (!obj->active ||
 			   (obj->base.write_domain & I915_GEM_GPU_DOMAINS) == 0 ||
-			   list_empty(&obj->gpu_write_list)){
+			   list_empty(&obj->gpu_write_list)) {
 			DRM_ERROR("invalid flushing %p (a %d w %x gwl %d)\n",
 				  obj,
 				  obj->active,
diff --git a/drivers/gpu/drm/i915/i915_gem_evict.c b/drivers/gpu/drm/i915/i915_gem_evict.c
index da05a26..ead5d00 100644
--- a/drivers/gpu/drm/i915/i915_gem_evict.c
+++ b/drivers/gpu/drm/i915/i915_gem_evict.c
@@ -122,7 +122,7 @@ i915_gem_evict_something(struct drm_device *dev, int min_size,
 			goto found;
 	}
 	list_for_each_entry(obj, &dev_priv->mm.active_list, mm_list) {
-		if (! obj->base.write_domain || obj->pin_count)
+		if (!obj->base.write_domain || obj->pin_count)
 			continue;
 
 		if (mark_free(obj, &unwind_list))
diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 9cbb0cd..012732b 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -711,7 +711,7 @@ i915_error_object_create(struct drm_i915_private *dev_priv,
 
 	page_count = src->base.size / PAGE_SIZE;
 
-	dst = kmalloc(sizeof(*dst) + page_count * sizeof (u32 *), GFP_ATOMIC);
+	dst = kmalloc(sizeof(*dst) + page_count * sizeof(u32 *), GFP_ATOMIC);
 	if (dst == NULL)
 		return NULL;
 
@@ -1493,7 +1493,7 @@ static int ironlake_enable_vblank(struct drm_device *dev, int pipe)
 
 	spin_lock_irqsave(&dev_priv->irq_lock, irqflags);
 	ironlake_enable_display_irq(dev_priv, (pipe == 0) ?
-				    DE_PIPEA_VBLANK: DE_PIPEB_VBLANK);
+				    DE_PIPEA_VBLANK : DE_PIPEB_VBLANK);
 	spin_unlock_irqrestore(&dev_priv->irq_lock, irqflags);
 
 	return 0;
@@ -1541,7 +1541,7 @@ static void ironlake_disable_vblank(struct drm_device *dev, int pipe)
 
 	spin_lock_irqsave(&dev_priv->irq_lock, irqflags);
 	ironlake_disable_display_irq(dev_priv, (pipe == 0) ?
-				     DE_PIPEA_VBLANK: DE_PIPEB_VBLANK);
+				     DE_PIPEA_VBLANK : DE_PIPEB_VBLANK);
 	spin_unlock_irqrestore(&dev_priv->irq_lock, irqflags);
 }
 
diff --git a/drivers/gpu/drm/i915/i915_mem.c b/drivers/gpu/drm/i915/i915_mem.c
index 83b7b81..cc8f6d4 100644
--- a/drivers/gpu/drm/i915/i915_mem.c
+++ b/drivers/gpu/drm/i915/i915_mem.c
@@ -202,7 +202,7 @@ static int init_heap(struct mem_block **heap, int start, int size)
 	blocks->next = blocks->prev = *heap;
 
 	memset(*heap, 0, sizeof(**heap));
-	(*heap)->file_priv = (struct drm_file *) - 1;
+	(*heap)->file_priv = (struct drm_file *) -1;
 	(*heap)->next = (*heap)->prev = blocks;
 	return 0;
 }
@@ -359,19 +359,19 @@ int i915_mem_init_heap(struct drm_device *dev, void *data,
 	return init_heap(heap, initheap->start, initheap->size);
 }
 
-int i915_mem_destroy_heap( struct drm_device *dev, void *data,
-			   struct drm_file *file_priv )
+int i915_mem_destroy_heap(struct drm_device *dev, void *data,
+			   struct drm_file *file_priv)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	drm_i915_mem_destroy_heap_t *destroyheap = data;
 	struct mem_block **heap;
 
-	if ( !dev_priv ) {
-		DRM_ERROR( "called with no initialization\n" );
+	if (!dev_priv) {
+		DRM_ERROR("called with no initialization\n");
 		return -EINVAL;
 	}
 
-	heap = get_heap( dev_priv, destroyheap->region );
+	heap = get_heap(dev_priv, destroyheap->region);
 	if (!heap) {
 		DRM_ERROR("get_heap failed");
 		return -EFAULT;
@@ -382,6 +382,6 @@ int i915_mem_destroy_heap( struct drm_device *dev, void *data,
 		return -EFAULT;
 	}
 
-	i915_mem_takedown( heap );
+	i915_mem_takedown(heap);
 	return 0;
 }
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 5baaef4..92bd437 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -156,7 +156,7 @@
 #define MI_SUSPEND_FLUSH	MI_INSTR(0x0b, 0)
 #define   MI_SUSPEND_FLUSH_EN	(1<<0)
 #define MI_REPORT_HEAD		MI_INSTR(0x07, 0)
-#define MI_OVERLAY_FLIP		MI_INSTR(0x11,0)
+#define MI_OVERLAY_FLIP		MI_INSTR(0x11, 0)
 #define   MI_OVERLAY_CONTINUE	(0x0<<21)
 #define   MI_OVERLAY_ON		(0x1<<21)
 #define   MI_OVERLAY_OFF	(0x2<<21)
@@ -466,7 +466,7 @@
 
 /* Enables non-sequential data reads through arbiter
  */
-#define   MI_ARB_DUAL_DATA_PHASE_DISABLE       	(1 << 9)
+#define   MI_ARB_DUAL_DATA_PHASE_DISABLE	(1 << 9)
 
 /* Disable FSB snooping of cacheable write cycles from binner/render
  * command stream
@@ -622,7 +622,7 @@
 
 #define ILK_DISPLAY_CHICKEN1	0x42000
 #define   ILK_FBCQ_DIS		(1<<22)
-#define   ILK_PABSTRETCH_DIS 	(1<<21)
+#define	  ILK_PABSTRETCH_DIS	(1<<21)
 
 
 /*
@@ -2354,7 +2354,7 @@
 
 #define DSPFW1			0x70034
 #define   DSPFW_SR_SHIFT	23
-#define   DSPFW_SR_MASK 	(0x1ff<<23)
+#define   DSPFW_SR_MASK		(0x1ff<<23)
 #define   DSPFW_CURSORB_SHIFT	16
 #define   DSPFW_CURSORB_MASK	(0x3f<<16)
 #define   DSPFW_PLANEB_SHIFT	8
diff --git a/drivers/gpu/drm/i915/i915_suspend.c b/drivers/gpu/drm/i915/i915_suspend.c
index f107423..f8f602d 100644
--- a/drivers/gpu/drm/i915/i915_suspend.c
+++ b/drivers/gpu/drm/i915/i915_suspend.c
@@ -60,7 +60,7 @@ static void i915_save_palette(struct drm_device *dev, enum pipe pipe)
 	else
 		array = dev_priv->save_palette_b;
 
-	for(i = 0; i < 256; i++)
+	for (i = 0; i < 256; i++)
 		array[i] = I915_READ(reg + (i << 2));
 }
 
@@ -82,7 +82,7 @@ static void i915_restore_palette(struct drm_device *dev, enum pipe pipe)
 	else
 		array = dev_priv->save_palette_b;
 
-	for(i = 0; i < 256; i++)
+	for (i = 0; i < 256; i++)
 		I915_WRITE(reg + (i << 2), array[i]);
 }
 
@@ -887,10 +887,10 @@ int i915_restore_state(struct drm_device *dev)
 	mutex_lock(&dev->struct_mutex);
 
 	/* Cache mode state */
-	I915_WRITE (CACHE_MODE_0, dev_priv->saveCACHE_MODE_0 | 0xffff0000);
+	I915_WRITE(CACHE_MODE_0, dev_priv->saveCACHE_MODE_0 | 0xffff0000);
 
 	/* Memory arbitration state */
-	I915_WRITE (MI_ARB_STATE, dev_priv->saveMI_ARB_STATE | 0xffff0000);
+	I915_WRITE(MI_ARB_STATE, dev_priv->saveMI_ARB_STATE | 0xffff0000);
 
 	for (i = 0; i < 16; i++) {
 		I915_WRITE(SWF00 + (i << 2), dev_priv->saveSWF0[i]);
diff --git a/drivers/gpu/drm/i915/i915_trace.h b/drivers/gpu/drm/i915/i915_trace.h
index d623fef..dac7bba 100644
--- a/drivers/gpu/drm/i915/i915_trace.h
+++ b/drivers/gpu/drm/i915/i915_trace.h
@@ -385,29 +385,29 @@ TRACE_EVENT(i915_flip_complete,
 );
 
 TRACE_EVENT(i915_reg_rw,
-           TP_PROTO(bool write, u32 reg, u64 val, int len),
-
-           TP_ARGS(write, reg, val, len),
-
-           TP_STRUCT__entry(
-                   __field(u64, val)
-                   __field(u32, reg)
-                   __field(u16, write)
-                   __field(u16, len)
-                   ),
-
-           TP_fast_assign(
-                   __entry->val = (u64)val;
-                   __entry->reg = reg;
-                   __entry->write = write;
-                   __entry->len = len;
-                   ),
-
-           TP_printk("%s reg=0x%x, len=%d, val=(0x%x, 0x%x)",
-                     __entry->write ? "write" : "read",
-		     __entry->reg, __entry->len,
-		     (u32)(__entry->val & 0xffffffff),
-		     (u32)(__entry->val >> 32))
+	TP_PROTO(bool write, u32 reg, u64 val, int len),
+
+	TP_ARGS(write, reg, val, len),
+
+	TP_STRUCT__entry(
+		__field(u64, val)
+		__field(u32, reg)
+		__field(u16, write)
+		__field(u16, len)
+		),
+
+	TP_fast_assign(
+		__entry->val = (u64)val;
+		__entry->reg = reg;
+		__entry->write = write;
+		__entry->len = len;
+		),
+
+	TP_printk("%s reg=0x%x, len=%d, val=(0x%x, 0x%x)",
+		__entry->write ? "write" : "read",
+		__entry->reg, __entry->len,
+		(u32)(__entry->val & 0xffffffff),
+		(u32)(__entry->val >> 32))
 );
 
 #endif /* _I915_TRACE_H_ */
diff --git a/drivers/gpu/drm/i915/intel_acpi.c b/drivers/gpu/drm/i915/intel_acpi.c
index 2cb8e0b..cb91210 100644
--- a/drivers/gpu/drm/i915/intel_acpi.c
+++ b/drivers/gpu/drm/i915/intel_acpi.c
@@ -64,7 +64,7 @@ static int intel_dsm(acpi_handle handle, int func, int arg)
 
 	case ACPI_TYPE_BUFFER:
 		if (obj->buffer.length == 4) {
-			result =(obj->buffer.pointer[0] |
+			result = (obj->buffer.pointer[0] |
 				(obj->buffer.pointer[1] <<  8) |
 				(obj->buffer.pointer[2] << 16) |
 				(obj->buffer.pointer[3] << 24));
diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
index 61abef8..33378da 100644
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -381,7 +381,7 @@ parse_sdvo_device_mapping(struct drm_i915_private *dev_priv,
 		if (p_child->dvo_port != DEVICE_PORT_DVOB &&
 			p_child->dvo_port != DEVICE_PORT_DVOC) {
 			/* skip the incorrect SDVO port */
-			DRM_DEBUG_KMS("Incorrect SDVO port. Skip it \n");
+			DRM_DEBUG_KMS("Incorrect SDVO port. Skip it\n");
 			continue;
 		}
 		DRM_DEBUG_KMS("the SDVO device with slave addr %2x is found on"
@@ -564,7 +564,7 @@ parse_device_mapping(struct drm_i915_private *dev_priv,
 		count++;
 	}
 	if (!count) {
-		DRM_DEBUG_KMS("no child dev is parsed from VBT \n");
+		DRM_DEBUG_KMS("no child dev is parsed from VBT\n");
 		return;
 	}
 	dev_priv->child_dev = kzalloc(sizeof(*p_child) * count, GFP_KERNEL);
diff --git a/drivers/gpu/drm/i915/intel_bios.h b/drivers/gpu/drm/i915/intel_bios.h
index 5f8e4ed..c2e38fe 100644
--- a/drivers/gpu/drm/i915/intel_bios.h
+++ b/drivers/gpu/drm/i915/intel_bios.h
@@ -240,7 +240,7 @@ struct bdb_general_definitions {
 	 * And the device num is related with the size of general definition
 	 * block. It is obtained by using the following formula:
 	 * number = (block_size - sizeof(bdb_general_definitions))/
-	 * 		sizeof(child_device_config);
+	 *	     sizeof(child_device_config);
 	 */
 	struct child_device_config devices[0];
 } __attribute__((packed));
diff --git a/drivers/gpu/drm/i915/intel_crt.c b/drivers/gpu/drm/i915/intel_crt.c
index 0979d88..451534c 100644
--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -69,7 +69,7 @@ static void intel_crt_dpms(struct drm_encoder *encoder, int mode)
 	temp &= ~(ADPA_HSYNC_CNTL_DISABLE | ADPA_VSYNC_CNTL_DISABLE);
 	temp &= ~ADPA_DAC_ENABLE;
 
-	switch(mode) {
+	switch (mode) {
 	case DRM_MODE_DPMS_ON:
 		temp |= ADPA_DAC_ENABLE;
 		break;
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index ee1d701..7152297 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -42,39 +42,39 @@
 
 #define HAS_eDP (intel_pipe_has_type(crtc, INTEL_OUTPUT_EDP))
 
-bool intel_pipe_has_type (struct drm_crtc *crtc, int type);
+bool intel_pipe_has_type(struct drm_crtc *crtc, int type);
 static void intel_update_watermarks(struct drm_device *dev);
 static void intel_increase_pllclock(struct drm_crtc *crtc);
 static void intel_crtc_update_cursor(struct drm_crtc *crtc, bool on);
 
 typedef struct {
-    /* given values */
-    int n;
-    int m1, m2;
-    int p1, p2;
-    /* derived values */
-    int	dot;
-    int	vco;
-    int	m;
-    int	p;
+	/* given values */
+	int n;
+	int m1, m2;
+	int p1, p2;
+	/* derived values */
+	int	dot;
+	int	vco;
+	int	m;
+	int	p;
 } intel_clock_t;
 
 typedef struct {
-    int	min, max;
+	int	min, max;
 } intel_range_t;
 
 typedef struct {
-    int	dot_limit;
-    int	p2_slow, p2_fast;
+	int	dot_limit;
+	int	p2_slow, p2_fast;
 } intel_p2_t;
 
 #define INTEL_P2_NUM		      2
 typedef struct intel_limit intel_limit_t;
 struct intel_limit {
-    intel_range_t   dot, vco, n, m, m1, m2, p, p1;
-    intel_p2_t	    p2;
-    bool (* find_pll)(const intel_limit_t *, struct drm_crtc *,
-		      int, int, intel_clock_t *);
+	intel_range_t   dot, vco, n, m, m1, m2, p, p1;
+	intel_p2_t	    p2;
+	bool (* find_pll)(const intel_limit_t *, struct drm_crtc *,
+			int, int, intel_clock_t *);
 };
 
 /* FDI */
@@ -105,56 +105,56 @@ intel_fdi_link_freq(struct drm_device *dev)
 }
 
 static const intel_limit_t intel_limits_i8xx_dvo = {
-        .dot = { .min = 25000, .max = 350000 },
-        .vco = { .min = 930000, .max = 1400000 },
-        .n = { .min = 3, .max = 16 },
-        .m = { .min = 96, .max = 140 },
-        .m1 = { .min = 18, .max = 26 },
-        .m2 = { .min = 6, .max = 16 },
-        .p = { .min = 4, .max = 128 },
-        .p1 = { .min = 2, .max = 33 },
+	.dot = { .min = 25000, .max = 350000 },
+	.vco = { .min = 930000, .max = 1400000 },
+	.n = { .min = 3, .max = 16 },
+	.m = { .min = 96, .max = 140 },
+	.m1 = { .min = 18, .max = 26 },
+	.m2 = { .min = 6, .max = 16 },
+	.p = { .min = 4, .max = 128 },
+	.p1 = { .min = 2, .max = 33 },
 	.p2 = { .dot_limit = 165000,
 		.p2_slow = 4, .p2_fast = 2 },
 	.find_pll = intel_find_best_PLL,
 };
 
 static const intel_limit_t intel_limits_i8xx_lvds = {
-        .dot = { .min = 25000, .max = 350000 },
-        .vco = { .min = 930000, .max = 1400000 },
-        .n = { .min = 3, .max = 16 },
-        .m = { .min = 96, .max = 140 },
-        .m1 = { .min = 18, .max = 26 },
-        .m2 = { .min = 6, .max = 16 },
-        .p = { .min = 4, .max = 128 },
-        .p1 = { .min = 1, .max = 6 },
+	.dot = { .min = 25000, .max = 350000 },
+	.vco = { .min = 930000, .max = 1400000 },
+	.n = { .min = 3, .max = 16 },
+	.m = { .min = 96, .max = 140 },
+	.m1 = { .min = 18, .max = 26 },
+	.m2 = { .min = 6, .max = 16 },
+	.p = { .min = 4, .max = 128 },
+	.p1 = { .min = 1, .max = 6 },
 	.p2 = { .dot_limit = 165000,
 		.p2_slow = 14, .p2_fast = 7 },
 	.find_pll = intel_find_best_PLL,
 };
 
 static const intel_limit_t intel_limits_i9xx_sdvo = {
-        .dot = { .min = 20000, .max = 400000 },
-        .vco = { .min = 1400000, .max = 2800000 },
-        .n = { .min = 1, .max = 6 },
-        .m = { .min = 70, .max = 120 },
-        .m1 = { .min = 10, .max = 22 },
-        .m2 = { .min = 5, .max = 9 },
-        .p = { .min = 5, .max = 80 },
-        .p1 = { .min = 1, .max = 8 },
+	.dot = { .min = 20000, .max = 400000 },
+	.vco = { .min = 1400000, .max = 2800000 },
+	.n = { .min = 1, .max = 6 },
+	.m = { .min = 70, .max = 120 },
+	.m1 = { .min = 10, .max = 22 },
+	.m2 = { .min = 5, .max = 9 },
+	.p = { .min = 5, .max = 80 },
+	.p1 = { .min = 1, .max = 8 },
 	.p2 = { .dot_limit = 200000,
 		.p2_slow = 10, .p2_fast = 5 },
 	.find_pll = intel_find_best_PLL,
 };
 
 static const intel_limit_t intel_limits_i9xx_lvds = {
-        .dot = { .min = 20000, .max = 400000 },
-        .vco = { .min = 1400000, .max = 2800000 },
-        .n = { .min = 1, .max = 6 },
-        .m = { .min = 70, .max = 120 },
-        .m1 = { .min = 10, .max = 22 },
-        .m2 = { .min = 5, .max = 9 },
-        .p = { .min = 7, .max = 98 },
-        .p1 = { .min = 1, .max = 8 },
+	.dot = { .min = 20000, .max = 400000 },
+	.vco = { .min = 1400000, .max = 2800000 },
+	.n = { .min = 1, .max = 6 },
+	.m = { .min = 70, .max = 120 },
+	.m1 = { .min = 10, .max = 22 },
+	.m2 = { .min = 5, .max = 9 },
+	.p = { .min = 7, .max = 98 },
+	.p1 = { .min = 1, .max = 8 },
 	.p2 = { .dot_limit = 112000,
 		.p2_slow = 14, .p2_fast = 7 },
 	.find_pll = intel_find_best_PLL,
@@ -222,44 +222,44 @@ static const intel_limit_t intel_limits_g4x_dual_channel_lvds = {
 };
 
 static const intel_limit_t intel_limits_g4x_display_port = {
-        .dot = { .min = 161670, .max = 227000 },
-        .vco = { .min = 1750000, .max = 3500000},
-        .n = { .min = 1, .max = 2 },
-        .m = { .min = 97, .max = 108 },
-        .m1 = { .min = 0x10, .max = 0x12 },
-        .m2 = { .min = 0x05, .max = 0x06 },
-        .p = { .min = 10, .max = 20 },
-        .p1 = { .min = 1, .max = 2},
-        .p2 = { .dot_limit = 0,
+	.dot = { .min = 161670, .max = 227000 },
+	.vco = { .min = 1750000, .max = 3500000},
+	.n = { .min = 1, .max = 2 },
+	.m = { .min = 97, .max = 108 },
+	.m1 = { .min = 0x10, .max = 0x12 },
+	.m2 = { .min = 0x05, .max = 0x06 },
+	.p = { .min = 10, .max = 20 },
+	.p1 = { .min = 1, .max = 2},
+	.p2 = { .dot_limit = 0,
 		.p2_slow = 10, .p2_fast = 10 },
-        .find_pll = intel_find_pll_g4x_dp,
+	.find_pll = intel_find_pll_g4x_dp,
 };
 
 static const intel_limit_t intel_limits_pineview_sdvo = {
-        .dot = { .min = 20000, .max = 400000},
-        .vco = { .min = 1700000, .max = 3500000 },
+	.dot = { .min = 20000, .max = 400000},
+	.vco = { .min = 1700000, .max = 3500000 },
 	/* Pineview's Ncounter is a ring counter */
-        .n = { .min = 3, .max = 6 },
-        .m = { .min = 2, .max = 256 },
+	.n = { .min = 3, .max = 6 },
+	.m = { .min = 2, .max = 256 },
 	/* Pineview only has one combined m divider, which we treat as m2. */
-        .m1 = { .min = 0, .max = 0 },
-        .m2 = { .min = 0, .max = 254 },
-        .p = { .min = 5, .max = 80 },
-        .p1 = { .min = 1, .max = 8 },
+	.m1 = { .min = 0, .max = 0 },
+	.m2 = { .min = 0, .max = 254 },
+	.p = { .min = 5, .max = 80 },
+	.p1 = { .min = 1, .max = 8 },
 	.p2 = { .dot_limit = 200000,
 		.p2_slow = 10, .p2_fast = 5 },
 	.find_pll = intel_find_best_PLL,
 };
 
 static const intel_limit_t intel_limits_pineview_lvds = {
-        .dot = { .min = 20000, .max = 400000 },
-        .vco = { .min = 1700000, .max = 3500000 },
-        .n = { .min = 3, .max = 6 },
-        .m = { .min = 2, .max = 256 },
-        .m1 = { .min = 0, .max = 0 },
-        .m2 = { .min = 0, .max = 254 },
-        .p = { .min = 7, .max = 112 },
-        .p1 = { .min = 1, .max = 8 },
+	.dot = { .min = 20000, .max = 400000 },
+	.vco = { .min = 1700000, .max = 3500000 },
+	.n = { .min = 3, .max = 6 },
+	.m = { .min = 2, .max = 256 },
+	.m1 = { .min = 0, .max = 0 },
+	.m2 = { .min = 0, .max = 254 },
+	.p = { .min = 7, .max = 112 },
+	.p1 = { .min = 1, .max = 8 },
 	.p2 = { .dot_limit = 112000,
 		.p2_slow = 14, .p2_fast = 14 },
 	.find_pll = intel_find_best_PLL,
@@ -321,7 +321,7 @@ static const intel_limit_t intel_limits_ironlake_single_lvds_100m = {
 	.m1 = { .min = 12, .max = 22 },
 	.m2 = { .min = 5, .max = 9 },
 	.p = { .min = 28, .max = 112 },
-	.p1 = { .min = 2,.max = 8 },
+	.p1 = { .min = 2, .max = 8 },
 	.p2 = { .dot_limit = 225000,
 		.p2_slow = 14, .p2_fast = 14 },
 	.find_pll = intel_g4x_find_best_PLL,
@@ -335,24 +335,24 @@ static const intel_limit_t intel_limits_ironlake_dual_lvds_100m = {
 	.m1 = { .min = 12, .max = 22 },
 	.m2 = { .min = 5, .max = 9 },
 	.p = { .min = 14, .max = 42 },
-	.p1 = { .min = 2,.max = 6 },
+	.p1 = { .min = 2, .max = 6 },
 	.p2 = { .dot_limit = 225000,
 		.p2_slow = 7, .p2_fast = 7 },
 	.find_pll = intel_g4x_find_best_PLL,
 };
 
 static const intel_limit_t intel_limits_ironlake_display_port = {
-        .dot = { .min = 25000, .max = 350000 },
-        .vco = { .min = 1760000, .max = 3510000},
-        .n = { .min = 1, .max = 2 },
-        .m = { .min = 81, .max = 90 },
-        .m1 = { .min = 12, .max = 22 },
-        .m2 = { .min = 5, .max = 9 },
-        .p = { .min = 10, .max = 20 },
-        .p1 = { .min = 1, .max = 2},
-        .p2 = { .dot_limit = 0,
+	.dot = { .min = 25000, .max = 350000 },
+	.vco = { .min = 1760000, .max = 3510000},
+	.n = { .min = 1, .max = 2 },
+	.m = { .min = 81, .max = 90 },
+	.m1 = { .min = 12, .max = 22 },
+	.m2 = { .min = 5, .max = 9 },
+	.p = { .min = 10, .max = 20 },
+	.p1 = { .min = 1, .max = 2},
+	.p2 = { .dot_limit = 0,
 		.p2_slow = 10, .p2_fast = 10 },
-        .find_pll = intel_find_pll_ironlake_dp,
+	.find_pll = intel_find_pll_ironlake_dp,
 };
 
 static const intel_limit_t *intel_ironlake_limit(struct drm_crtc *crtc,
@@ -404,7 +404,7 @@ static const intel_limit_t *intel_g4x_limit(struct drm_crtc *crtc)
 		limit = &intel_limits_g4x_hdmi;
 	} else if (intel_pipe_has_type(crtc, INTEL_OUTPUT_SDVO)) {
 		limit = &intel_limits_g4x_sdvo;
-	} else if (intel_pipe_has_type (crtc, INTEL_OUTPUT_DISPLAYPORT)) {
+	} else if (intel_pipe_has_type(crtc, INTEL_OUTPUT_DISPLAYPORT)) {
 		limit = &intel_limits_g4x_display_port;
 	} else /* The option is for other outputs */
 		limit = &intel_limits_i9xx_sdvo;
@@ -488,26 +488,26 @@ static bool intel_PLL_is_valid(struct drm_device *dev,
 			       const intel_clock_t *clock)
 {
 	if (clock->p1  < limit->p1.min  || limit->p1.max  < clock->p1)
-		INTELPllInvalid ("p1 out of range\n");
+		INTELPllInvalid("p1 out of range\n");
 	if (clock->p   < limit->p.min   || limit->p.max   < clock->p)
-		INTELPllInvalid ("p out of range\n");
+		INTELPllInvalid("p out of range\n");
 	if (clock->m2  < limit->m2.min  || limit->m2.max  < clock->m2)
-		INTELPllInvalid ("m2 out of range\n");
+		INTELPllInvalid("m2 out of range\n");
 	if (clock->m1  < limit->m1.min  || limit->m1.max  < clock->m1)
-		INTELPllInvalid ("m1 out of range\n");
+		INTELPllInvalid("m1 out of range\n");
 	if (clock->m1 <= clock->m2 && !IS_PINEVIEW(dev))
-		INTELPllInvalid ("m1 <= m2\n");
+		INTELPllInvalid("m1 <= m2\n");
 	if (clock->m   < limit->m.min   || limit->m.max   < clock->m)
-		INTELPllInvalid ("m out of range\n");
+		INTELPllInvalid("m out of range\n");
 	if (clock->n   < limit->n.min   || limit->n.max   < clock->n)
-		INTELPllInvalid ("n out of range\n");
+		INTELPllInvalid("n out of range\n");
 	if (clock->vco < limit->vco.min || limit->vco.max < clock->vco)
-		INTELPllInvalid ("vco out of range\n");
+		INTELPllInvalid("vco out of range\n");
 	/* XXX: We may need to be checking "Dot clock" depending on the multiplier,
 	 * connector, etc., rather than just a single range.
 	 */
 	if (clock->dot < limit->dot.min || limit->dot.max < clock->dot)
-		INTELPllInvalid ("dot out of range\n");
+		INTELPllInvalid("dot out of range\n");
 
 	return true;
 }
@@ -542,7 +542,7 @@ intel_find_best_PLL(const intel_limit_t *limit, struct drm_crtc *crtc,
 			clock.p2 = limit->p2.p2_fast;
 	}
 
-	memset (best_clock, 0, sizeof (*best_clock));
+	memset(best_clock, 0, sizeof(*best_clock));
 
 	for (clock.m1 = limit->m1.min; clock.m1 <= limit->m1.max;
 	     clock.m1++) {
@@ -2432,7 +2432,7 @@ static void ironlake_fdi_link_train(struct drm_crtc *crtc)
 
 }
 
-static const int snb_b_fdi_train_param [] = {
+static const int snb_b_fdi_train_param[] = {
 	FDI_LINK_TRAIN_400MV_0DB_SNB_B,
 	FDI_LINK_TRAIN_400MV_6DB_SNB_B,
 	FDI_LINK_TRAIN_600MV_3_5DB_SNB_B,
@@ -2488,7 +2488,7 @@ static void gen6_fdi_link_train(struct drm_crtc *crtc)
 	if (HAS_PCH_CPT(dev))
 		cpt_phase_pointer_enable(dev, pipe);
 
-	for (i = 0; i < 4; i++ ) {
+	for (i = 0; i < 4; i++) {
 		reg = FDI_TX_CTL(pipe);
 		temp = I915_READ(reg);
 		temp &= ~FDI_LINK_TRAIN_VOL_EMP_MASK;
@@ -2537,7 +2537,7 @@ static void gen6_fdi_link_train(struct drm_crtc *crtc)
 	POSTING_READ(reg);
 	udelay(150);
 
-	for (i = 0; i < 4; i++ ) {
+	for (i = 0; i < 4; i++) {
 		reg = FDI_TX_CTL(pipe);
 		temp = I915_READ(reg);
 		temp &= ~FDI_LINK_TRAIN_VOL_EMP_MASK;
@@ -2607,7 +2607,7 @@ static void ivb_manual_fdi_link_train(struct drm_crtc *crtc)
 	if (HAS_PCH_CPT(dev))
 		cpt_phase_pointer_enable(dev, pipe);
 
-	for (i = 0; i < 4; i++ ) {
+	for (i = 0; i < 4; i++) {
 		reg = FDI_TX_CTL(pipe);
 		temp = I915_READ(reg);
 		temp &= ~FDI_LINK_TRAIN_VOL_EMP_MASK;
@@ -2649,7 +2649,7 @@ static void ivb_manual_fdi_link_train(struct drm_crtc *crtc)
 	POSTING_READ(reg);
 	udelay(150);
 
-	for (i = 0; i < 4; i++ ) {
+	for (i = 0; i < 4; i++) {
 		reg = FDI_TX_CTL(pipe);
 		temp = I915_READ(reg);
 		temp &= ~FDI_LINK_TRAIN_VOL_EMP_MASK;
@@ -3285,14 +3285,14 @@ static void ironlake_crtc_commit(struct drm_crtc *crtc)
 	ironlake_crtc_enable(crtc);
 }
 
-void intel_encoder_prepare (struct drm_encoder *encoder)
+void intel_encoder_prepare(struct drm_encoder *encoder)
 {
 	struct drm_encoder_helper_funcs *encoder_funcs = encoder->helper_private;
 	/* lvds has its own version of prepare see intel_lvds_prepare */
 	encoder_funcs->dpms(encoder, DRM_MODE_DPMS_OFF);
 }
 
-void intel_encoder_commit (struct drm_encoder *encoder)
+void intel_encoder_commit(struct drm_encoder *encoder)
 {
 	struct drm_encoder_helper_funcs *encoder_funcs = encoder->helper_private;
 	/* lvds has its own version of commit see intel_lvds_commit */
@@ -8146,7 +8146,7 @@ static void intel_init_display(struct drm_device *dev)
 	}
 
 	/* Returns the core display clock speed */
-	if (IS_I945G(dev) || (IS_G33(dev) && ! IS_PINEVIEW_M(dev)))
+	if (IS_I945G(dev) || (IS_G33(dev) && !IS_PINEVIEW_M(dev)))
 		dev_priv->display.get_display_clock_speed =
 			i945_get_display_clock_speed;
 	else if (IS_I915G(dev))
@@ -8217,7 +8217,7 @@ static void intel_init_display(struct drm_device *dev)
 			DRM_INFO("failed to find known CxSR latency "
 				 "(found ddr%s fsb freq %d, mem freq %d), "
 				 "disabling CxSR\n",
-				 (dev_priv->is_ddr3 == 1) ? "3": "2",
+				 (dev_priv->is_ddr3 == 1) ? "3" : "2",
 				 dev_priv->fsb_freq, dev_priv->mem_freq);
 			/* Disable CxSR and never update its watermark again */
 			pineview_disable_cxsr(dev);
@@ -8286,7 +8286,7 @@ static void intel_init_display(struct drm_device *dev)
  * resume, or other times.  This quirk makes sure that's the case for
  * affected systems.
  */
-static void quirk_pipea_force (struct drm_device *dev)
+static void quirk_pipea_force(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
@@ -8314,7 +8314,7 @@ struct intel_quirk intel_quirks[] = {
 	/* HP Compaq 2730p needs pipe A force quirk (LP: #291555) */
 	{ 0x2a42, 0x103c, 0x30eb, quirk_pipea_force },
 	/* HP Mini needs pipe A force quirk (LP: #322104) */
-	{ 0x27ae,0x103c, 0x361a, quirk_pipea_force },
+	{ 0x27ae, 0x103c, 0x361a, quirk_pipea_force },
 
 	/* Thinkpad R31 needs pipe A force quirk */
 	{ 0x3577, 0x1014, 0x0505, quirk_pipea_force },
@@ -8565,7 +8565,7 @@ struct intel_display_error_state {
 struct intel_display_error_state *
 intel_display_capture_error_state(struct drm_device *dev)
 {
-        drm_i915_private_t *dev_priv = dev->dev_private;
+	drm_i915_private_t *dev_priv = dev->dev_private;
 	struct intel_display_error_state *error;
 	int i;
 
@@ -8581,7 +8581,7 @@ intel_display_capture_error_state(struct drm_device *dev)
 		error->plane[i].control = I915_READ(DSPCNTR(i));
 		error->plane[i].stride = I915_READ(DSPSTRIDE(i));
 		error->plane[i].size = I915_READ(DSPSIZE(i));
-		error->plane[i].pos= I915_READ(DSPPOS(i));
+		error->plane[i].pos = I915_READ(DSPPOS(i));
 		error->plane[i].addr = I915_READ(DSPADDR(i));
 		if (INTEL_INFO(dev)->gen >= 4) {
 			error->plane[i].surface = I915_READ(DSPSURF(i));
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 44fef5e..4091f21 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -121,7 +121,7 @@ static void intel_dp_complete_link_train(struct intel_dp *intel_dp);
 static void intel_dp_link_down(struct intel_dp *intel_dp);
 
 void
-intel_edp_link_config (struct intel_encoder *intel_encoder,
+intel_edp_link_config(struct intel_encoder *intel_encoder,
 		       int *lane_num, int *link_bw)
 {
 	struct intel_dp *intel_dp = container_of(intel_encoder, struct intel_dp, base);
@@ -337,7 +337,7 @@ intel_dp_aux_ch(struct intel_dp *intel_dp,
 		for (i = 0; i < send_bytes; i += 4)
 			I915_WRITE(ch_data + i,
 				   pack_aux(send + i, send_bytes - i));
-	
+
 		/* Send the command and wait for it to complete */
 		I915_WRITE(ch_ctl,
 			   DP_AUX_CH_CTL_SEND_BUSY |
@@ -354,7 +354,7 @@ intel_dp_aux_ch(struct intel_dp *intel_dp,
 				break;
 			udelay(100);
 		}
-	
+
 		/* Clear done status and any errors */
 		I915_WRITE(ch_ctl,
 			   status |
@@ -390,7 +390,7 @@ intel_dp_aux_ch(struct intel_dp *intel_dp,
 		      DP_AUX_CH_CTL_MESSAGE_SIZE_SHIFT);
 	if (recv_bytes > recv_size)
 		recv_bytes = recv_size;
-	
+
 	for (i = 0; i < recv_bytes; i += 4)
 		unpack_aux(I915_READ(ch_data + i),
 			   recv + i, recv_bytes - i);
@@ -582,10 +582,10 @@ intel_dp_i2c_init(struct intel_dp *intel_dp,
 	intel_dp->algo.address = 0;
 	intel_dp->algo.aux_ch = intel_dp_i2c_aux_ch;
 
-	memset(&intel_dp->adapter, '\0', sizeof (intel_dp->adapter));
+	memset(&intel_dp->adapter, '\0', sizeof(intel_dp->adapter));
 	intel_dp->adapter.owner = THIS_MODULE;
 	intel_dp->adapter.class = I2C_CLASS_DDC;
-	strncpy (intel_dp->adapter.name, name, sizeof(intel_dp->adapter.name) - 1);
+	strncpy(intel_dp->adapter.name, name, sizeof(intel_dp->adapter.name) - 1);
 	intel_dp->adapter.name[sizeof(intel_dp->adapter.name) - 1] = '\0';
 	intel_dp->adapter.algo_data = &intel_dp->algo;
 	intel_dp->adapter.dev.parent = &intel_connector->base.kdev;
@@ -839,7 +839,7 @@ static void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp)
 }
 
 /* Returns true if the panel was already on when called */
-static bool ironlake_edp_panel_on (struct intel_dp *intel_dp)
+static bool ironlake_edp_panel_on(struct intel_dp *intel_dp)
 {
 	struct drm_device *dev = intel_dp->base.base.dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -871,7 +871,7 @@ static bool ironlake_edp_panel_on (struct intel_dp *intel_dp)
 	return false;
 }
 
-static void ironlake_edp_panel_off (struct drm_device *dev)
+static void ironlake_edp_panel_off(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	u32 pp, idle_off_mask = PP_ON | PP_SEQUENCE_MASK |
@@ -897,7 +897,7 @@ static void ironlake_edp_panel_off (struct drm_device *dev)
 	POSTING_READ(PCH_PP_CONTROL);
 }
 
-static void ironlake_edp_backlight_on (struct drm_device *dev)
+static void ironlake_edp_backlight_on(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	u32 pp;
@@ -915,7 +915,7 @@ static void ironlake_edp_backlight_on (struct drm_device *dev)
 	I915_WRITE(PCH_PP_CONTROL, pp);
 }
 
-static void ironlake_edp_backlight_off (struct drm_device *dev)
+static void ironlake_edp_backlight_off(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	u32 pp;
@@ -1584,7 +1584,7 @@ static bool
 intel_dp_get_dpcd(struct intel_dp *intel_dp)
 {
 	if (intel_dp_aux_native_read_retry(intel_dp, 0x000, intel_dp->dpcd,
-					   sizeof (intel_dp->dpcd)) &&
+					   sizeof(intel_dp->dpcd)) &&
 	    (intel_dp->dpcd[DP_DPCD_REV] != 0)) {
 		return true;
 	}
@@ -1839,7 +1839,7 @@ done:
 }
 
 static void
-intel_dp_destroy (struct drm_connector *connector)
+intel_dp_destroy(struct drm_connector *connector)
 {
 	struct drm_device *dev = connector->dev;
 
@@ -1896,7 +1896,7 @@ intel_dp_hot_plug(struct intel_encoder *intel_encoder)
 
 /* Return which DP Port should be selected for Transcoder DP control */
 int
-intel_trans_dp_port_sel (struct drm_crtc *crtc)
+intel_trans_dp_port_sel(struct drm_crtc *crtc)
 {
 	struct drm_device *dev = crtc->dev;
 	struct drm_mode_config *mode_config = &dev->mode_config;
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 0b2ee9d..375690b 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -34,7 +34,7 @@
 #define _wait_for(COND, MS, W) ({ \
 	unsigned long timeout__ = jiffies + msecs_to_jiffies(MS);	\
 	int ret__ = 0;							\
-	while (! (COND)) {						\
+	while (!(COND)) {						\
 		if (time_after(jiffies, timeout__)) {			\
 			ret__ = -ETIMEDOUT;				\
 			break;						\
@@ -49,10 +49,10 @@
 
 #define MSLEEP(x) do { \
 	if (in_dbg_master()) \
-	       	mdelay(x); \
+		mdelay(x); \
 	else \
 		msleep(x); \
-} while(0)
+} while (0)
 
 #define KHz(x) (1000*x)
 #define MHz(x) KHz(1000*x)
@@ -284,7 +284,7 @@ void
 intel_dp_set_m_n(struct drm_crtc *crtc, struct drm_display_mode *mode,
 		 struct drm_display_mode *adjusted_mode);
 extern bool intel_dpd_is_edp(struct drm_device *dev);
-extern void intel_edp_link_config (struct intel_encoder *, int *, int *);
+extern void intel_edp_link_config(struct intel_encoder *, int *, int *);
 extern bool intel_encoder_is_pch_edp(struct drm_encoder *encoder);
 
 /* intel_panel.c */
@@ -304,8 +304,8 @@ extern void intel_panel_destroy_backlight(struct drm_device *dev);
 extern enum drm_connector_status intel_panel_detect(struct drm_device *dev);
 
 extern void intel_crtc_load_lut(struct drm_crtc *crtc);
-extern void intel_encoder_prepare (struct drm_encoder *encoder);
-extern void intel_encoder_commit (struct drm_encoder *encoder);
+extern void intel_encoder_prepare(struct drm_encoder *encoder);
+extern void intel_encoder_commit(struct drm_encoder *encoder);
 extern void intel_encoder_destroy(struct drm_encoder *encoder);
 
 static inline struct intel_encoder *intel_attached_encoder(struct drm_connector *connector)
diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
index b8e8158b..289140b 100644
--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ b/drivers/gpu/drm/i915/intel_opregion.c
@@ -51,61 +51,61 @@
 #define MBOX_ASLE      (1<<2)
 
 struct opregion_header {
-       u8 signature[16];
-       u32 size;
-       u32 opregion_ver;
-       u8 bios_ver[32];
-       u8 vbios_ver[16];
-       u8 driver_ver[16];
-       u32 mboxes;
-       u8 reserved[164];
+	u8 signature[16];
+	u32 size;
+	u32 opregion_ver;
+	u8 bios_ver[32];
+	u8 vbios_ver[16];
+	u8 driver_ver[16];
+	u32 mboxes;
+	u8 reserved[164];
 } __attribute__((packed));
 
 /* OpRegion mailbox #1: public ACPI methods */
 struct opregion_acpi {
-       u32 drdy;       /* driver readiness */
-       u32 csts;       /* notification status */
-       u32 cevt;       /* current event */
-       u8 rsvd1[20];
-       u32 didl[8];    /* supported display devices ID list */
-       u32 cpdl[8];    /* currently presented display list */
-       u32 cadl[8];    /* currently active display list */
-       u32 nadl[8];    /* next active devices list */
-       u32 aslp;       /* ASL sleep time-out */
-       u32 tidx;       /* toggle table index */
-       u32 chpd;       /* current hotplug enable indicator */
-       u32 clid;       /* current lid state*/
-       u32 cdck;       /* current docking state */
-       u32 sxsw;       /* Sx state resume */
-       u32 evts;       /* ASL supported events */
-       u32 cnot;       /* current OS notification */
-       u32 nrdy;       /* driver status */
-       u8 rsvd2[60];
+	u32 drdy;       /* driver readiness */
+	u32 csts;       /* notification status */
+	u32 cevt;       /* current event */
+	u8 rsvd1[20];
+	u32 didl[8];    /* supported display devices ID list */
+	u32 cpdl[8];    /* currently presented display list */
+	u32 cadl[8];    /* currently active display list */
+	u32 nadl[8];    /* next active devices list */
+	u32 aslp;       /* ASL sleep time-out */
+	u32 tidx;       /* toggle table index */
+	u32 chpd;       /* current hotplug enable indicator */
+	u32 clid;       /* current lid state*/
+	u32 cdck;       /* current docking state */
+	u32 sxsw;       /* Sx state resume */
+	u32 evts;       /* ASL supported events */
+	u32 cnot;       /* current OS notification */
+	u32 nrdy;       /* driver status */
+	u8 rsvd2[60];
 } __attribute__((packed));
 
 /* OpRegion mailbox #2: SWSCI */
 struct opregion_swsci {
-       u32 scic;       /* SWSCI command|status|data */
-       u32 parm;       /* command parameters */
-       u32 dslp;       /* driver sleep time-out */
-       u8 rsvd[244];
+	u32 scic;       /* SWSCI command|status|data */
+	u32 parm;       /* command parameters */
+	u32 dslp;       /* driver sleep time-out */
+	u8 rsvd[244];
 } __attribute__((packed));
 
 /* OpRegion mailbox #3: ASLE */
 struct opregion_asle {
-       u32 ardy;       /* driver readiness */
-       u32 aslc;       /* ASLE interrupt command */
-       u32 tche;       /* technology enabled indicator */
-       u32 alsi;       /* current ALS illuminance reading */
-       u32 bclp;       /* backlight brightness to set */
-       u32 pfit;       /* panel fitting state */
-       u32 cblv;       /* current brightness level */
-       u16 bclm[20];   /* backlight level duty cycle mapping table */
-       u32 cpfm;       /* current panel fitting mode */
-       u32 epfm;       /* enabled panel fitting modes */
-       u8 plut[74];    /* panel LUT and identifier */
-       u32 pfmb;       /* PWM freq and min brightness */
-       u8 rsvd[102];
+	u32 ardy;       /* driver readiness */
+	u32 aslc;       /* ASLE interrupt command */
+	u32 tche;       /* technology enabled indicator */
+	u32 alsi;       /* current ALS illuminance reading */
+	u32 bclp;       /* backlight brightness to set */
+	u32 pfit;       /* panel fitting state */
+	u32 cblv;       /* current brightness level */
+	u16 bclm[20];   /* backlight level duty cycle mapping table */
+	u32 cpfm;       /* current panel fitting mode */
+	u32 epfm;       /* enabled panel fitting modes */
+	u8 plut[74];    /* panel LUT and identifier */
+	u32 pfmb;       /* PWM freq and min brightness */
+	u8 rsvd[102];
 } __attribute__((packed));
 
 /* ASLE irq request bits */
@@ -361,7 +361,7 @@ static void intel_didl_outputs(struct drm_device *dev)
 
 	list_for_each_entry(acpi_cdev, &acpi_video_bus->children, node) {
 		if (i >= 8) {
-			dev_printk (KERN_ERR, &dev->pdev->dev,
+			dev_printk(KERN_ERR, &dev->pdev->dev,
 				    "More than 8 outputs detected\n");
 			return;
 		}
@@ -387,7 +387,7 @@ blind_set:
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
 		int output_type = ACPI_OTHER_OUTPUT;
 		if (i >= 8) {
-			dev_printk (KERN_ERR, &dev->pdev->dev,
+			dev_printk(KERN_ERR, &dev->pdev->dev,
 				    "More than 8 outputs detected\n");
 			return;
 		}
diff --git a/drivers/gpu/drm/i915/intel_overlay.c b/drivers/gpu/drm/i915/intel_overlay.c
index d360380..cdf17d4 100644
--- a/drivers/gpu/drm/i915/intel_overlay.c
+++ b/drivers/gpu/drm/i915/intel_overlay.c
@@ -117,57 +117,57 @@
 
 /* memory bufferd overlay registers */
 struct overlay_registers {
-    u32 OBUF_0Y;
-    u32 OBUF_1Y;
-    u32 OBUF_0U;
-    u32 OBUF_0V;
-    u32 OBUF_1U;
-    u32 OBUF_1V;
-    u32 OSTRIDE;
-    u32 YRGB_VPH;
-    u32 UV_VPH;
-    u32 HORZ_PH;
-    u32 INIT_PHS;
-    u32 DWINPOS;
-    u32 DWINSZ;
-    u32 SWIDTH;
-    u32 SWIDTHSW;
-    u32 SHEIGHT;
-    u32 YRGBSCALE;
-    u32 UVSCALE;
-    u32 OCLRC0;
-    u32 OCLRC1;
-    u32 DCLRKV;
-    u32 DCLRKM;
-    u32 SCLRKVH;
-    u32 SCLRKVL;
-    u32 SCLRKEN;
-    u32 OCONFIG;
-    u32 OCMD;
-    u32 RESERVED1; /* 0x6C */
-    u32 OSTART_0Y;
-    u32 OSTART_1Y;
-    u32 OSTART_0U;
-    u32 OSTART_0V;
-    u32 OSTART_1U;
-    u32 OSTART_1V;
-    u32 OTILEOFF_0Y;
-    u32 OTILEOFF_1Y;
-    u32 OTILEOFF_0U;
-    u32 OTILEOFF_0V;
-    u32 OTILEOFF_1U;
-    u32 OTILEOFF_1V;
-    u32 FASTHSCALE; /* 0xA0 */
-    u32 UVSCALEV; /* 0xA4 */
-    u32 RESERVEDC[(0x200 - 0xA8) / 4]; /* 0xA8 - 0x1FC */
-    u16 Y_VCOEFS[N_VERT_Y_TAPS * N_PHASES]; /* 0x200 */
-    u16 RESERVEDD[0x100 / 2 - N_VERT_Y_TAPS * N_PHASES];
-    u16 Y_HCOEFS[N_HORIZ_Y_TAPS * N_PHASES]; /* 0x300 */
-    u16 RESERVEDE[0x200 / 2 - N_HORIZ_Y_TAPS * N_PHASES];
-    u16 UV_VCOEFS[N_VERT_UV_TAPS * N_PHASES]; /* 0x500 */
-    u16 RESERVEDF[0x100 / 2 - N_VERT_UV_TAPS * N_PHASES];
-    u16 UV_HCOEFS[N_HORIZ_UV_TAPS * N_PHASES]; /* 0x600 */
-    u16 RESERVEDG[0x100 / 2 - N_HORIZ_UV_TAPS * N_PHASES];
+	u32 OBUF_0Y;
+	u32 OBUF_1Y;
+	u32 OBUF_0U;
+	u32 OBUF_0V;
+	u32 OBUF_1U;
+	u32 OBUF_1V;
+	u32 OSTRIDE;
+	u32 YRGB_VPH;
+	u32 UV_VPH;
+	u32 HORZ_PH;
+	u32 INIT_PHS;
+	u32 DWINPOS;
+	u32 DWINSZ;
+	u32 SWIDTH;
+	u32 SWIDTHSW;
+	u32 SHEIGHT;
+	u32 YRGBSCALE;
+	u32 UVSCALE;
+	u32 OCLRC0;
+	u32 OCLRC1;
+	u32 DCLRKV;
+	u32 DCLRKM;
+	u32 SCLRKVH;
+	u32 SCLRKVL;
+	u32 SCLRKEN;
+	u32 OCONFIG;
+	u32 OCMD;
+	u32 RESERVED1; /* 0x6C */
+	u32 OSTART_0Y;
+	u32 OSTART_1Y;
+	u32 OSTART_0U;
+	u32 OSTART_0V;
+	u32 OSTART_1U;
+	u32 OSTART_1V;
+	u32 OTILEOFF_0Y;
+	u32 OTILEOFF_1Y;
+	u32 OTILEOFF_0U;
+	u32 OTILEOFF_0V;
+	u32 OTILEOFF_1U;
+	u32 OTILEOFF_1V;
+	u32 FASTHSCALE; /* 0xA0 */
+	u32 UVSCALEV; /* 0xA4 */
+	u32 RESERVEDC[(0x200 - 0xA8) / 4]; /* 0xA8 - 0x1FC */
+	u16 Y_VCOEFS[N_VERT_Y_TAPS * N_PHASES]; /* 0x200 */
+	u16 RESERVEDD[0x100 / 2 - N_VERT_Y_TAPS * N_PHASES];
+	u16 Y_HCOEFS[N_HORIZ_Y_TAPS * N_PHASES]; /* 0x300 */
+	u16 RESERVEDE[0x200 / 2 - N_HORIZ_Y_TAPS * N_PHASES];
+	u16 UV_VCOEFS[N_VERT_UV_TAPS * N_PHASES]; /* 0x500 */
+	u16 RESERVEDF[0x100 / 2 - N_VERT_UV_TAPS * N_PHASES];
+	u16 UV_HCOEFS[N_HORIZ_UV_TAPS * N_PHASES]; /* 0x600 */
+	u16 RESERVEDG[0x100 / 2 - N_HORIZ_UV_TAPS * N_PHASES];
 };
 
 struct intel_overlay {
@@ -192,7 +192,7 @@ struct intel_overlay {
 static struct overlay_registers *
 intel_overlay_map_regs(struct intel_overlay *overlay)
 {
-        drm_i915_private_t *dev_priv = overlay->dev->dev_private;
+	drm_i915_private_t *dev_priv = overlay->dev->dev_private;
 	struct overlay_registers *regs;
 
 	if (OVERLAY_NEEDS_PHYSICAL(overlay->dev))
@@ -264,7 +264,7 @@ i830_activate_pipe_a(struct drm_device *dev)
 
 	mode = drm_mode_duplicate(dev, &vesa_640x480);
 	drm_mode_set_crtcinfo(mode, CRTC_INTERLACE_HALVE_V);
-	if(!drm_crtc_helper_set_mode(&crtc->base, mode,
+	if (!drm_crtc_helper_set_mode(&crtc->base, mode,
 				       crtc->base.x, crtc->base.y,
 				       crtc->base.fb))
 		return 0;
@@ -332,7 +332,7 @@ static int intel_overlay_continue(struct intel_overlay *overlay,
 				  bool load_polyphase_filter)
 {
 	struct drm_device *dev = overlay->dev;
-        drm_i915_private_t *dev_priv = dev->dev_private;
+	drm_i915_private_t *dev_priv = dev->dev_private;
 	struct drm_i915_gem_request *request;
 	u32 flip_addr = overlay->flip_addr;
 	u32 tmp;
@@ -359,7 +359,7 @@ static int intel_overlay_continue(struct intel_overlay *overlay,
 	}
 	OUT_RING(MI_OVERLAY_FLIP | MI_OVERLAY_CONTINUE);
 	OUT_RING(flip_addr);
-        ADVANCE_LP_RING();
+	ADVANCE_LP_RING();
 
 	ret = i915_add_request(LP_RING(dev_priv), NULL, request);
 	if (ret) {
@@ -583,7 +583,7 @@ static u32 calc_swidthsw(struct drm_device *dev, u32 offset, u32 width)
 	ret = ((offset + width + mask) >> shift) - (offset >> shift);
 	if (!IS_GEN2(dev))
 		ret <<= 1;
-	ret -=1;
+	ret -= 1;
 	return ret << 2;
 }
 
@@ -817,7 +817,7 @@ static int intel_overlay_do_put_image(struct intel_overlay *overlay,
 	regs->SWIDTHSW = calc_swidthsw(overlay->dev,
 				       params->offset_Y, tmp_width);
 	regs->SHEIGHT = params->src_h;
-	regs->OBUF_0Y = new_bo->gtt_offset + params-> offset_Y;
+	regs->OBUF_0Y = new_bo->gtt_offset + params->offset_Y;
 	regs->OSTRIDE = params->stride_Y;
 
 	if (params->format & I915_OVERLAY_YUV_PLANAR) {
@@ -917,7 +917,7 @@ static void update_pfit_vscale_ratio(struct intel_overlay *overlay)
 	 * line with the intel documentation for the i965
 	 */
 	if (INTEL_INFO(dev)->gen >= 4) {
-	       	/* on i965 use the PGM reg to read out the autoscaler values */
+		/* on i965 use the PGM reg to read out the autoscaler values */
 		ratio = I915_READ(PFIT_PGM_RATIOS) >> PFIT_VERT_SCALE_SHIFT_965;
 	} else {
 		if (pfit_control & VERT_AUTO_SCALE)
@@ -1098,7 +1098,7 @@ static int intel_panel_fitter_pipe(struct drm_device *dev)
 }
 
 int intel_overlay_put_image(struct drm_device *dev, void *data,
-                            struct drm_file *file_priv)
+			    struct drm_file *file_priv)
 {
 	struct drm_intel_overlay_put_image *put_image_rec = data;
 	drm_i915_private_t *dev_priv = dev->dev_private;
@@ -1301,10 +1301,10 @@ static int check_gamma(struct drm_intel_overlay_attrs *attrs)
 }
 
 int intel_overlay_attrs(struct drm_device *dev, void *data,
-                        struct drm_file *file_priv)
+			struct drm_file *file_priv)
 {
 	struct drm_intel_overlay_attrs *attrs = data;
-        drm_i915_private_t *dev_priv = dev->dev_private;
+	drm_i915_private_t *dev_priv = dev->dev_private;
 	struct intel_overlay *overlay;
 	struct overlay_registers *regs;
 	int ret;
@@ -1393,7 +1393,7 @@ out_unlock:
 
 void intel_setup_overlay(struct drm_device *dev)
 {
-        drm_i915_private_t *dev_priv = dev->dev_private;
+	drm_i915_private_t *dev_priv = dev->dev_private;
 	struct intel_overlay *overlay;
 	struct drm_i915_gem_object *reg_bo;
 	struct overlay_registers *regs;
@@ -1421,24 +1421,24 @@ void intel_setup_overlay(struct drm_device *dev)
 		ret = i915_gem_attach_phys_object(dev, reg_bo,
 						  I915_GEM_PHYS_OVERLAY_REGS,
 						  PAGE_SIZE);
-                if (ret) {
-                        DRM_ERROR("failed to attach phys overlay regs\n");
-                        goto out_free_bo;
-                }
+		if (ret) {
+			DRM_ERROR("failed to attach phys overlay regs\n");
+			goto out_free_bo;
+		}
 		overlay->flip_addr = reg_bo->phys_obj->handle->busaddr;
 	} else {
 		ret = i915_gem_object_pin(reg_bo, PAGE_SIZE, true);
 		if (ret) {
-                        DRM_ERROR("failed to pin overlay register bo\n");
-                        goto out_free_bo;
-                }
+			DRM_ERROR("failed to pin overlay register bo\n");
+			goto out_free_bo;
+		}
 		overlay->flip_addr = reg_bo->gtt_offset;
 
 		ret = i915_gem_object_set_to_gtt_domain(reg_bo, true);
 		if (ret) {
-                        DRM_ERROR("failed to move overlay register bo into the GTT\n");
-                        goto out_unpin_bo;
-                }
+			DRM_ERROR("failed to move overlay register bo into the GTT\n");
+			goto out_unpin_bo;
+		}
 	}
 
 	/* init all values */
@@ -1525,7 +1525,7 @@ static void intel_overlay_unmap_regs_atomic(struct intel_overlay *overlay,
 struct intel_overlay_error_state *
 intel_overlay_capture_error_state(struct drm_device *dev)
 {
-        drm_i915_private_t *dev_priv = dev->dev_private;
+	drm_i915_private_t *dev_priv = dev->dev_private;
 	struct intel_overlay *overlay = dev_priv->overlay;
 	struct intel_overlay_error_state *error;
 	struct overlay_registers __iomem *regs;
diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index a9e0c7b..03500e9 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -84,7 +84,7 @@ intel_pch_panel_fitting(struct drm_device *dev,
 			if (scaled_width > scaled_height) { /* pillar */
 				width = scaled_height / mode->vdisplay;
 				if (width & 1)
-				    	width++;
+					width++;
 				x = (adjusted_mode->hdisplay - width + 1) / 2;
 				y = 0;
 				height = adjusted_mode->vdisplay;
@@ -206,7 +206,7 @@ u32 intel_panel_get_backlight(struct drm_device *dev)
 		if (IS_PINEVIEW(dev))
 			val >>= 1;
 
-		if (is_backlight_combination_mode(dev)){
+		if (is_backlight_combination_mode(dev)) {
 			u8 lbpc;
 
 			val &= ~1;
@@ -236,7 +236,7 @@ void intel_panel_set_backlight(struct drm_device *dev, u32 level)
 	if (HAS_PCH_SPLIT(dev))
 		return intel_pch_panel_set_backlight(dev, level);
 
-	if (is_backlight_combination_mode(dev)){
+	if (is_backlight_combination_mode(dev)) {
 		u32 max = intel_panel_get_max_backlight(dev);
 		u8 lbpc;
 
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 47b9b27..fc2a30e 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -1022,7 +1022,7 @@ static const struct intel_ring_buffer render_ring = {
 	.irq_get		= render_ring_get_irq,
 	.irq_put		= render_ring_put_irq,
 	.dispatch_execbuffer	= render_ring_dispatch_execbuffer,
-       .cleanup			= render_ring_cleanup,
+	.cleanup		= render_ring_cleanup,
 };
 
 /* ring buffer for bit-stream decoder */
@@ -1046,23 +1046,23 @@ static const struct intel_ring_buffer bsd_ring = {
 static void gen6_bsd_ring_write_tail(struct intel_ring_buffer *ring,
 				     u32 value)
 {
-       drm_i915_private_t *dev_priv = ring->dev->dev_private;
+	drm_i915_private_t *dev_priv = ring->dev->dev_private;
 
        /* Every tail move must follow the sequence below */
-       I915_WRITE(GEN6_BSD_SLEEP_PSMI_CONTROL,
-	       GEN6_BSD_SLEEP_PSMI_CONTROL_RC_ILDL_MESSAGE_MODIFY_MASK |
-	       GEN6_BSD_SLEEP_PSMI_CONTROL_RC_ILDL_MESSAGE_DISABLE);
-       I915_WRITE(GEN6_BSD_RNCID, 0x0);
-
-       if (wait_for((I915_READ(GEN6_BSD_SLEEP_PSMI_CONTROL) &
-                               GEN6_BSD_SLEEP_PSMI_CONTROL_IDLE_INDICATOR) == 0,
-                       50))
-               DRM_ERROR("timed out waiting for IDLE Indicator\n");
-
-       I915_WRITE_TAIL(ring, value);
-       I915_WRITE(GEN6_BSD_SLEEP_PSMI_CONTROL,
-	       GEN6_BSD_SLEEP_PSMI_CONTROL_RC_ILDL_MESSAGE_MODIFY_MASK |
-	       GEN6_BSD_SLEEP_PSMI_CONTROL_RC_ILDL_MESSAGE_ENABLE);
+	I915_WRITE(GEN6_BSD_SLEEP_PSMI_CONTROL,
+		GEN6_BSD_SLEEP_PSMI_CONTROL_RC_ILDL_MESSAGE_MODIFY_MASK |
+		GEN6_BSD_SLEEP_PSMI_CONTROL_RC_ILDL_MESSAGE_DISABLE);
+	I915_WRITE(GEN6_BSD_RNCID, 0x0);
+
+	if (wait_for((I915_READ(GEN6_BSD_SLEEP_PSMI_CONTROL) &
+		GEN6_BSD_SLEEP_PSMI_CONTROL_IDLE_INDICATOR) == 0,
+		50))
+	DRM_ERROR("timed out waiting for IDLE Indicator\n");
+
+	I915_WRITE_TAIL(ring, value);
+	I915_WRITE(GEN6_BSD_SLEEP_PSMI_CONTROL,
+		GEN6_BSD_SLEEP_PSMI_CONTROL_RC_ILDL_MESSAGE_MODIFY_MASK |
+		GEN6_BSD_SLEEP_PSMI_CONTROL_RC_ILDL_MESSAGE_ENABLE);
 }
 
 static int gen6_ring_flush(struct intel_ring_buffer *ring,
@@ -1090,18 +1090,18 @@ static int
 gen6_ring_dispatch_execbuffer(struct intel_ring_buffer *ring,
 			      u32 offset, u32 len)
 {
-       int ret;
+	int ret;
 
-       ret = intel_ring_begin(ring, 2);
-       if (ret)
-	       return ret;
+	ret = intel_ring_begin(ring, 2);
+	if (ret)
+		return ret;
 
-       intel_ring_emit(ring, MI_BATCH_BUFFER_START | MI_BATCH_NON_SECURE_I965);
-       /* bit0-7 is the length on GEN6+ */
-       intel_ring_emit(ring, offset);
-       intel_ring_advance(ring);
+	intel_ring_emit(ring, MI_BATCH_BUFFER_START | MI_BATCH_NON_SECURE_I965);
+	/* bit0-7 is the length on GEN6+ */
+	intel_ring_emit(ring, offset);
+	intel_ring_advance(ring);
 
-       return 0;
+	return 0;
 }
 
 static bool
@@ -1268,19 +1268,19 @@ static void blt_ring_cleanup(struct intel_ring_buffer *ring)
 }
 
 static const struct intel_ring_buffer gen6_blt_ring = {
-       .name			= "blt ring",
-       .id			= RING_BLT,
-       .mmio_base		= BLT_RING_BASE,
-       .size			= 32 * PAGE_SIZE,
-       .init			= blt_ring_init,
-       .write_tail		= ring_write_tail,
-       .flush			= blt_ring_flush,
-       .add_request		= gen6_add_request,
-       .get_seqno		= ring_get_seqno,
-       .irq_get			= blt_ring_get_irq,
-       .irq_put			= blt_ring_put_irq,
-       .dispatch_execbuffer	= gen6_ring_dispatch_execbuffer,
-       .cleanup			= blt_ring_cleanup,
+	.name			= "blt ring",
+	.id			= RING_BLT,
+	.mmio_base		= BLT_RING_BASE,
+	.size			= 32 * PAGE_SIZE,
+	.init			= blt_ring_init,
+	.write_tail		= ring_write_tail,
+	.flush			= blt_ring_flush,
+	.add_request		= gen6_add_request,
+	.get_seqno		= ring_get_seqno,
+	.irq_get			= blt_ring_get_irq,
+	.irq_put			= blt_ring_put_irq,
+	.dispatch_execbuffer	= gen6_ring_dispatch_execbuffer,
+	.cleanup			= blt_ring_cleanup,
 };
 
 int intel_init_render_ring_buffer(struct drm_device *dev)
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.h b/drivers/gpu/drm/i915/intel_ringbuffer.h
index 39ac2b6..600e67a 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.h
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.h
@@ -2,10 +2,10 @@
 #define _INTEL_RINGBUFFER_H_
 
 enum {
-    RCS = 0x0,
-    VCS,
-    BCS,
-    I915_NUM_RINGS,
+	RCS = 0x0,
+	VCS,
+	BCS,
+	I915_NUM_RINGS,
 };
 
 struct  intel_hw_status_page {
diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index 30fe554..aa94110 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -43,7 +43,7 @@
 #define SDVO_TV_MASK   (SDVO_OUTPUT_CVBS0 | SDVO_OUTPUT_SVID0)
 
 #define SDVO_OUTPUT_MASK (SDVO_TMDS_MASK | SDVO_RGB_MASK | SDVO_LVDS_MASK |\
-                         SDVO_TV_MASK)
+			SDVO_TV_MASK)
 
 #define IS_TV(c)	(c->output_flag & SDVO_TV_MASK)
 #define IS_TMDS(c)	(c->output_flag & SDVO_TMDS_MASK)
@@ -283,117 +283,117 @@ static const struct _sdvo_cmd_name {
 	u8 cmd;
 	const char *name;
 } sdvo_cmd_names[] = {
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_RESET),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_DEVICE_CAPS),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_FIRMWARE_REV),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_TRAINED_INPUTS),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_ACTIVE_OUTPUTS),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_ACTIVE_OUTPUTS),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_IN_OUT_MAP),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_IN_OUT_MAP),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_ATTACHED_DISPLAYS),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HOT_PLUG_SUPPORT),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_ACTIVE_HOT_PLUG),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_ACTIVE_HOT_PLUG),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_INTERRUPT_EVENT_SOURCE),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_TARGET_INPUT),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_TARGET_OUTPUT),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_INPUT_TIMINGS_PART1),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_INPUT_TIMINGS_PART2),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_INPUT_TIMINGS_PART1),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_INPUT_TIMINGS_PART2),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_INPUT_TIMINGS_PART1),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_OUTPUT_TIMINGS_PART1),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_OUTPUT_TIMINGS_PART2),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_OUTPUT_TIMINGS_PART1),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_OUTPUT_TIMINGS_PART2),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_CREATE_PREFERRED_INPUT_TIMING),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_PREFERRED_INPUT_TIMING_PART1),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_PREFERRED_INPUT_TIMING_PART2),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_INPUT_PIXEL_CLOCK_RANGE),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_OUTPUT_PIXEL_CLOCK_RANGE),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SUPPORTED_CLOCK_RATE_MULTS),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_CLOCK_RATE_MULT),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_CLOCK_RATE_MULT),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SUPPORTED_TV_FORMATS),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_TV_FORMAT),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_TV_FORMAT),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SUPPORTED_POWER_STATES),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_POWER_STATE),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_ENCODER_POWER_STATE),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_DISPLAY_POWER_STATE),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_CONTROL_BUS_SWITCH),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SDTV_RESOLUTION_SUPPORT),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SCALED_HDTV_RESOLUTION_SUPPORT),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SUPPORTED_ENHANCEMENTS),
-
-    /* Add the op code for SDVO enhancements */
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_HPOS),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HPOS),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_HPOS),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_VPOS),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_VPOS),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_VPOS),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_SATURATION),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SATURATION),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_SATURATION),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_HUE),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HUE),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_HUE),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_CONTRAST),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_CONTRAST),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_CONTRAST),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_BRIGHTNESS),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_BRIGHTNESS),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_BRIGHTNESS),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_OVERSCAN_H),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_OVERSCAN_H),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_OVERSCAN_H),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_OVERSCAN_V),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_OVERSCAN_V),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_OVERSCAN_V),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_FLICKER_FILTER),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_FLICKER_FILTER),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_FLICKER_FILTER),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_FLICKER_FILTER_ADAPTIVE),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_FLICKER_FILTER_ADAPTIVE),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_FLICKER_FILTER_ADAPTIVE),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_FLICKER_FILTER_2D),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_FLICKER_FILTER_2D),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_FLICKER_FILTER_2D),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_SHARPNESS),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SHARPNESS),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_SHARPNESS),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_DOT_CRAWL),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_DOT_CRAWL),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_TV_CHROMA_FILTER),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_TV_CHROMA_FILTER),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_TV_CHROMA_FILTER),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_TV_LUMA_FILTER),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_TV_LUMA_FILTER),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_TV_LUMA_FILTER),
-
-    /* HDMI op code */
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SUPP_ENCODE),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_ENCODE),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_ENCODE),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_PIXEL_REPLI),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_PIXEL_REPLI),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_COLORIMETRY_CAP),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_COLORIMETRY),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_COLORIMETRY),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_AUDIO_ENCRYPT_PREFER),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_AUDIO_STAT),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_AUDIO_STAT),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HBUF_INDEX),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_HBUF_INDEX),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HBUF_INFO),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HBUF_AV_SPLIT),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_HBUF_AV_SPLIT),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HBUF_TXRATE),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_HBUF_TXRATE),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_HBUF_DATA),
-    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HBUF_DATA),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_RESET),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_DEVICE_CAPS),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_FIRMWARE_REV),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_TRAINED_INPUTS),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_ACTIVE_OUTPUTS),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_ACTIVE_OUTPUTS),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_IN_OUT_MAP),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_IN_OUT_MAP),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_ATTACHED_DISPLAYS),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HOT_PLUG_SUPPORT),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_ACTIVE_HOT_PLUG),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_ACTIVE_HOT_PLUG),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_INTERRUPT_EVENT_SOURCE),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_TARGET_INPUT),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_TARGET_OUTPUT),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_INPUT_TIMINGS_PART1),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_INPUT_TIMINGS_PART2),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_INPUT_TIMINGS_PART1),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_INPUT_TIMINGS_PART2),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_INPUT_TIMINGS_PART1),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_OUTPUT_TIMINGS_PART1),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_OUTPUT_TIMINGS_PART2),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_OUTPUT_TIMINGS_PART1),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_OUTPUT_TIMINGS_PART2),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_CREATE_PREFERRED_INPUT_TIMING),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_PREFERRED_INPUT_TIMING_PART1),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_PREFERRED_INPUT_TIMING_PART2),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_INPUT_PIXEL_CLOCK_RANGE),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_OUTPUT_PIXEL_CLOCK_RANGE),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SUPPORTED_CLOCK_RATE_MULTS),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_CLOCK_RATE_MULT),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_CLOCK_RATE_MULT),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SUPPORTED_TV_FORMATS),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_TV_FORMAT),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_TV_FORMAT),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SUPPORTED_POWER_STATES),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_POWER_STATE),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_ENCODER_POWER_STATE),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_DISPLAY_POWER_STATE),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_CONTROL_BUS_SWITCH),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SDTV_RESOLUTION_SUPPORT),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SCALED_HDTV_RESOLUTION_SUPPORT),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SUPPORTED_ENHANCEMENTS),
+
+	/* Add the op code for SDVO enhancements */
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_HPOS),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HPOS),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_HPOS),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_VPOS),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_VPOS),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_VPOS),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_SATURATION),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SATURATION),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_SATURATION),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_HUE),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HUE),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_HUE),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_CONTRAST),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_CONTRAST),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_CONTRAST),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_BRIGHTNESS),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_BRIGHTNESS),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_BRIGHTNESS),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_OVERSCAN_H),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_OVERSCAN_H),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_OVERSCAN_H),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_OVERSCAN_V),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_OVERSCAN_V),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_OVERSCAN_V),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_FLICKER_FILTER),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_FLICKER_FILTER),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_FLICKER_FILTER),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_FLICKER_FILTER_ADAPTIVE),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_FLICKER_FILTER_ADAPTIVE),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_FLICKER_FILTER_ADAPTIVE),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_FLICKER_FILTER_2D),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_FLICKER_FILTER_2D),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_FLICKER_FILTER_2D),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_SHARPNESS),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SHARPNESS),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_SHARPNESS),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_DOT_CRAWL),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_DOT_CRAWL),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_TV_CHROMA_FILTER),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_TV_CHROMA_FILTER),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_TV_CHROMA_FILTER),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_TV_LUMA_FILTER),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_TV_LUMA_FILTER),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_TV_LUMA_FILTER),
+
+	/* HDMI op code */
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SUPP_ENCODE),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_ENCODE),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_ENCODE),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_PIXEL_REPLI),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_PIXEL_REPLI),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_COLORIMETRY_CAP),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_COLORIMETRY),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_COLORIMETRY),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_AUDIO_ENCRYPT_PREFER),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_AUDIO_STAT),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_AUDIO_STAT),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HBUF_INDEX),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_HBUF_INDEX),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HBUF_INFO),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HBUF_AV_SPLIT),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_HBUF_AV_SPLIT),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HBUF_TXRATE),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_HBUF_TXRATE),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_HBUF_DATA),
+	SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HBUF_DATA),
 };
 
 #define IS_SDVOB(reg)	(reg == SDVOB || reg == PCH_SDVOB)
@@ -2313,7 +2313,7 @@ static bool intel_sdvo_tv_create_property(struct intel_sdvo *intel_sdvo,
 		DRM_DEBUG_KMS(#name ": max %d, default %d, current %d\n", \
 			      data_value[0], data_value[1], response); \
 	} \
-} while(0)
+} while (0)
 
 static bool
 intel_sdvo_create_enhance_property_tv(struct intel_sdvo *intel_sdvo,
@@ -2480,7 +2480,7 @@ static bool intel_sdvo_create_enhance_property(struct intel_sdvo *intel_sdvo,
 
 	if (IS_TV(intel_sdvo_connector))
 		return intel_sdvo_create_enhance_property_tv(intel_sdvo, intel_sdvo_connector, enhancements.reply);
-	else if(IS_LVDS(intel_sdvo_connector))
+	else if (IS_LVDS(intel_sdvo_connector))
 		return intel_sdvo_create_enhance_property_lvds(intel_sdvo, intel_sdvo_connector, enhancements.reply);
 	else
 		return true;
diff --git a/drivers/gpu/drm/i915/intel_sdvo_regs.h b/drivers/gpu/drm/i915/intel_sdvo_regs.h
index 4f4e23b..4aa6f34 100644
--- a/drivers/gpu/drm/i915/intel_sdvo_regs.h
+++ b/drivers/gpu/drm/i915/intel_sdvo_regs.h
@@ -46,63 +46,63 @@
 #define SDVO_OUTPUT_LAST    (14)
 
 struct intel_sdvo_caps {
-    u8 vendor_id;
-    u8 device_id;
-    u8 device_rev_id;
-    u8 sdvo_version_major;
-    u8 sdvo_version_minor;
-    unsigned int sdvo_inputs_mask:2;
-    unsigned int smooth_scaling:1;
-    unsigned int sharp_scaling:1;
-    unsigned int up_scaling:1;
-    unsigned int down_scaling:1;
-    unsigned int stall_support:1;
-    unsigned int pad:1;
-    u16 output_flags;
+	u8 vendor_id;
+	u8 device_id;
+	u8 device_rev_id;
+	u8 sdvo_version_major;
+	u8 sdvo_version_minor;
+	unsigned int sdvo_inputs_mask:2;
+	unsigned int smooth_scaling:1;
+	unsigned int sharp_scaling:1;
+	unsigned int up_scaling:1;
+	unsigned int down_scaling:1;
+	unsigned int stall_support:1;
+	unsigned int pad:1;
+	u16 output_flags;
 } __attribute__((packed));
 
 /** This matches the EDID DTD structure, more or less */
 struct intel_sdvo_dtd {
-    struct {
-	u16 clock;		/**< pixel clock, in 10kHz units */
-	u8 h_active;		/**< lower 8 bits (pixels) */
-	u8 h_blank;		/**< lower 8 bits (pixels) */
-	u8 h_high;		/**< upper 4 bits each h_active, h_blank */
-	u8 v_active;		/**< lower 8 bits (lines) */
-	u8 v_blank;		/**< lower 8 bits (lines) */
-	u8 v_high;		/**< upper 4 bits each v_active, v_blank */
-    } part1;
-
-    struct {
-	u8 h_sync_off;	/**< lower 8 bits, from hblank start */
-	u8 h_sync_width;	/**< lower 8 bits (pixels) */
-	/** lower 4 bits each vsync offset, vsync width */
-	u8 v_sync_off_width;
-	/**
-	 * 2 high bits of hsync offset, 2 high bits of hsync width,
-	 * bits 4-5 of vsync offset, and 2 high bits of vsync width.
-	 */
-	u8 sync_off_width_high;
-	u8 dtd_flags;
-	u8 sdvo_flags;
-	/** bits 6-7 of vsync offset at bits 6-7 */
-	u8 v_sync_off_high;
-	u8 reserved;
-    } part2;
+	struct {
+		u16 clock;	/**< pixel clock, in 10kHz units */
+		u8 h_active;	/**< lower 8 bits (pixels) */
+		u8 h_blank;	/**< lower 8 bits (pixels) */
+		u8 h_high;	/**< upper 4 bits each h_active, h_blank */
+		u8 v_active;	/**< lower 8 bits (lines) */
+		u8 v_blank;	/**< lower 8 bits (lines) */
+		u8 v_high;	/**< upper 4 bits each v_active, v_blank */
+	} part1;
+
+	struct {
+		u8 h_sync_off;	/**< lower 8 bits, from hblank start */
+		u8 h_sync_width;	/**< lower 8 bits (pixels) */
+		/** lower 4 bits each vsync offset, vsync width */
+		u8 v_sync_off_width;
+		/**
+		* 2 high bits of hsync offset, 2 high bits of hsync width,
+		* bits 4-5 of vsync offset, and 2 high bits of vsync width.
+		*/
+		u8 sync_off_width_high;
+		u8 dtd_flags;
+		u8 sdvo_flags;
+		/** bits 6-7 of vsync offset at bits 6-7 */
+		u8 v_sync_off_high;
+		u8 reserved;
+	} part2;
 } __attribute__((packed));
 
 struct intel_sdvo_pixel_clock_range {
-    u16 min;			/**< pixel clock, in 10kHz units */
-    u16 max;			/**< pixel clock, in 10kHz units */
+	u16 min;	/**< pixel clock, in 10kHz units */
+	u16 max;	/**< pixel clock, in 10kHz units */
 } __attribute__((packed));
 
 struct intel_sdvo_preferred_input_timing_args {
-    u16 clock;
-    u16 width;
-    u16 height;
-    u8	interlace:1;
-    u8	scaled:1;
-    u8	pad:6;
+	u16 clock;
+	u16 width;
+	u16 height;
+	u8	interlace:1;
+	u8	scaled:1;
+	u8	pad:6;
 } __attribute__((packed));
 
 /* I2C registers for SDVO */
@@ -154,9 +154,9 @@ struct intel_sdvo_preferred_input_timing_args {
  */
 #define SDVO_CMD_GET_TRAINED_INPUTS			0x03
 struct intel_sdvo_get_trained_inputs_response {
-    unsigned int input0_trained:1;
-    unsigned int input1_trained:1;
-    unsigned int pad:6;
+	unsigned int input0_trained:1;
+	unsigned int input1_trained:1;
+	unsigned int pad:6;
 } __attribute__((packed));
 
 /** Returns a struct intel_sdvo_output_flags of active outputs. */
@@ -177,7 +177,7 @@ struct intel_sdvo_get_trained_inputs_response {
  */
 #define SDVO_CMD_GET_IN_OUT_MAP				0x06
 struct intel_sdvo_in_out_map {
-    u16 in0, in1;
+	u16 in0, in1;
 };
 
 /**
@@ -210,10 +210,10 @@ struct intel_sdvo_in_out_map {
 
 #define SDVO_CMD_GET_INTERRUPT_EVENT_SOURCE		0x0f
 struct intel_sdvo_get_interrupt_event_source_response {
-    u16 interrupt_status;
-    unsigned int ambient_light_interrupt:1;
-    unsigned int hdmi_audio_encrypt_change:1;
-    unsigned int pad:6;
+	u16 interrupt_status;
+	unsigned int ambient_light_interrupt:1;
+	unsigned int hdmi_audio_encrypt_change:1;
+	unsigned int pad:6;
 } __attribute__((packed));
 
 /**
@@ -225,8 +225,8 @@ struct intel_sdvo_get_interrupt_event_source_response {
  */
 #define SDVO_CMD_SET_TARGET_INPUT			0x10
 struct intel_sdvo_set_target_input_args {
-    unsigned int target_1:1;
-    unsigned int pad:7;
+	unsigned int target_1:1;
+	unsigned int pad:7;
 } __attribute__((packed));
 
 /**
@@ -314,57 +314,57 @@ struct intel_sdvo_set_target_input_args {
 #define SDVO_CMD_GET_SUPPORTED_TV_FORMATS		0x27
 /** 6 bytes of bit flags for TV formats shared by all TV format functions */
 struct intel_sdvo_tv_format {
-    unsigned int ntsc_m:1;
-    unsigned int ntsc_j:1;
-    unsigned int ntsc_443:1;
-    unsigned int pal_b:1;
-    unsigned int pal_d:1;
-    unsigned int pal_g:1;
-    unsigned int pal_h:1;
-    unsigned int pal_i:1;
-
-    unsigned int pal_m:1;
-    unsigned int pal_n:1;
-    unsigned int pal_nc:1;
-    unsigned int pal_60:1;
-    unsigned int secam_b:1;
-    unsigned int secam_d:1;
-    unsigned int secam_g:1;
-    unsigned int secam_k:1;
-
-    unsigned int secam_k1:1;
-    unsigned int secam_l:1;
-    unsigned int secam_60:1;
-    unsigned int hdtv_std_smpte_240m_1080i_59:1;
-    unsigned int hdtv_std_smpte_240m_1080i_60:1;
-    unsigned int hdtv_std_smpte_260m_1080i_59:1;
-    unsigned int hdtv_std_smpte_260m_1080i_60:1;
-    unsigned int hdtv_std_smpte_274m_1080i_50:1;
-
-    unsigned int hdtv_std_smpte_274m_1080i_59:1;
-    unsigned int hdtv_std_smpte_274m_1080i_60:1;
-    unsigned int hdtv_std_smpte_274m_1080p_23:1;
-    unsigned int hdtv_std_smpte_274m_1080p_24:1;
-    unsigned int hdtv_std_smpte_274m_1080p_25:1;
-    unsigned int hdtv_std_smpte_274m_1080p_29:1;
-    unsigned int hdtv_std_smpte_274m_1080p_30:1;
-    unsigned int hdtv_std_smpte_274m_1080p_50:1;
-
-    unsigned int hdtv_std_smpte_274m_1080p_59:1;
-    unsigned int hdtv_std_smpte_274m_1080p_60:1;
-    unsigned int hdtv_std_smpte_295m_1080i_50:1;
-    unsigned int hdtv_std_smpte_295m_1080p_50:1;
-    unsigned int hdtv_std_smpte_296m_720p_59:1;
-    unsigned int hdtv_std_smpte_296m_720p_60:1;
-    unsigned int hdtv_std_smpte_296m_720p_50:1;
-    unsigned int hdtv_std_smpte_293m_480p_59:1;
-
-    unsigned int hdtv_std_smpte_170m_480i_59:1;
-    unsigned int hdtv_std_iturbt601_576i_50:1;
-    unsigned int hdtv_std_iturbt601_576p_50:1;
-    unsigned int hdtv_std_eia_7702a_480i_60:1;
-    unsigned int hdtv_std_eia_7702a_480p_60:1;
-    unsigned int pad:3;
+	unsigned int ntsc_m:1;
+	unsigned int ntsc_j:1;
+	unsigned int ntsc_443:1;
+	unsigned int pal_b:1;
+	unsigned int pal_d:1;
+	unsigned int pal_g:1;
+	unsigned int pal_h:1;
+	unsigned int pal_i:1;
+
+	unsigned int pal_m:1;
+	unsigned int pal_n:1;
+	unsigned int pal_nc:1;
+	unsigned int pal_60:1;
+	unsigned int secam_b:1;
+	unsigned int secam_d:1;
+	unsigned int secam_g:1;
+	unsigned int secam_k:1;
+
+	unsigned int secam_k1:1;
+	unsigned int secam_l:1;
+	unsigned int secam_60:1;
+	unsigned int hdtv_std_smpte_240m_1080i_59:1;
+	unsigned int hdtv_std_smpte_240m_1080i_60:1;
+	unsigned int hdtv_std_smpte_260m_1080i_59:1;
+	unsigned int hdtv_std_smpte_260m_1080i_60:1;
+	unsigned int hdtv_std_smpte_274m_1080i_50:1;
+
+	unsigned int hdtv_std_smpte_274m_1080i_59:1;
+	unsigned int hdtv_std_smpte_274m_1080i_60:1;
+	unsigned int hdtv_std_smpte_274m_1080p_23:1;
+	unsigned int hdtv_std_smpte_274m_1080p_24:1;
+	unsigned int hdtv_std_smpte_274m_1080p_25:1;
+	unsigned int hdtv_std_smpte_274m_1080p_29:1;
+	unsigned int hdtv_std_smpte_274m_1080p_30:1;
+	unsigned int hdtv_std_smpte_274m_1080p_50:1;
+
+	unsigned int hdtv_std_smpte_274m_1080p_59:1;
+	unsigned int hdtv_std_smpte_274m_1080p_60:1;
+	unsigned int hdtv_std_smpte_295m_1080i_50:1;
+	unsigned int hdtv_std_smpte_295m_1080p_50:1;
+	unsigned int hdtv_std_smpte_296m_720p_59:1;
+	unsigned int hdtv_std_smpte_296m_720p_60:1;
+	unsigned int hdtv_std_smpte_296m_720p_50:1;
+	unsigned int hdtv_std_smpte_293m_480p_59:1;
+
+	unsigned int hdtv_std_smpte_170m_480i_59:1;
+	unsigned int hdtv_std_iturbt601_576i_50:1;
+	unsigned int hdtv_std_iturbt601_576p_50:1;
+	unsigned int hdtv_std_eia_7702a_480i_60:1;
+	unsigned int hdtv_std_eia_7702a_480p_60:1;
+	unsigned int pad:3;
 } __attribute__((packed));
 
 #define SDVO_CMD_GET_TV_FORMAT				0x28
@@ -374,53 +374,53 @@ struct intel_sdvo_tv_format {
 /** Returns the resolutiosn that can be used with the given TV format */
 #define SDVO_CMD_GET_SDTV_RESOLUTION_SUPPORT		0x83
 struct intel_sdvo_sdtv_resolution_request {
-    unsigned int ntsc_m:1;
-    unsigned int ntsc_j:1;
-    unsigned int ntsc_443:1;
-    unsigned int pal_b:1;
-    unsigned int pal_d:1;
-    unsigned int pal_g:1;
-    unsigned int pal_h:1;
-    unsigned int pal_i:1;
-
-    unsigned int pal_m:1;
-    unsigned int pal_n:1;
-    unsigned int pal_nc:1;
-    unsigned int pal_60:1;
-    unsigned int secam_b:1;
-    unsigned int secam_d:1;
-    unsigned int secam_g:1;
-    unsigned int secam_k:1;
-
-    unsigned int secam_k1:1;
-    unsigned int secam_l:1;
-    unsigned int secam_60:1;
-    unsigned int pad:5;
+	unsigned int ntsc_m:1;
+	unsigned int ntsc_j:1;
+	unsigned int ntsc_443:1;
+	unsigned int pal_b:1;
+	unsigned int pal_d:1;
+	unsigned int pal_g:1;
+	unsigned int pal_h:1;
+	unsigned int pal_i:1;
+
+	unsigned int pal_m:1;
+	unsigned int pal_n:1;
+	unsigned int pal_nc:1;
+	unsigned int pal_60:1;
+	unsigned int secam_b:1;
+	unsigned int secam_d:1;
+	unsigned int secam_g:1;
+	unsigned int secam_k:1;
+
+	unsigned int secam_k1:1;
+	unsigned int secam_l:1;
+	unsigned int secam_60:1;
+	unsigned int pad:5;
 } __attribute__((packed));
 
 struct intel_sdvo_sdtv_resolution_reply {
-    unsigned int res_320x200:1;
-    unsigned int res_320x240:1;
-    unsigned int res_400x300:1;
-    unsigned int res_640x350:1;
-    unsigned int res_640x400:1;
-    unsigned int res_640x480:1;
-    unsigned int res_704x480:1;
-    unsigned int res_704x576:1;
-
-    unsigned int res_720x350:1;
-    unsigned int res_720x400:1;
-    unsigned int res_720x480:1;
-    unsigned int res_720x540:1;
-    unsigned int res_720x576:1;
-    unsigned int res_768x576:1;
-    unsigned int res_800x600:1;
-    unsigned int res_832x624:1;
-
-    unsigned int res_920x766:1;
-    unsigned int res_1024x768:1;
-    unsigned int res_1280x1024:1;
-    unsigned int pad:5;
+	unsigned int res_320x200:1;
+	unsigned int res_320x240:1;
+	unsigned int res_400x300:1;
+	unsigned int res_640x350:1;
+	unsigned int res_640x400:1;
+	unsigned int res_640x480:1;
+	unsigned int res_704x480:1;
+	unsigned int res_704x576:1;
+
+	unsigned int res_720x350:1;
+	unsigned int res_720x400:1;
+	unsigned int res_720x480:1;
+	unsigned int res_720x540:1;
+	unsigned int res_720x576:1;
+	unsigned int res_768x576:1;
+	unsigned int res_800x600:1;
+	unsigned int res_832x624:1;
+
+	unsigned int res_920x766:1;
+	unsigned int res_1024x768:1;
+	unsigned int res_1280x1024:1;
+	unsigned int pad:5;
 } __attribute__((packed));
 
 /* Get supported resolution with squire pixel aspect ratio that can be
@@ -428,90 +428,90 @@ struct intel_sdvo_sdtv_resolution_reply {
 #define SDVO_CMD_GET_SCALED_HDTV_RESOLUTION_SUPPORT		0x85
 
 struct intel_sdvo_hdtv_resolution_request {
-    unsigned int hdtv_std_smpte_240m_1080i_59:1;
-    unsigned int hdtv_std_smpte_240m_1080i_60:1;
-    unsigned int hdtv_std_smpte_260m_1080i_59:1;
-    unsigned int hdtv_std_smpte_260m_1080i_60:1;
-    unsigned int hdtv_std_smpte_274m_1080i_50:1;
-    unsigned int hdtv_std_smpte_274m_1080i_59:1;
-    unsigned int hdtv_std_smpte_274m_1080i_60:1;
-    unsigned int hdtv_std_smpte_274m_1080p_23:1;
-
-    unsigned int hdtv_std_smpte_274m_1080p_24:1;
-    unsigned int hdtv_std_smpte_274m_1080p_25:1;
-    unsigned int hdtv_std_smpte_274m_1080p_29:1;
-    unsigned int hdtv_std_smpte_274m_1080p_30:1;
-    unsigned int hdtv_std_smpte_274m_1080p_50:1;
-    unsigned int hdtv_std_smpte_274m_1080p_59:1;
-    unsigned int hdtv_std_smpte_274m_1080p_60:1;
-    unsigned int hdtv_std_smpte_295m_1080i_50:1;
-
-    unsigned int hdtv_std_smpte_295m_1080p_50:1;
-    unsigned int hdtv_std_smpte_296m_720p_59:1;
-    unsigned int hdtv_std_smpte_296m_720p_60:1;
-    unsigned int hdtv_std_smpte_296m_720p_50:1;
-    unsigned int hdtv_std_smpte_293m_480p_59:1;
-    unsigned int hdtv_std_smpte_170m_480i_59:1;
-    unsigned int hdtv_std_iturbt601_576i_50:1;
-    unsigned int hdtv_std_iturbt601_576p_50:1;
-
-    unsigned int hdtv_std_eia_7702a_480i_60:1;
-    unsigned int hdtv_std_eia_7702a_480p_60:1;
-    unsigned int pad:6;
+	unsigned int hdtv_std_smpte_240m_1080i_59:1;
+	unsigned int hdtv_std_smpte_240m_1080i_60:1;
+	unsigned int hdtv_std_smpte_260m_1080i_59:1;
+	unsigned int hdtv_std_smpte_260m_1080i_60:1;
+	unsigned int hdtv_std_smpte_274m_1080i_50:1;
+	unsigned int hdtv_std_smpte_274m_1080i_59:1;
+	unsigned int hdtv_std_smpte_274m_1080i_60:1;
+	unsigned int hdtv_std_smpte_274m_1080p_23:1;
+
+	unsigned int hdtv_std_smpte_274m_1080p_24:1;
+	unsigned int hdtv_std_smpte_274m_1080p_25:1;
+	unsigned int hdtv_std_smpte_274m_1080p_29:1;
+	unsigned int hdtv_std_smpte_274m_1080p_30:1;
+	unsigned int hdtv_std_smpte_274m_1080p_50:1;
+	unsigned int hdtv_std_smpte_274m_1080p_59:1;
+	unsigned int hdtv_std_smpte_274m_1080p_60:1;
+	unsigned int hdtv_std_smpte_295m_1080i_50:1;
+
+	unsigned int hdtv_std_smpte_295m_1080p_50:1;
+	unsigned int hdtv_std_smpte_296m_720p_59:1;
+	unsigned int hdtv_std_smpte_296m_720p_60:1;
+	unsigned int hdtv_std_smpte_296m_720p_50:1;
+	unsigned int hdtv_std_smpte_293m_480p_59:1;
+	unsigned int hdtv_std_smpte_170m_480i_59:1;
+	unsigned int hdtv_std_iturbt601_576i_50:1;
+	unsigned int hdtv_std_iturbt601_576p_50:1;
+
+	unsigned int hdtv_std_eia_7702a_480i_60:1;
+	unsigned int hdtv_std_eia_7702a_480p_60:1;
+	unsigned int pad:6;
 } __attribute__((packed));
 
 struct intel_sdvo_hdtv_resolution_reply {
-    unsigned int res_640x480:1;
-    unsigned int res_800x600:1;
-    unsigned int res_1024x768:1;
-    unsigned int res_1280x960:1;
-    unsigned int res_1400x1050:1;
-    unsigned int res_1600x1200:1;
-    unsigned int res_1920x1440:1;
-    unsigned int res_2048x1536:1;
-
-    unsigned int res_2560x1920:1;
-    unsigned int res_3200x2400:1;
-    unsigned int res_3840x2880:1;
-    unsigned int pad1:5;
-
-    unsigned int res_848x480:1;
-    unsigned int res_1064x600:1;
-    unsigned int res_1280x720:1;
-    unsigned int res_1360x768:1;
-    unsigned int res_1704x960:1;
-    unsigned int res_1864x1050:1;
-    unsigned int res_1920x1080:1;
-    unsigned int res_2128x1200:1;
-
-    unsigned int res_2560x1400:1;
-    unsigned int res_2728x1536:1;
-    unsigned int res_3408x1920:1;
-    unsigned int res_4264x2400:1;
-    unsigned int res_5120x2880:1;
-    unsigned int pad2:3;
-
-    unsigned int res_768x480:1;
-    unsigned int res_960x600:1;
-    unsigned int res_1152x720:1;
-    unsigned int res_1124x768:1;
-    unsigned int res_1536x960:1;
-    unsigned int res_1680x1050:1;
-    unsigned int res_1728x1080:1;
-    unsigned int res_1920x1200:1;
-
-    unsigned int res_2304x1440:1;
-    unsigned int res_2456x1536:1;
-    unsigned int res_3072x1920:1;
-    unsigned int res_3840x2400:1;
-    unsigned int res_4608x2880:1;
-    unsigned int pad3:3;
-
-    unsigned int res_1280x1024:1;
-    unsigned int pad4:7;
-
-    unsigned int res_1280x768:1;
-    unsigned int pad5:7;
+	unsigned int res_640x480:1;
+	unsigned int res_800x600:1;
+	unsigned int res_1024x768:1;
+	unsigned int res_1280x960:1;
+	unsigned int res_1400x1050:1;
+	unsigned int res_1600x1200:1;
+	unsigned int res_1920x1440:1;
+	unsigned int res_2048x1536:1;
+
+	unsigned int res_2560x1920:1;
+	unsigned int res_3200x2400:1;
+	unsigned int res_3840x2880:1;
+	unsigned int pad1:5;
+
+	unsigned int res_848x480:1;
+	unsigned int res_1064x600:1;
+	unsigned int res_1280x720:1;
+	unsigned int res_1360x768:1;
+	unsigned int res_1704x960:1;
+	unsigned int res_1864x1050:1;
+	unsigned int res_1920x1080:1;
+	unsigned int res_2128x1200:1;
+
+	unsigned int res_2560x1400:1;
+	unsigned int res_2728x1536:1;
+	unsigned int res_3408x1920:1;
+	unsigned int res_4264x2400:1;
+	unsigned int res_5120x2880:1;
+	unsigned int pad2:3;
+
+	unsigned int res_768x480:1;
+	unsigned int res_960x600:1;
+	unsigned int res_1152x720:1;
+	unsigned int res_1124x768:1;
+	unsigned int res_1536x960:1;
+	unsigned int res_1680x1050:1;
+	unsigned int res_1728x1080:1;
+	unsigned int res_1920x1200:1;
+
+	unsigned int res_2304x1440:1;
+	unsigned int res_2456x1536:1;
+	unsigned int res_3072x1920:1;
+	unsigned int res_3840x2400:1;
+	unsigned int res_4608x2880:1;
+	unsigned int pad3:3;
+
+	unsigned int res_1280x1024:1;
+	unsigned int pad4:7;
+
+	unsigned int res_1280x768:1;
+	unsigned int pad5:7;
 } __attribute__((packed));
 
 /* Get supported power state returns info for encoder and monitor, rely on
@@ -539,25 +539,25 @@ struct intel_sdvo_hdtv_resolution_reply {
  * The high fields are bits 8:9 of the 10-bit values.
  */
 struct sdvo_panel_power_sequencing {
-    u8 t0;
-    u8 t1;
-    u8 t2;
-    u8 t3;
-    u8 t4;
-
-    unsigned int t0_high:2;
-    unsigned int t1_high:2;
-    unsigned int t2_high:2;
-    unsigned int t3_high:2;
-
-    unsigned int t4_high:2;
-    unsigned int pad:6;
+	u8 t0;
+	u8 t1;
+	u8 t2;
+	u8 t3;
+	u8 t4;
+
+	unsigned int t0_high:2;
+	unsigned int t1_high:2;
+	unsigned int t2_high:2;
+	unsigned int t3_high:2;
+
+	unsigned int t4_high:2;
+	unsigned int pad:6;
 } __attribute__((packed));
 
 #define SDVO_CMD_GET_MAX_BACKLIGHT_LEVEL		0x30
 struct sdvo_max_backlight_reply {
-    u8 max_value;
-    u8 default_value;
+	u8 max_value;
+	u8 default_value;
 } __attribute__((packed));
 
 #define SDVO_CMD_GET_BACKLIGHT_LEVEL			0x31
@@ -565,16 +565,16 @@ struct sdvo_max_backlight_reply {
 
 #define SDVO_CMD_GET_AMBIENT_LIGHT			0x33
 struct sdvo_get_ambient_light_reply {
-    u16 trip_low;
-    u16 trip_high;
-    u16 value;
+	u16 trip_low;
+	u16 trip_high;
+	u16 value;
 } __attribute__((packed));
 #define SDVO_CMD_SET_AMBIENT_LIGHT			0x34
 struct sdvo_set_ambient_light_reply {
-    u16 trip_low;
-    u16 trip_high;
-    unsigned int enable:1;
-    unsigned int pad:7;
+	u16 trip_low;
+	u16 trip_high;
+	unsigned int enable:1;
+	unsigned int pad:7;
 } __attribute__((packed));
 
 /* Set display power state */
@@ -586,23 +586,23 @@ struct sdvo_set_ambient_light_reply {
 
 #define SDVO_CMD_GET_SUPPORTED_ENHANCEMENTS		0x84
 struct intel_sdvo_enhancements_reply {
-    unsigned int flicker_filter:1;
-    unsigned int flicker_filter_adaptive:1;
-    unsigned int flicker_filter_2d:1;
-    unsigned int saturation:1;
-    unsigned int hue:1;
-    unsigned int brightness:1;
-    unsigned int contrast:1;
-    unsigned int overscan_h:1;
-
-    unsigned int overscan_v:1;
-    unsigned int hpos:1;
-    unsigned int vpos:1;
-    unsigned int sharpness:1;
-    unsigned int dot_crawl:1;
-    unsigned int dither:1;
-    unsigned int tv_chroma_filter:1;
-    unsigned int tv_luma_filter:1;
+	unsigned int flicker_filter:1;
+	unsigned int flicker_filter_adaptive:1;
+	unsigned int flicker_filter_2d:1;
+	unsigned int saturation:1;
+	unsigned int hue:1;
+	unsigned int brightness:1;
+	unsigned int contrast:1;
+	unsigned int overscan_h:1;
+
+	unsigned int overscan_v:1;
+	unsigned int hpos:1;
+	unsigned int vpos:1;
+	unsigned int sharpness:1;
+	unsigned int dot_crawl:1;
+	unsigned int dither:1;
+	unsigned int tv_chroma_filter:1;
+	unsigned int tv_luma_filter:1;
 } __attribute__((packed));
 
 /* Picture enhancement limits below are dependent on the current TV format,
@@ -623,8 +623,8 @@ struct intel_sdvo_enhancements_reply {
 #define SDVO_CMD_GET_MAX_TV_CHROMA_FILTER		0x74
 #define SDVO_CMD_GET_MAX_TV_LUMA_FILTER			0x77
 struct intel_sdvo_enhancement_limits_reply {
-    u16 max_value;
-    u16 default_value;
+	u16 max_value;
+	u16 default_value;
 } __attribute__((packed));
 
 #define SDVO_CMD_GET_LVDS_PANEL_INFORMATION		0x7f
@@ -665,8 +665,8 @@ struct intel_sdvo_enhancement_limits_reply {
 #define SDVO_CMD_GET_TV_LUMA_FILTER			0x78
 #define SDVO_CMD_SET_TV_LUMA_FILTER			0x79
 struct intel_sdvo_enhancements_arg {
-    u16 value;
-}__attribute__((packed));
+	u16 value;
+} __attribute__((packed));
 
 #define SDVO_CMD_GET_DOT_CRAWL				0x70
 #define SDVO_CMD_SET_DOT_CRAWL				0x71
@@ -717,7 +717,7 @@ struct intel_sdvo_enhancements_arg {
 #define SDVO_CMD_GET_AUDIO_TX_INFO	0x9c
 #define SDVO_NEED_TO_STALL  (1 << 7)
 
-struct intel_sdvo_encode{
-    u8 dvi_rev;
-    u8 hdmi_rev;
+struct intel_sdvo_encode {
+	u8 dvi_rev;
+	u8 hdmi_rev;
 } __attribute__ ((packed));
diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
index 210d570..f3c6a9a 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -194,10 +194,10 @@ static const u32 filter_table[] = {
  *
  *     if (f >= 1) {
  *         exp = 0x7;
- * 	   mant = 1 << 8;
+ *	   mant = 1 << 8;
  *     } else {
  *         for (exp = 0; exp < 3 && f < 0.5; exp++)
- * 	       f *= 2.0;
+ *	   f *= 2.0;
  *         mant = (f * (1 << 9) + 0.5);
  *         if (mant >= (1 << 9))
  *             mant = (1 << 9) - 1;
@@ -430,7 +430,7 @@ static const struct tv_mode tv_modes[] = {
 		.vsync_start_f1	= 6,		    .vsync_start_f2	= 7,
 		.vsync_len	= 6,
 
-		.veq_ena	= true,		    .veq_start_f1    	= 0,
+		.veq_ena	= true,		    .veq_start_f1	= 0,
 		.veq_start_f2	= 1,		    .veq_len		= 18,
 
 		.vi_end_f1	= 20,		    .vi_end_f2		= 21,
@@ -472,7 +472,7 @@ static const struct tv_mode tv_modes[] = {
 		.vsync_start_f1 = 6,		    .vsync_start_f2	= 7,
 		.vsync_len	= 6,
 
-		.veq_ena	= true,		    .veq_start_f1    	= 0,
+		.veq_ena	= true,		    .veq_start_f1	= 0,
 		.veq_start_f2	= 1,		    .veq_len		= 18,
 
 		.vi_end_f1	= 20,		    .vi_end_f2		= 21,
@@ -515,7 +515,7 @@ static const struct tv_mode tv_modes[] = {
 		.vsync_start_f1	= 6,	    .vsync_start_f2	= 7,
 		.vsync_len	= 6,
 
-		.veq_ena	= true,		    .veq_start_f1    	= 0,
+		.veq_ena      = true,	    .veq_start_f1	= 0,
 		.veq_start_f2 = 1,	    .veq_len		= 18,
 
 		.vi_end_f1	= 20,		    .vi_end_f2		= 21,
@@ -558,7 +558,7 @@ static const struct tv_mode tv_modes[] = {
 		.vsync_start_f1	= 6,		    .vsync_start_f2	= 7,
 		.vsync_len	= 6,
 
-		.veq_ena	= true,		    .veq_start_f1    	= 0,
+		.veq_ena	= true,		    .veq_start_f1	= 0,
 		.veq_start_f2	= 1,		    .veq_len		= 18,
 
 		.vi_end_f1	= 20,		    .vi_end_f2		= 21,
@@ -602,14 +602,14 @@ static const struct tv_mode tv_modes[] = {
 		.vsync_start_f1	= 6,	   .vsync_start_f2	= 7,
 		.vsync_len	= 6,
 
-		.veq_ena	= true,		    .veq_start_f1    	= 0,
+		.veq_ena	= true,		    .veq_start_f1	= 0,
 		.veq_start_f2	= 1,		    .veq_len		= 18,
 
 		.vi_end_f1	= 24,		    .vi_end_f2		= 25,
 		.nbr_end	= 286,
 
 		.burst_ena	= true,
-		.hburst_start = 73,	    	    .hburst_len		= 34,
+		.hburst_start = 73,	    .hburst_len		= 34,
 		.vburst_start_f1 = 8,	    .vburst_end_f1	= 285,
 		.vburst_start_f2 = 8,	    .vburst_end_f2	= 286,
 		.vburst_start_f3 = 9,	    .vburst_end_f3	= 286,
@@ -646,7 +646,7 @@ static const struct tv_mode tv_modes[] = {
 		.vsync_start_f1	= 5,	    .vsync_start_f2	= 6,
 		.vsync_len	= 5,
 
-		.veq_ena	= true,		    .veq_start_f1    	= 0,
+		.veq_ena	= true,	    .veq_start_f1	= 0,
 		.veq_start_f2	= 1,	    .veq_len		= 15,
 
 		.vi_end_f1	= 24,		    .vi_end_f2		= 25,
@@ -675,7 +675,7 @@ static const struct tv_mode tv_modes[] = {
 	},
 	{
 		.name       = "480p@59.94Hz",
-		.clock 	= 107520,
+		.clock		= 107520,
 		.refresh	= 59940,
 		.oversample     = TV_OVERSAMPLE_4X,
 		.component_only = 1,
@@ -683,7 +683,7 @@ static const struct tv_mode tv_modes[] = {
 		.hsync_end      = 64,               .hblank_end         = 122,
 		.hblank_start   = 842,              .htotal             = 857,
 
-		.progressive    = true,.trilevel_sync = false,
+		.progressive    = true,		    .trilevel_sync = false,
 
 		.vsync_start_f1 = 12,               .vsync_start_f2     = 12,
 		.vsync_len      = 12,
@@ -699,7 +699,7 @@ static const struct tv_mode tv_modes[] = {
 	},
 	{
 		.name       = "480p@60Hz",
-		.clock 	= 107520,
+		.clock		= 107520,
 		.refresh	= 60000,
 		.oversample     = TV_OVERSAMPLE_4X,
 		.component_only = 1,
@@ -707,7 +707,7 @@ static const struct tv_mode tv_modes[] = {
 		.hsync_end      = 64,               .hblank_end         = 122,
 		.hblank_start   = 842,              .htotal             = 856,
 
-		.progressive    = true,.trilevel_sync = false,
+		.progressive    = true,		    .trilevel_sync = false,
 
 		.vsync_start_f1 = 12,               .vsync_start_f2     = 12,
 		.vsync_len      = 12,
@@ -723,7 +723,7 @@ static const struct tv_mode tv_modes[] = {
 	},
 	{
 		.name       = "576p",
-		.clock 	= 107520,
+		.clock		= 107520,
 		.refresh	= 50000,
 		.oversample     = TV_OVERSAMPLE_4X,
 		.component_only = 1,
@@ -755,7 +755,7 @@ static const struct tv_mode tv_modes[] = {
 		.hsync_end      = 80,               .hblank_end         = 300,
 		.hblank_start   = 1580,             .htotal             = 1649,
 
-		.progressive    = true, 	    .trilevel_sync = true,
+		.progressive	= true,		    .trilevel_sync = true,
 
 		.vsync_start_f1 = 10,               .vsync_start_f2     = 10,
 		.vsync_len      = 10,
@@ -779,7 +779,7 @@ static const struct tv_mode tv_modes[] = {
 		.hsync_end      = 80,               .hblank_end         = 300,
 		.hblank_start   = 1580,             .htotal             = 1651,
 
-		.progressive    = true, 	    .trilevel_sync = true,
+		.progressive	= true,		    .trilevel_sync = true,
 
 		.vsync_start_f1 = 10,               .vsync_start_f2     = 10,
 		.vsync_len      = 10,
@@ -803,7 +803,7 @@ static const struct tv_mode tv_modes[] = {
 		.hsync_end      = 80,               .hblank_end         = 300,
 		.hblank_start   = 1580,             .htotal             = 1979,
 
-		.progressive    = true, 	        .trilevel_sync = true,
+		.progressive	= true,		    .trilevel_sync = true,
 
 		.vsync_start_f1 = 10,               .vsync_start_f2     = 10,
 		.vsync_len      = 10,
@@ -828,12 +828,12 @@ static const struct tv_mode tv_modes[] = {
 		.hsync_end      = 88,               .hblank_end         = 235,
 		.hblank_start   = 2155,             .htotal             = 2639,
 
-		.progressive    = false, 	    .trilevel_sync = true,
+		.progressive	= false,	  .trilevel_sync = true,
 
 		.vsync_start_f1 = 4,              .vsync_start_f2     = 5,
 		.vsync_len      = 10,
 
-		.veq_ena	= true,		    .veq_start_f1    	= 4,
+		.veq_ena	= true,	    .veq_start_f1	= 4,
 		.veq_start_f2   = 4,	    .veq_len		= 10,
 
 
@@ -854,12 +854,12 @@ static const struct tv_mode tv_modes[] = {
 		.hsync_end      = 88,               .hblank_end         = 235,
 		.hblank_start   = 2155,             .htotal             = 2199,
 
-		.progressive    = false, 	    .trilevel_sync = true,
+		.progressive	= false,	    .trilevel_sync = true,
 
 		.vsync_start_f1 = 4,               .vsync_start_f2     = 5,
 		.vsync_len      = 10,
 
-		.veq_ena	= true,		    .veq_start_f1    	= 4,
+		.veq_ena	= true,		    .veq_start_f1	= 4,
 		.veq_start_f2	= 4,		    .veq_len		= 10,
 
 
@@ -880,16 +880,16 @@ static const struct tv_mode tv_modes[] = {
 		.hsync_end      = 88,               .hblank_end         = 235,
 		.hblank_start   = 2155,             .htotal             = 2201,
 
-		.progressive    = false, 	    .trilevel_sync = true,
+		.progressive	= false,	    .trilevel_sync = true,
 
 		.vsync_start_f1 = 4,            .vsync_start_f2    = 5,
 		.vsync_len      = 10,
 
 		.veq_ena	= true,		    .veq_start_f1	= 4,
-		.veq_start_f2 = 4,	    	    .veq_len = 10,
+		.veq_start_f2	= 4,		.veq_len	  = 10,
 
 
-		.vi_end_f1      = 21,           .vi_end_f2         	= 22,
+		.vi_end_f1	= 21,		.vi_end_f2	  = 22,
 		.nbr_end        = 539,
 
 		.burst_ena      = false,
@@ -916,7 +916,7 @@ intel_tv_dpms(struct drm_encoder *encoder, int mode)
 	struct drm_device *dev = encoder->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
-	switch(mode) {
+	switch (mode) {
 	case DRM_MODE_DPMS_ON:
 		I915_WRITE(TV_CTL, I915_READ(TV_CTL) | TV_ENC_ENABLE);
 		break;
@@ -933,7 +933,7 @@ intel_tv_mode_lookup(const char *tv_format)
 {
 	int i;
 
-	for (i = 0; i < sizeof(tv_modes) / sizeof (tv_modes[0]); i++) {
+	for (i = 0; i < sizeof(tv_modes) / sizeof(tv_modes[0]); i++) {
 		const struct tv_mode *tv_mode = &tv_modes[i];
 
 		if (!strcmp(tv_format, tv_mode->name))
@@ -1128,7 +1128,7 @@ intel_tv_mode_set(struct drm_encoder *encoder, struct drm_display_mode *mode,
 	if (color_conversion) {
 		I915_WRITE(TV_CSC_Y, (color_conversion->ry << 16) |
 			   color_conversion->gy);
-		I915_WRITE(TV_CSC_Y2,(color_conversion->by << 16) |
+		I915_WRITE(TV_CSC_Y2, (color_conversion->by << 16) |
 			   color_conversion->ay);
 		I915_WRITE(TV_CSC_U, (color_conversion->ru << 16) |
 			   color_conversion->gu);
@@ -1232,7 +1232,7 @@ static const struct drm_display_mode reported_modes[] = {
  * \return false if TV is disconnected.
  */
 static int
-intel_tv_detect_type (struct intel_tv *intel_tv,
+intel_tv_detect_type(struct intel_tv *intel_tv,
 		      struct drm_connector *connector)
 {
 	struct drm_encoder *encoder = &intel_tv->base.base;
@@ -1486,7 +1486,7 @@ intel_tv_get_modes(struct drm_connector *connector)
 }
 
 static void
-intel_tv_destroy (struct drm_connector *connector)
+intel_tv_destroy(struct drm_connector *connector)
 {
 	drm_sysfs_connector_remove(connector);
 	drm_connector_cleanup(connector);
-- 
1.7.5.4

