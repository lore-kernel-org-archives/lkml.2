Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945897Ab2E0BaL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:30:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54259 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422640Ab2E0BQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:16:50 -0400
Message-Id: <20120527002515.148499606@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:25:44 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Shaohua Li <shli@fusionio.com>,
        NeilBrown <neilb@suse.de>
Subject: [ 38/91] md: using GFP_NOIO to allocate bio for flush request
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shaohua Li <shli@kernel.org>

commit b5e1b8cee7ad58a15d2fa79bcd7946acb592602d upstream.

A flush request is usually issued in transaction commit code path, so
using GFP_KERNEL to allocate memory for flush request bio falls into
the classic deadlock issue.

This is suitable for any -stable kernel to which it applies as it
avoids a possible deadlock.

Signed-off-by: Shaohua Li <shli@fusionio.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -452,7 +452,7 @@ static void submit_flushes(struct work_s
 			atomic_inc(&rdev->nr_pending);
 			atomic_inc(&rdev->nr_pending);
 			rcu_read_unlock();
-			bi = bio_alloc_mddev(GFP_KERNEL, 0, mddev);
+			bi = bio_alloc_mddev(GFP_NOIO, 0, mddev);
 			bi->bi_end_io = md_end_flush;
 			bi->bi_private = rdev;
 			bi->bi_bdev = rdev->bdev;


