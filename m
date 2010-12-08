Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab0LHCOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:14:04 -0500
Received: from kroah.org ([198.145.64.141]:46037 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755791Ab0LHArD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:03 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:28 2010
Message-Id: <20101208004428.116630616@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Justin Maggard <jmaggard10@gmail.com>, NeilBrown <neilb@suse.de>
Subject: [038/127] md: fix return value of rdev_size_change()
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Justin Maggard <jmaggard10@gmail.com>

commit c26a44ed1e552aaa1d4ceb71842002d235fe98d7 upstream.

When trying to grow an array by enlarging component devices,
rdev_size_store() expects the return value of rdev_size_change() to be
in sectors, but the actual value is returned in KBs.

This functionality was broken by commit
     dd8ac336c13fd8afdb082ebacb1cddd5cf727889
so this patch is suitable for any kernel since 2.6.30.

Signed-off-by: Justin Maggard <jmaggard10@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1122,7 +1122,7 @@ super_90_rdev_size_change(mdk_rdev_t *rd
 	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
 		       rdev->sb_page);
 	md_super_wait(rdev->mddev);
-	return num_sectors / 2; /* kB for sysfs */
+	return num_sectors;
 }
 
 
@@ -1485,7 +1485,7 @@ super_1_rdev_size_change(mdk_rdev_t *rde
 	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
 		       rdev->sb_page);
 	md_super_wait(rdev->mddev);
-	return num_sectors / 2; /* kB for sysfs */
+	return num_sectors;
 }
 
 static struct super_type super_types[] = {


