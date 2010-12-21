Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364Ab0LUMS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 07:18:58 -0500
Received: from jester.euphonynet.be ([212.87.96.13]:36197 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab0LUMS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 07:18:57 -0500
X-Greylist: delayed 565 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Dec 2010 07:18:56 EST
From: Bart Van Assche <bvanassche@acm.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] block: Clean up exit_io_context() source code.
Date: Tue, 21 Dec 2010 13:18:47 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.6-scst; KDE/4.4.4; x86_64; ; )
Cc: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012211318.47736.bvanassche@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a spelling error in a source code comment and removes
superfluous braces in the function exit_io_context().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <jaxboe@fusionio.com>
---
 block/blk-ioc.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 3c7a339..b791022 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -64,7 +64,7 @@ static void cfq_exit(struct io_context *ioc)
 	rcu_read_unlock();
 }
 
-/* Called by the exitting task */
+/* Called by the exiting task */
 void exit_io_context(struct task_struct *task)
 {
 	struct io_context *ioc;
@@ -74,10 +74,9 @@ void exit_io_context(struct task_struct *task)
 	task->io_context = NULL;
 	task_unlock(task);
 
-	if (atomic_dec_and_test(&ioc->nr_tasks)) {
+	if (atomic_dec_and_test(&ioc->nr_tasks))
 		cfq_exit(ioc);
 
-	}
 	put_io_context(ioc);
 }
 
-- 
1.7.1

