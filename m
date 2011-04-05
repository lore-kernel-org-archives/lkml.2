Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab1DEQRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 12:17:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38696 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755096Ab1DEQRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 12:17:50 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH] gma500: Add oaktrail
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Apr 2011 16:55:26 +0100
Message-ID: <20110405155512.15143.44918.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oaktrail needs a couple of slight plumbing tweaks

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/Kconfig     |    2 +-
 drivers/staging/gma500/mrst_lvds.c |   11 ++++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/gma500/Kconfig b/drivers/staging/gma500/Kconfig
index 5501eb9..ce8beda 100644
--- a/drivers/staging/gma500/Kconfig
+++ b/drivers/staging/gma500/Kconfig
@@ -1,6 +1,6 @@
 config DRM_PSB
 	tristate "Intel GMA500 KMS Framebuffer"
-	depends on DRM && PCI
+	depends on DRM && PCI && X86
 	select FB_CFB_COPYAREA
         select FB_CFB_FILLRECT
         select FB_CFB_IMAGEBLIT
diff --git a/drivers/staging/gma500/mrst_lvds.c b/drivers/staging/gma500/mrst_lvds.c
index 21b9056..4a08b74 100644
--- a/drivers/staging/gma500/mrst_lvds.c
+++ b/drivers/staging/gma500/mrst_lvds.c
@@ -22,6 +22,7 @@
 
 #include <linux/i2c.h>
 #include <drm/drmP.h>
+#include <asm/mrst.h>
 
 #include "psb_intel_bios.h"
 #include "psb_drv.h"
@@ -300,7 +301,15 @@ void mrst_lvds_init(struct drm_device *dev,
 	 * 4) make sure lid is open
 	 *    if closed, act like it's not there for now
 	 */
-	i2c_adap = i2c_get_adapter(2);
+
+	 /* This ifdef can go once the cpu ident stuff is cleaned up in arch */
+#if defined(CONFIG_X86_MRST)
+	if (mrst_identify_cpu())
+        	i2c_adap = i2c_get_adapter(2);
+        else	/* Oaktrail uses I2C 1 */
+#endif        
+        	i2c_adap = i2c_get_adapter(1);
+
 	if (i2c_adap == NULL)
 		printk(KERN_ALERT "No ddc adapter available!\n");
 	/*

