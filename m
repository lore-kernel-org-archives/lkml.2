Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab2ICDag (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 23:30:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49291 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab2ICDaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 23:30:35 -0400
From: Prasad Joshi <prasadjoshi.linux@gmail.com>
To: prasadjoshi.linux@gmail.com
Cc: ebiederm@xmission.com, akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        lucas.demarchi@profusion.mobi, linux-kernel@vger.kernel.org
Subject: [PATCH] sysctl: Use BUG_ON instead of BUG
Date: Mon,  3 Sep 2012 09:00:25 +0530
Message-Id: <1346643025-2769-1-git-send-email-prasadjoshi.linux@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of if (!head) BUG(); can be replaced with single line
BUG_ON(!head).

Signed-off-by: Prasad Joshi <prasadjoshi.linux@gmail.com>
---
 fs/proc/proc_sysctl.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index dfafeb2..63bdfa0 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -266,8 +266,7 @@ void sysctl_head_put(struct ctl_table_header *head)
 
 static struct ctl_table_header *sysctl_head_grab(struct ctl_table_header *head)
 {
-	if (!head)
-		BUG();
+	BUG_ON(!head);
 	spin_lock(&sysctl_lock);
 	if (!use_table(head))
 		head = ERR_PTR(-ENOENT);
-- 
1.7.5.4

