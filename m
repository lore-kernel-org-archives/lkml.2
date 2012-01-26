Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318Ab2AZGg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 01:36:59 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:55621 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750757Ab2AZGg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 01:36:58 -0500
Message-ID: <1327559803.28707.6.camel@joe2Laptop>
Subject: drivers: Use NULL not zero for pointer
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>, Jiri Kosina <trivial@kernel.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Jan 2012 22:36:43 -0800
In-Reply-To: <20120126061330.GA15856@elgon.mountain>
References: <20120126061330.GA15856@elgon.mountain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some assignments that should use NULL
not 0;

Done via script:

$ grep -rPl --include=*.[ch] "\bstruct\s+\w+\s*\*\s*\w+\s*\=\s*0\s*;" drivers | \
  xargs sed -r -i -e 's/\b(struct\s+\w+\s*\*\s*\w+)\s*\=\s*0\s*;/\1 = NULL;/g'

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/gpu/drm/gma500/framebuffer.c    |    4 ++--
 drivers/input/input-mt.c                |    2 +-
 drivers/iommu/amd_iommu_init.c          |    2 +-
 drivers/scsi/lpfc/lpfc_sli.c            |    2 +-
 drivers/staging/gma500/framebuffer.c    |    4 ++--
 drivers/staging/media/cxd2099/cxd2099.c |    2 +-
 drivers/tty/serial/68328serial.c        |    2 +-
 drivers/usb/host/ohci-omap.c            |    2 +-
 drivers/usb/host/ohci-pnx4008.c         |    2 +-
 drivers/video/pxa168fb.c                |    4 ++--
 drivers/video/smscufx.c                 |    2 +-
 drivers/video/udlfb.c                   |    4 ++--
 12 files changed, 16 insertions(+), 16 deletions(-)

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
diff --git a/drivers/tty/serial/68328serial.c b/drivers/tty/serial/68328serial.c
index a88ef97..8df7fa8 100644
--- a/drivers/tty/serial/68328serial.c
+++ b/drivers/tty/serial/68328serial.c
@@ -74,7 +74,7 @@ static unsigned int uart_irqs[NR_PORTS] = UART_IRQ_DEFNS;
 m68328_uart *uart_addr = (m68328_uart *)USTCNT_ADDR;
 
 struct tty_struct m68k_ttys;
-struct m68k_serial *m68k_consinfo = 0;
+struct m68k_serial *m68k_consinfo = NULL;
 
 #define M68K_CLOCK (16667000) /* FIXME: 16MHz is likely wrong */
 
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
index ccbfef5..376d84a 100644
--- a/drivers/video/smscufx.c
+++ b/drivers/video/smscufx.c
@@ -1619,7 +1619,7 @@ static int ufx_usb_probe(struct usb_interface *interface,
 {
 	struct usb_device *usbdev;
 	struct ufx_data *dev;
-	struct fb_info *info = 0;
+	struct fb_info *info = NULL;
 	int retval = -ENOMEM;
 	u32 id_rev, fpga_rev;
 
diff --git a/drivers/video/udlfb.c b/drivers/video/udlfb.c
index a197731..f4e6374 100644
--- a/drivers/video/udlfb.c
+++ b/drivers/video/udlfb.c
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
 


