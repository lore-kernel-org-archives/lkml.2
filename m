Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab1CRIhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 04:37:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60863 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab1CRIh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 04:37:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Bj78pTomic+M3MFABUCbCzUOOaXy3KCSzOfx4ShCUuU2umwFxQjHvp6oo5b67GZ3yt
         ARuVSTIjOnVks6SCGr9F2w+AgRPMlcKfjtctCAYuO/cV3Ud6m+tpeyh9i8vXX8LhkT6U
         V7UchensXNnQ5ET6PuNEwFd/YQ0YliTI2qZ+Y=
Date: Fri, 18 Mar 2011 09:37:23 +0100
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH] block: NULL dereference on error path in __blkdev_get()
Message-ID: <20110318083723.GE8571@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

"disk" is always NULL when we goto out.  There was a check for this
before, but it was removed in 69e02c59a7d9 "block: Don't check events
while open is in progress".

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>

diff --git a/fs/block_dev.c b/fs/block_dev.c
index fbe05cb..7d02afb 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1181,9 +1181,9 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
  out_unlock_bdev:
 	mutex_unlock(&bdev->bd_mutex);
 	disk_unblock_events(disk);
- out:
 	module_put(disk->fops->owner);
 	put_disk(disk);
+ out:
 	bdput(bdev);
 
 	return ret;
