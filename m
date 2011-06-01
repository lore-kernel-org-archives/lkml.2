Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507Ab1FATeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:34:50 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:39062 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759301Ab1FATet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:34:49 -0400
Subject: [PATCH] Remove bogus check in queue_fail path
From: Paul Bolle <pebolle@tiscali.nl>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 01 Jun 2011 21:34:47 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.1 (3.1.1-3.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306956887.9926.3.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

queue_fail can only be reached if cic is NULL, so its check for cic must
be bogus.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 block/cfq-iosched.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 7c52d68..9632e62 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3786,9 +3786,6 @@ new_queue:
 	return 0;
 
 queue_fail:
-	if (cic)
-		put_io_context(cic->ioc);
-
 	cfq_schedule_dispatch(cfqd);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 	cfq_log(cfqd, "set_request fail");
-- 
1.7.5.2



