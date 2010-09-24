Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203Ab0IXQi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:38:28 -0400
Received: from kroah.org ([198.145.64.141]:37434 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933131Ab0IXQfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:35:53 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:49 2010
Message-Id: <20100924163349.173812964@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:32:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Paris <eparis@redhat.com>
Subject: [58/68] [PATCH] inotify: fix inotify oneshot support
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit ff311008ab8d2f2cfdbbefd407d1b05acc8164b2 upstream.

During the large inotify rewrite to fsnotify I completely dropped support
for IN_ONESHOT.  Reimplement that support.

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/notify/inotify/inotify_fsnotify.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -72,6 +72,9 @@ static int inotify_handle_event(struct f
 			ret = 0;
 	}
 
+	if (entry->mask & IN_ONESHOT)
+		fsnotify_destroy_mark_by_entry(entry);
+
 	/*
 	 * If we hold the entry until after the event is on the queue
 	 * IN_IGNORED won't be able to pass this event in the queue


