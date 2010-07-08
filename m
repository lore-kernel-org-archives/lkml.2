Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab0GHU6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:58:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614Ab0GHU6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:58:13 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/2] inotify: fix inotify oneshot support
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk
Date: Thu, 08 Jul 2010 16:58:11 -0400
Message-ID: <20100708205811.21351.60266.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the large inotify rewrite to fsnotify I completely dropped support
for IN_ONESHOT.  Reimplement that support.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/inotify/inotify_fsnotify.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index daa666a..388a150 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -126,6 +126,9 @@ static int inotify_handle_event(struct fsnotify_group *group, struct fsnotify_ev
 			ret = 0;
 	}
 
+	if (fsn_mark->mask & IN_ONESHOT)
+		fsnotify_destroy_mark(fsn_mark);
+
 	/*
 	 * If we hold the fsn_mark until after the event is on the queue
 	 * IN_IGNORED won't be able to pass this event in the queue

