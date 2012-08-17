Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab2HQO5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:57:50 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47540 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758127Ab2HQO5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:57:37 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=201/4=5D=20sync=20include/mtd/ubi-user=2Eh=20with=20kernel=20v3=2E6-rc1?=
Date: Fri, 17 Aug 2012 16:57:19 +0200
Message-Id: <1345215442-19082-2-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1345215442-19082-1-git-send-email-richard.genoud@gmail.com>
References: <1345215442-19082-1-git-send-email-richard.genoud@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 include/mtd/ubi-user.h |  138 +++++++++++++++++++++++-------------------------
 1 files changed, 67 insertions(+), 71 deletions(-)

diff --git a/include/mtd/ubi-user.h b/include/mtd/ubi-user.h
index 296efae..123951f 100644
--- a/include/mtd/ubi-user.h
+++ b/include/mtd/ubi-user.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) International Business Machines Corp., 2006
+ * Copyright © International Business Machines Corp., 2006
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -21,6 +21,8 @@
 #ifndef __UBI_USER_H__
 #define __UBI_USER_H__
 
+#include <linux/types.h>
+
 /*
  * UBI device creation (the same as MTD device attachment)
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
@@ -129,7 +131,7 @@
  * ~~~~~~~~~~~~~~~~~~~~~~~~~
  *
  * To set an UBI volume property the %UBI_IOCSETPROP ioctl command should be
- * used. A pointer to a &struct ubi_set_prop_req object is expected to be
+ * used. A pointer to a &struct ubi_set_vol_prop_req object is expected to be
  * passed. The object describes which property should be set, and to which value
  * it should be set.
  */
@@ -152,7 +154,7 @@
 /* Create an UBI volume */
 #define UBI_IOCMKVOL _IOW(UBI_IOC_MAGIC, 0, struct ubi_mkvol_req)
 /* Remove an UBI volume */
-#define UBI_IOCRMVOL _IOW(UBI_IOC_MAGIC, 1, int32_t)
+#define UBI_IOCRMVOL _IOW(UBI_IOC_MAGIC, 1, __s32)
 /* Re-size an UBI volume */
 #define UBI_IOCRSVOL _IOW(UBI_IOC_MAGIC, 2, struct ubi_rsvol_req)
 /* Re-name volumes */
@@ -165,26 +167,27 @@
 /* Attach an MTD device */
 #define UBI_IOCATT _IOW(UBI_CTRL_IOC_MAGIC, 64, struct ubi_attach_req)
 /* Detach an MTD device */
-#define UBI_IOCDET _IOW(UBI_CTRL_IOC_MAGIC, 65, int32_t)
+#define UBI_IOCDET _IOW(UBI_CTRL_IOC_MAGIC, 65, __s32)
 
 /* ioctl commands of UBI volume character devices */
 
 #define UBI_VOL_IOC_MAGIC 'O'
 
 /* Start UBI volume update */
-#define UBI_IOCVOLUP _IOW(UBI_VOL_IOC_MAGIC, 0, int64_t)
+#define UBI_IOCVOLUP _IOW(UBI_VOL_IOC_MAGIC, 0, __s64)
 /* LEB erasure command, used for debugging, disabled by default */
-#define UBI_IOCEBER _IOW(UBI_VOL_IOC_MAGIC, 1, int32_t)
+#define UBI_IOCEBER _IOW(UBI_VOL_IOC_MAGIC, 1, __s32)
 /* Atomic LEB change command */
-#define UBI_IOCEBCH _IOW(UBI_VOL_IOC_MAGIC, 2, int32_t)
+#define UBI_IOCEBCH _IOW(UBI_VOL_IOC_MAGIC, 2, __s32)
 /* Map LEB command */
 #define UBI_IOCEBMAP _IOW(UBI_VOL_IOC_MAGIC, 3, struct ubi_map_req)
 /* Unmap LEB command */
-#define UBI_IOCEBUNMAP _IOW(UBI_VOL_IOC_MAGIC, 4, int32_t)
+#define UBI_IOCEBUNMAP _IOW(UBI_VOL_IOC_MAGIC, 4, __s32)
 /* Check if LEB is mapped command */
-#define UBI_IOCEBISMAP _IOR(UBI_VOL_IOC_MAGIC, 5, int32_t)
+#define UBI_IOCEBISMAP _IOR(UBI_VOL_IOC_MAGIC, 5, __s32)
 /* Set an UBI volume property */
-#define UBI_IOCSETPROP _IOW(UBI_VOL_IOC_MAGIC, 6, struct ubi_set_prop_req)
+#define UBI_IOCSETVOLPROP _IOW(UBI_VOL_IOC_MAGIC, 6, \
+			       struct ubi_set_vol_prop_req)
 
 /* Maximum MTD device name length supported by UBI */
 #define MAX_UBI_MTD_NAME_LEN 127
