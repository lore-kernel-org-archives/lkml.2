Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763041Ab2KBRHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:07:54 -0400
Received: from mail.kernel.org ([198.145.19.201]:33355 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762327Ab2KBRHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:07:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>, Jens Axboe <axboe@kernel.dk>
Subject: [ 07/24] floppy: do put_disk on current dr if blk_init_queue fails
Date: Fri,  2 Nov 2012 10:06:55 -0700
Message-Id: <20121102170247.953165950@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121102170247.406319110@linuxfoundation.org>
References: <20121102170247.406319110@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>

commit 238ab78469c6ab7845b43d5061cd3c92331b2452 upstream.

If blk_init_queue fails, we do not call put_disk on the current dr
(dr is decremented first in the error handling loop).

Reviewed-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/floppy.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4151,6 +4151,7 @@ static int __init do_floppy_init(void)
 
 		disks[dr]->queue = blk_init_queue(do_fd_request, &floppy_lock);
 		if (!disks[dr]->queue) {
+			put_disk(disks[dr]);
 			err = -ENOMEM;
 			goto out_put_disk;
 		}


