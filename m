Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab2AUDYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 22:24:18 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:39802 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab2AUDYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 22:24:17 -0500
From: Kashyap Gada <gada.kashyap@gmail.com>
To: gregkh@suse.de
Cc: rebecca@android.com, rschultz@google.com, jgennis@google.com,
        dima@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Kashyap Gada <gada.kashyap@gmail.com>
Subject: [PATCH 5/5] Staging: android: Add KERN_ facility level in printk () in pmem.c
Date: Sat, 21 Jan 2012 03:24:09 +0000
Message-Id: <1327116249-18274-1-git-send-email-gada.kashyap@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Signed-off-by: Kashyap Gada <gada.kashyap@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/drivers/staging/android/pmem.c b/drivers/staging/android/pmem.c
index 65ba61a..c589c0c 100644
--- a/drivers/staging/android/pmem.c
+++ b/drivers/staging/android/pmem.c
@@ -831,7 +831,7 @@ static int pmem_connect(unsigned long connect, struct file *file)
 	src_file = fget_light(connect, &put_needed);
 	DLOG("connect %p to %p\n", file, src_file);
 	if (!src_file) {
-		printk("pmem: src file not found!\n");
+		printk(KERN_ERR "pmem: src file not found!\n");
 		ret = -EINVAL;
 		goto err_no_file;
 	}
@@ -934,7 +934,7 @@ int pmem_remap(struct pmem_region *region, struct file *file,
 	if (unlikely(!PMEM_IS_PAGE_ALIGNED(region->offset) ||
 		 !PMEM_IS_PAGE_ALIGNED(region->len))) {
 #if PMEM_DEBUG
-		printk("pmem: request for unaligned pmem suballocation "
+		printk(KERN_DEBUG "pmem: request for unaligned pmem suballocation "
 		       "%lx %lx\n", region->offset, region->len);
 #endif
 		return -EINVAL;
-- 
1.7.5.4

