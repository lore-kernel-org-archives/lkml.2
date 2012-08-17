Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231Ab2HQO6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:58:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43346 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758160Ab2HQO5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:57:38 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 2/4] sync include/mtd/ubi-user.h: add max_beb_per1024 parameter
Date: Fri, 17 Aug 2012 16:57:20 +0200
Message-Id: <1345215442-19082-3-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1345215442-19082-1-git-send-email-richard.genoud@gmail.com>
References: <1345215442-19082-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 include/mtd/ubi-user.h |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/include/mtd/ubi-user.h b/include/mtd/ubi-user.h
index 123951f..32771cf 100644
--- a/include/mtd/ubi-user.h
+++ b/include/mtd/ubi-user.h
@@ -222,6 +222,7 @@ enum {
  * @ubi_num: UBI device number to create
  * @mtd_num: MTD device number to attach
  * @vid_hdr_offset: VID header offset (use defaults if %0)
+ * @max_beb_per1024: Maximum expected bad eraseblocks per 1024 eraseblocks
  * @padding: reserved for future, not used, has to be zeroed
  *
  * This data structure is used to specify MTD device UBI has to attach and the
@@ -245,12 +246,28 @@ enum {
  * be 2KiB-64 bytes = 1984. Note, that this position is not even 512-bytes
  * aligned, which is OK, as UBI is clever enough to realize this is 4th
  * sub-page of the first page and add needed padding.
+ *
+ * The @max_beb_per1024 is the maximum bad eraseblocks UBI expects on the ubi
+ * device per 1024 eraseblocks.
+ * This value is often given in an other form in the NAND datasheet (min NVB
+ * i.e. minimal number of valid blocks). The maximum expected bad eraseblocks
+ * per 1024 is then:
+ *   1024 * (1 - MinNVB / MaxNVB)
+ * Which gives 20 for most NAND devices.
+ * This limit is used in order to derive amount of eraseblock UBI reserves for
+ * handling new bad blocks.
+ * If the device has more bad eraseblocks than this limit, UBI does not reserve
+ * any physical eraseblocks for new bad eraseblocks, but attempts to use
+ * available eraseblocks (if any).
+ * The accepted range is 0-255. If 0 is given, the default kernel config value
+ * CONFIG_MTD_UBI_BEB_LIMIT will be used for compatibility.
  */
 struct ubi_attach_req {
 	__s32 ubi_num;
 	__s32 mtd_num;
 	__s32 vid_hdr_offset;
-	__s8 padding[12];
+	__u8 max_beb_per1024;
+	__s8 padding[11];
 };
 
 /**
-- 
1.7.2.5

