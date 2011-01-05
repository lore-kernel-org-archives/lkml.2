Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab1AEVU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 16:20:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957Ab1AEVU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 16:20:27 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        akpm@linux-foundation.org
Subject: [patch] aio: remove unused function, aio_run_iocbs
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 05 Jan 2011 16:19:50 -0500
Message-ID: <x49k4ijoxop.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

aio_run_iocbs is not used at all, so get rid of it.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/fs/aio.c b/fs/aio.c
index 8c8f6c5..6ca2f96 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -798,30 +798,14 @@ static void aio_queue_work(struct kioctx * ctx)
 	queue_delayed_work(aio_wq, &ctx->wq, timeout);
 }
 
-
 /*
- * aio_run_iocbs:
+ * aio_run_all_iocbs:
  * 	Process all pending retries queued on the ioctx
- * 	run list.
+ * 	run list, and keep running them until the list
+ * 	stays empty.
  * Assumes it is operating within the aio issuer's mm
  * context.
  */
-static inline void aio_run_iocbs(struct kioctx *ctx)
-{
-	int requeue;
-
-	spin_lock_irq(&ctx->ctx_lock);
-
-	requeue = __aio_run_iocbs(ctx);
-	spin_unlock_irq(&ctx->ctx_lock);
-	if (requeue)
-		aio_queue_work(ctx);
-}
-
-/*
- * just like aio_run_iocbs, but keeps running them until
- * the list stays empty
- */
 static inline void aio_run_all_iocbs(struct kioctx *ctx)
 {
 	spin_lock_irq(&ctx->ctx_lock);
