Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651Ab0GWBOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 21:14:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:32915 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756927Ab0GWBMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 21:12:53 -0400
From: Armando Uribe <x0095078@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Ameya Palande <ameya.palande@nokia.com>,
        <linux-kernel@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        Rene Sapiens <rene.sapiens@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Armando Uribe <x0095078@ti.com>
Subject: [PATCH 6/9] staging: tidspbridge: Remove unused magic number
Date: Thu, 22 Jul 2010 20:25:31 -0500
Message-Id: <1279848334-4043-7-git-send-email-x0095078@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1279848334-4043-6-git-send-email-x0095078@ti.com>
References: <1279848334-4043-1-git-send-email-x0095078@ti.com>
 <1279848334-4043-2-git-send-email-x0095078@ti.com>
 <1279848334-4043-3-git-send-email-x0095078@ti.com>
 <1279848334-4043-4-git-send-email-x0095078@ti.com>
 <1279848334-4043-5-git-send-email-x0095078@ti.com>
 <1279848334-4043-6-git-send-email-x0095078@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes an unused magic number from the cod_manager
structure.

Signed-off-by: Armando Uribe <x0095078@ti.com>
---
 drivers/staging/tidspbridge/pmgr/cod.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/tidspbridge/pmgr/cod.c b/drivers/staging/tidspbridge/pmgr/cod.c
index 0cbe6e5..81102d2 100644
--- a/drivers/staging/tidspbridge/pmgr/cod.c
+++ b/drivers/staging/tidspbridge/pmgr/cod.c
@@ -43,9 +43,6 @@
 /*  ----------------------------------- This */
 #include <dspbridge/cod.h>
 
-/* magic number for handle validation */
-#define MAGIC	 0xc001beef
-
 /*
  *  ======== cod_manager ========
  */
@@ -58,7 +55,6 @@ struct cod_manager {
 	struct dbll_fxns fxns;
 	struct dbll_attrs attrs;
 	char sz_zl_file[COD_MAXPATHLENGTH];
-	u32 ul_magic;
 };
 
 /*
@@ -234,8 +230,6 @@ int cod_create(struct cod_manager **mgr, char *str_zl_file,
 	if (mgr_new == NULL)
 		return -ENOMEM;
 
-	mgr_new->ul_magic = MAGIC;
-
 	/* Set up loader functions */
 	mgr_new->fxns = ldr_fxns;
 
@@ -295,7 +289,6 @@ void cod_delete(struct cod_manager *cod_mgr_obj)
 		cod_mgr_obj->fxns.delete_fxn(cod_mgr_obj->target);
 		cod_mgr_obj->fxns.exit_fxn();
 	}
-	cod_mgr_obj->ul_magic = ~MAGIC;
 	kfree(cod_mgr_obj);
 }
 
-- 
1.6.3.3

