Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab0EYPrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 11:47:18 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:36461 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab0EYPrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 11:47:17 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@suse.de>,
       Tejun Heo <tj@kernel.org>, Scott James Remnant <scott@ubuntu.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Harald Hoyer <harald@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>, agk@redhat.com,
       snitzer@redhat.com, Will Drewry <wad@chromium.org>
Subject: [PATCH 1/2] init: make the path argument a const in name_to_dev_t
Date: Tue, 25 May 2010 10:46:50 -0500
Message-Id: <1274802411-26613-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

name_to_dev_t takes a char * argument which it never modifies.  This
change converts it to a const char *.

(This is useful with the second patch in the series which exports the
symbol.  External consumers of the function will now be able to pass in
a const char * without duping or casting away const-ness.)

Signed-off-by: Will Drewry <wad@chromium.org>
---
 include/linux/mount.h |    2 +-
 init/do_mounts.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mount.h b/include/linux/mount.h
index 4bd0547..ad819a0 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -134,6 +134,6 @@ extern int do_add_mount(struct vfsmount *newmnt, struct path *path,
 
 extern void mark_mounts_for_expiry(struct list_head *mounts);
 
-extern dev_t name_to_dev_t(char *name);
+extern dev_t name_to_dev_t(const char *name);
 
 #endif /* _LINUX_MOUNT_H */
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 0848a5b..a322b13 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -75,7 +75,7 @@ __setup("rw", readwrite);
  *	bangs.
  */
 
-dev_t name_to_dev_t(char *name)
+dev_t name_to_dev_t(const char *name)
 {
 	char s[32];
 	char *p;
-- 
1.7.0.4

