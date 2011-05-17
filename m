Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab1EQOgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 10:36:50 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56123 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab1EQOgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 10:36:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ABNM8zH0uwnw73JlAhHebbuuL2goUkg0yi0+K6CasBl4gTqAz0P/9KoOORpsRVxDFH
         Wviv8+9LL3HxT88RvN/rXZKFZJx4GZaOZ1md6hiKrf4Ywdx7BOtxEKYENwEvU9FJOVWy
         QuJGEoMfbHepWJEDtQRbAWjjDgUJQIj/cmiyU=
From: Wanlong Gao <wanlong.gao@gmail.com>
To: dwmw2@infradead.org, akpm@linux-foundation.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH 1/2] driver:mtd:use the wrapped __get_mtd_device in get_mtd_device_nm
Date: Tue, 17 May 2011 22:36:18 +0800
Message-Id: <1305642979-7419-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

Use the wrapped function __get_mtd_device in the function
get_mtd_device_nm instead of these get device reference codes.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 drivers/mtd/mtdcore.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index da69bc8..9b7ad35 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -570,21 +570,13 @@ struct mtd_info *get_mtd_device_nm(const char *name)
 	if (!mtd)
 		goto out_unlock;
 
-	if (!try_module_get(mtd->owner))
+	err = __get_mtd_device(mtd);
+	if (err)
 		goto out_unlock;
 
-	if (mtd->get_device) {
-		err = mtd->get_device(mtd);
-		if (err)
-			goto out_put;
-	}
-
-	mtd->usecount++;
 	mutex_unlock(&mtd_table_mutex);
 	return mtd;
 
-out_put:
-	module_put(mtd->owner);
 out_unlock:
 	mutex_unlock(&mtd_table_mutex);
 	return ERR_PTR(err);
-- 
1.7.4.1

