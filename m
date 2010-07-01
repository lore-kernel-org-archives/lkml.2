Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048Ab0GAVtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:49:41 -0400
Received: from kroah.org ([198.145.64.141]:60957 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759014Ab0GAVN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:57 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:53 2010
Message-Id: <20100701174253.772572260@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [087/200] md/linear: avoid possible oops and array stop
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

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
@@ -282,6 +282,7 @@ static int linear_stop (mddev_t *mddev)
 	rcu_barrier();
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	kfree(conf);
+	mddev->private = NULL;
 
 	return 0;
 }


