Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab2A0Fdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 00:33:33 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:48754 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752965Ab2A0Fda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 00:33:30 -0500
Message-ID: <1327642391.4846.36.camel@joe2Laptop>
Subject: [PATCH next V2] drivers: Use NULL not zero pointer assignments
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jiri Kosina <trivial@kernel.org>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 26 Jan 2012 21:33:11 -0800
In-Reply-To: <1327559803.28707.6.camel@joe2Laptop>
References: <20120126061330.GA15856@elgon.mountain>
	 <1327559803.28707.6.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using NULL pointer assignments is more kernel-style standard.

Uncompiled, untested.

Done via cocinelle script:

@@
type T;
T *pointer;
@@
-pointer = 0
+pointer = NULL

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/atm/ambassador.c                         |    2 +-
 drivers/atm/nicstar.c                            |    8 +++---
 drivers/char/msm_smd_pkt.c                       |    4 +-
 drivers/crypto/ixp4xx_crypto.c                   |    2 +-
 drivers/gpu/drm/gma500/framebuffer.c             |    4 +-
 drivers/gpu/drm/nouveau/nv50_instmem.c           |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c              |    2 +-
 drivers/i2c/busses/i2c-eg20t.c                   |    2 +-
 drivers/i2c/busses/i2c-s6000.c                   |    2 +-
 drivers/input/input-mt.c                         |    2 +-
 drivers/iommu/amd_iommu_init.c                   |    2 +-
 drivers/isdn/hardware/mISDN/hfc_multi_8xx.h      |    2 +-
 drivers/macintosh/therm_pm72.c                   |    2 +-
 drivers/media/dvb/ddbridge/ddbridge-core.c       |    6 ++--
 drivers/media/dvb/ngene/ngene-core.c             |    2 +-
 drivers/media/video/hdpvr/hdpvr-core.c           |    2 +-
 drivers/media/video/s5p-g2d/g2d.c                |    2 +-
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c       |   14 ++++++------
 drivers/media/video/s5p-mfc/s5p_mfc_opr.c        |   26 +++++++++++-----------
 drivers/mfd/menelaus.c                           |    2 +-
 drivers/mtd/maps/autcpu12-nvram.c                |    2 +-
 drivers/mtd/maps/cdb89712.c                      |    6 ++--
 drivers/mtd/maps/impa7.c                         |    2 +-
 drivers/mtd/maps/tqm8xxl.c                       |    2 +-
 drivers/mtd/maps/tsunami_flash.c                 |    4 +-
 drivers/net/cris/eth_v10.c                       |    6 ++--
 drivers/net/ethernet/neterion/vxge/vxge-config.c |    2 +-
 drivers/net/ethernet/packetengines/yellowfin.c   |    4 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c         |    2 +-
 drivers/net/ethernet/sgi/meth.c                  |    2 +-
 drivers/net/fddi/skfp/hwmtm.c                    |    6 ++--
 drivers/parport/parport_gsc.c                    |    2 +-
 drivers/scsi/NCR53c406a.c                        |    2 +-
 drivers/scsi/atari_scsi.c                        |    6 ++--
 drivers/scsi/be2iscsi/be_cmds.c                  |    8 +++---
 drivers/scsi/be2iscsi/be_main.c                  |    4 +-
 drivers/scsi/lpfc/lpfc_sli.c                     |    2 +-
 drivers/scsi/mvumi.c                             |    6 ++--
 drivers/scsi/pm8001/pm8001_init.c                |    2 +-
 drivers/scsi/pmcraid.c                           |    2 +-
 drivers/scsi/qla2xxx/qla_nx.c                    |    6 ++--
 drivers/spi/spi-au1550.c                         |    4 +-
 drivers/staging/comedi/drivers/jr3_pci.c         |    2 +-
 drivers/staging/comedi/drivers/pcmmio.c          |    4 +-
 drivers/staging/comedi/drivers/pcmuio.c          |    4 +-
 drivers/staging/comedi/drivers/s626.c            |    2 +-
 drivers/staging/comedi/drivers/serial2002.c      |    6 ++--
 drivers/staging/cxt1e1/hwprobe.c                 |    2 +-
 drivers/staging/cxt1e1/linux.c                   |    4 +-
 drivers/staging/cxt1e1/musycc.c                  |    8 +++---
 drivers/staging/cxt1e1/pmcc4_drv.c               |   10 ++++----
 drivers/staging/cxt1e1/sbecrc.c                  |    2 +-
 drivers/staging/cxt1e1/sbeid.c                   |    2 +-
 drivers/staging/cxt1e1/sbeproc.c                 |    2 +-
 drivers/staging/gma500/framebuffer.c             |    4 +-
 drivers/staging/iio/Documentation/iio_utils.h    |    4 +-
 drivers/staging/line6/midi.c                     |    2 +-
 drivers/staging/media/cxd2099/cxd2099.c          |    2 +-
 drivers/staging/rtl8192u/r8192U_core.c           |    4 +-
 drivers/staging/sep/sep_driver.c                 |    4 +-
 drivers/tty/serial/68328serial.c                 |    4 +-
 drivers/tty/serial/msm_smd_tty.c                 |    2 +-
 drivers/usb/gadget/f_mass_storage.c              |    8 +++---
 drivers/usb/gadget/fsl_udc_core.c                |    2 +-
 drivers/usb/gadget/s3c-hsudc.c                   |    8 +++---
 drivers/usb/host/ohci-omap.c                     |    2 +-
 drivers/usb/host/ohci-pnx4008.c                  |    2 +-
 drivers/video/atafb.c                            |    2 +-
 drivers/video/msm/mddi.c                         |    4 +-
 drivers/video/msm/mddi_client_toshiba.c          |    2 +-
 drivers/video/msm/mdp.c                          |    2 +-
 drivers/video/pxa168fb.c                         |    4 +-
 drivers/video/smscufx.c                          |    4 +-
 drivers/video/udlfb.c                            |   14 ++++++------
 74 files changed, 150 insertions(+), 150 deletions(-)

