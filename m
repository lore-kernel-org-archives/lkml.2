Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab2KSLGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 06:06:48 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41307 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2KSLGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 06:06:47 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, patches@linaro.org
Subject: [PATCH] block: Fix sparse warning
Date: Mon, 19 Nov 2012 16:30:40 +0530
Message-Id: <1353322840-2881-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_drain_queue is only used in this file, so should be marked static.

Fixes following sparse warning.

block/blk-core.c:361:6: warning: symbol 'blk_drain_queue' was not
declared. Should it be static?

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 block/blk-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a8b1527..5db63eb 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -358,7 +358,7 @@ EXPORT_SYMBOL(blk_put_queue);
  * If not, only ELVPRIV requests are drained.  The caller is responsible
  * for ensuring that no new requests which need to be drained are queued.
  */
-void blk_drain_queue(struct request_queue *q, bool drain_all)
+static void blk_drain_queue(struct request_queue *q, bool drain_all)
 {
 	int i;
 
-- 
1.7.4.1

