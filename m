Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab2B1JJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 04:09:44 -0500
Received: from mail.windriver.com ([147.11.1.11]:51339 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932573Ab2B1JJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 04:09:41 -0500
From: Zhengwang Ruan <ruan.zhengwang@gmail.com>
To: <rostedt@goodmis.org>, <fweisbec@gmail.com>, <mingo@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH] Trace: initialize variable to clear warning
Date: Tue, 28 Feb 2012 17:09:34 +0800
Message-ID: <1330420174-20537-1-git-send-email-ruan.zhengwang@gmail.com>
X-Mailer: git-send-email 1.7.0.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GCC warns that 'page2' is used without being initialized previously before
being used, this is to clear it.

Signed-off-by: Zhengwang Ruan <ruan.zhengwang@gmail.com>
---
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a3f1bc5..47376ba 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3694,7 +3694,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	int nr_pages = 1;
 	ssize_t written;
 	void *page1;
-	void *page2;
+	void *uninitialized_var(page2);
 	int offset;
 	int size;
 	int len;
-- 
1.6.0.4

