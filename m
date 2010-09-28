Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab0I1OAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 10:00:05 -0400
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:59166 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753527Ab0I1OAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 10:00:04 -0400
Subject: [Patch] fsnotify: remove alignment padding from fsnotify_mark on
 64 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Eric Paris <eparis@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 15:00:02 +0100
Message-ID: <1285682402.1878.11.camel@castor.rsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder struct fsnotfiy_mark to remove 8 bytes of alignment padding on
64 bit builds.
Shrinks fsnotfiy_mark to 128 bytes allowing more objects per slab in its
kmem_cache and reduces the number of cachelines needed for each
structure.
    
Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
----

Hi Eric,
patch against 2.6.36-rc5
compiled & booted on x86_64.

I'm not sure how to test this, but it boots and I think it's safe to
make this change.

regards
Richard



diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index e40190d..369bed5 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -275,8 +275,8 @@ struct fsnotify_mark {
 		struct fsnotify_inode_mark i;
 		struct fsnotify_vfsmount_mark m;
 	};
-	__u32 ignored_mask;		/* events types to ignore */
 	struct list_head free_g_list;	/* tmp list used when freeing this mark */
+	__u32 ignored_mask;		/* events types to ignore */
 #define FSNOTIFY_MARK_FLAG_INODE		0x01
 #define FSNOTIFY_MARK_FLAG_VFSMOUNT		0x02
 #define FSNOTIFY_MARK_FLAG_OBJECT_PINNED	0x04


