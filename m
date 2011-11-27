Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab1K0SGm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 13:06:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932Ab1K0SEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 13:04:45 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/9] trace: Fix uninitialized variable compiler warning
Date: Sun, 27 Nov 2011 19:04:26 +0100
Message-Id: <1322417074-5834-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize page2 variable to make compiler happy.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9e158cc..4a06862 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3655,8 +3655,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	struct page *pages[2];
 	int nr_pages = 1;
 	ssize_t written;
-	void *page1;
-	void *page2;
+	void *page1, *page2 = NULL;
 	int offset;
 	int size;
 	int len;
-- 
1.7.1

