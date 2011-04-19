Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab1DSOtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 10:49:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48193 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753060Ab1DSOte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:49:34 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 7/8] gma500: prune some unused variables
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 19 Apr 2011 15:28:32 +0100
Message-ID: <20110419142826.16479.60123.stgit@localhost.localdomain>
In-Reply-To: <20110419142432.16479.89255.stgit@localhost.localdomain>
References: <20110419142432.16479.89255.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_intel_lvds.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/gma500/psb_intel_lvds.c b/drivers/staging/gma500/psb_intel_lvds.c
index 28e04a3..b0a225b 100644
--- a/drivers/staging/gma500/psb_intel_lvds.c
+++ b/drivers/staging/gma500/psb_intel_lvds.c
@@ -32,13 +32,6 @@
 #include "psb_powermgmt.h"
 #include <linux/pm_runtime.h>
 
-/* MRST defines start */
-uint8_t blc_freq;
-uint8_t blc_minbrightness;
-uint8_t blc_i2caddr;
-uint8_t blc_brightnesscmd;
-int lvds_backlight;		/* restore backlight to this value */
-
 u32 CoreClock;
 u32 PWMControlRegFreq;
 
@@ -97,8 +90,11 @@ static u32 psb_intel_lvds_get_max_backlight(struct drm_device *dev)
 	return retVal;
 }
 
-/**
+/*
  * Set LVDS backlight level by I2C command
+ *
+ * FIXME: at some point we need to both track this for PM and also
+ * disable runtime pm on MRST if the brightness is nil (ie blanked)
  */
 static int psb_lvds_i2c_set_brightness(struct drm_device *dev,
 					unsigned int level)
@@ -131,7 +127,7 @@ static int psb_lvds_i2c_set_brightness(struct drm_device *dev,
 
 	if (i2c_transfer(&lvds_i2c_bus->adapter, msgs, 1) == 1) {
 		DRM_DEBUG("I2C set brightness.(command, value) (%d, %d)\n",
-			blc_brightnesscmd,
+			dev_priv->lvds_bl->brightnesscmd,
 			blc_i2c_brightness);
 		return 0;
 	}

