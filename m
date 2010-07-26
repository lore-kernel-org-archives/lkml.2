Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab0GZI2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 04:28:33 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43018 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab0GZI2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 04:28:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=q9PRNNoG4GM/4SYhvUZfzOUWAQO77tT1uAAgyJYV25pzvl3+S83g+rh/DlGuA0VO3S
         IX8mjdOXduwXdN1DVnuLaAfkofafo2rJBwXeACjRbjK+q6B9BvKtVC4Was0bqodaEiVV
         +vOrpGvT6aGBuNzs4o3NNvgHsKPmKmhfEmlIY=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Chris Mason <chris.mason@oracle.com>, Tejun Heo <tj@kernel.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: set task state with schedule_timeout_uninterruptible()
Date: Mon, 26 Jul 2010 12:27:43 +0400
Message-Id: <1280132864-8266-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

worker_loop() uses schedule_timeout() without setting state to
STATE_(UN)INTERRUPTIBLE. As it is called in cycle without checking of
pending signals, use schedule_timeout_uninterruptible().

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 fs/btrfs/async-thread.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 7ec1409..54eb070 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -362,7 +362,7 @@ again:
 				 * worker->working is still 1, so nobody
 				 * is going to try and wake us up
 				 */
-				schedule_timeout(1);
+				schedule_timeout_uninterruptible(1);
 				smp_mb();
 				if (!list_empty(&worker->pending) ||
 				    !list_empty(&worker->prio_pending))
-- 
1.7.0.4

