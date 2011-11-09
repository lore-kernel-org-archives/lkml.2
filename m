Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965485Ab1KJDmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:42:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44436 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965457Ab1KJDmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:42:39 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:56 2011
Message-Id: <20111109213156.770553400@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:33:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>
Subject: [145/264] md/raid10:  Fix bug when activating a hot-spare.
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 7fcc7c8acf0fba44d19a713207af7e58267c1179 upstream.

This is a fairly serious bug in RAID10.

When a RAID10 array is degraded and a hot-spare is activated, the
spare does not take up the empty slot, but rather replaces the first
working device.
This is likely to make the array non-functional.   It would normally
be possible to recover the data, but that would need care and is not
guaranteed.

This bug was introduced in commit
   2bb77736ae5dca0a189829fbb7379d43364a9dac
which first appeared in 3.1.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1337,7 +1337,7 @@ static int raid10_add_disk(mddev_t *mdde
 		mirror_info_t *p = &conf->mirrors[mirror];
 		if (p->recovery_disabled == mddev->recovery_disabled)
 			continue;
-		if (!p->rdev)
+		if (p->rdev)
 			continue;
 
 		disk_stack_limits(mddev->gendisk, rdev->bdev,


