Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab2AUEXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 23:23:41 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:40123 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249Ab2AUEXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 23:23:40 -0500
From: Kashyap Gada <gada.kashyap@gmail.com>
To: gregkh@suse.de
Cc: rebecca@android.com, jgennis@google.com, dima@android.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Kashyap Gada <gada.kashyap@gmail.com>
Subject: [PATCH 6/6] Staging: android: Add parenthesis to macros with complex values in pmem.c
Date: Sat, 21 Jan 2012 04:23:32 +0000
Message-Id: <1327119812-19851-1-git-send-email-gada.kashyap@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Signed-off-by: Kashyap Gada <gada.kashyap@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/drivers/staging/android/pmem.c b/drivers/staging/android/pmem.c
index c589c0c..b685c18 100644
--- a/drivers/staging/android/pmem.c
+++ b/drivers/staging/android/pmem.c
@@ -38,17 +38,17 @@
  * the file should not be released until put_pmem_file is called */
 #define PMEM_FLAGS_BUSY 0x1
 /* indicates that this is a suballocation of a larger master range */
-#define PMEM_FLAGS_CONNECTED 0x1 << 1
+#define PMEM_FLAGS_CONNECTED (x1 << 1)
 /* indicates this is a master and not a sub allocation and that it is mmaped */
-#define PMEM_FLAGS_MASTERMAP 0x1 << 2
+#define PMEM_FLAGS_MASTERMAP (0x1 << 2)
 /* submap and unsubmap flags indicate:
  * 00: subregion has never been mmaped
  * 10: subregion has been mmaped, reference to the mm was taken
  * 11: subretion has ben released, refernece to the mm still held
  * 01: subretion has been released, reference to the mm has been released
  */
-#define PMEM_FLAGS_SUBMAP 0x1 << 3
-#define PMEM_FLAGS_UNSUBMAP 0x1 << 4
+#define PMEM_FLAGS_SUBMAP (0x1 << 3)
+#define PMEM_FLAGS_UNSUBMAP (0x1 << 4)
 
 
 struct pmem_data {
@@ -153,8 +153,8 @@ struct pmem_info {
 static struct pmem_info pmem[PMEM_MAX_DEVICES];
 static int id_count;
 
-#define PMEM_IS_FREE(id, index) !(pmem[id].bitmap[index].allocated)
-#define PMEM_ORDER(id, index) pmem[id].bitmap[index].order
+#define PMEM_IS_FREE(id, index) (!(pmem[id].bitmap[index].allocated))
+#define PMEM_ORDER(id, index) (pmem[id].bitmap[index].order)
 #define PMEM_BUDDY_INDEX(id, index) (index ^ (1 << PMEM_ORDER(id, index)))
 #define PMEM_NEXT_INDEX(id, index) (index + (1 << PMEM_ORDER(id, index)))
 #define PMEM_OFFSET(index) (index * PMEM_MIN_ALLOC)
-- 
1.7.5.4

