Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab2HMSQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 14:16:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53897 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab2HMSQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 14:16:40 -0400
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH v3 2/6] floppy: do put_disk on current dr if blk_init_queue fails
Date: Mon, 13 Aug 2012 15:16:23 -0300
Message-Id: <1344881787-6422-3-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344881787-6422-1-git-send-email-herton.krzesinski@canonical.com>
References: <1344881787-6422-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If blk_init_queue fails, we do not call put_disk on the current dr
(dr is decremented first in the error handling loop).

Cc: stable@vger.kernel.org
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/block/floppy.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index c8d9e68..1e09e99 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4151,6 +4151,7 @@ static int __init do_floppy_init(void)
 
 		disks[dr]->queue = blk_init_queue(do_fd_request, &floppy_lock);
 		if (!disks[dr]->queue) {
+			put_disk(disks[dr]);
 			err = -ENOMEM;
 			goto out_put_disk;
 		}
-- 
1.7.9.5

