Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab0IESc6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 14:32:58 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46186 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab0IEScz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 14:32:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rUGkbE8vBCRG6Nz0R8g/P64CQ9+XUS/Mn5Ir/nliTC3U6gpYY4WsmHapviqmTBgXbF
         MuBk6DIOnb1BzMSGWZ+JSXnWY+4hfHvSJo2AVk6cxbt7qV3CHduwiW8RHKQvc9DUkEBi
         UZVPP6YTGuhN8YLTQrM3j2TLt1ZXljpWXtobc=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Vasiliy Kulikov <segooon@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Rene Sapiens <rene.sapiens@ti.com>, Nishanth Menon <nm@ti.com>,
        Ernesto Ramos <ernesto@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/14] staging: tidspbridge: check return code of kzalloc
Date: Sun,  5 Sep 2010 22:32:49 +0400
Message-Id: <1283711569-7418-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segooon@gmail.com>

Function kzalloc may fail. Check for it.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 I couldn't compile this driver at all, so it is not tested.

 drivers/staging/tidspbridge/rmgr/dbdcd.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/tidspbridge/rmgr/dbdcd.c b/drivers/staging/tidspbridge/rmgr/dbdcd.c
index f71e860..3581a55 100644
--- a/drivers/staging/tidspbridge/rmgr/dbdcd.c
+++ b/drivers/staging/tidspbridge/rmgr/dbdcd.c
@@ -487,6 +487,10 @@ int dcd_get_object_def(struct dcd_manager *hdcd_mgr,
 
 	/* Allocate zeroed buffer. */
 	psz_coff_buf = kzalloc(ul_len + 4, GFP_KERNEL);
+	if (psz_coff_buf == NULL) {
+		status = -ENOMEM;
+		goto func_end;
+	}
 #ifdef _DB_TIOMAP
 	if (strstr(dcd_key->path, "iva") == NULL) {
 		/* Locate section by objectID and read its content. */
@@ -571,6 +575,10 @@ int dcd_get_objects(struct dcd_manager *hdcd_mgr,
 
 	/* Allocate zeroed buffer. */
 	psz_coff_buf = kzalloc(ul_len + 4, GFP_KERNEL);
+	if (psz_coff_buf == NULL) {
+		status = -ENOMEM;
+		goto func_cont;
+	}
 #ifdef _DB_TIOMAP
 	if (strstr(sz_coff_path, "iva") == NULL) {
 		/* Locate section by objectID and read its content. */
-- 
1.7.0.4

