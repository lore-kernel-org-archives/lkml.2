Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab0KASoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:44:54 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45912 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab0KASmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:42:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=d8ayR7toI4+l6CKX4S7eIglhRVDcFgDAwJBIlfQJMpDcqr9AOGOkcn+I5I50X0jVKR
         I471NNqDq8zOmKoAYNG8qjNsDCLEEljpyC9wEh5wd9uVs53iJLKmKFyqXBwM3f5LOv4s
         rWaN0Lo0PZmyDigm39Ib6Xrbj6s29kIvp94Sw=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 18/29] Staging: yaffs2: yaffs_packedtags1: Add files
Date: Mon,  1 Nov 2010 14:41:06 -0400
Message-Id: <1288636877-7964-19-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding files to yaffs2 directory.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/yaffs2/yaffs_packedtags1.c |   50 ++++++++++++++++++++++++++++
 drivers/staging/yaffs2/yaffs_packedtags1.h |   37 ++++++++++++++++++++
 2 files changed, 87 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/yaffs2/yaffs_packedtags1.c
 create mode 100644 drivers/staging/yaffs2/yaffs_packedtags1.h

diff --git a/drivers/staging/yaffs2/yaffs_packedtags1.c b/drivers/staging/yaffs2/yaffs_packedtags1.c
new file mode 100644
index 0000000..2ce873f
--- /dev/null
+++ b/drivers/staging/yaffs2/yaffs_packedtags1.c
@@ -0,0 +1,50 @@
+/*
+ * YAFFS: Yet Another Flash File System. A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "yaffs_packedtags1.h"
+#include "yportenv.h"
+
+void yaffs_pack_tags1(yaffs_packed_tags1 *pt, const yaffs_ext_tags *t)
+{
+	pt->chunk_id = t->chunk_id;
+	pt->serial_number = t->serial_number;
+	pt->n_bytes = t->n_bytes;
+	pt->obj_id = t->obj_id;
+	pt->ecc = 0;
+	pt->deleted = (t->is_deleted) ? 0 : 1;
+	pt->unused_stuff = 0;
+	pt->should_be_ff = 0xFFFFFFFF;
+
+}
+
+void yaffs_unpack_tags1(yaffs_ext_tags *t, const yaffs_packed_tags1 *pt)
+{
+	static const __u8 all_ff[] =
+	    { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+0xff };
+
+	if (memcmp(all_ff, pt, sizeof(yaffs_packed_tags1))) {
+		t->block_bad = 0;
+		if (pt->should_be_ff != 0xFFFFFFFF)
+			t->block_bad = 1;
+		t->chunk_used = 1;
+		t->obj_id = pt->obj_id;
+		t->chunk_id = pt->chunk_id;
+		t->n_bytes = pt->n_bytes;
+		t->ecc_result = YAFFS_ECC_RESULT_NO_ERROR;
+		t->is_deleted = (pt->deleted) ? 0 : 1;
+		t->serial_number = pt->serial_number;
+	} else {
+		memset(t, 0, sizeof(yaffs_ext_tags));
+	}
+}
diff --git a/drivers/staging/yaffs2/yaffs_packedtags1.h b/drivers/staging/yaffs2/yaffs_packedtags1.h
new file mode 100644
index 0000000..50f32e8
--- /dev/null
+++ b/drivers/staging/yaffs2/yaffs_packedtags1.h
@@ -0,0 +1,37 @@
+/*
+ * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License version 2.1 as
+ * published by the Free Software Foundation.
+ *
+ * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
+ */
+
+/* This is used to pack YAFFS1 tags, not YAFFS2 tags. */
+
+#ifndef __YAFFS_PACKEDTAGS1_H__
+#define __YAFFS_PACKEDTAGS1_H__
+
+#include "yaffs_guts.h"
+
+typedef struct {
+	unsigned chunk_id:20;
+	unsigned serial_number:2;
+	unsigned n_bytes:10;
+	unsigned obj_id:18;
+	unsigned ecc:12;
+	unsigned deleted:1;
+	unsigned unused_stuff:1;
+	unsigned should_be_ff;
+
+} yaffs_packed_tags1;
+
+void yaffs_pack_tags1(yaffs_packed_tags1 *pt, const yaffs_ext_tags *t);
+void yaffs_unpack_tags1(yaffs_ext_tags *t, const yaffs_packed_tags1 *pt);
+#endif
-- 
1.7.3.2.146.gca209