diff --git a/drivers/atm/ambassador.c b/drivers/atm/ambassador.c
index f8f41e0..8df54cf 100644
--- a/drivers/atm/ambassador.c
+++ b/drivers/atm/ambassador.c
@@ -1922,7 +1922,7 @@ static int __devinit ucode_init (loader_block * lb, amb_dev * dev) {
   const struct firmware *fw;
   unsigned long start_address;
   const struct ihex_binrec *rec;
-  const char *errmsg = 0;
+  const char *errmsg = NULL;
   int res;
 
   res = request_ihex_firmware(&fw, "atmsar11.fw", &dev->pci_dev->dev);
diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index 1c70c45..9c9b280 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -640,9 +640,9 @@ static int __devinit ns_init_card(int i, struct pci_dev *pcidev)
 	card->hbnr.init = NUM_HB;
 	card->hbnr.max = MAX_HB;
 
-	card->sm_handle = 0x00000000;
+	card->sm_handle = NULL;
 	card->sm_addr = 0x00000000;
-	card->lg_handle = 0x00000000;
+	card->lg_handle = NULL;
 	card->lg_addr = 0x00000000;
 
 	card->efbie = 1;	/* To prevent push_rxbufs from enabling the interrupt */
@@ -982,7 +982,7 @@ static void push_rxbufs(ns_dev * card, struct sk_buff *skb)
 				addr2 = card->sm_addr;
 				handle2 = card->sm_handle;
 				card->sm_addr = 0x00000000;
-				card->sm_handle = 0x00000000;
+				card->sm_handle = NULL;
 			} else {	/* (!sm_addr) */
 
 				card->sm_addr = addr1;
@@ -996,7 +996,7 @@ static void push_rxbufs(ns_dev * card, struct sk_buff *skb)
 				addr2 = card->lg_addr;
 				handle2 = card->lg_handle;
 				card->lg_addr = 0x00000000;
-				card->lg_handle = 0x00000000;
+				card->lg_handle = NULL;
 			} else {	/* (!lg_addr) */
 
 				card->lg_addr = addr1;
diff --git a/drivers/char/msm_smd_pkt.c b/drivers/char/msm_smd_pkt.c
index 8eca55d..61393b8 100644
--- a/drivers/char/msm_smd_pkt.c
+++ b/drivers/char/msm_smd_pkt.c
@@ -319,7 +319,7 @@ static int smd_pkt_open(struct inode *inode, struct file *file)
 		if (r < 0) {
 			pr_err("wait returned %d\n", r);
 			smd_close(smd_pkt_devp->ch);
-			smd_pkt_devp->ch = 0;
+			smd_pkt_devp->ch = NULL;
 		} else {
 			smd_pkt_devp->open_count++;
 			r = 0;
@@ -341,7 +341,7 @@ static int smd_pkt_release(struct inode *inode, struct file *file)
 	mutex_lock(&smd_pkt_devp->ch_lock);
 	if (--smd_pkt_devp->open_count == 0) {
 		r = smd_close(smd_pkt_devp->ch);
-		smd_pkt_devp->ch = 0;
+		smd_pkt_devp->ch = NULL;
 	}
 	mutex_unlock(&smd_pkt_devp->ch_lock);
 
diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 0053d7e..db7dd0e 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -642,7 +642,7 @@ static int register_chain_var(struct crypto_tfm *tfm, u8 xpad, u32 target,
 	crypt->init_len = init_len;
 	crypt->ctl_flags |= CTL_FLAG_GEN_ICV;
 
-	buf->next = 0;
+	buf->next = NULL;
 	buf->buf_len = HMAC_PAD_BLOCKLEN;
 	buf->pkt_len = 0;
 	buf->phys_addr = pad_phys;
diff --git a/drivers/gpu/drm/gma500/framebuffer.c b/drivers/gpu/drm/gma500/framebuffer.c
index 791c0ef..1db1845 100644
--- a/drivers/gpu/drm/gma500/framebuffer.c
+++ b/drivers/gpu/drm/gma500/framebuffer.c
@@ -113,7 +113,7 @@ static int psbfb_pan(struct fb_var_screeninfo *var, struct fb_info *info)
 
 void psbfb_suspend(struct drm_device *dev)
 {
-	struct drm_framebuffer *fb = 0;
+	struct drm_framebuffer *fb = NULL;
 	struct psb_framebuffer *psbfb = to_psb_fb(fb);
 
 	console_lock();
@@ -129,7 +129,7 @@ void psbfb_suspend(struct drm_device *dev)
 
 void psbfb_resume(struct drm_device *dev)
 {
-	struct drm_framebuffer *fb = 0;
+	struct drm_framebuffer *fb = NULL;
 	struct psb_framebuffer *psbfb = to_psb_fb(fb);
 
 	console_lock();
diff --git a/drivers/gpu/drm/nouveau/nv50_instmem.c b/drivers/gpu/drm/nouveau/nv50_instmem.c
index a7c12c9..b2f89ef 100644
--- a/drivers/gpu/drm/nouveau/nv50_instmem.c
+++ b/drivers/gpu/drm/nouveau/nv50_instmem.c
@@ -253,7 +253,7 @@ nv50_instmem_takedown(struct drm_device *dev)
 	nouveau_gpuobj_ref(NULL, &priv->bar1_dmaobj);
 
 	nouveau_vm_ref(NULL, &dev_priv->bar1_vm, chan->vm_pd);
-	dev_priv->channels.ptr[127] = 0;
+	dev_priv->channels.ptr[127] = NULL;
 	nv50_channel_del(&dev_priv->channels.ptr[0]);
 
 	nouveau_gpuobj_ref(NULL, &dev_priv->bar3_vm->pgt[0].obj[0]);
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 0af6ebd..15531c5 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -378,7 +378,7 @@ int vmw_framebuffer_create_handle(struct drm_framebuffer *fb,
 				  unsigned int *handle)
 {
 	if (handle)
-		handle = 0;
+		handle = NULL;
 
 	return 0;
 }
diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index ca88776..45ba097 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -965,7 +965,7 @@ static void __devexit pch_i2c_remove(struct pci_dev *pdev)
 		pci_iounmap(pdev, adap_info->pch_data[0].pch_base_address);
 
 	for (i = 0; i < adap_info->ch_num; i++)
-		adap_info->pch_data[i].pch_base_address = 0;
+		adap_info->pch_data[i].pch_base_address = NULL;
 
 	pci_set_drvdata(pdev, NULL);
 
diff --git a/drivers/i2c/busses/i2c-s6000.c b/drivers/i2c/busses/i2c-s6000.c
index c64ba73..8d7e29a 100644
--- a/drivers/i2c/busses/i2c-s6000.c
+++ b/drivers/i2c/busses/i2c-s6000.c
@@ -288,7 +288,7 @@ static int __devinit s6i2c_probe(struct platform_device *dev)
 		goto err_reg;
 	}
 
-	clock = 0;
+	clock = NULL;
 	bus_num = -1;
 	if (dev->dev.platform_data) {
 		struct s6_i2c_platform_data *pdata = dev->dev.platform_data;
diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
index f658086..70a16c7 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -135,7 +135,7 @@ EXPORT_SYMBOL(input_mt_report_finger_count);
  */
 void input_mt_report_pointer_emulation(struct input_dev *dev, bool use_count)
 {
-	struct input_mt_slot *oldest = 0;
+	struct input_mt_slot *oldest = NULL;
 	int oldid = dev->trkid;
 	int count = 0;
 	int i;
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index bdea288..c727cf6 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1210,7 +1210,7 @@ static int __init init_exclusion_range(struct ivmd_header *m)
 /* called for unity map ACPI definition */
 static int __init init_unity_map_range(struct ivmd_header *m)
 {
-	struct unity_map_entry *e = 0;
+	struct unity_map_entry *e = NULL;
 	char *s;
 
 	e = kzalloc(sizeof(*e), GFP_KERNEL);
diff --git a/drivers/isdn/hardware/mISDN/hfc_multi_8xx.h b/drivers/isdn/hardware/mISDN/hfc_multi_8xx.h
index 45ddced..e223857 100644
--- a/drivers/isdn/hardware/mISDN/hfc_multi_8xx.h
+++ b/drivers/isdn/hardware/mISDN/hfc_multi_8xx.h
@@ -108,7 +108,7 @@ setup_embedded(struct hfc_multi *hc, struct hm_map *m)
 	hc->opticalsupport = m->opticalsupport;
 
 	hc->pci_iobase = 0;
-	hc->pci_membase = 0;
+	hc->pci_membase = NULL;
 	hc->xhfc_membase = NULL;
 	hc->xhfc_memaddr = NULL;
 	hc->xhfc_memdata = NULL;
diff --git a/drivers/macintosh/therm_pm72.c b/drivers/macintosh/therm_pm72.c
index 0ff92c2..cda90df 100644
--- a/drivers/macintosh/therm_pm72.c
+++ b/drivers/macintosh/therm_pm72.c
@@ -1876,7 +1876,7 @@ static int main_control_loop(void *x)
  out:
 	DBG("main_control_loop ended\n");
 
-	ctrl_task = 0;
+	ctrl_task = NULL;
 	complete_and_exit(&ctrl_complete, 0);
 }
 
diff --git a/drivers/media/dvb/ddbridge/ddbridge-core.c b/drivers/media/dvb/ddbridge/ddbridge-core.c
index d88c4aa..7584a78 100644
--- a/drivers/media/dvb/ddbridge/ddbridge-core.c
+++ b/drivers/media/dvb/ddbridge/ddbridge-core.c
@@ -267,7 +267,7 @@ static void io_free(struct pci_dev *pdev, u8 **vbuf,
 	for (i = 0; i < num; i++) {
 		if (vbuf[i]) {
 			pci_free_consistent(pdev, size, vbuf[i], pbuf[i]);
-			vbuf[i] = 0;
+			vbuf[i] = NULL;
 		}
 	}
 }
@@ -849,7 +849,7 @@ static int dvb_input_attach(struct ddb_input *input)
 		return ret;
 	input->attached = 4;
 
-	input->fe = 0;
+	input->fe = NULL;
 	switch (port->type) {
 	case DDB_TUNER_DVBS_ST:
 		if (demod_attach_stv0900(input, 0) < 0)
@@ -1129,7 +1129,7 @@ static void ddb_ports_detach(struct ddb *dev)
 				ddb_output_stop(port->output);
 				dvb_ca_en50221_release(port->en);
 				kfree(port->en);
-				port->en = 0;
+				port->en = NULL;
 				dvb_unregister_adapter(&port->output->adap);
 			}
 			break;
diff --git a/drivers/media/dvb/ngene/ngene-core.c b/drivers/media/dvb/ngene/ngene-core.c
index f129a93..0cc990d 100644
--- a/drivers/media/dvb/ngene/ngene-core.c
+++ b/drivers/media/dvb/ngene/ngene-core.c
@@ -1604,7 +1604,7 @@ static void cxd_detach(struct ngene *dev)
 
 	dvb_ca_en50221_release(ci->en);
 	kfree(ci->en);
-	ci->en = 0;
+	ci->en = NULL;
 }
 
 /***********************************/
diff --git a/drivers/media/video/hdpvr/hdpvr-core.c b/drivers/media/video/hdpvr/hdpvr-core.c
index e5eb56a..90db4f3 100644
--- a/drivers/media/video/hdpvr/hdpvr-core.c
+++ b/drivers/media/video/hdpvr/hdpvr-core.c
@@ -295,7 +295,7 @@ static int hdpvr_probe(struct usb_interface *interface,
 		goto error;
 	}
 
-	dev->workqueue = 0;
+	dev->workqueue = NULL;
 
 	/* register v4l2_device early so it can be used for printks */
 	if (v4l2_device_register(&interface->dev, &dev->v4l2_dev)) {
diff --git a/drivers/media/video/s5p-g2d/g2d.c b/drivers/media/video/s5p-g2d/g2d.c
index febaa67..093c174 100644
--- a/drivers/media/video/s5p-g2d/g2d.c
+++ b/drivers/media/video/s5p-g2d/g2d.c
@@ -592,7 +592,7 @@ static irqreturn_t g2d_isr(int irq, void *prv)
 	v4l2_m2m_buf_done(dst, VB2_BUF_STATE_DONE);
 	v4l2_m2m_job_finish(dev->m2m_dev, ctx->m2m_ctx);
 
-	dev->curr = 0;
+	dev->curr = NULL;
 	wake_up(&dev->irq_queue);
 	return IRQ_HANDLED;
 }
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
index f2481a8..e41fb62 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
@@ -52,7 +52,7 @@ int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev *dev)
 	s5p_mfc_bitproc_buf = vb2_dma_contig_memops.alloc(
 		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], dev->fw_size);
 	if (IS_ERR(s5p_mfc_bitproc_buf)) {
-		s5p_mfc_bitproc_buf = 0;
+		s5p_mfc_bitproc_buf = NULL;
 		mfc_err("Allocating bitprocessor buffer failed\n");
 		release_firmware(fw_blob);
 		return -ENOMEM;
@@ -63,7 +63,7 @@ int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev *dev)
 		mfc_err("The base memory for bank 1 is not aligned to 128KB\n");
 		vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
 		s5p_mfc_bitproc_phys = 0;
-		s5p_mfc_bitproc_buf = 0;
+		s5p_mfc_bitproc_buf = NULL;
 		release_firmware(fw_blob);
 		return -EIO;
 	}
@@ -72,7 +72,7 @@ int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev *dev)
 		mfc_err("Bitprocessor memory remap failed\n");
 		vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
 		s5p_mfc_bitproc_phys = 0;
-		s5p_mfc_bitproc_buf = 0;
+		s5p_mfc_bitproc_buf = NULL;
 		release_firmware(fw_blob);
 		return -EIO;
 	}
