Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab2CUSpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 14:45:34 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:20492 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab2CUSpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 14:45:33 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-160.messagelabs.com!1332355496!1803590!52
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs/notify/notification.c: make subsys_initcall function static
Date: Wed, 21 Mar 2012 11:45:17 -0700
User-Agent: KMail/1.9.9
CC: <akpm@linux-foundation.org>, <eric.dumazet@gmail.com>, <vapier@gentoo.org>,
        <asharma@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201203211145.17416.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

subsys_initcall functions should be marked static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Arun Sharma <asharma@fb.com>

---

diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index ee18815..c887b13 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -447,7 +447,7 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
 	return event;
 }
 
-__init int fsnotify_notification_init(void)
+static __init int fsnotify_notification_init(void)
 {
 	fsnotify_event_cachep = KMEM_CACHE(fsnotify_event, SLAB_PANIC);
 	fsnotify_event_holder_cachep = KMEM_CACHE(fsnotify_event_holder, SLAB_PANIC);
@@ -461,4 +461,3 @@ __init int fsnotify_notification_init(void)
 	return 0;
 }
 subsys_initcall(fsnotify_notification_init);
-

