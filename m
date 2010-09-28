Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338Ab0I1I1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 04:27:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55810 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758511Ab0I1I1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 04:27:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wlNybI0MEbgtOcUg6laIztlfwv8bjYG1EpmRdeN2Z361IjG8kUto++EgCQHaeK+8/o
         Ves6YD1NqAozKD0+p+98yx/HaggCJfQtGEi+FGFDRmusiwNsaYgrRzxp2HaZ7yWGD8V2
         +nt2bLRtTw6uO4iNf601hfcSqtyaUcIJpttZQ=
From: Namhyung Kim <namhyung@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] vfs: remove a warning on OPEN_FMODE()
Date: Tue, 28 Sep 2010 17:27:00 +0900
Message-Id: <1285662421-17095-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AND-ing FMODE_* constant with normal integer results in following
sparse warnings. Fix it.

 fs/open.c:662:21: warning: restricted fmode_t degrades to integer
 fs/anon_inodes.c:123:34: warning: restricted fmode_t degrades to integer

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 include/linux/fs.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 63d069b..e60f9b1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2477,9 +2477,11 @@ int proc_nr_files(struct ctl_table *table, int write,
 
 int __init get_filesystem_list(char *buf);
 
+#define __FMODE_NONOTIFY	((__force int) FMODE_NONOTIFY)
+
 #define ACC_MODE(x) ("\004\002\006\006"[(x)&O_ACCMODE])
 #define OPEN_FMODE(flag) ((__force fmode_t)(((flag + 1) & O_ACCMODE) | \
-					    (flag & FMODE_NONOTIFY)))
+					    (flag & __FMODE_NONOTIFY)))
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_FS_H */
-- 
1.7.2.2

