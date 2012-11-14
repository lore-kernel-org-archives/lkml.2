Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab2KNFvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:51:15 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55260 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756457Ab2KNFvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:51:07 -0500
Message-Id: <20121114053938.595866708@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:07 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>, Jens Axboe <axboe@kernel.dk>
Subject: [ 34/82] floppy: do put_disk on current dr if blk_init_queue fails
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>

commit 238ab78469c6ab7845b43d5061cd3c92331b2452 upstream.

If blk_init_queue fails, we do not call put_disk on the current dr
(dr is decremented first in the error handling loop).

Reviewed-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/floppy.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 83112f0..9a558b6 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4150,6 +4150,7 @@ static int __init do_floppy_init(void)
 
 		disks[dr]->queue = blk_init_queue(do_fd_request, &floppy_lock);
 		if (!disks[dr]->queue) {
+			put_disk(disks[dr]);
 			err = -ENOMEM;
 			goto out_put_disk;
 		}


