Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510Ab0GAWKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:10:08 -0400
Received: from kroah.org ([198.145.64.141]:47468 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932662Ab0GAUuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:50:15 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:32 2010
Message-Id: <20100701173432.298155919@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:34:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [patch 065/164] md/linear: avoid possible oops and array stop
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit ef2f80ff7325b2c1888ff02ead28957b5840bf51 upstream.

Since commit ef286f6fa673cd7fb367e1b145069d8dbfcc6081
it has been important that each personality clears
->private in the ->stop() function, or sets it to a
attribute group to be removed.
linear.c doesn't.  This can sometimes lead to an oops,
though it doesn't always.

Suitable for 2.6.33-stable and 2.6.34.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/linear.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -281,6 +281,7 @@ static int linear_stop (mddev_t *mddev)
 	rcu_barrier();
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	kfree(conf);
+	mddev->private = NULL;
 
 	return 0;
 }


