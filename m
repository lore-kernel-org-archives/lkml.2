Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab1ABHrm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:47:42 -0500
Received: from mail.windriver.com ([147.11.1.11]:36152 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab1ABHYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:11 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Eric Paris <eparis@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 154/260] inotify: fix inotify oneshot support
Date: Sun,  2 Jan 2011 02:17:30 -0500
Message-Id: <1293952756-15010-155-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:59.0244 (UTC) FILETIME=[E21546C0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

commit ff311008ab8d2f2cfdbbefd407d1b05acc8164b2 upstream.

During the large inotify rewrite to fsnotify I completely dropped support
for IN_ONESHOT.  Reimplement that support.

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/notify/inotify/inotify_fsnotify.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index e27960c..5d3d2a7 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -72,6 +72,9 @@ static int inotify_handle_event(struct fsnotify_group *group, struct fsnotify_ev
 			ret = 0;
 	}
 
+	if (entry->mask & IN_ONESHOT)
+		fsnotify_destroy_mark_by_entry(entry);
+
 	/*
 	 * If we hold the entry until after the event is on the queue
 	 * IN_IGNORED won't be able to pass this event in the queue
-- 
1.7.3.3

