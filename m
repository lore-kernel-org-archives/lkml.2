Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab2KSLKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 06:10:24 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54598 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab2KSLKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 06:10:22 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: eparis@redhat.com, patches@linaro.org
Subject: [PATCH] fsnotify: Fix sparse warning
Date: Mon, 19 Nov 2012 16:34:15 +0530
Message-Id: <1353323055-4197-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes following sparse warning.
fs/notify/inode_mark.c:127:22: warning: symbol
'fsnotify_find_inode_mark_locked' was not declared. Should it be static?

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 fs/notify/inode_mark.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 2123020..f31e90f 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -124,8 +124,9 @@ void fsnotify_clear_inode_marks_by_group(struct fsnotify_group *group)
  * given a group and inode, find the mark associated with that combination.
  * if found take a reference to that mark and return it, else return NULL
  */
-struct fsnotify_mark *fsnotify_find_inode_mark_locked(struct fsnotify_group *group,
-						      struct inode *inode)
+static struct fsnotify_mark *fsnotify_find_inode_mark_locked(
+		struct fsnotify_group *group,
+		struct inode *inode)
 {
 	struct fsnotify_mark *mark;
 	struct hlist_node *pos;
-- 
1.7.4.1

