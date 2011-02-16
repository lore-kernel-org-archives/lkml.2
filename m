Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638Ab1BPAgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:36:11 -0500
Received: from kroah.org ([198.145.64.141]:49637 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932293Ab1BPAYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:24:17 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:47 2011
Message-Id: <20110216001446.935427362@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>
Subject: [218/272] md: Fix removal of extra drives when converting RAID6 to RAID5
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit bf2cb0dab8c97f00a71875d9b13dbac17a2f47ca upstream.

When a RAID6 is converted to a RAID5, the extra drive should
be discarded.  However it isn't due to a typo in a comparison.

This bug was introduced in commit e93f68a1fc6 in 2.6.35-rc4
and is suitable for any -stable since than.

As the extra drive is not removed, the 'degraded' counter is wrong and
so the RAID5 will not respond correctly to a subsequent failure.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3117,7 +3117,7 @@ level_store(mddev_t *mddev, const char *
 		char nm[20];
 		if (rdev->raid_disk < 0)
 			continue;
-		if (rdev->new_raid_disk > mddev->raid_disks)
+		if (rdev->new_raid_disk >= mddev->raid_disks)
 			rdev->new_raid_disk = -1;
 		if (rdev->new_raid_disk == rdev->raid_disk)
 			continue;


