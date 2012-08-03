Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab2HCRjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 13:39:12 -0400
Received: from mail.tpi.com ([70.99.223.143]:1866 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab2HCRjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 13:39:09 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Subject: [PATCH] cpia2: Declare MODULE_FIRMWARE usage
Date: Fri,  3 Aug 2012 11:39:28 -0600
Message-Id: <1344015568-125316-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/media/video/cpia2/cpia2_core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/video/cpia2/cpia2_core.c b/drivers/media/video/cpia2/cpia2_core.c
index 17188e2..187012c 100644
--- a/drivers/media/video/cpia2/cpia2_core.c
+++ b/drivers/media/video/cpia2/cpia2_core.c
@@ -31,11 +31,15 @@
 
 #include "cpia2.h"
 
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/firmware.h>
 
+#define FIRMWARE "cpia2/stv0672_vp4.bin"
+MODULE_FIRMWARE(FIRMWARE);
+
 /* #define _CPIA2_DEBUG_ */
 
 #ifdef _CPIA2_DEBUG_
@@ -898,7 +902,7 @@ static int cpia2_send_onebyte_command(struct camera_data *cam,
 static int apply_vp_patch(struct camera_data *cam)
 {
 	const struct firmware *fw;
-	const char fw_name[] = "cpia2/stv0672_vp4.bin";
+	const char fw_name[] = FIRMWARE;
 	int i, ret;
 	struct cpia2_command cmd;
 
-- 
1.7.9.5

