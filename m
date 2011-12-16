Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741Ab1LPHPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 02:15:48 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62145 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab1LPHPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 02:15:47 -0500
From: Devendra Naga <devendra.aaru@gmail.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 1/1] Fix Compilation Warning in kernel/trace/trace.c
Date: Fri, 16 Dec 2011 02:15:24 -0500
Message-Id: <1324019724-3422-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

there was a compilation warning saying
kernel/trace/trace.c:3644:8: warning: ‘page2’ may be used uninitialized in this function

The page2 pointer is used only when nr_pages = 2.

Assigned a null value to the page2 to get rid of warning.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f2bd275..80dfd92 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3641,7 +3641,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	int nr_pages = 1;
 	ssize_t written;
 	void *page1;
-	void *page2;
+	void *page2 = NULL;
 	int offset;
 	int size;
 	int len;
-- 
1.7.4.1

