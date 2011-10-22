Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab1JVKMF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 06:12:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57970 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab1JVKMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 06:12:02 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, Michael Hunold <michael@mihu.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
        Andy Walls <awalls@md.metrocast.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org,
        ivtv-devel@ivtvdriver.org, linux-arm-kernel@lists.infradead.org,
        mjpeg-users@lists.sourceforge.net
Subject: [PATCH 32/49] media: irq: Remove IRQF_DISABLED
Date: Sat, 22 Oct 2011 17:56:44 +0800
Message-Id: <1319277421-9203-33-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com>
References: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/saa7146_core.c        |    2 +-
 drivers/media/dvb/bt8xx/bt878.c            |    2 +-
 drivers/media/radio/si4713-i2c.c           |    2 +-
 drivers/media/rc/winbond-cir.c             |    2 +-
 drivers/media/video/bt8xx/bttv-driver.c    |    2 +-
 drivers/media/video/cx18/cx18-driver.c     |    2 +-
 drivers/media/video/cx23885/cx23885-core.c |    2 +-
 drivers/media/video/cx88/cx88-alsa.c       |    2 +-
 drivers/media/video/cx88/cx88-mpeg.c       |    2 +-
 drivers/media/video/cx88/cx88-video.c      |    2 +-
 drivers/media/video/davinci/vpbe_display.c |    2 +-
 drivers/media/video/davinci/vpfe_capture.c |    4 ++--
 drivers/media/video/davinci/vpif_capture.c |    2 +-
 drivers/media/video/davinci/vpif_display.c |    2 +-
 drivers/media/video/ivtv/ivtv-driver.c     |    2 +-
 drivers/media/video/meye.c                 |    2 +-
 drivers/media/video/s5p-mfc/s5p_mfc.c      |    3 +--
 drivers/media/video/saa7134/saa7134-alsa.c |    2 +-
 drivers/media/video/saa7134/saa7134-core.c |    2 +-
 drivers/media/video/saa7164/saa7164-core.c |    2 +-
 drivers/media/video/sh_mobile_ceu_camera.c |    2 +-
 drivers/media/video/zoran/zoran_card.c     |    2 +-
 22 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/media/common/saa7146_core.c b/drivers/media/common/saa7146_core.c
index d6b1cf6..dc8bf5e 100644
--- a/drivers/media/common/saa7146_core.c
+++ b/drivers/media/common/saa7146_core.c
@@ -414,7 +414,7 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
 	saa7146_write(dev, MC2, 0xf8000000);
 
 	/* request an interrupt for the saa7146 */
