Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab1EFAgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:36:36 -0400
Received: from kroah.org ([198.145.64.141]:37455 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932545Ab1EFA1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:27:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:26:07 2011
Message-Id: <20110506002607.502775716@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:25:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Liu Yuan <tailai.ly@taobao.com>, Jens Axboe <jaxboe@fusionio.com>
Subject: [02/43] block, blk-sysfs: Fix an err return path in blk_register_queue()
In-Reply-To: <20110506002625.GA20426@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Liu Yuan <tailai.ly@taobao.com>

commit ed5302d3c25006a9edc7a7fbea97a30483f89ef7 upstream.

We do not call blk_trace_remove_sysfs() in err return path
if kobject_add() fails. This path fixes it.

Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/blk-sysfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -473,8 +473,10 @@ int blk_register_queue(struct gendisk *d
 		return ret;
 
 	ret = kobject_add(&q->kobj, kobject_get(&dev->kobj), "%s", "queue");
-	if (ret < 0)
+	if (ret < 0) {
+		blk_trace_remove_sysfs(dev);
 		return ret;
+	}
 
 	kobject_uevent(&q->kobj, KOBJ_ADD);
 