@@ -82,7 +82,7 @@ int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev *dev)
 	if (IS_ERR(b_base)) {
 		vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
 		s5p_mfc_bitproc_phys = 0;
-		s5p_mfc_bitproc_buf = 0;
+		s5p_mfc_bitproc_buf = NULL;
 		mfc_err("Allocating bank2 base failed\n");
 	release_firmware(fw_blob);
 		return -ENOMEM;
@@ -94,7 +94,7 @@ int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev *dev)
 		mfc_err("The base memory for bank 2 is not aligned to 128KB\n");
 		vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
 		s5p_mfc_bitproc_phys = 0;
-		s5p_mfc_bitproc_buf = 0;
+		s5p_mfc_bitproc_buf = NULL;
 		release_firmware(fw_blob);
 		return -EIO;
 	}
@@ -146,9 +146,9 @@ int s5p_mfc_release_firmware(struct s5p_mfc_dev *dev)
 	if (!s5p_mfc_bitproc_buf)
 		return -EINVAL;
 	vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
-	s5p_mfc_bitproc_virt =  0;
+	s5p_mfc_bitproc_virt = NULL;
 	s5p_mfc_bitproc_phys = 0;
-	s5p_mfc_bitproc_buf = 0;
+	s5p_mfc_bitproc_buf = NULL;
 	return 0;
 }
 
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
index e08b21c..a802829 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
@@ -43,7 +43,7 @@ int s5p_mfc_alloc_dec_temp_buffers(struct s5p_mfc_ctx *ctx)
 	ctx->desc_buf = vb2_dma_contig_memops.alloc(
 			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], DESC_BUF_SIZE);
 	if (IS_ERR_VALUE((int)ctx->desc_buf)) {
-		ctx->desc_buf = 0;
+		ctx->desc_buf = NULL;
 		mfc_err("Allocating DESC buffer failed\n");
 		return -ENOMEM;
 	}
@@ -54,7 +54,7 @@ int s5p_mfc_alloc_dec_temp_buffers(struct s5p_mfc_ctx *ctx)
 	if (desc_virt == NULL) {
 		vb2_dma_contig_memops.put(ctx->desc_buf);
 		ctx->desc_phys = 0;
-		ctx->desc_buf = 0;
+		ctx->desc_buf = NULL;
 		mfc_err("Remapping DESC buffer failed\n");
 		return -ENOMEM;
 	}
@@ -69,7 +69,7 @@ void s5p_mfc_release_dec_desc_buffer(struct s5p_mfc_ctx *ctx)
 	if (ctx->desc_phys) {
 		vb2_dma_contig_memops.put(ctx->desc_buf);
 		ctx->desc_phys = 0;
-		ctx->desc_buf = 0;
+		ctx->desc_buf = NULL;
 	}
 }
 
@@ -186,7 +186,7 @@ int s5p_mfc_alloc_codec_buffers(struct s5p_mfc_ctx *ctx)
 		ctx->bank1_buf = vb2_dma_contig_memops.alloc(
 		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->bank1_size);
 		if (IS_ERR(ctx->bank1_buf)) {
-			ctx->bank1_buf = 0;
+			ctx->bank1_buf = NULL;
 			printk(KERN_ERR
 			       "Buf alloc for decoding failed (port A)\n");
 			return -ENOMEM;
@@ -200,7 +200,7 @@ int s5p_mfc_alloc_codec_buffers(struct s5p_mfc_ctx *ctx)
 		ctx->bank2_buf = vb2_dma_contig_memops.alloc(
 		dev->alloc_ctx[MFC_BANK2_ALLOC_CTX], ctx->bank2_size);
 		if (IS_ERR(ctx->bank2_buf)) {
-			ctx->bank2_buf = 0;
+			ctx->bank2_buf = NULL;
 			mfc_err("Buf alloc for decoding failed (port B)\n");
 			return -ENOMEM;
 		}
@@ -216,13 +216,13 @@ void s5p_mfc_release_codec_buffers(struct s5p_mfc_ctx *ctx)
 {
 	if (ctx->bank1_buf) {
 		vb2_dma_contig_memops.put(ctx->bank1_buf);
-		ctx->bank1_buf = 0;
+		ctx->bank1_buf = NULL;
 		ctx->bank1_phys = 0;
 		ctx->bank1_size = 0;
 	}
 	if (ctx->bank2_buf) {
 		vb2_dma_contig_memops.put(ctx->bank2_buf);
-		ctx->bank2_buf = 0;
+		ctx->bank2_buf = NULL;
 		ctx->bank2_phys = 0;
 		ctx->bank2_size = 0;
 	}
@@ -244,7 +244,7 @@ int s5p_mfc_alloc_instance_buffer(struct s5p_mfc_ctx *ctx)
 	if (IS_ERR(ctx->ctx_buf)) {
 		mfc_err("Allocating context buffer failed\n");
 		ctx->ctx_phys = 0;
-		ctx->ctx_buf = 0;
+		ctx->ctx_buf = NULL;
 		return -ENOMEM;
 	}
 	ctx->ctx_phys = s5p_mfc_mem_cookie(
@@ -256,7 +256,7 @@ int s5p_mfc_alloc_instance_buffer(struct s5p_mfc_ctx *ctx)
 		mfc_err("Remapping instance buffer failed\n");
 		vb2_dma_contig_memops.put(ctx->ctx_buf);
 		ctx->ctx_phys = 0;
-		ctx->ctx_buf = 0;
+		ctx->ctx_buf = NULL;
 		return -ENOMEM;
 	}
 	/* Zero content of the allocated memory */
@@ -265,7 +265,7 @@ int s5p_mfc_alloc_instance_buffer(struct s5p_mfc_ctx *ctx)
 	if (s5p_mfc_init_shm(ctx) < 0) {
 		vb2_dma_contig_memops.put(ctx->ctx_buf);
 		ctx->ctx_phys = 0;
-		ctx->ctx_buf = 0;
+		ctx->ctx_buf = NULL;
 		return -ENOMEM;
 	}
 	return 0;
@@ -277,12 +277,12 @@ void s5p_mfc_release_instance_buffer(struct s5p_mfc_ctx *ctx)
 	if (ctx->ctx_buf) {
 		vb2_dma_contig_memops.put(ctx->ctx_buf);
 		ctx->ctx_phys = 0;
-		ctx->ctx_buf = 0;
+		ctx->ctx_buf = NULL;
 	}
 	if (ctx->shm_alloc) {
 		vb2_dma_contig_memops.put(ctx->shm_alloc);
-		ctx->shm_alloc = 0;
-		ctx->shm = 0;
+		ctx->shm_alloc = NULL;
+		ctx->shm = NULL;
 	}
 }
 
diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index cb4910a..4da6a72 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -442,7 +442,7 @@ void menelaus_unregister_mmc_callback(void)
 	menelaus_remove_irq_work(MENELAUS_MMC_S2D1_IRQ);
 
 	the_menelaus->mmc_callback = NULL;
-	the_menelaus->mmc_callback_data = 0;
+	the_menelaus->mmc_callback_data = NULL;
 }
 EXPORT_SYMBOL(menelaus_unregister_mmc_callback);
 
diff --git a/drivers/mtd/maps/autcpu12-nvram.c b/drivers/mtd/maps/autcpu12-nvram.c
index e5bfd0e..2e69cea 100644
--- a/drivers/mtd/maps/autcpu12-nvram.c
+++ b/drivers/mtd/maps/autcpu12-nvram.c
@@ -100,7 +100,7 @@ map:
 
 out_probe:
 	map_destroy(sram_mtd);
-	sram_mtd = 0;
+	sram_mtd = NULL;
 
 out_ioremap:
 	iounmap((void *)autcpu12_sram_map.virt);
diff --git a/drivers/mtd/maps/cdb89712.c b/drivers/mtd/maps/cdb89712.c
index c29cbf8..c78cffb 100644
--- a/drivers/mtd/maps/cdb89712.c
+++ b/drivers/mtd/maps/cdb89712.c
@@ -85,7 +85,7 @@ static int __init init_cdb89712_flash (void)
 
 out_probe:
 	map_destroy(flash_mtd);
-	flash_mtd = 0;
+	flash_mtd = NULL;
 out_ioremap:
 	iounmap((void *)cdb89712_flash_map.virt);
 out_resource:
@@ -151,7 +151,7 @@ static int __init init_cdb89712_sram (void)
 
 out_probe:
 	map_destroy(sram_mtd);
