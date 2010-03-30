Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab0C3XMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:12:12 -0400
Received: from kroah.org ([198.145.64.141]:48829 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756363Ab0C3XMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:08 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:19 2010
Message-Id: <20100330225819.376291909@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Paris <eparis@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [18/89] inotify: only warn once for inotify problems
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Paris <eparis@redhat.com>

commit 976ae32be45a736acd49215a7e4771ff91f161c3 upstream.

inotify will WARN() if it finds that the idr and the fsnotify internals
somehow got out of sync.  It was only supposed to do this once but due
to this stupid bug it would warn every single time a problem was
detected.

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/notify/inotify/inotify_fsnotify.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -121,7 +121,7 @@ static int idr_callback(int id, void *p,
 	if (warned)
 		return 0;
 
-	warned = false;
+	warned = true;
 	entry = p;
 	ientry = container_of(entry, struct inotify_inode_mark_entry, fsn_entry);
 


