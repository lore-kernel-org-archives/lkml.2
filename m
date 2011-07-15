Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab1GOQ4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:56:01 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34240 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab1GOQ4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:56:00 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] gma500: wire up the mrst i2c bus from chip_info
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 15 Jul 2011 17:47:11 +0100
Message-ID: <20110715164710.2918.45772.stgit@localhost.localdomain>
In-Reply-To: <20110715164650.2918.32196.stgit@localhost.localdomain>
References: <20110715164650.2918.32196.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We did the groundwork earlier now we can use it

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/mrst_lvds.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/gma500/mrst_lvds.c b/drivers/staging/gma500/mrst_lvds.c
index ac791c4..e7999a2 100644
--- a/drivers/staging/gma500/mrst_lvds.c
+++ b/drivers/staging/gma500/mrst_lvds.c
@@ -347,16 +347,10 @@ void mrst_lvds_init(struct drm_device *dev,
 	 *    if closed, act like it's not there for now
 	 */
 
-	 /* This ifdef can go once the cpu ident stuff is cleaned up in arch */
-#if defined(CONFIG_X86_MRST)
-	if (mrst_identify_cpu())
-		i2c_adap = i2c_get_adapter(2);
-	else	/* Oaktrail uses I2C 1 */
-#endif
-		i2c_adap = i2c_get_adapter(1);
+	i2c_adap = i2c_get_adapter(dev_priv->ops->i2c_bus);
 
 	if (i2c_adap == NULL)
-		printk(KERN_ALERT "No ddc adapter available!\n");
+		dev_err(dev->dev, "No ddc adapter available!\n");
 	/*
 	 * Attempt to get the fixed panel mode from DDC.  Assume that the
 	 * preferred mode is the right one.
@@ -378,7 +372,6 @@ void mrst_lvds_init(struct drm_device *dev,
 			}
 		}
 	}
-
 	/*
 	 * If we didn't get EDID, try geting panel timing
 	 * from configuration data
@@ -386,8 +379,7 @@ void mrst_lvds_init(struct drm_device *dev,
 	mode_dev->panel_fixed_mode = mrst_lvds_get_configuration_mode(dev);
 
 	if (mode_dev->panel_fixed_mode) {
-		mode_dev->panel_fixed_mode->type |=
-		    DRM_MODE_TYPE_PREFERRED;
+		mode_dev->panel_fixed_mode->type |= DRM_MODE_TYPE_PREFERRED;
 		goto out;	/* FIXME: check for quirks */
 	}
 