-	sram_mtd = 0;
+	sram_mtd = NULL;
 out_ioremap:
 	iounmap((void *)cdb89712_sram_map.virt);
 out_resource:
@@ -219,7 +219,7 @@ static int __init init_cdb89712_bootrom (void)
 
 out_probe:
 	map_destroy(bootrom_mtd);
-	bootrom_mtd = 0;
+	bootrom_mtd = NULL;
 out_ioremap:
 	iounmap((void *)cdb89712_bootrom_map.virt);
 out_resource:
diff --git a/drivers/mtd/maps/impa7.c b/drivers/mtd/maps/impa7.c
index f47aedb..1b2e521 100644
--- a/drivers/mtd/maps/impa7.c
+++ b/drivers/mtd/maps/impa7.c
@@ -82,7 +82,7 @@ static int __init init_impa7(void)
 		}
 		simple_map_init(&impa7_map[i]);
 
-		impa7_mtd[i] = 0;
+		impa7_mtd[i] = NULL;
 		type = rom_probe_types;
 		for(; !impa7_mtd[i] && *type; type++) {
 			impa7_mtd[i] = do_map_probe(*type, &impa7_map[i]);
diff --git a/drivers/mtd/maps/tqm8xxl.c b/drivers/mtd/maps/tqm8xxl.c
index d785879..80f7917 100644
--- a/drivers/mtd/maps/tqm8xxl.c
+++ b/drivers/mtd/maps/tqm8xxl.c
@@ -237,7 +237,7 @@ static void __exit cleanup_tqm_mtd(void)
 
 	if (start_scan_addr) {
 		iounmap(start_scan_addr);
-		start_scan_addr = 0;
+		start_scan_addr = NULL;
 	}
 }
 
diff --git a/drivers/mtd/maps/tsunami_flash.c b/drivers/mtd/maps/tsunami_flash.c
index 1de390e..7adf23f 100644
--- a/drivers/mtd/maps/tsunami_flash.c
+++ b/drivers/mtd/maps/tsunami_flash.c
@@ -79,7 +79,7 @@ static void __exit  cleanup_tsunami_flash(void)
 		mtd_device_unregister(mtd);
 		map_destroy(mtd);
 	}
-	tsunami_flash_mtd = 0;
+	tsunami_flash_mtd = NULL;
 }
 
 
@@ -90,7 +90,7 @@ static int __init init_tsunami_flash(void)
 
 	tsunami_tig_writeb(FLASH_ENABLE_BYTE, FLASH_ENABLE_PORT);
 
-	tsunami_flash_mtd = 0;
+	tsunami_flash_mtd = NULL;
 	type = rom_probe_types;
 	for(; !tsunami_flash_mtd && *type; type++) {
 		tsunami_flash_mtd = do_map_probe(*type, &tsunami_flash_map);
diff --git a/drivers/net/cris/eth_v10.c b/drivers/net/cris/eth_v10.c
index c7e1df9..12e6816 100644
--- a/drivers/net/cris/eth_v10.c
+++ b/drivers/net/cris/eth_v10.c
@@ -355,7 +355,7 @@ etrax_ethernet_init(void)
 		TxDescList[i].descr.buf    = 0;
 		TxDescList[i].descr.status = 0;
 		TxDescList[i].descr.hw_len = 0;
-		TxDescList[i].skb = 0;
+		TxDescList[i].skb = NULL;
 	}
 
 	TxDescList[NBR_OF_TX_DESC - 1].descr.ctrl   = d_eol;
@@ -1072,7 +1072,7 @@ e100_tx_timeout(struct net_device *dev)
 	/* and get rid of the packets that never got an interrupt */
 	while (myFirstTxDesc != myNextTxDesc) {
 		dev_kfree_skb(myFirstTxDesc->skb);
-		myFirstTxDesc->skb = 0;
+		myFirstTxDesc->skb = NULL;
 		myFirstTxDesc = phys_to_virt(myFirstTxDesc->descr.next);
 	}
 
@@ -1177,7 +1177,7 @@ e100rxtx_interrupt(int irq, void *dev_id)
 		/* dma is ready with the transmission of the data in tx_skb, so now
 		   we can release the skb memory */
 		dev_kfree_skb_irq(myFirstTxDesc->skb);
-		myFirstTxDesc->skb = 0;
+		myFirstTxDesc->skb = NULL;
 		myFirstTxDesc = phys_to_virt(myFirstTxDesc->descr.next);
                 /* Wake up queue. */
 		netif_wake_queue(dev);
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-config.c b/drivers/net/ethernet/neterion/vxge/vxge-config.c
index 98e2c10..8ed1a9a 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-config.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-config.c
@@ -4645,7 +4645,7 @@ static void __vxge_hw_vp_terminate(struct __vxge_hw_device *hldev, u32 vp_id)
 	vpath->ringh = NULL;
 	vpath->fifoh = NULL;
 	memset(&vpath->vpath_handles, 0, sizeof(struct list_head));
-	vpath->stats_block = 0;
+	vpath->stats_block = NULL;
 	vpath->hw_stats = NULL;
 	vpath->hw_stats_sav = NULL;
 	vpath->sw_stats = NULL;
diff --git a/drivers/net/ethernet/packetengines/yellowfin.c b/drivers/net/ethernet/packetengines/yellowfin.c
index db44e9a..0f016f7 100644
--- a/drivers/net/ethernet/packetengines/yellowfin.c
+++ b/drivers/net/ethernet/packetengines/yellowfin.c
@@ -777,7 +777,7 @@ static int yellowfin_init_ring(struct net_device *dev)
 	/* Tx ring needs a pair of descriptors, the second for the status. */
 	for (i = 0; i < TX_RING_SIZE; i++) {
 		j = 2*i;
-		yp->tx_skbuff[i] = 0;
+		yp->tx_skbuff[i] = NULL;
 		/* Branch on Tx error. */
 		yp->tx_ring[j].dbdma_cmd = cpu_to_le32(CMD_STOP);
 		yp->tx_ring[j].branch_addr = cpu_to_le32(yp->tx_ring_dma +
@@ -994,7 +994,7 @@ static irqreturn_t yellowfin_interrupt(int irq, void *dev_instance)
 					yp->tx_ring[entry<<1].addr, skb->len,
 					PCI_DMA_TODEVICE);
 				dev_kfree_skb_irq(skb);
-				yp->tx_skbuff[entry] = 0;
+				yp->tx_skbuff[entry] = NULL;
 				/* Mark status as empty. */
 				yp->tx_status[entry].tx_errs = 0;
 			}
diff --git a/drivers/net/ethernet/pasemi/pasemi_mac.c b/drivers/net/ethernet/pasemi/pasemi_mac.c
index 49b549f..0bef109 100644
--- a/drivers/net/ethernet/pasemi/pasemi_mac.c
+++ b/drivers/net/ethernet/pasemi/pasemi_mac.c
@@ -393,7 +393,7 @@ static void pasemi_mac_setup_csrings(struct pasemi_mac *mac)
 	if (mac->type == MAC_TYPE_XAUI)
 		mac->cs[1] = pasemi_mac_setup_csring(mac);
 	else
-		mac->cs[1] = 0;
+		mac->cs[1] = NULL;
 
 	for (i = 0; i < MAX_CS; i++)
 		if (mac->cs[i])
diff --git a/drivers/net/ethernet/sgi/meth.c b/drivers/net/ethernet/sgi/meth.c
index 53efe7c..09328f3 100644
--- a/drivers/net/ethernet/sgi/meth.c
+++ b/drivers/net/ethernet/sgi/meth.c
@@ -266,7 +266,7 @@ static void meth_free_rx_ring(struct meth_private *priv)
 	for (i = 0; i < RX_RING_ENTRIES; i++) {
 		dma_unmap_single(NULL, priv->rx_ring_dmas[i],
 				 METH_RX_BUFF_SIZE, DMA_FROM_DEVICE);
-		priv->rx_ring[i] = 0;
+		priv->rx_ring[i] = NULL;
 		priv->rx_ring_dmas[i] = 0;
 		kfree_skb(priv->rx_skbs[i]);
 	}
diff --git a/drivers/net/fddi/skfp/hwmtm.c b/drivers/net/fddi/skfp/hwmtm.c
index e26398b..41fd280 100644
--- a/drivers/net/fddi/skfp/hwmtm.c
+++ b/drivers/net/fddi/skfp/hwmtm.c
@@ -46,8 +46,8 @@ static char const ID_sccs[] = "@(#)hwmtm.c	1.40 99/05/31 (C) SK" ;
 	-------------------------------------------------------------
 */
 #ifdef COMMON_MB_POOL
-static	SMbuf *mb_start = 0 ;
-static	SMbuf *mb_free = 0 ;
+static	SMbuf *mb_start = NULL;
+static	SMbuf *mb_free = NULL;
 static	int mb_init = FALSE ;
 static	int call_count = 0 ;
 #endif
