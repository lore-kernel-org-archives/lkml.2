Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965600Ab2EOCSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:18:31 -0400
Received: from mail.windriver.com ([147.11.1.11]:49299 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964904Ab2EOCQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:38 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 047/179] block: export blk_{get,put}_queue()
Date: Mon, 14 May 2012 22:12:23 -0400
Message-ID: <1337048075-6132-48-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jaxboe@fusionio.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d86e0e83b32bc84600adb0b6ea1fce389b266682 upstream.

We need them in SCSI to fix a bug, but currently they are not
exported to modules. Export them.

Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 block/blk-core.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index dd9795d..94f274b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -439,6 +439,7 @@ void blk_put_queue(struct request_queue *q)
 {
 	kobject_put(&q->kobj);
 }
+EXPORT_SYMBOL(blk_put_queue);
 
 void blk_cleanup_queue(struct request_queue *q)
 {
@@ -612,6 +613,7 @@ int blk_get_queue(struct request_queue *q)
 
 	return 1;
 }
+EXPORT_SYMBOL(blk_get_queue);
 
 static inline void blk_free_request(struct request_queue *q, struct request *rq)
 {
-- 
1.7.9.6

