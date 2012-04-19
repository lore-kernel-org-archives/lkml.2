Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab2DSOcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 10:32:09 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:37837 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab2DSOcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 10:32:07 -0400
From: Sasikantha babu <sasikanth.v19@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasikantha babu <sasikanth.v19@gmail.com>
Subject: [PATCH] fs: eventfd - Removed redundant initialization of res in BLOCKing mode
Date: Thu, 19 Apr 2012 20:04:24 +0530
Message-Id: <1334846064-11994-1-git-send-email-sasikanth.v19@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant initialization of res to 0, since eventfd_write in 
blocking mode guarantees res to be either sizeof(ucnt) or -ERESTARTSYS.

Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
---
 fs/eventfd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index dba15fe..6bd051c 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -261,7 +261,7 @@ static ssize_t eventfd_write(struct file *file, const char __user *buf, size_t c
 		res = sizeof(ucnt);
 	else if (!(file->f_flags & O_NONBLOCK)) {
 		__add_wait_queue(&ctx->wqh, &wait);
-		for (res = 0;;) {
+		for (;;) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			if (ULLONG_MAX - ctx->count > ucnt) {
 				res = sizeof(ucnt);
-- 
1.7.3.4