@@ -441,7 +441,7 @@ void init_fddi_driver(struct s_smc *smc, u_char *mac_addr)
 #else
 	mb = mb_start ;
 	if (!mb_init) {
-		mb_free = 0 ;
+		mb_free = NULL;
 		for (i = 0; i < MAX_MBUF; i++) {
 			mb->sm_use_count = 1 ;
 			smt_free_mbuf(smc,mb)	;
diff --git a/drivers/parport/parport_gsc.c b/drivers/parport/parport_gsc.c
index 5d6de38..4f93e68 100644
--- a/drivers/parport/parport_gsc.c
+++ b/drivers/parport/parport_gsc.c
@@ -257,7 +257,7 @@ struct parport *__devinit parport_gsc_probe_port (unsigned long base,
 	memcpy (ops, &parport_gsc_ops, sizeof (struct parport_operations));
 	priv->ctr = 0xc;
 	priv->ctr_writable = 0xff;
-	priv->dma_buf = 0;
+	priv->dma_buf = NULL;
 	priv->dma_handle = 0;
 	priv->dev = dev;
 	p->base = base;
diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
index c91888a..ea400d0 100644
--- a/drivers/scsi/NCR53c406a.c
+++ b/drivers/scsi/NCR53c406a.c
@@ -458,7 +458,7 @@ static int __init NCR53c406a_detect(struct scsi_host_template * tpnt)
 
 #if USE_BIOS
 	int ii, jj;
-	bios_base = 0;
+	bios_base = NULL;
 	/* look for a valid signature */
 	for (ii = 0; ii < ADDRESS_COUNT && !bios_base; ii++)
 		for (jj = 0; (jj < SIGNATURE_COUNT) && !bios_base; jj++)
diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index 04a154f..0e2533a 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -634,13 +634,13 @@ int __init atari_scsi_detect(struct scsi_host_template *host)
 			return 0;
 		}
 		atari_dma_phys_buffer = virt_to_phys(atari_dma_buffer);
-		atari_dma_orig_addr = 0;
+		atari_dma_orig_addr = NULL;
 	}
 #endif
 	instance = scsi_register(host, sizeof(struct NCR5380_hostdata));
 	if (instance == NULL) {
 		atari_stram_free(atari_dma_buffer);
-		atari_dma_buffer = 0;
+		atari_dma_buffer = NULL;
 		return 0;
 	}
 	atari_scsi_host = instance;
@@ -667,7 +667,7 @@ int __init atari_scsi_detect(struct scsi_host_template *host)
 			printk(KERN_ERR "atari_scsi_detect: cannot allocate irq %d, aborting",IRQ_TT_MFP_SCSI);
 			scsi_unregister(atari_scsi_host);
 			atari_stram_free(atari_dma_buffer);
-			atari_dma_buffer = 0;
+			atari_dma_buffer = NULL;
 			return 0;
 		}
 		tt_mfp.active_edge |= 0x80;		/* SCSI int on L->H */
diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index cdb1536..ef67f9c 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -22,9 +22,9 @@
 int beiscsi_pci_soft_reset(struct beiscsi_hba *phba)
 {
 	u32 sreset;
-	u8 *pci_reset_offset = 0;
-	u8 *pci_online0_offset = 0;
-	u8 *pci_online1_offset = 0;
+	u8 *pci_reset_offset = NULL;
+	u8 *pci_online0_offset = NULL;
+	u8 *pci_online1_offset = NULL;
 	u32 pconline0 = 0;
 	u32 pconline1 = 0;
 	u32 i;
@@ -74,7 +74,7 @@ int beiscsi_pci_soft_reset(struct beiscsi_hba *phba)
 int be_chk_reset_complete(struct beiscsi_hba *phba)
 {
 	unsigned int num_loop;
-	u8 *mpu_sem = 0;
+	u8 *mpu_sem = NULL;
 	u32 status;
 
 	num_loop = 1000;
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 375756f..a53e797 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4132,7 +4132,7 @@ static void beiscsi_quiesce(struct beiscsi_hba *phba)
 	struct hwi_context_memory *phwi_context;
 	struct be_eq_obj *pbe_eq;
 	unsigned int i, msix_vec;
-	u8 *real_offset = 0;
+	u8 *real_offset = NULL;
 	u32 value = 0;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
@@ -4229,7 +4229,7 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 	struct hwi_context_memory *phwi_context;
 	struct be_eq_obj *pbe_eq;
 	int ret, num_cpus, i;
-	u8 *real_offset = 0;
+	u8 *real_offset = NULL;
 	u32 value = 0;
 
 	ret = beiscsi_enable_pci(pcidev);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 23a2759..7daba92 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -15898,7 +15898,7 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 {
 	LIST_HEAD(completions);
 	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
-	struct lpfc_iocbq *piocbq = 0;
+	struct lpfc_iocbq *piocbq = NULL;
 	unsigned long iflags = 0;
 	char *fail_msg = NULL;
 	struct lpfc_sglq *sglq;
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 88cf1db..84448ea 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -606,7 +606,7 @@ static int mvumi_issue_blocked_cmd(struct mvumi_hba *mhba,
 		spin_lock_irqsave(mhba->shost->host_lock, flags);
 		atomic_dec(&cmd->sync_cmd);
 		if (mhba->tag_cmd[cmd->frame->tag]) {
-			mhba->tag_cmd[cmd->frame->tag] = 0;
+			mhba->tag_cmd[cmd->frame->tag] = NULL;
 			dev_warn(&mhba->pdev->dev, "TIMEOUT:release tag [%d]\n",
 							cmd->frame->tag);
 			tag_release_one(mhba, &mhba->tag_pool, cmd->frame->tag);
@@ -1301,7 +1301,7 @@ static void mvumi_handle_clob(struct mvumi_hba *mhba)
 		cmd = mhba->tag_cmd[ob_frame->tag];
 
 		atomic_dec(&mhba->fw_outstanding);
-		mhba->tag_cmd[ob_frame->tag] = 0;
+		mhba->tag_cmd[ob_frame->tag] = NULL;
 		tag_release_one(mhba, &mhba->tag_pool, ob_frame->tag);
 		if (cmd->scmd)
 			mvumi_complete_cmd(mhba, cmd, ob_frame);
@@ -1607,7 +1607,7 @@ static enum blk_eh_timer_return mvumi_timed_out(struct scsi_cmnd *scmd)
 	spin_lock_irqsave(mhba->shost->host_lock, flags);
 
 	if (mhba->tag_cmd[cmd->frame->tag]) {
-		mhba->tag_cmd[cmd->frame->tag] = 0;
+		mhba->tag_cmd[cmd->frame->tag] = NULL;
 		tag_release_one(mhba, &mhba->tag_pool, cmd->frame->tag);
 	}
 	if (!list_empty(&cmd->queue_pointer))
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index c21a216..00f637b 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -349,7 +349,7 @@ static int pm8001_ioremap(struct pm8001_hba_info *pm8001_ha)
 		} else {
 			pm8001_ha->io_mem[logicalBar].membase	= 0;
 			pm8001_ha->io_mem[logicalBar].memsize	= 0;
-			pm8001_ha->io_mem[logicalBar].memvirtaddr = 0;
+			pm8001_ha->io_mem[logicalBar].memvirtaddr = NULL;
 		}
 		logicalBar++;
 	}
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index ea8a0b4..55c365a 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -385,7 +385,7 @@ void pmcraid_init_cmdblk(struct pmcraid_cmd *cmd, int index)
 	cmd->scsi_cmd = NULL;
 	cmd->release = 0;
 	cmd->completion_req = 0;
-	cmd->sense_buffer = 0;
+	cmd->sense_buffer = NULL;
 	cmd->sense_buffer_dma = 0;
 	cmd->dma_handle = 0;
 	init_timer(&cmd->timer);
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 1cd46cd..b1c670fc 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -4363,7 +4363,7 @@ qla82xx_md_free(scsi_qla_host_t *vha)
 		    ha->md_tmplt_hdr, ha->md_template_size / 1024);
 		dma_free_coherent(&ha->pdev->dev, ha->md_template_size,
 		    ha->md_tmplt_hdr, ha->md_tmplt_hdr_dma);
-		ha->md_tmplt_hdr = 0;
+		ha->md_tmplt_hdr = NULL;
 	}
 
 	/* Release the template data buffer allocated */
@@ -4373,7 +4373,7 @@ qla82xx_md_free(scsi_qla_host_t *vha)
 		    ha->md_dump, ha->md_dump_size / 1024);
 		vfree(ha->md_dump);
 		ha->md_dump_size = 0;
-		ha->md_dump = 0;
+		ha->md_dump = NULL;
 	}
 }
 
@@ -4410,7 +4410,7 @@ qla82xx_md_prep(scsi_qla_host_t *vha)
 				dma_free_coherent(&ha->pdev->dev,
 				    ha->md_template_size,
 				    ha->md_tmplt_hdr, ha->md_tmplt_hdr_dma);
-				ha->md_tmplt_hdr = 0;
+				ha->md_tmplt_hdr = NULL;
 			}
 
 		}
diff --git a/drivers/spi/spi-au1550.c b/drivers/spi/spi-au1550.c
index 5784c87..6b230c4 100644
--- a/drivers/spi/spi-au1550.c
+++ b/drivers/spi/spi-au1550.c
@@ -333,7 +333,7 @@ static int au1550_spi_dma_rxtmp_alloc(struct au1550_spi *hw, unsigned size)
 			size, DMA_FROM_DEVICE);
 	if (dma_mapping_error(hw->dev, hw->dma_rx_tmpbuf_addr)) {
 		kfree(hw->dma_rx_tmpbuf);
-		hw->dma_rx_tmpbuf = 0;
+		hw->dma_rx_tmpbuf = NULL;
 		hw->dma_rx_tmpbuf_size = 0;
 		return -EFAULT;
 	}
@@ -345,7 +345,7 @@ static void au1550_spi_dma_rxtmp_free(struct au1550_spi *hw)
 	dma_unmap_single(hw->dev, hw->dma_rx_tmpbuf_addr,
 			hw->dma_rx_tmpbuf_size, DMA_FROM_DEVICE);
 	kfree(hw->dma_rx_tmpbuf);
