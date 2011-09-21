Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab1IUJdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:33:45 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:37829 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab1IUJdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:33:38 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Sonic Zhang <sonic.zhang@analog.com>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@stericsson.com>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Barry Song <21cnbao@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Joe Perches <joe@perches.com>, Dave Airlie <airlied@linux.ie>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Magnus Damm <damm@opensource.se>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 32/57] i2c: irq: Remove IRQF_DISABLED
Date: Wed, 21 Sep 2011 17:28:33 +0800
Message-Id: <1316597339-29861-33-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [c58543c8: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Barry Song <21cnbao@gmail.com>
---
 drivers/i2c/busses/i2c-bfin-twi.c   |    4 ++--
 drivers/i2c/busses/i2c-designware.c |    2 +-
 drivers/i2c/busses/i2c-highlander.c |    2 +-
 drivers/i2c/busses/i2c-nomadik.c    |    2 +-
 drivers/i2c/busses/i2c-nuc900.c     |    2 +-
 drivers/i2c/busses/i2c-pmcmsp.c     |    2 +-
 drivers/i2c/busses/i2c-s3c2410.c    |    2 +-
 drivers/i2c/busses/i2c-sh7760.c     |    2 +-
 drivers/i2c/busses/i2c-sh_mobile.c  |    2 +-
 drivers/i2c/busses/i2c-stu300.c     |    2 +-
 10 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index cbc98ae..cdb59e5 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -631,7 +631,7 @@ static int i2c_bfin_twi_resume(struct platform_device *pdev)
 	struct bfin_twi_iface *iface = platform_get_drvdata(pdev);
 
 	int rc = request_irq(iface->irq, bfin_twi_interrupt_entry,
-		IRQF_DISABLED, pdev->name, iface);
+		0, pdev->name, iface);
 	if (rc) {
 		dev_err(&pdev->dev, "Can't get IRQ %d !\n", iface->irq);
 		return -ENODEV;
@@ -702,7 +702,7 @@ static int i2c_bfin_twi_probe(struct platform_device *pdev)
 	}
 
 	rc = request_irq(iface->irq, bfin_twi_interrupt_entry,
-		IRQF_DISABLED, pdev->name, iface);
+		0, pdev->name, iface);
 	if (rc) {
 		dev_err(&pdev->dev, "Can't get IRQ %d !\n", iface->irq);
 		rc = -ENODEV;
diff --git a/drivers/i2c/busses/i2c-designware.c b/drivers/i2c/busses/i2c-designware.c
index 1b42b50..2ac1903 100644
--- a/drivers/i2c/busses/i2c-designware.c
+++ b/drivers/i2c/busses/i2c-designware.c
@@ -755,7 +755,7 @@ static int __devinit dw_i2c_probe(struct platform_device *pdev)
 	i2c_dw_init(dev);
 
 	writel(0, dev->base + DW_IC_INTR_MASK); /* disable IRQ */
-	r = request_irq(dev->irq, i2c_dw_isr, IRQF_DISABLED, pdev->name, dev);
+	r = request_irq(dev->irq, i2c_dw_isr, 0, pdev->name, dev);
 	if (r) {
 		dev_err(&pdev->dev, "failure requesting irq %i\n", dev->irq);
 		goto err_iounmap;
diff --git a/drivers/i2c/busses/i2c-highlander.c b/drivers/i2c/busses/i2c-highlander.c
index 3876a24..63bb1cc 100644
--- a/drivers/i2c/busses/i2c-highlander.c
+++ b/drivers/i2c/busses/i2c-highlander.c
@@ -387,7 +387,7 @@ static int __devinit highlander_i2c_probe(struct platform_device *pdev)
 		dev->irq = 0;
 
 	if (dev->irq) {
-		ret = request_irq(dev->irq, highlander_i2c_irq, IRQF_DISABLED,
+		ret = request_irq(dev->irq, highlander_i2c_irq, 0,
 				  pdev->name, dev);
 		if (unlikely(ret))
 			goto err_unmap;
diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index b228e09..40702e8 100644
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@ -935,7 +935,7 @@ static int __devinit nmk_i2c_probe(struct platform_device *pdev)
 	}
 
 	dev->irq = platform_get_irq(pdev, 0);
-	ret = request_irq(dev->irq, i2c_irq_handler, IRQF_DISABLED,
+	ret = request_irq(dev->irq, i2c_irq_handler, 0,
 				DRIVER_NAME, dev);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot claim the irq %d\n", dev->irq);
diff --git a/drivers/i2c/busses/i2c-nuc900.c b/drivers/i2c/busses/i2c-nuc900.c
index 7243426..835e47b 100644
--- a/drivers/i2c/busses/i2c-nuc900.c
+++ b/drivers/i2c/busses/i2c-nuc900.c
@@ -610,7 +610,7 @@ static int __devinit nuc900_i2c_probe(struct platform_device *pdev)
 		goto err_iomap;
 	}
 
-	ret = request_irq(i2c->irq, nuc900_i2c_irq, IRQF_DISABLED | IRQF_SHARED,
+	ret = request_irq(i2c->irq, nuc900_i2c_irq, IRQF_SHARED,
 			  dev_name(&pdev->dev), i2c);
 
 	if (ret != 0) {
diff --git a/drivers/i2c/busses/i2c-pmcmsp.c b/drivers/i2c/busses/i2c-pmcmsp.c
index dfa7ae9..127051b 100644
--- a/drivers/i2c/busses/i2c-pmcmsp.c
+++ b/drivers/i2c/busses/i2c-pmcmsp.c
@@ -306,7 +306,7 @@ static int __devinit pmcmsptwi_probe(struct platform_device *pldev)
 	pmcmsptwi_data.irq = platform_get_irq(pldev, 0);
 	if (pmcmsptwi_data.irq) {
 		rc = request_irq(pmcmsptwi_data.irq, &pmcmsptwi_interrupt,
-			IRQF_SHARED | IRQF_DISABLED | IRQF_SAMPLE_RANDOM,
+			IRQF_SHARED | IRQF_SAMPLE_RANDOM,
 			pldev->name, &pmcmsptwi_data);
 		if (rc == 0) {
 			/*
diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index 9c00ad1..2754cef 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -980,7 +980,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 		goto err_iomap;
 	}
 
-	ret = request_irq(i2c->irq, s3c24xx_i2c_irq, IRQF_DISABLED,
+	ret = request_irq(i2c->irq, s3c24xx_i2c_irq, 0,
 			  dev_name(&pdev->dev), i2c);
 
 	if (ret != 0) {
diff --git a/drivers/i2c/busses/i2c-sh7760.c b/drivers/i2c/busses/i2c-sh7760.c
index 4cd0a1d..a67132b 100644
--- a/drivers/i2c/busses/i2c-sh7760.c
+++ b/drivers/i2c/busses/i2c-sh7760.c
@@ -503,7 +503,7 @@ static int __devinit sh7760_i2c_probe(struct platform_device *pdev)
 	}
 	OUT32(id, I2CCCR, ret);
 
-	if (request_irq(id->irq, sh7760_i2c_irq, IRQF_DISABLED,
+	if (request_irq(id->irq, sh7760_i2c_irq, 0,
 			SH7760_I2C_DEVNAME, id)) {
 		dev_err(&pdev->dev, "cannot get irq %d\n", id->irq);
 		ret = -EBUSY;
diff --git a/drivers/i2c/busses/i2c-sh_mobile.c b/drivers/i2c/busses/i2c-sh_mobile.c
index f633a53..675c969 100644
--- a/drivers/i2c/busses/i2c-sh_mobile.c
+++ b/drivers/i2c/busses/i2c-sh_mobile.c
@@ -543,7 +543,7 @@ static int sh_mobile_i2c_hook_irqs(struct platform_device *dev, int hook)
 
 	while ((res = platform_get_resource(dev, IORESOURCE_IRQ, k))) {
 		for (n = res->start; hook && n <= res->end; n++) {
-			if (request_irq(n, sh_mobile_i2c_isr, IRQF_DISABLED,
+			if (request_irq(n, sh_mobile_i2c_isr, 0,
 					dev_name(&dev->dev), dev)) {
 				for (n--; n >= res->start; n--)
 					free_irq(n, dev);
diff --git a/drivers/i2c/busses/i2c-stu300.c b/drivers/i2c/busses/i2c-stu300.c
index 9987961..4d44af1 100644
--- a/drivers/i2c/busses/i2c-stu300.c
+++ b/drivers/i2c/busses/i2c-stu300.c
@@ -916,7 +916,7 @@ stu300_probe(struct platform_device *pdev)
 	}
 
 	dev->irq = platform_get_irq(pdev, 0);
-	if (request_irq(dev->irq, stu300_irh, IRQF_DISABLED,
+	if (request_irq(dev->irq, stu300_irh, 0,
 			NAME, dev)) {
 		ret = -EIO;
 		goto err_no_irq;
-- 
1.7.4.1

