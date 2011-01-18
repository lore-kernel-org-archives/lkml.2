Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab1ARVRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 16:17:35 -0500
Received: from mail132.messagelabs.com ([216.82.242.115]:6611 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab1ARVRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 16:17:34 -0500
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-132.messagelabs.com!1295385434!11033037!34
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.97]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs/notify/notification.c: make subsys_initcall static
Date: Tue, 18 Jan 2011 14:17:08 -0700
User-Agent: KMail/1.9.9
CC: <eparis@redhat.com>, <agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201101181417.08751.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol fsnotify_notification_init is a subsys_initcall and can be declared
static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Andreas Gruenbacher <agruen@suse.de>

---

diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index f39260f..85ae08f 100644
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