-	hw->dma_rx_tmpbuf = 0;
+	hw->dma_rx_tmpbuf = NULL;
 	hw->dma_rx_tmpbuf_size = 0;
 }
 
diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index 6a79ba1..ad738e1 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -896,7 +896,7 @@ static int jr3_pci_attach(struct comedi_device *dev,
 			p->maxdata_list[56] = 0xffff;
 			p->maxdata_list[57] = 0xffff;
 			/*  Channel specific range and maxdata */
-			dev->subdevices[i].range_table = 0;
+			dev->subdevices[i].range_table = NULL;
 			dev->subdevices[i].range_table_list =
 			    p->range_table_list;
 			dev->subdevices[i].maxdata = 0;
diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index eddac00..3773202 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -1002,7 +1002,7 @@ static void pcmmio_stop_intr(struct comedi_device *dev,
 
 	subpriv->dio.intr.enabled_mask = 0;
 	subpriv->dio.intr.active = 0;
-	s->async->inttrig = 0;
+	s->async->inttrig = NULL;
 	nports = subpriv->dio.intr.num_asic_chans / CHANS_PER_PORT;
 	firstport = subpriv->dio.intr.asic_chan / CHANS_PER_PORT;
 	switch_page(dev, asic, PAGE_ENAB);
@@ -1108,7 +1108,7 @@ pcmmio_inttrig_start_intr(struct comedi_device *dev, struct comedi_subdevice *s,
 		return -EINVAL;
 
 	spin_lock_irqsave(&subpriv->dio.intr.spinlock, flags);
-	s->async->inttrig = 0;
+	s->async->inttrig = NULL;
 	if (subpriv->dio.intr.active)
 		event = pcmmio_start_intr(dev, s);
 	spin_unlock_irqrestore(&subpriv->dio.intr.spinlock, flags);
diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index 661ba2e..fa95df0 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -863,7 +863,7 @@ static void pcmuio_stop_intr(struct comedi_device *dev,
 
 	subpriv->intr.enabled_mask = 0;
 	subpriv->intr.active = 0;
-	s->async->inttrig = 0;
+	s->async->inttrig = NULL;
 	nports = subpriv->intr.num_asic_chans / CHANS_PER_PORT;
 	firstport = subpriv->intr.asic_chan / CHANS_PER_PORT;
 	switch_page(dev, asic, PAGE_ENAB);
@@ -952,7 +952,7 @@ pcmuio_inttrig_start_intr(struct comedi_device *dev, struct comedi_subdevice *s,
 		return -EINVAL;
 
 	spin_lock_irqsave(&subpriv->intr.spinlock, flags);
-	s->async->inttrig = 0;
+	s->async->inttrig = NULL;
 	if (subpriv->intr.active)
 		event = pcmuio_start_intr(dev, s);
 
diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 23fc64b..5b063af 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -2851,7 +2851,7 @@ static void CloseDMAB(struct comedi_device *dev, struct bufferDMA *pdma,
 	vpptr = pdma->PhysicalBase;
 	if (vbptr) {
 		pci_free_consistent(devpriv->pdev, bsize, vbptr, vpptr);
-		pdma->LogicalBase = 0;
+		pdma->LogicalBase = NULL;
 		pdma->PhysicalBase = 0;
 
 		DEBUG("CloseDMAB(): Logical=%p, bsize=%d, Physical=0x%x\n",
diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
index d880c2f..5e9ad99 100644
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -862,7 +862,7 @@ static int serial2002_attach(struct comedi_device *dev,
 	s->subdev_flags = SDF_READABLE | SDF_GROUND;
 	s->n_chan = 0;
 	s->maxdata = 1;
-	s->range_table = 0;
+	s->range_table = NULL;
 	s->insn_read = &serial2002_ai_rinsn;
 
 	/* analog output subdevice */
@@ -871,7 +871,7 @@ static int serial2002_attach(struct comedi_device *dev,
 	s->subdev_flags = SDF_WRITEABLE;
 	s->n_chan = 0;
 	s->maxdata = 1;
-	s->range_table = 0;
+	s->range_table = NULL;
 	s->insn_write = &serial2002_ao_winsn;
 	s->insn_read = &serial2002_ao_rinsn;
 
@@ -881,7 +881,7 @@ static int serial2002_attach(struct comedi_device *dev,
 	s->subdev_flags = SDF_READABLE | SDF_LSAMPL;
 	s->n_chan = 0;
 	s->maxdata = 1;
-	s->range_table = 0;
+	s->range_table = NULL;
 	s->insn_read = &serial2002_ei_rinsn;
 
 	return 1;
diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
index de8ac0b..37775fc 100644
--- a/drivers/staging/cxt1e1/hwprobe.c
+++ b/drivers/staging/cxt1e1/hwprobe.c
@@ -163,7 +163,7 @@ prep_hdw_info (void)
         hi->pci_slot = 0xff;
         hi->pci_pin[0] = 0;
         hi->pci_pin[1] = 0;
-        hi->ndev = 0;
+        hi->ndev = NULL;
         hi->addr[0] = 0L;
         hi->addr[1] = 0L;
         hi->addr_mapped[0] = 0L;
diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
index 911c0e4..9706f5f 100644
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@ -251,7 +251,7 @@ c4_wq_port_cleanup (mpi_t * pi)
     {
         destroy_workqueue (pi->wq_port);        /* this also calls
                                                  * flush_workqueue() */
-        pi->wq_port = 0;
+        pi->wq_port = NULL;
     }
 }
 
@@ -750,7 +750,7 @@ do_deluser (struct net_device * ndev, int lockit)
         ch = c4_find_chan (channum);
         if (ch == NULL)
             return -ENOENT;
-        ch->user = 0;               /* will be freed, below */
+        ch->user = NULL;               /* will be freed, below */
     }
 
     if (lockit)
diff --git a/drivers/staging/cxt1e1/musycc.c b/drivers/staging/cxt1e1/musycc.c
index 90c0f1e..7f3fcb8 100644
--- a/drivers/staging/cxt1e1/musycc.c
+++ b/drivers/staging/cxt1e1/musycc.c
@@ -829,7 +829,7 @@ musycc_init (ci_t * ci)
             {
                 pi = &ci->port[gchan];
                 OS_kfree (pi->reg);
-                pi->reg = 0;
+                pi->reg = NULL;
             }
             return ENOMEM;
         }
@@ -1001,7 +1001,7 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
 #endif                              /*** CONFIG_SBE_WAN256T3_NCOMM ***/
 
             OS_mem_token_free_irq (md->mem_token);
-            md->mem_token = 0;
+            md->mem_token = NULL;
         }
         md->status = 0;
 #ifdef RLD_TXFULL_DEBUG
@@ -1702,10 +1702,10 @@ musycc_chan_down (ci_t * dummy, int channum)
     }
 
     OS_kfree (ch->mdr);
-    ch->mdr = 0;
+    ch->mdr = NULL;
     ch->rxd_num = 0;
     OS_kfree (ch->mdt);
-    ch->mdt = 0;
+    ch->mdt = NULL;
     ch->txd_num = 0;
 
     musycc_update_timeslots (pi);
diff --git a/drivers/staging/cxt1e1/pmcc4_drv.c b/drivers/staging/cxt1e1/pmcc4_drv.c
index 8a7b3a6..681a75a 100644
--- a/drivers/staging/cxt1e1/pmcc4_drv.c
+++ b/drivers/staging/cxt1e1/pmcc4_drv.c
@@ -77,7 +77,7 @@ extern void *memset (void *s, int c, size_t n);
 #endif
 
 int         drvr_state = SBE_DRVR_INIT;
-ci_t       *c4_list = 0;
+ci_t       *c4_list = NULL;
 ci_t       *CI;                 /* dummy pointer to board ZEROE's data -
                                  * DEBUG USAGE */
 
@@ -838,7 +838,7 @@ c4_musycc_rw (ci_t * ci, struct c4_musycc_param * mcp)
 {
     mpi_t      *pi;
     volatile u_int32_t *dph;    /* hardware implemented register */
-    u_int32_t  *dpr = 0;        /* RAM image of registers for group command
+    u_int32_t  *dpr = NULL;        /* RAM image of registers for group command
                                  * usage */
     int         offset = mcp->offset % 0x800;   /* group relative address
                                                  * offset, mcp->portnum is
@@ -1399,7 +1399,7 @@ c4_chan_up (ci_t * ci, int channum)
         md->status = HOST_TX_OWNED; /* Host owns TX descriptor ** CODING
                                      * NOTE: HOST_TX_OWNED = 0 so no need to
                                      * byteSwap */
-        md->mem_token = 0;
+        md->mem_token = NULL;
         md->data = 0;
         if (i == (txnum - 1))
         {
@@ -1455,10 +1455,10 @@ errfree:
         OS_mem_token_free (ch->mdr[i].mem_token);
     }
     OS_kfree (ch->mdt);
-    ch->mdt = 0;
+    ch->mdt = NULL;
     ch->txd_num = 0;
     OS_kfree (ch->mdr);
-    ch->mdr = 0;
+    ch->mdr = NULL;
     ch->rxd_num = 0;
     ch->state = DOWN;
     return ENOBUFS;
diff --git a/drivers/staging/cxt1e1/sbecrc.c b/drivers/staging/cxt1e1/sbecrc.c
index 3f3cd60..e5777ad 100644
--- a/drivers/staging/cxt1e1/sbecrc.c
+++ b/drivers/staging/cxt1e1/sbecrc.c
@@ -90,7 +90,7 @@ sbeCrc (u_int8_t *buffer,          /* data buffer to crc */
         u_int32_t initialCrc,      /* starting CRC */
         u_int32_t *result)
 {
-    u_int32_t     *tbl = 0;
+    u_int32_t     *tbl = NULL;
     u_int32_t      temp1, temp2, crc;
 
     /*
diff --git a/drivers/staging/cxt1e1/sbeid.c b/drivers/staging/cxt1e1/sbeid.c
index a2243b1..a12198e 100644
--- a/drivers/staging/cxt1e1/sbeid.c
+++ b/drivers/staging/cxt1e1/sbeid.c
@@ -29,7 +29,7 @@
 char       *
 sbeid_get_bdname (ci_t * ci)
 {
-    char       *np = 0;
+    char       *np = NULL;
 
     switch (ci->brd_id)
     {
diff --git a/drivers/staging/cxt1e1/sbeproc.c b/drivers/staging/cxt1e1/sbeproc.c
index f42531c..5f25b97 100644
--- a/drivers/staging/cxt1e1/sbeproc.c
+++ b/drivers/staging/cxt1e1/sbeproc.c
@@ -73,7 +73,7 @@ sbecom_proc_get_sbe_info (char *buffer, char **start, off_t offset,
     {
         hdw_info_t *hi = &hdw_info[ci->brdno];
 
-        u_int8_t *bsn = 0;
+        u_int8_t *bsn = NULL;
 
         switch (hi->promfmt)
         {
diff --git a/drivers/staging/gma500/framebuffer.c b/drivers/staging/gma500/framebuffer.c
index b00761c..770ba00 100644
--- a/drivers/staging/gma500/framebuffer.c
+++ b/drivers/staging/gma500/framebuffer.c
@@ -111,7 +111,7 @@ static int psbfb_pan(struct fb_var_screeninfo *var, struct fb_info *info)
 
 void psbfb_suspend(struct drm_device *dev)
 {
-	struct drm_framebuffer *fb = 0;
+	struct drm_framebuffer *fb = NULL;
 	struct psb_framebuffer *psbfb = to_psb_fb(fb);
 
 	console_lock();
@@ -127,7 +127,7 @@ void psbfb_suspend(struct drm_device *dev)
 
 void psbfb_resume(struct drm_device *dev)
 {
-	struct drm_framebuffer *fb = 0;
+	struct drm_framebuffer *fb = NULL;
 	struct psb_framebuffer *psbfb = to_psb_fb(fb);
 
 	console_lock();
diff --git a/drivers/staging/iio/Documentation/iio_utils.h b/drivers/staging/iio/Documentation/iio_utils.h
index 6f3a392..a5b463b 100644
--- a/drivers/staging/iio/Documentation/iio_utils.h
+++ b/drivers/staging/iio/Documentation/iio_utils.h
@@ -103,7 +103,7 @@ inline int iioutils_get_type(unsigned *is_signed,
 	FILE *sysfsfp;
 	int ret;
 	DIR *dp;
-	char *scan_el_dir, *builtname, *builtname_generic, *filename = 0;
+	char *scan_el_dir, *builtname, *builtname_generic, *filename = NULL;
 	char signchar, endianchar;
 	unsigned padint;
 	const struct dirent *ent;
@@ -172,7 +172,7 @@ inline int iioutils_get_type(unsigned *is_signed,
 			fclose(sysfsfp);
 			free(filename);
 
-			filename = 0;
+			filename = NULL;
 		}
 error_free_filename:
 	if (filename)
diff --git a/drivers/staging/line6/midi.c b/drivers/staging/line6/midi.c
index 13d0293..262b462 100644
--- a/drivers/staging/line6/midi.c
+++ b/drivers/staging/line6/midi.c
@@ -237,7 +237,7 @@ static void line6_midi_input_trigger(struct snd_rawmidi_substream *substream,
 	if (up)
 		line6->line6midi->substream_receive = substream;
 	else
-		line6->line6midi->substream_receive = 0;
+		line6->line6midi->substream_receive = NULL;
 }
 
 static struct snd_rawmidi_ops line6_midi_output_ops = {
diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
index 1c04185..f0c04f6 100644
--- a/drivers/staging/media/cxd2099/cxd2099.c
+++ b/drivers/staging/media/cxd2099/cxd2099.c
@@ -683,7 +683,7 @@ struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
 				      void *priv,
 				      struct i2c_adapter *i2c)
 {
-	struct cxd *ci = 0;
+	struct cxd *ci = NULL;
 	u8 val;
 
 	if (i2c_read_reg(i2c, cfg->adr, 0, &val) < 0) {
diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index c09be0a..ffeee50 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -2274,7 +2274,7 @@ void rtl8192_usb_deleteendpoints(struct net_device *dev)
 	priv->oldaddr = NULL;
 	if (priv->pp_rxskb) {
 		kfree(priv->pp_rxskb);
-		priv->pp_rxskb = 0;
+		priv->pp_rxskb = NULL;
 	}
 }
 #else
@@ -2302,7 +2302,7 @@ void rtl8192_usb_deleteendpoints(struct net_device *dev)
 	priv->oldaddr = NULL;
 	if (priv->pp_rxskb) {
 		kfree(priv->pp_rxskb);
-		priv->pp_rxskb = 0;
+		priv->pp_rxskb = NULL;
 
 	}
 
diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 6b3d156..bf66ecf 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -1500,7 +1500,7 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 	/* Number of entries in lli table */
 	u32 num_entries_in_table = 0;
 	/* Next table address */
-	void *lli_table_alloc_addr = 0;
+	void *lli_table_alloc_addr = NULL;
 
 	dev_dbg(&sep->pdev->dev, "prepare intput dma table data_size is %x\n", data_size);
 	dev_dbg(&sep->pdev->dev, "block_size is %x\n", block_size);
@@ -1671,7 +1671,7 @@ static int sep_construct_dma_tables_from_lli(
 	u32	*table_data_size_ptr)
 {
 	/* Points to the area where next lli table can be allocated */
-	void *lli_table_alloc_addr = 0;
+	void *lli_table_alloc_addr = NULL;
 	/* Input lli table */
 	struct sep_lli_entry *in_lli_table_ptr = NULL;
 	/* Output lli table */
diff --git a/drivers/tty/serial/68328serial.c b/drivers/tty/serial/68328serial.c
index a88ef97..0244115 100644
--- a/drivers/tty/serial/68328serial.c
+++ b/drivers/tty/serial/68328serial.c
@@ -74,7 +74,7 @@ static unsigned int uart_irqs[NR_PORTS] = UART_IRQ_DEFNS;
 m68328_uart *uart_addr = (m68328_uart *)USTCNT_ADDR;
 
 struct tty_struct m68k_ttys;
-struct m68k_serial *m68k_consinfo = 0;
+struct m68k_serial *m68k_consinfo = NULL;
 
 #define M68K_CLOCK (16667000) /* FIXME: 16MHz is likely wrong */
 
@@ -427,7 +427,7 @@ static void shutdown(struct m68k_serial * info)
 	
 	if (info->xmit_buf) {
 		free_page((unsigned long) info->xmit_buf);
-		info->xmit_buf = 0;
+		info->xmit_buf = NULL;
 	}
 
 	if (info->tty)
diff --git a/drivers/tty/serial/msm_smd_tty.c b/drivers/tty/serial/msm_smd_tty.c
index 4f41dcd..59bb529 100644
--- a/drivers/tty/serial/msm_smd_tty.c
+++ b/drivers/tty/serial/msm_smd_tty.c
@@ -123,7 +123,7 @@ static void smd_tty_port_shutdown(struct tty_port *tport)
 	info = tty->driver_data;
 	if (info->ch) {
 		smd_close(info->ch);
-		info->ch = 0;
+		info->ch = NULL;
 	}
 
 	tty->driver_data = 0;
diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 6353eca..a3c98b4 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -3184,10 +3184,10 @@ fsg_config_from_params(struct fsg_config *cfg,
 	}
 
 	/* Let MSF use defaults */
-	cfg->lun_name_format = 0;
-	cfg->thread_name = 0;
-	cfg->vendor_name = 0;
-	cfg->product_name = 0;
+	cfg->lun_name_format = NULL;
+	cfg->thread_name = NULL;
+	cfg->vendor_name = NULL;
+	cfg->product_name = NULL;
 	cfg->release = 0xffff;
 
 	cfg->ops = NULL;
diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index d7ea6c0..2ba0886 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -1972,7 +1972,7 @@ static int fsl_start(struct usb_gadget_driver *driver,
 				ERR("can't bind to transceiver\n");
 				driver->unbind(&udc_controller->gadget);
 				udc_controller->gadget.dev.driver = 0;
-				udc_controller->driver = 0;
+				udc_controller->driver = NULL;
 				return retval;
 			}
 		}
diff --git a/drivers/usb/gadget/s3c-hsudc.c b/drivers/usb/gadget/s3c-hsudc.c
index df8661d..a956a4b 100644
--- a/drivers/usb/gadget/s3c-hsudc.c
+++ b/drivers/usb/gadget/s3c-hsudc.c
@@ -815,7 +815,7 @@ static int s3c_hsudc_ep_disable(struct usb_ep *_ep)
 
 	s3c_hsudc_nuke_ep(hsep, -ESHUTDOWN);
 
-	hsep->desc = 0;
+	hsep->desc = NULL;
 	hsep->stopped = 1;
 
 	spin_unlock_irqrestore(&hsudc->lock, flags);
@@ -905,12 +905,12 @@ static int s3c_hsudc_queue(struct usb_ep *_ep, struct usb_request *_req,
 			csr = readl((u32)hsudc->regs + offset);
 			if (!(csr & S3C_ESR_TX_SUCCESS) &&
 				(s3c_hsudc_write_fifo(hsep, hsreq) == 1))
-				hsreq = 0;
+				hsreq = NULL;
 		} else {
 			csr = readl((u32)hsudc->regs + offset);
 			if ((csr & S3C_ESR_RX_SUCCESS)
 				   && (s3c_hsudc_read_fifo(hsep, hsreq) == 1))
-				hsreq = 0;
+				hsreq = NULL;
 		}
 	}
 
@@ -1004,7 +1004,7 @@ static void s3c_hsudc_initep(struct s3c_hsudc *hsudc,
 	hsep->ep.maxpacket = epnum ? 512 : 64;
 	hsep->ep.ops = &s3c_hsudc_ep_ops;
 	hsep->fifo = hsudc->regs + S3C_BR(epnum);
-	hsep->desc = 0;
+	hsep->desc = NULL;
 	hsep->stopped = 0;
 	hsep->wedge = 0;
 
diff --git a/drivers/usb/host/ohci-omap.c b/drivers/usb/host/ohci-omap.c
index db39686..8d46db1 100644
--- a/drivers/usb/host/ohci-omap.c
+++ b/drivers/usb/host/ohci-omap.c
@@ -301,7 +301,7 @@ static int usb_hcd_omap_probe (const struct hc_driver *driver,
 			  struct platform_device *pdev)
 {
 	int retval, irq;
-	struct usb_hcd *hcd = 0;
+	struct usb_hcd *hcd = NULL;
 	struct ohci_hcd *ohci;
 
 	if (pdev->num_resources != 2) {
diff --git a/drivers/usb/host/ohci-pnx4008.c b/drivers/usb/host/ohci-pnx4008.c
index 0013db7..311d944 100644
--- a/drivers/usb/host/ohci-pnx4008.c
+++ b/drivers/usb/host/ohci-pnx4008.c
@@ -294,7 +294,7 @@ static void pnx4008_unset_usb_bits(void)
 
 static int __devinit usb_hcd_pnx4008_probe(struct platform_device *pdev)
 {
-	struct usb_hcd *hcd = 0;
+	struct usb_hcd *hcd = NULL;
 	struct ohci_hcd *ohci;
 	const struct hc_driver *driver = &ohci_pnx4008_hc_driver;
 	struct i2c_adapter *i2c_adap;
diff --git a/drivers/video/atafb.c b/drivers/video/atafb.c
index 64e41f5..0579452 100644
--- a/drivers/video/atafb.c
+++ b/drivers/video/atafb.c
@@ -1134,7 +1134,7 @@ static int falcon_decode_var(struct fb_var_screeninfo *var,
 			/* Choose largest pixelclock <= wanted clock */
 			int i;
 			unsigned long pcl = ULONG_MAX;
-			pclock = 0;
+			pclock = NULL;
 			for (i = 1; i <= 4; i *= 2) {
 				if (f25.t * i >= var->pixclock &&
 				    f25.t * i < pcl) {
diff --git a/drivers/video/msm/mddi.c b/drivers/video/msm/mddi.c
index 4527cbf..9771350 100644
--- a/drivers/video/msm/mddi.c
+++ b/drivers/video/msm/mddi.c
@@ -535,7 +535,7 @@ void mddi_remote_write(struct msm_mddi_client_data *cdata, uint32_t val,
 	ll->data_count = 4;
 	ll->data = mddi->reg_write_addr + offsetof(struct mddi_llentry,
 						   u.r.register_data_list);
-	ll->next = 0;
+	ll->next = NULL;
 	ll->reserved = 0;
 
 	mddi_writel(mddi->reg_write_addr, PRI_PTR);
@@ -572,7 +572,7 @@ uint32_t mddi_remote_read(struct msm_mddi_client_data *cdata, uint32_t reg)
 	ll->header_count = 14;
 	ll->data_count = 0;
 	ll->data = 0;
-	ll->next = 0;
+	ll->next = NULL;
 	ll->reserved = 0;
 
 	s = mddi_readl(STAT);
diff --git a/drivers/video/msm/mddi_client_toshiba.c b/drivers/video/msm/mddi_client_toshiba.c
index f9bc932..64dabcb 100644
--- a/drivers/video/msm/mddi_client_toshiba.c
+++ b/drivers/video/msm/mddi_client_toshiba.c
@@ -169,7 +169,7 @@ irqreturn_t toshiba_vsync_interrupt(int irq, void *data)
 	panel->toshiba_got_int = 1;
 	if (panel->toshiba_callback) {
 		panel->toshiba_callback->func(panel->toshiba_callback);
-		panel->toshiba_callback = 0;
+		panel->toshiba_callback = NULL;
 	}
 	wake_up(&toshiba_vsync_wait);
 	return IRQ_HANDLED;
diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
index cb2ddf1..4c2444e 100644
--- a/drivers/video/msm/mdp.c
+++ b/drivers/video/msm/mdp.c
@@ -284,7 +284,7 @@ int mdp_blit(struct mdp_device *mdp_dev, struct fb_info *fb,
 	int ret;
 	unsigned long src_start = 0, src_len = 0, dst_start = 0, dst_len = 0;
 	struct mdp_info *mdp = container_of(mdp_dev, struct mdp_info, mdp_dev);
-	struct file *src_file = 0, *dst_file = 0;
+	struct file *src_file = NULL, *dst_file = NULL;
 
 	/* WORKAROUND FOR HARDWARE BUG IN BG TILE FETCH */
 	if (unlikely(req->src_rect.h == 0 ||
diff --git a/drivers/video/pxa168fb.c b/drivers/video/pxa168fb.c
index 8384b94..ecfd62e 100644
--- a/drivers/video/pxa168fb.c
+++ b/drivers/video/pxa168fb.c
@@ -602,8 +602,8 @@ static int __devinit pxa168fb_init_mode(struct fb_info *info,
 static int __devinit pxa168fb_probe(struct platform_device *pdev)
 {
 	struct pxa168fb_mach_info *mi;
-	struct fb_info *info = 0;
-	struct pxa168fb_info *fbi = 0;
+	struct fb_info *info = NULL;
+	struct pxa168fb_info *fbi = NULL;
 	struct resource *res;
 	struct clk *clk;
 	int irq, ret;
diff --git a/drivers/video/smscufx.c b/drivers/video/smscufx.c
index ccbfef5..e63fedc 100644
--- a/drivers/video/smscufx.c
+++ b/drivers/video/smscufx.c
@@ -1144,7 +1144,7 @@ static void ufx_free_framebuffer_work(struct work_struct *work)
 
 	fb_destroy_modelist(&info->modelist);
 
-	dev->info = 0;
+	dev->info = NULL;
 
 	/* Assume info structure is freed after this point */
 	framebuffer_release(info);
@@ -1619,7 +1619,7 @@ static int ufx_usb_probe(struct usb_interface *interface,
 {
 	struct usb_device *usbdev;
 	struct ufx_data *dev;
-	struct fb_info *info = 0;
+	struct fb_info *info = NULL;
 	int retval = -ENOMEM;
 	u32 id_rev, fpga_rev;
 
diff --git a/drivers/video/udlfb.c b/drivers/video/udlfb.c
index a197731..f0a6423 100644
--- a/drivers/video/udlfb.c
+++ b/drivers/video/udlfb.c
@@ -430,10 +430,10 @@ static void dlfb_compress_hline(
 
 	while ((pixel_end > pixel) &&
 	       (cmd_buffer_end - MIN_RLX_CMD_BYTES > cmd)) {
-		uint8_t *raw_pixels_count_byte = 0;
-		uint8_t *cmd_pixels_count_byte = 0;
-		const uint16_t *raw_pixel_start = 0;
-		const uint16_t *cmd_pixel_start, *cmd_pixel_end = 0;
+		uint8_t *raw_pixels_count_byte = NULL;
+		uint8_t *cmd_pixels_count_byte = NULL;
+		const uint16_t *raw_pixel_start = NULL;
+		const uint16_t *cmd_pixel_start, *cmd_pixel_end = NULL;
 
 		prefetchw((void *) cmd); /* pull in one cache line at least */
 
@@ -1158,7 +1158,7 @@ static int dlfb_realloc_framebuffer(struct dlfb_data *dev, struct fb_info *info)
 	int new_len;
 	unsigned char *old_fb = info->screen_base;
 	unsigned char *new_fb;
-	unsigned char *new_back = 0;
+	unsigned char *new_back = NULL;
 
 	pr_warn("Reallocating framebuffer. Addresses will change!\n");
 
@@ -1574,8 +1574,8 @@ static int dlfb_usb_probe(struct usb_interface *interface,
 			const struct usb_device_id *id)
 {
 	struct usb_device *usbdev;
-	struct dlfb_data *dev = 0;
-	struct fb_info *info = 0;
+	struct dlfb_data *dev = NULL;
+	struct fb_info *info = NULL;
 	int retval = -ENOMEM;
 	int i;
 


