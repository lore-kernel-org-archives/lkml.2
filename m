Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab0G1Okz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 10:40:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35251 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424Ab0G1Oku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 10:40:50 -0400
From: Ernesto Ramos <ernesto@ti.com>
To: gregkh@suse.de
Cc: omar.ramirez@ti.com, ohad@wizery.com, ameya.palande@nokia.com,
        felipe.contreras@nokia.com, fernando.lugo@ti.com,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com, nm@ti.com,
        linux-omap@vger.kernel.org, Ernesto Ramos <ernesto@ti.com>
Subject: [PATCH 04/10] staging:ti dspbridge: remove DSP_SUCCEEDED macro from services
Date: Wed, 28 Jul 2010 09:45:27 -0500
Message-Id: <1280328333-31336-5-git-send-email-ernesto@ti.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1280328333-31336-4-git-send-email-ernesto@ti.com>
References: <1280328333-31336-1-git-send-email-ernesto@ti.com>
 <1280328333-31336-2-git-send-email-ernesto@ti.com>
 <1280328333-31336-3-git-send-email-ernesto@ti.com>
 <1280328333-31336-4-git-send-email-ernesto@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since status succeeded is now 0 macro DSP_SUCCEEDED
is not necessary anymore.

Signed-off-by: Ernesto Ramos <ernesto@ti.com>
---
 drivers/staging/tidspbridge/services/cfg.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/tidspbridge/services/cfg.c b/drivers/staging/tidspbridge/services/cfg.c
index 4ab3cd7..c3f33f6 100644
--- a/drivers/staging/tidspbridge/services/cfg.c
+++ b/drivers/staging/tidspbridge/services/cfg.c
@@ -62,7 +62,7 @@ int cfg_get_auto_start(struct cfg_devnode *dev_node_obj,
 		status = -EFAULT;
 	if (!auto_start || !drv_datap)
 		status = -EFAULT;
-	if (DSP_SUCCEEDED(status))
+	if (!status)
 		*auto_start = (drv_datap->base_img) ? 1 : 0;
 
 	DBC_ENSURE((status == 0 &&
@@ -93,7 +93,7 @@ int cfg_get_dev_object(struct cfg_devnode *dev_node_obj,
 		status = -EFAULT;
 
 	dw_buf_size = sizeof(value);
-	if (DSP_SUCCEEDED(status)) {
+	if (!status) {
 
 		/* check the device string and then store dev object */
 		if (!
@@ -127,7 +127,7 @@ int cfg_get_exec_file(struct cfg_devnode *dev_node_obj, u32 buf_size,
 	if (strlen(drv_datap->base_img) > buf_size)
 		status = -EINVAL;
 
-	if (DSP_SUCCEEDED(status) && drv_datap->base_img)
+	if (!status && drv_datap->base_img)
 		strcpy(str_exec_file, drv_datap->base_img);
 
 	if (DSP_FAILED(status))
@@ -178,7 +178,7 @@ int cfg_get_object(u32 *value, u8 dw_type)
 		*value = 0;
 		pr_err("%s: Failed, status 0x%x\n", __func__, status);
 	}
-	DBC_ENSURE((DSP_SUCCEEDED(status) && *value != 0) ||
+	DBC_ENSURE((!status && *value != 0) ||
 		   (DSP_FAILED(status) && *value == 0));
 	return status;
 }
@@ -211,7 +211,7 @@ int cfg_set_dev_object(struct cfg_devnode *dev_node_obj, u32 value)
 	if (!dev_node_obj)
 		status = -EFAULT;
 
-	if (DSP_SUCCEEDED(status)) {
+	if (!status) {
 		/* Store the Bridge device object in the Registry */
 
 		if (!(strcmp((char *)dev_node_obj, "TIOMAP1510")))
-- 
1.5.4.5

