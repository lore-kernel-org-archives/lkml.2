Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464Ab0G3LJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 07:09:52 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55239 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461Ab0G3LJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 07:09:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Vp/uAeS+FkeVckZcdqtFyN1GrsMvTBresOp5rPtBYYO6w6p1RCcFYbWtX+hT1BdS8L
         07kA8dlFbgJHRt8QeS8PtpRbNxWFZiiRF0rxK6nhOdH92+OWvF8Ofaxp5ovdIqDHAVRY
         B4PZCQJFnsOcCNinBXW5wpB+jnbr1y4PJeb50=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Rene Sapiens <rene.sapiens@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Nishanth Menon <nm@ti.com>, Omar Ramirez Luna <omar.ramirez@ti.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] staging: tidspbridge: fix memory leak
Date: Fri, 30 Jul 2010 15:09:22 +0400
Message-Id: <1280488163-20939-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dbll_create() leaks pzl_target if target_obj is NULL. Call kzalloc()
only if memory is used.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/tidspbridge/pmgr/dbll.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tidspbridge/pmgr/dbll.c b/drivers/staging/tidspbridge/pmgr/dbll.c
index 3636aa3..86840ce 100644
--- a/drivers/staging/tidspbridge/pmgr/dbll.c
+++ b/drivers/staging/tidspbridge/pmgr/dbll.c
@@ -247,9 +247,9 @@ int dbll_create(struct dbll_tar_obj **target_obj,
 	DBC_REQUIRE(pattrs != NULL);
 	DBC_REQUIRE(target_obj != NULL);
 
-	/* Allocate DBL target object */
-	pzl_target = kzalloc(sizeof(struct dbll_tar_obj), GFP_KERNEL);
 	if (target_obj != NULL) {
+		/* Allocate DBL target object */
+		pzl_target = kzalloc(sizeof(struct dbll_tar_obj), GFP_KERNEL);
 		if (pzl_target == NULL) {
 			*target_obj = NULL;
 			status = -ENOMEM;
-- 
1.7.0.4

