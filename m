Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595Ab0GHU6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:58:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758179Ab0GHU6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:58:18 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/2] inotify: send IN_UNMOUNT events
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk
Date: Thu, 08 Jul 2010 16:58:17 -0400
Message-ID: <20100708205817.21351.80159.stgit@paris.rdu.redhat.com>
In-Reply-To: <20100708205811.21351.60266.stgit@paris.rdu.redhat.com>
References: <20100708205811.21351.60266.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the .31 or so notify rewrite inotify has not sent events about
inodes which are unmounted.  This patch restores those events.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/inotify/inotify_user.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 44aeb0f..f381daf 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -90,8 +90,11 @@ static inline __u32 inotify_arg_to_mask(u32 arg)
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

