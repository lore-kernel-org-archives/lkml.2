Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761615Ab0J1VeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:34:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934192Ab0J1Vdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:33:35 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 20/20] fsnotify: remove alignment padding from fsnotify_mark
	on 64 bit builds
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de, tvrtko.ursulin@sophos.com
Date: Thu, 28 Oct 2010 17:33:31 -0400
Message-ID: <20101028213331.24810.75808.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
References: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Kennedy <richard@rsk.demon.co.uk>

Reorder struct fsnotfiy_mark to remove 8 bytes of alignment padding on 64
bit builds.  Shrinks fsnotfiy_mark to 128 bytes allowing more objects per
slab in its kmem_cache and reduces the number of cachelines needed for
each structure.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/fsnotify_backend.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index b36041e..0a68f92 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -287,8 +287,8 @@ struct fsnotify_mark {
 		struct fsnotify_inode_mark i;
 		struct fsnotify_vfsmount_mark m;
 	};
-	__u32 ignored_mask;		/* events types to ignore */
 	struct list_head free_g_list;	/* tmp list used when freeing this mark */
+	__u32 ignored_mask;		/* events types to ignore */
 #define FSNOTIFY_MARK_FLAG_INODE		0x01
 #define FSNOTIFY_MARK_FLAG_VFSMOUNT		0x02
 #define FSNOTIFY_MARK_FLAG_OBJECT_PINNED	0x04

