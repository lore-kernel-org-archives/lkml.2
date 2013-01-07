Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab3AGFKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 00:10:35 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39717 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab3AGFK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 00:10:29 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Sekhar Nori <nsekhar@ti.com>, Vaibhav Hiremath <hvaibhav@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>
Subject: [PATCH 06/10] video: da8xx-fb: minimal dt support
Date: Mon, 7 Jan 2013 10:41:11 +0530
Message-ID: <af85c00fcd63618d67ef6d9026f1af7ae35299d2.1357304090.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1357304090.git.afzal@ti.com>
References: <cover.1357304090.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver is provided a means to have the probe triggered by DT.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 .../devicetree/bindings/video/fb-da8xx.txt         |   16 ++++++++++++++++
 drivers/video/da8xx-fb.c                           |    7 +++++++
 2 files changed, 23 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/fb-da8xx.txt

diff --git a/Documentation/devicetree/bindings/video/fb-da8xx.txt b/Documentation/devicetree/bindings/video/fb-da8xx.txt
new file mode 100644
index 0000000..581e014
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/fb-da8xx.txt
@@ -0,0 +1,16 @@
+TI LCD Controller on DA830/DA850/AM335x SoC's
+
+Required properties:
+- compatible:
+	DA830 - "ti,da830-lcdc"
+	AM335x SoC's - "ti,am3352-lcdc", "ti,da830-lcdc"
+- reg: Address range of lcdc register set
+- interrupts: lcdc interrupt
+
+Example:
+
+lcdc@4830e000 {
+	compatible = "ti,am3352-lcdc", "ti,da830-lcdc";
+	reg =  <0x4830e000 0x1000>;
+	interrupts = <36>;
+};
diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 991d9e3..d10479f 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -1599,6 +1599,12 @@ static int fb_resume(struct platform_device *dev)
 #define fb_resume NULL
 #endif
 
+static const struct of_device_id da8xx_fb_of_match[] = {
+	{.compatible = "ti,da830-lcdc", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, da8xx_fb_of_match);
+
 static struct platform_driver da8xx_fb_driver = {
 	.probe = fb_probe,
 	.remove = __devexit_p(fb_remove),
@@ -1607,6 +1613,7 @@ static struct platform_driver da8xx_fb_driver = {
 	.driver = {
 		   .name = DRIVER_NAME,
 		   .owner = THIS_MODULE,
+		   .of_match_table = of_match_ptr(da8xx_fb_of_match),
 		   },
 };
 
-- 
1.7.9.5

