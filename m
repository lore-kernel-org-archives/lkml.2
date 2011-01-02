Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab1ABHXy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:23:54 -0500
Received: from mail.windriver.com ([147.11.1.11]:35829 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab1ABHXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:45 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Eric Paris <eparis@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 136/260] inotify: send IN_UNMOUNT events
Date: Sun,  2 Jan 2011 02:17:12 -0500
Message-Id: <1293952756-15010-137-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:38.0884 (UTC) FILETIME=[D5F29640:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

commit 611da04f7a31b2208e838be55a42c7a1310ae321 upstream.

Since the .31 or so notify rewrite inotify has not sent events about
inodes which are unmounted.  This patch restores those events.

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/notify/inotify/inotify_user.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index e46ca68..0c6bbc0 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -96,8 +96,11 @@ static inline __u32 inotify_arg_to_mask(u32 arg)
 {
 	__u32 mask;
 
-	/* everything should accept their own ignored and cares about children */
-	mask = (FS_IN_IGNORED | FS_EVENT_ON_CHILD);
+	/*
+	 * everything should accept their own ignored, cares about children,
+	 * and should receive events when the inode is unmounted
+	 */
+	mask = (FS_IN_IGNORED | FS_EVENT_ON_CHILD | FS_UNMOUNT);
 
 	/* mask off the flags used to open the fd */
 	mask |= (arg & (IN_ALL_EVENTS | IN_ONESHOT));
-- 
1.7.3.3

