Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab1FPHhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:37:25 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:47976 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755629Ab1FPHAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:49 -0400
X-Sasl-enc: Za/SvnWWN7t4OloDY7eU2juKXJQRVIIYNp9PEIE3+Ivx 1308207648
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:32 2011
Message-Id: <20110616000232.229338746@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [33/89] block: export blk_{get,put}_queue()
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jens Axboe <jaxboe@fusionio.com>

commit d86e0e83b32bc84600adb0b6ea1fce389b266682 upstream.

We need them in SCSI to fix a bug, but currently they are not
exported to modules. Export them.

Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/blk-core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -345,6 +345,7 @@ void blk_put_queue(struct request_queue
 {
 	kobject_put(&q->kobj);
 }
+EXPORT_SYMBOL(blk_put_queue);
 
 /*
  * Note: If a driver supplied the queue lock, it should not zap that lock
@@ -566,6 +567,7 @@ int blk_get_queue(struct request_queue *
 
 	return 1;
 }
+EXPORT_SYMBOL(blk_get_queue);
 
 static inline void blk_free_request(struct request_queue *q, struct request *rq)
 {


