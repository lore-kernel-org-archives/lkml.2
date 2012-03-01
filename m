Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265Ab2CAClZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 21:41:25 -0500
Received: from mail1.windriver.com ([147.11.146.13]:32869 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758192Ab2CAClY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 21:41:24 -0500
From: Zhengwang Ruan <ruan.zhengwang@gmail.com>
To: <rostedt@goodmis.org>, <fweisbec@gmail.com>, <mingo@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH v2] Trace: Add comment to notify a warning caused by a gcc bug
Date: Thu, 1 Mar 2012 10:41:17 +0800
Message-ID: <1330569677-11984-1-git-send-email-ruan.zhengwang@gmail.com>
X-Mailer: git-send-email 1.7.0.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GCC (version < 4.6) warns 'page2' is uninitialized, but this is helpful
to track a real potential bug, simply add comment to note this.

Signed-off-by: Zhengwang Ruan <ruan.zhengwang@gmail.com>
---
v2: Change fix to add a comment.
---
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a3f1bc5..ef332e6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3694,7 +3694,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	int nr_pages = 1;
 	ssize_t written;
 	void *page1;
-	void *page2;
+	void *page2;	/* if you get a warning here, upgrade your gcc to 4.6 */
 	int offset;
 	int size;
 	int len;
-- 
1.6.0.4