-	err = request_irq(pci->irq, interrupt_hw, IRQF_SHARED | IRQF_DISABLED,
+	err = request_irq(pci->irq, interrupt_hw, IRQF_SHARED,
 			  dev->name, dev);
 	if (err < 0) {
 		ERR("request_irq() failed\n");
diff --git a/drivers/media/dvb/bt8xx/bt878.c b/drivers/media/dvb/bt8xx/bt878.c
index b34fa95..d6d78df 100644
--- a/drivers/media/dvb/bt8xx/bt878.c
+++ b/drivers/media/dvb/bt8xx/bt878.c
@@ -489,7 +489,7 @@ static int __devinit bt878_probe(struct pci_dev *dev,
 	btwrite(0, BT848_INT_MASK);
 
 	result = request_irq(bt->irq, bt878_irq,
-			     IRQF_SHARED | IRQF_DISABLED, "bt878",
+			     IRQF_SHARED, "bt878",
 			     (void *) bt);
 	if (result == -EINVAL) {
 		printk(KERN_ERR "bt878(%d): Bad irq number or handler\n",
diff --git a/drivers/media/radio/si4713-i2c.c b/drivers/media/radio/si4713-i2c.c
index 27aba93..5d48210 100644
--- a/drivers/media/radio/si4713-i2c.c
+++ b/drivers/media/radio/si4713-i2c.c
@@ -2036,7 +2036,7 @@ static int si4713_probe(struct i2c_client *client,
 
 	if (client->irq) {
 		rval = request_irq(client->irq,
-			si4713_handler, IRQF_TRIGGER_FALLING | IRQF_DISABLED,
+			si4713_handler, IRQF_TRIGGER_FALLING,
 			client->name, sdev);
 		if (rval < 0) {
 			v4l2_err(&sdev->sd, "Could not request IRQ\n");
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 13f54b5..2a33b8e 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -1013,7 +1013,7 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	}
 
 	err = request_irq(data->irq, wbcir_irq_handler,
-			  IRQF_DISABLED, DRVNAME, device);
+			  0, DRVNAME, device);
 	if (err) {
 		dev_err(dev, "Failed to claim IRQ %u\n", data->irq);
 		err = -EBUSY;
diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 3dd0660..966d57f 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -4336,7 +4336,7 @@ static int __devinit bttv_probe(struct pci_dev *dev,
 	/* disable irqs, register irq handler */
 	btwrite(0, BT848_INT_MASK);
 	result = request_irq(btv->c.pci->irq, bttv_irq,
-	    IRQF_SHARED | IRQF_DISABLED, btv->c.v4l2_dev.name, (void *)btv);
+	    IRQF_SHARED, btv->c.v4l2_dev.name, (void *)btv);
 	if (result < 0) {
 		pr_err("%d: can't get IRQ %d\n",
 		       bttv_num, btv->c.pci->irq);
diff --git a/drivers/media/video/cx18/cx18-driver.c b/drivers/media/video/cx18/cx18-driver.c
index 9e2f870..185221a 100644
--- a/drivers/media/video/cx18/cx18-driver.c
+++ b/drivers/media/video/cx18/cx18-driver.c
@@ -1031,7 +1031,7 @@ static int __devinit cx18_probe(struct pci_dev *pci_dev,
 
 	/* Register IRQ */
 	retval = request_irq(cx->pci_dev->irq, cx18_irq_handler,
-			     IRQF_SHARED | IRQF_DISABLED,
+			     IRQF_SHARED,
 			     cx->v4l2_dev.name, (void *)cx);
 	if (retval) {
 		CX18_ERR("Failed to register irq %d\n", retval);
diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index ee41a88..84464f5 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -2062,7 +2062,7 @@ static int __devinit cx23885_initdev(struct pci_dev *pci_dev,
 	}
 
 	err = request_irq(pci_dev->irq, cx23885_irq,
-			  IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
+			  IRQF_SHARED, dev->name, dev);
 	if (err < 0) {
 		printk(KERN_ERR "%s: can't get IRQ %d\n",
 		       dev->name, pci_dev->irq);
diff --git a/drivers/media/video/cx88/cx88-alsa.c b/drivers/media/video/cx88/cx88-alsa.c
index 68d1240..fd0c6b3 100644
--- a/drivers/media/video/cx88/cx88-alsa.c
+++ b/drivers/media/video/cx88/cx88-alsa.c
@@ -849,7 +849,7 @@ static int __devinit snd_cx88_create(struct snd_card *card,
 
 	/* get irq */
 	err = request_irq(chip->pci->irq, cx8801_irq,
-			  IRQF_SHARED | IRQF_DISABLED, chip->core->name, chip);
+			  IRQF_SHARED, chip->core->name, chip);
 	if (err < 0) {
 		dprintk(0, "%s: can't get IRQ %d\n",
 		       chip->core->name, chip->pci->irq);
diff --git a/drivers/media/video/cx88/cx88-mpeg.c b/drivers/media/video/cx88/cx88-mpeg.c
index cd5386e..3488efc 100644
--- a/drivers/media/video/cx88/cx88-mpeg.c
+++ b/drivers/media/video/cx88/cx88-mpeg.c
@@ -497,7 +497,7 @@ static int cx8802_init_common(struct cx8802_dev *dev)
 
 	/* get irq */
 	err = request_irq(dev->pci->irq, cx8802_irq,
-			  IRQF_SHARED | IRQF_DISABLED, dev->core->name, dev);
+			  IRQF_SHARED, dev->core->name, dev);
 	if (err < 0) {
 		printk(KERN_ERR "%s: can't get IRQ %d\n",
 		       dev->core->name, dev->pci->irq);
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 921c56d..1f5d12c 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -1917,7 +1917,7 @@ static int __devinit cx8800_initdev(struct pci_dev *pci_dev,
 
 	/* get irq */
 	err = request_irq(pci_dev->irq, cx8800_irq,
-			  IRQF_SHARED | IRQF_DISABLED, core->name, dev);
+			  IRQF_SHARED, core->name, dev);
 	if (err < 0) {
 		printk(KERN_ERR "%s/0: can't get IRQ %d\n",
 		       core->name,pci_dev->irq);
diff --git a/drivers/media/video/davinci/vpbe_display.c b/drivers/media/video/davinci/vpbe_display.c
index 8588a86..32ea582 100644
--- a/drivers/media/video/davinci/vpbe_display.c
+++ b/drivers/media/video/davinci/vpbe_display.c
@@ -1735,7 +1735,7 @@ static __devinit int vpbe_display_probe(struct platform_device *pdev)
 	}
 
 	irq = res->start;
-	if (request_irq(irq, venc_isr,  IRQF_DISABLED, VPBE_DISPLAY_DRIVER,
+	if (request_irq(irq, venc_isr,  0, VPBE_DISPLAY_DRIVER,
 		disp_dev)) {
 		v4l2_err(&disp_dev->vpbe_dev->v4l2_dev,
 				"Unable to request interrupt\n");
diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index 5b38fc9..adb7c5c 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -691,7 +691,7 @@ static int vpfe_attach_irq(struct vpfe_device *vpfe_dev)
 	frame_format = ccdc_dev->hw_ops.get_frame_format();
 	if (frame_format == CCDC_FRMFMT_PROGRESSIVE) {
 		return request_irq(vpfe_dev->ccdc_irq1, vdint1_isr,
-				    IRQF_DISABLED, "vpfe_capture1",
+				    0, "vpfe_capture1",
 				    vpfe_dev);
 	}
 	return 0;
@@ -1898,7 +1898,7 @@ static __init int vpfe_probe(struct platform_device *pdev)
 	}
 	vpfe_dev->ccdc_irq1 = res1->start;
 
-	ret = request_irq(vpfe_dev->ccdc_irq0, vpfe_isr, IRQF_DISABLED,
+	ret = request_irq(vpfe_dev->ccdc_irq0, vpfe_isr, 0,
 			  "vpfe_capture0", vpfe_dev);
 
 	if (0 != ret) {
diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index 49e4deb..f2785aa 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -2180,7 +2180,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 	k = 0;
 	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, k))) {
 		for (i = res->start; i <= res->end; i++) {
-			if (request_irq(i, vpif_channel_isr, IRQF_DISABLED,
+			if (request_irq(i, vpif_channel_isr, 0,
 					"DM646x_Capture",
 				(void *)(&vpif_obj.dev[k]->channel_id))) {
 				err = -EBUSY;
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index 286f029..7cd4fe8 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -1708,7 +1708,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 	k = 0;
 	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, k))) {
 		for (i = res->start; i <= res->end; i++) {
-			if (request_irq(i, vpif_channel_isr, IRQF_DISABLED,
+			if (request_irq(i, vpif_channel_isr, 0,
 					"DM646x_Display",
 				(void *)(&vpif_obj.dev[k]->channel_id))) {
 				err = -EBUSY;
diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/ivtv/ivtv-driver.c
index 0fb7552..a787082 100644
--- a/drivers/media/video/ivtv/ivtv-driver.c
+++ b/drivers/media/video/ivtv/ivtv-driver.c
@@ -1213,7 +1213,7 @@ static int __devinit ivtv_probe(struct pci_dev *pdev,
 
 	/* Register IRQ */
 	retval = request_irq(itv->pdev->irq, ivtv_irq_handler,
-	     IRQF_SHARED | IRQF_DISABLED, itv->v4l2_dev.name, (void *)itv);
+	     IRQF_SHARED, itv->v4l2_dev.name, (void *)itv);
 	if (retval) {
 		IVTV_ERR("Failed to register irq %d\n", retval);
 		goto free_i2c;
diff --git a/drivers/media/video/meye.c b/drivers/media/video/meye.c
index b09a3c8..d4d8db2 100644
--- a/drivers/media/video/meye.c
+++ b/drivers/media/video/meye.c
@@ -1807,7 +1807,7 @@ static int __devinit meye_probe(struct pci_dev *pcidev,
 
 	meye.mchip_irq = pcidev->irq;
 	if (request_irq(meye.mchip_irq, meye_irq,
-			IRQF_DISABLED | IRQF_SHARED, "meye", meye_irq)) {
+			IRQF_SHARED, "meye", meye_irq)) {
 		v4l2_err(v4l2_dev, "request_irq failed\n");
 		goto outreqirq;
 	}
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c b/drivers/media/video/s5p-mfc/s5p_mfc.c
index 8be8b54..db6f34d 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
@@ -998,8 +998,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 		goto err_get_res;
 	}
 	dev->irq = res->start;
-	ret = request_irq(dev->irq, s5p_mfc_irq, IRQF_DISABLED, pdev->name,
-									dev);
+	ret = request_irq(dev->irq, s5p_mfc_irq, 0, pdev->name, dev);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to install irq (%d)\n", ret);
 		goto err_req_irq;
diff --git a/drivers/media/video/saa7134/saa7134-alsa.c b/drivers/media/video/saa7134/saa7134-alsa.c
index 10460fd..95df27e 100644
--- a/drivers/media/video/saa7134/saa7134-alsa.c
+++ b/drivers/media/video/saa7134/saa7134-alsa.c
@@ -1094,7 +1094,7 @@ static int alsa_card_saa7134_create(struct saa7134_dev *dev, int devnum)
 
 
 	err = request_irq(dev->pci->irq, saa7134_alsa_irq,
-				IRQF_SHARED | IRQF_DISABLED, dev->name,
+				IRQF_SHARED, dev->name,
 				(void*) &dev->dmasound);
 
 	if (err < 0) {
diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/video/saa7134/saa7134-core.c
index ca65cda..259eced 100644
--- a/drivers/media/video/saa7134/saa7134-core.c
+++ b/drivers/media/video/saa7134/saa7134-core.c
@@ -992,7 +992,7 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 
 	/* get irq */
 	err = request_irq(pci_dev->irq, saa7134_irq,
-			  IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
+			  IRQF_SHARED, dev->name, dev);
 	if (err < 0) {
 		printk(KERN_ERR "%s: can't get IRQ %d\n",
 		       dev->name,pci_dev->irq);
diff --git a/drivers/media/video/saa7164/saa7164-core.c b/drivers/media/video/saa7164/saa7164-core.c
index 3b7d7b4..db224fb 100644
--- a/drivers/media/video/saa7164/saa7164-core.c
+++ b/drivers/media/video/saa7164/saa7164-core.c
@@ -1264,7 +1264,7 @@ static int __devinit saa7164_initdev(struct pci_dev *pci_dev,
 	}
 
 	err = request_irq(pci_dev->irq, saa7164_irq,
-		IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
+		IRQF_SHARED, dev->name, dev);
 	if (err < 0) {
 		printk(KERN_ERR "%s: can't get IRQ %d\n", dev->name,
 			pci_dev->irq);
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 8615fb8..98bb590 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -2030,7 +2030,7 @@ static int __devinit sh_mobile_ceu_probe(struct platform_device *pdev)
 	}
 
 	/* request irq */
-	err = request_irq(pcdev->irq, sh_mobile_ceu_irq, IRQF_DISABLED,
+	err = request_irq(pcdev->irq, sh_mobile_ceu_irq, 0,
 			  dev_name(&pdev->dev), pcdev);
 	if (err) {
 		dev_err(&pdev->dev, "Unable to register CEU interrupt.\n");
diff --git a/drivers/media/video/zoran/zoran_card.c b/drivers/media/video/zoran/zoran_card.c
index c3602d6..23b4023 100644
--- a/drivers/media/video/zoran/zoran_card.c
+++ b/drivers/media/video/zoran/zoran_card.c
@@ -1294,7 +1294,7 @@ static int __devinit zoran_probe(struct pci_dev *pdev,
 	}
 
 	result = request_irq(zr->pci_dev->irq, zoran_irq,
-			     IRQF_SHARED | IRQF_DISABLED, ZR_DEVNAME(zr), zr);
+			     IRQF_SHARED, ZR_DEVNAME(zr), zr);
 	if (result < 0) {
 		if (result == -EINVAL) {
 			dprintk(1,
-- 
1.7.1

