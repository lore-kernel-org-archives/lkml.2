Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab0HWAhZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 20:37:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab0HWAhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 20:37:24 -0400
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>, Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/4] fanotify: drop duplicate pr_debug statement
Date: Sun, 22 Aug 2010 20:37:08 -0400
Message-Id: <1282523830-27751-2-git-send-email-eparis@redhat.com>
In-Reply-To: <1282523830-27751-1-git-send-email-eparis@redhat.com>
References: <1282523830-27751-1-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>

This reminded me... you have two pr_debugs in fanotify_should_send_event
which output redundant information. Maybe you intended it like that so
it is selectable how much log spam you want, or if not you may want to
apply this patch.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
---
 fs/notify/fanotify/fanotify.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 756566f..85366c7 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -165,9 +165,6 @@ static bool fanotify_should_send_event(struct fsnotify_group *group,
 		 "mask=%x data=%p data_type=%d\n", __func__, group, to_tell,
 		 inode_mark, vfsmnt_mark, event_mask, data, data_type);
 
-	pr_debug("%s: group=%p vfsmount_mark=%p inode_mark=%p mask=%x\n",
-		 __func__, group, vfsmnt_mark, inode_mark, event_mask);
-
 	/* sorry, fanotify only gives a damn about files and dirs */
 	if (!S_ISREG(to_tell->i_mode) &&
 	    !S_ISDIR(to_tell->i_mode))
-- 
1.6.5.3

