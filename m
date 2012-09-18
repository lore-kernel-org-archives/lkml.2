Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab2IRXhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 19:37:23 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:45964 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2IRXhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 19:37:14 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 3/6] dyndbg: add more info to -E2BIG log warning
Date: Tue, 18 Sep 2012 17:36:44 -0600
Message-Id: <1348011407-24108-4-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348011407-24108-1-git-send-email-jim.cromie@gmail.com>
References: <1348011407-24108-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tell user how big the attempted write was, in case its not obvious.
This helped identify a missing flush in my stress-test script.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 43ae319..85258a8 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -693,7 +693,8 @@ static ssize_t ddebug_proc_write(struct file *file, const char __user *ubuf,
 	if (len == 0)
 		return 0;
 	if (len > USER_BUF_PAGE - 1) {
-		pr_warn("expected <%d bytes into control\n", USER_BUF_PAGE);
+		pr_warn("expected <%d bytes into control, you wrote %d\n",
+			USER_BUF_PAGE, (int) len);
 		return -E2BIG;
 	}
 	tmpbuf = kmalloc(len + 1, GFP_KERNEL);
-- 
1.7.11.4

