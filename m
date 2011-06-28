Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab1F1WJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:09:31 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41016 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab1F1WJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:09:22 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 25/29] gma500: Fix early Medfield crash
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:08:58 +0100
Message-ID: <20110628220856.898.55355.stgit@bob.linux.org.uk>
In-Reply-To: <20110628220151.898.15775.stgit@bob.linux.org.uk>
References: <20110628220151.898.15775.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We need to initialise the DBI interface and the code for it got missed in
the original merge as it's in a daft place. This will need moving but lets
get it added first.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_drv.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)


diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index bb6b68f..dfb3f3a 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -28,6 +28,7 @@
 #include "psb_intel_reg.h"
 #include "psb_intel_bios.h"
 #include "mrst_bios.h"
+#include "mdfld_dsi_dbi.h"
 #include <drm/drm_pciids.h>
 #include "psb_powermgmt.h"
 #include <linux/cpu.h>
@@ -442,6 +443,17 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 
 	dev->driver->get_vblank_counter = psb_get_vblank_counter;
 
+	/* FIXME: this is not the right place for this stuff ! */
+	if (IS_MFLD(dev)) {
+#ifdef CONFIG_MDFLD_DSI_DPU
+		/*init dpu info*/
+		mdfld_dbi_dpu_init(dev);
+#else 
+		mdfld_dbi_dsr_init(dev);
+#endif /*CONFIG_MDFLD_DSI_DPU*/
+		/* INIT_WORK(&dev_priv->te_work, mdfld_te_handler_work);*/
+	}
+
 	if (drm_psb_no_fb == 0) {
 		psb_modeset_init(dev);
 		psb_fbdev_init(dev);

