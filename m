Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab0HYWQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 18:16:36 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39323 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323Ab0HYWQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 18:16:32 -0400
From: Ivan Gomez Castellanos <ivan.gomez@ti.com>
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, gregkh@suse.de
Cc: Hiroshi.DOYU@nokia.com, ameya.palande@nokia.com,
        felipe.contreras@nokia.com, omar.ramirez@ti.com, ohad@wizery.com,
        rene.sapiens@ti.com, nm@ti.com, ernesto@ti.com, x0095078@ti.com,
        Ivan Gomez Castellanos <ivan.gomez@ti.com>
Subject: [PATCH 04/11] staging: tidspbridge: Remove cfg_init() and cfg_exit()
Date: Wed, 25 Aug 2010 17:08:57 -0500
Message-Id: <1282774144-11628-5-git-send-email-ivan.gomez@ti.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1282774144-11628-1-git-send-email-ivan.gomez@ti.com>
References: <1282774144-11628-1-git-send-email-ivan.gomez@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions cfg_init() and cfg_exit() do nothing, so they are removed.

Signed-off-by: Ivan Gomez Castellanos <ivan.gomez@ti.com>
---
 .../staging/tidspbridge/include/dspbridge/cfg.h    |   26 --------------------
 drivers/staging/tidspbridge/services/cfg.c         |   20 ---------------
 drivers/staging/tidspbridge/services/services.c    |   12 ---------
 3 files changed, 0 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/cfg.h b/drivers/staging/tidspbridge/include/dspbridge/cfg.h
index a84fa2b..eea9000 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cfg.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cfg.h
@@ -22,19 +22,6 @@
 #include <dspbridge/cfgdefs.h>
 
 /*
- *  ======== cfg_exit ========
- *  Purpose:
- *      Discontinue usage of the CFG module.
- *  Parameters:
- *  Returns:
- *  Requires:
- *      cfg_init(void) was previously called.
- *  Ensures:
- *      Resources acquired in cfg_init(void) are freed.
- */
-extern void cfg_exit(void);
-
-/*
  *  ======== cfg_get_cd_version ========
  *  Purpose:
  *      Retrieves the version of the PM Class Driver.
@@ -152,19 +139,6 @@ extern int cfg_get_zl_file(struct cfg_devnode *dev_node_obj,
 				  u32 buf_size, char *str_zl_file_name);
 
 /*
- *  ======== cfg_init ========
- *  Purpose:
- *      Initialize the CFG module's private state.
- *  Parameters:
- *  Returns:
- *      TRUE if initialized; FALSE if error occured.
- *  Requires:
- *  Ensures:
- *      A requirement for each of the other public CFG functions.
- */
-extern bool cfg_init(void);
-
-/*
  *  ======== cfg_set_dev_object ========
  *  Purpose:
  *      Store the Device Object handle for a given devnode.
diff --git a/drivers/staging/tidspbridge/services/cfg.c b/drivers/staging/tidspbridge/services/cfg.c
index e9cdbf6..b9c3882 100644
--- a/drivers/staging/tidspbridge/services/cfg.c
+++ b/drivers/staging/tidspbridge/services/cfg.c
@@ -36,16 +36,6 @@ struct drv_ext {
 };
 
 /*
- *  ======== cfg_exit ========
- *  Purpose:
- *      Discontinue usage of the CFG module.
- */
-void cfg_exit(void)
-{
-	/* Do nothing */
-}
-
-/*
  *  ======== cfg_get_dev_object ========
  *  Purpose:
  *      Retrieve the Device Object handle for a given devnode.
@@ -157,16 +147,6 @@ int cfg_get_object(u32 *value, u8 dw_type)
 }
 
 /*
- *  ======== cfg_init ========
- *  Purpose:
- *      Initialize the CFG module's private state.
- */
-bool cfg_init(void)
-{
-	return true;
-}
-
-/*
  *  ======== cfg_set_dev_object ========
  *  Purpose:
  *      Store the Device Object handle and dev_node pointer for a given devnode.
diff --git a/drivers/staging/tidspbridge/services/services.c b/drivers/staging/tidspbridge/services/services.c
index 6a7dd6f..47bac21 100644
--- a/drivers/staging/tidspbridge/services/services.c
+++ b/drivers/staging/tidspbridge/services/services.c
@@ -43,7 +43,6 @@
  */
 void services_exit(void)
 {
-	cfg_exit();
 }
 
 /*
@@ -54,17 +53,6 @@ void services_exit(void)
 bool services_init(void)
 {
 	bool ret = true;
-	bool fcfg;
-
-	/* Perform required initialization of SERVICES modules. */
-	fcfg = cfg_init();
-
-	ret = fcfg;
-
-	if (!ret) {
-		if (fcfg)
-			cfg_exit();
-	}
 
 	return ret;
 }
-- 
1.7.0.3

