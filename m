Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab1GEOsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:48:40 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59122 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab1GEOsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:48:39 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 22/49] gma500: Fix early Medfield crash
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Jul 2011 15:38:53 +0100
Message-ID: <20110705143851.23872.15959.stgit@localhost.localdomain>
In-Reply-To: <20110705141038.23872.55303.stgit@localhost.localdomain>
References: <20110705141038.23872.55303.stgit@localhost.localdomain>
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

