Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab1FPQye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 12:54:34 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51912 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab1FPQyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:54:32 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 27/29] gma500: Read the GCT panel type information for Medfield
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Thu, 16 Jun 2011 17:43:01 +0100
Message-ID: <20110616164241.6039.36001.stgit@localhost.localdomain>
In-Reply-To: <20110616160104.6039.44019.stgit@localhost.localdomain>
References: <20110616160104.6039.44019.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Missed in the original merge work

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/mrst_bios.c |   29 ++++++++++++++++++++++++++++-
 1 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/gma500/mrst_bios.c b/drivers/staging/gma500/mrst_bios.c
index 0d944c4..103777b 100644
--- a/drivers/staging/gma500/mrst_bios.c
+++ b/drivers/staging/gma500/mrst_bios.c
@@ -28,6 +28,12 @@
 #include "psb_drm.h"
 #include "psb_drv.h"
 #include "mrst_bios.h"
+#include "mdfld_output.h"
+
+static int panel_id;
+module_param_named(panel_id, panel_id, int, 0600);
+MODULE_PARM_DESC(panel_id, "Panel Identifier");
+
 
 void mrst_get_fuse_settings(struct drm_device *dev)
 {
@@ -231,6 +237,27 @@ void mrst_get_vbt_data(struct drm_psb_private *dev_priv)
 		dev_err(dev->dev, "Unknown revision of GCT!\n");
 		vbt->size = 0;
 	}
-	/* FIXME: Need to sort out Medfield panel identifiers in future */
+	if (IS_MDFLD(dev_priv->dev)){
+		if (panel_id == GCT_DETECT) {
+			if (dev_priv->gct_data.bpi == 2) {
+				dev_info(dev->dev, "[GFX] PYR Panel Detected\n");
+				dev_priv->panel_id = PYR_CMD;
+				panel_id = PYR_CMD;
+			}
+			else if(dev_priv->gct_data.bpi == 0) {
+				dev_info(dev->dev, "[GFX] TMD Panel Detected.\n");
+				dev_priv->panel_id = TMD_VID;
+				panel_id = TMD_VID;
+			}
+			else {
+				dev_info(dev->dev, "[GFX] Default Panel (TPO)\n");
+				dev_priv->panel_id = TPO_CMD;
+				panel_id = TPO_CMD;
+			}
+		} else {
+			dev_info(dev->dev, "[GFX] Panel Parameter Passed in through cmd line\n");
+			dev_priv->panel_id = panel_id;
+		}
+	}
 }
 

