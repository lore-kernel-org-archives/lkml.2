Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab2HQCiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:38:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58365 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721Ab2HQCh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:37:28 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 2/2] dyndbg: add more info to -E2BIG log warning
Date: Thu, 16 Aug 2012 20:37:23 -0600
Message-Id: <1345171043-14859-3-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.10.1.487.ga3935e6
In-Reply-To: <1345171043-14859-1-git-send-email-jim.cromie@gmail.com>
References: <1345171043-14859-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ddebug_proc_write() warns if the written buffer is >4096 bytes.
Might as well tell user how much was attempted, in case its not obvious.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 86d4065..0983f60 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -643,7 +643,8 @@ static ssize_t ddebug_proc_write(struct file *file, const char __user *ubuf,
 	if (len == 0)
 		return 0;
 	if (len > USER_BUF_PAGE - 1) {
-		pr_warn("expected <%d bytes into control\n", USER_BUF_PAGE);
+		pr_warn("expected <%d bytes into control, you wrote %d\n",
+			USER_BUF_PAGE, len);
 		return -E2BIG;
 	}
 	tmpbuf = kmalloc(len + 1, GFP_KERNEL);
-- 
1.7.10.1.487.ga3935e6

