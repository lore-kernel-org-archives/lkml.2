Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab1BKVcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 16:32:10 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11339 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170Ab1BKVcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 16:32:08 -0500
Date: Fri, 11 Feb 2011 22:30:59 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>,
        Neil Brown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md: Remove risk of overflow via sprintf) by using snprintf()
 in md_check_recovery()
Message-ID: <alpine.LNX.2.00.1102112227040.16994@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sprintf() is dangerous - given the wrong source string it will overflow 
the destination. snprintf() is safer in that at least we'll never overflow 
the destination. Even if overflow will never happen today, code changes 
over time and snprintf() is just safer in the long run.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

 just compile tested

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0cc30ec..6283658 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7164,7 +7164,7 @@ void md_check_recovery(mddev_t *mddev)
 					if (mddev->pers->hot_remove_disk(
 						    mddev, rdev->raid_disk)==0) {
 						char nm[20];
-						sprintf(nm,"rd%d", rdev->raid_disk);
+						snprintf(nm, sizeof(nm), "rd%d", rdev->raid_disk);
 						sysfs_remove_link(&mddev->kobj, nm);
 						rdev->raid_disk = -1;
 					}


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

