Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964865Ab1DNS2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:28:51 -0400
Received: from mail.windriver.com ([147.11.1.11]:38016 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933010Ab1DNRqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Justin Maggard <jmaggard10@gmail.com>,
        NeilBrown <neilb@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 051/209] md: fix return value of rdev_size_change()
Date: Thu, 14 Apr 2011 13:41:21 -0400
Message-Id: <1302803039-9400-52-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Justin Maggard <jmaggard10@gmail.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit c26a44ed1e552aaa1d4ceb71842002d235fe98d7 upstream.

When trying to grow an array by enlarging component devices,
rdev_size_store() expects the return value of rdev_size_change() to be
in sectors, but the actual value is returned in KBs.

This functionality was broken by commit
     dd8ac336c13fd8afdb082ebacb1cddd5cf727889
so this patch is suitable for any kernel since 2.6.30.

Signed-off-by: Justin Maggard <jmaggard10@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/md/md.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 81c0282..92dbef5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1260,7 +1260,7 @@ super_90_rdev_size_change(mdk_rdev_t *rdev, sector_t num_sectors)
 	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
 		       rdev->sb_page);
 	md_super_wait(rdev->mddev);
-	return num_sectors / 2; /* kB for sysfs */
+	return num_sectors;
 }
 
 
@@ -1622,7 +1622,7 @@ super_1_rdev_size_change(mdk_rdev_t *rdev, sector_t num_sectors)
 	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
 		       rdev->sb_page);
 	md_super_wait(rdev->mddev);
-	return num_sectors / 2; /* kB for sysfs */
+	return num_sectors;
 }
 
 static struct super_type super_types[] = {
-- 
1.7.4.4

