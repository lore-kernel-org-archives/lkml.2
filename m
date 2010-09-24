Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870Ab0IXQeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:34:46 -0400
Received: from kroah.org ([198.145.64.141]:38434 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932703Ab0IXQ2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:39 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:19 2010
Message-Id: <20100924162619.388361452@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Paris <eparis@redhat.com>, Ben Hutchings <ben@decadent.org.uk>
Subject: [52/80] inotify: send IN_UNMOUNT events
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Paris <eparis@redhat.com>

commit 611da04f7a31b2208e838be55a42c7a1310ae321 upstream.

Since the .31 or so notify rewrite inotify has not sent events about
inodes which are unmounted.  This patch restores those events.

Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/notify/inotify/inotify_user.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -96,8 +96,11 @@ static inline __u32 inotify_arg_to_mask(
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