@@ -193,23 +196,6 @@
 #define UBI_MAX_RNVOL 32
 
 /*
- * UBI data type hint constants.
- *
- * UBI_LONGTERM: long-term data
- * UBI_SHORTTERM: short-term data
- * UBI_UNKNOWN: data persistence is unknown
- *
- * These constants are used when data is written to UBI volumes in order to
- * help the UBI wear-leveling unit to find more appropriate physical
- * eraseblocks.
- */
-enum {
-	UBI_LONGTERM  = 1,
-	UBI_SHORTTERM = 2,
-	UBI_UNKNOWN   = 3,
-};
-
-/*
  * UBI volume type constants.
  *
  * @UBI_DYNAMIC_VOLUME: dynamic volume
@@ -221,13 +207,14 @@ enum {
 };
 
 /*
- * UBI set property ioctl constants
+ * UBI set volume property ioctl constants.
  *
- * @UBI_PROP_DIRECT_WRITE: allow / disallow user to directly write and
- *                         erase individual eraseblocks on dynamic volumes
+ * @UBI_VOL_PROP_DIRECT_WRITE: allow (any non-zero value) or disallow (value 0)
+ *                             user to directly write and erase individual
+ *                             eraseblocks on dynamic volumes
  */
 enum {
-       UBI_PROP_DIRECT_WRITE = 1,
+	UBI_VOL_PROP_DIRECT_WRITE = 1,
 };
 
 /**
@@ -260,10 +247,10 @@ enum {
  * sub-page of the first page and add needed padding.
  */
 struct ubi_attach_req {
-	int32_t ubi_num;
-	int32_t mtd_num;
-	int32_t vid_hdr_offset;
-	int8_t padding[12];
+	__s32 ubi_num;
+	__s32 mtd_num;
+	__s32 vid_hdr_offset;
+	__s8 padding[12];
 };
 
 /**
@@ -298,15 +285,15 @@ struct ubi_attach_req {
  * BLOBs, without caring about how to properly align them.
  */
 struct ubi_mkvol_req {
-	int32_t vol_id;
-	int32_t alignment;
-	int64_t bytes;
-	int8_t vol_type;
-	int8_t padding1;
-	int16_t name_len;
-	int8_t padding2[4];
+	__s32 vol_id;
+	__s32 alignment;
+	__s64 bytes;
+	__s8 vol_type;
+	__s8 padding1;
+	__s16 name_len;
+	__s8 padding2[4];
 	char name[UBI_MAX_VOLUME_NAME + 1];
-} __attribute__ ((packed));
+} __attribute__((packed));
 
 /**
  * struct ubi_rsvol_req - a data structure used in volume re-size requests.
@@ -320,9 +307,9 @@ struct ubi_mkvol_req {
  * zero number of bytes).
  */
 struct ubi_rsvol_req {
-	int64_t bytes;
-	int32_t vol_id;
-} __attribute__ ((packed));
+	__s64 bytes;
+	__s32 vol_id;
+} __attribute__((packed));
 
 /**
  * struct ubi_rnvol_req - volumes re-name request.
@@ -356,55 +343,64 @@ struct ubi_rsvol_req {
  * re-name request.
  */
 struct ubi_rnvol_req {
-	int32_t count;
-	int8_t padding1[12];
+	__s32 count;
+	__s8 padding1[12];
 	struct {
-		int32_t vol_id;
-		int16_t name_len;
-		int8_t  padding2[2];
+		__s32 vol_id;
+		__s16 name_len;
+		__s8  padding2[2];
 		char    name[UBI_MAX_VOLUME_NAME + 1];
 	} ents[UBI_MAX_RNVOL];
-} __attribute__ ((packed));
+} __attribute__((packed));
 
 /**
  * struct ubi_leb_change_req - a data structure used in atomic LEB change
  *                             requests.
  * @lnum: logical eraseblock number to change
  * @bytes: how many bytes will be written to the logical eraseblock
- * @dtype: data type (%UBI_LONGTERM, %UBI_SHORTTERM, %UBI_UNKNOWN)
+ * @dtype: pass "3" for better compatibility with old kernels
  * @padding: reserved for future, not used, has to be zeroed
+ *
+ * The @dtype field used to inform UBI about what kind of data will be written
+ * to the LEB: long term (value 1), short term (value 2), unknown (value 3).
+ * UBI tried to pick a PEB with lower erase counter for short term data and a
+ * PEB with higher erase counter for long term data. But this was not really
+ * used because users usually do not know this and could easily mislead UBI. We
+ * removed this feature in May 2012. UBI currently just ignores the @dtype
+ * field. But for better compatibility with older kernels it is recommended to
+ * set @dtype to 3 (unknown).
  */
 struct ubi_leb_change_req {
-	int32_t lnum;
-	int32_t bytes;
-	int8_t  dtype;
-	int8_t  padding[7];
-} __attribute__ ((packed));
+	__s32 lnum;
+	__s32 bytes;
+	__s8  dtype; /* obsolete, do not use! */
+	__s8  padding[7];
+} __attribute__((packed));
 
 /**
  * struct ubi_map_req - a data structure used in map LEB requests.
+ * @dtype: pass "3" for better compatibility with old kernels
  * @lnum: logical eraseblock number to unmap
- * @dtype: data type (%UBI_LONGTERM, %UBI_SHORTTERM, %UBI_UNKNOWN)
  * @padding: reserved for future, not used, has to be zeroed
  */
 struct ubi_map_req {
-	int32_t lnum;
-	int8_t  dtype;
-	int8_t  padding[3];
-} __attribute__ ((packed));
+	__s32 lnum;
+	__s8  dtype; /* obsolete, do not use! */
+	__s8  padding[3];
+} __attribute__((packed));
 
 
 /**
- * struct ubi_set_prop_req - a data structure used to set an ubi volume
- *                           property.
- * @property: property to set (%UBI_PROP_DIRECT_WRITE)
+ * struct ubi_set_vol_prop_req - a data structure used to set an UBI volume
+ *                               property.
+ * @property: property to set (%UBI_VOL_PROP_DIRECT_WRITE)
  * @padding: reserved for future, not used, has to be zeroed
  * @value: value to set
  */
-struct ubi_set_prop_req {
-       uint8_t  property;
-       uint8_t  padding[7];
-       uint64_t value;
-}  __attribute__ ((packed));
+struct ubi_set_vol_prop_req {
+	__u8  property;
+	__u8  padding[7];
+	__u64 value;
+}  __attribute__((packed));
 
 #endif /* __UBI_USER_H__ */
-- 
1.7.2.5

