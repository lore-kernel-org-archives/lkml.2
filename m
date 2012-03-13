Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268Ab2CMAyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:54:43 -0400
Received: from mail.windriver.com ([147.11.1.11]:47876 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758764Ab2CMAWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:49 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Liu Yuan <tailai.ly@taobao.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 086/196] block, blk-sysfs: Fix an err return path in blk_register_queue()
Date: Mon, 12 Mar 2012 20:19:59 -0400
Message-Id: <1331598109-31424-41-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yuan <tailai.ly@taobao.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit ed5302d3c25006a9edc7a7fbea97a30483f89ef7 upstream.

We do not call blk_trace_remove_sysfs() in err return path
if kobject_add() fails. This path fixes it.

Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 block/blk-sysfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index d246654..3eede79 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -502,8 +502,10 @@ int blk_register_queue(struct gendisk *disk)
 		return ret;
 
 	ret = kobject_add(&q->kobj, kobject_get(&dev->kobj), "%s", "queue");
-	if (ret < 0)
+	if (ret < 0) {
+		blk_trace_remove_sysfs(dev);
 		return ret;
+	}
 
 	kobject_uevent(&q->kobj, KOBJ_ADD);
 
-- 
1.7.9.3

