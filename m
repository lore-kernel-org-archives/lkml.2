Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab1EXNdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:33:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39052 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371Ab1EXNdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:33:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=mmVVvQ5qCbqICINOdB0TnYYzKlLYIBoFHoqQCYienqjdWfc9rCVXf8XcP6X47kSMbW
         WBtWmJe1Q6hA+VU++W9jMA1PhzPj/DcApODP5cDkLGf7Bknn4cOSsRcdzfsEfVLVeP9H
         CmMXNzjWwTiWzPnuvTdWhXzox10kQ/18hTfrg=
Date: Tue, 24 May 2011 15:33:16 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>, John McCutchan <john@johnmccutchan.com>
Subject: [PATCH] inotify_ignored_and_remove_idr: remove unsued variable
Message-ID: <20110524133316.GA11623@nb-core2.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The funtion returns void, no need to track the return value (this is leftover
from f70ab54c).

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
Cc: Eric Paris <eparis@redhat.com>
---
 fs/notify/inotify/inotify_user.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 8445fbc..9d1b993 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -517,7 +517,6 @@ void inotify_ignored_and_remove_idr(struct fsnotify_mark *fsn_mark,
 	struct fsnotify_event *ignored_event, *notify_event;
 	struct inotify_event_private_data *event_priv;
 	struct fsnotify_event_private_data *fsn_event_priv;
-	int ret;
 
 	ignored_event = fsnotify_create_event(NULL, FS_IN_IGNORED, NULL,
 					      FSNOTIFY_EVENT_NONE, NULL, 0,
@@ -538,9 +537,7 @@ void inotify_ignored_and_remove_idr(struct fsnotify_mark *fsn_mark,
 
 	notify_event = fsnotify_add_notify_event(group, ignored_event, fsn_event_priv, NULL);
 	if (notify_event) {
-		if (IS_ERR(notify_event))
-			ret = PTR_ERR(notify_event);
-		else
+		if (!IS_ERR(notify_event))
 			fsnotify_put_event(notify_event);
 		inotify_free_event_priv(fsn_event_priv);
 	}
-- 
1.7.5.1
