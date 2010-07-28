Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab0G1OhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 10:37:01 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57487 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814Ab0G1Ogc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 10:36:32 -0400
From: Ernesto Ramos <ernesto@ti.com>
To: gregkh@suse.de
Cc: omar.ramirez@ti.com, ohad@wizery.com, ameya.palande@nokia.com,
        felipe.contreras@nokia.com, fernando.lugo@ti.com,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com, nm@ti.com,
        linux-omap@vger.kernel.org, Ernesto Ramos <ernesto@ti.com>
Subject: [PATCH 3/5] staging:ti dspbridge: remove function delete_strm_mgr
Date: Wed, 28 Jul 2010 09:40:50 -0500
Message-Id: <1280328052-31292-4-git-send-email-ernesto@ti.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1280328052-31292-3-git-send-email-ernesto@ti.com>
References: <1280328052-31292-1-git-send-email-ernesto@ti.com>
 <1280328052-31292-2-git-send-email-ernesto@ti.com>
 <1280328052-31292-3-git-send-email-ernesto@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove function delete_strm_mgr in strm.c and
use kfree instead.

Signed-off-by: Ernesto Ramos <ernesto@ti.com>
---
 drivers/staging/tidspbridge/rmgr/strm.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/tidspbridge/rmgr/strm.c b/drivers/staging/tidspbridge/rmgr/strm.c
index 73888e3..6c184c6 100644
--- a/drivers/staging/tidspbridge/rmgr/strm.c
+++ b/drivers/staging/tidspbridge/rmgr/strm.c
@@ -90,7 +90,6 @@ static u32 refs;		/* module reference count */
 
 /*  ----------------------------------- Function Prototypes */
 static int delete_strm(struct strm_object *stream_obj);
-static void delete_strm_mgr(struct strm_mgr *strm_mgr_obj);
 
 /*
  *  ======== strm_allocate_buffer ========
@@ -232,7 +231,7 @@ int strm_create(struct strm_mgr **strm_man,
 	if (DSP_SUCCEEDED(status))
 		*strm_man = strm_mgr_obj;
 	else
-		delete_strm_mgr(strm_mgr_obj);
+		kfree(strm_mgr_obj);
 
 	DBC_ENSURE((DSP_SUCCEEDED(status) && *strm_man) ||
 				(DSP_FAILED(status) && *strm_man == NULL));
@@ -250,7 +249,7 @@ void strm_delete(struct strm_mgr *strm_mgr_obj)
 	DBC_REQUIRE(refs > 0);
 	DBC_REQUIRE(strm_mgr_obj);
 
-	delete_strm_mgr(strm_mgr_obj);
+	kfree(strm_mgr_obj);
 }
 
 /*
@@ -859,14 +858,3 @@ static int delete_strm(struct strm_object *stream_obj)
 	}
 	return status;
 }
-
-/*
- *  ======== delete_strm_mgr ========
- *  Purpose:
- *      Frees stream manager.
- */
-static void delete_strm_mgr(struct strm_mgr *strm_mgr_obj)
-{
-	if (strm_mgr_obj)
-		kfree(strm_mgr_obj);
-}
-- 
1.5.4.5

