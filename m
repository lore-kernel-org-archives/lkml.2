Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab0G1Og6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 10:36:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57493 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768Ab0G1Ogd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 10:36:33 -0400
From: Ernesto Ramos <ernesto@ti.com>
To: gregkh@suse.de
Cc: omar.ramirez@ti.com, ohad@wizery.com, ameya.palande@nokia.com,
        felipe.contreras@nokia.com, fernando.lugo@ti.com,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com, nm@ti.com,
        linux-omap@vger.kernel.org, Ernesto Ramos <ernesto@ti.com>
Subject: [PATCH 2/5] staging:ti dspbridge: remove unnecessary check for NULL pointer in cmm.c
Date: Wed, 28 Jul 2010 09:40:49 -0500
Message-Id: <1280328052-31292-3-git-send-email-ernesto@ti.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1280328052-31292-2-git-send-email-ernesto@ti.com>
References: <1280328052-31292-1-git-send-email-ernesto@ti.com>
 <1280328052-31292-2-git-send-email-ernesto@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary check for NULL pointer in cmm.c.

Signed-off-by: Ernesto Ramos <ernesto@ti.com>
---
 drivers/staging/tidspbridge/pmgr/cmm.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/tidspbridge/pmgr/cmm.c b/drivers/staging/tidspbridge/pmgr/cmm.c
index 8e808d9..874ed64 100644
--- a/drivers/staging/tidspbridge/pmgr/cmm.c
+++ b/drivers/staging/tidspbridge/pmgr/cmm.c
@@ -992,16 +992,12 @@ int cmm_xlator_create(struct cmm_xlatorobject **xlator,
 int cmm_xlator_delete(struct cmm_xlatorobject *xlator, bool force)
 {
 	struct cmm_xlator *xlator_obj = (struct cmm_xlator *)xlator;
-	int status = 0;
 
 	DBC_REQUIRE(refs > 0);
 
-	if (xlator_obj)
-		kfree(xlator_obj);
-	else
-		status = -EFAULT;
+	kfree(xlator_obj);
 
-	return status;
+	return 0;
 }
 
 /*
-- 
1.5.4.5

