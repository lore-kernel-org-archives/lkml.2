Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab0JSOrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 10:47:12 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:48863 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab0JSOrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 10:47:11 -0400
/m: 
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com,
        user-mode-linux-devel@lists.sourceforge.net,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] hostfs: trivial code cleanup
Date: Tue, 19 Oct 2010 16:47:01 +0200
Message-Id: <1287499621-28447-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some trivial code cleanups for hostfs.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/hostfs/hostfs_user.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/hostfs/hostfs_user.c b/fs/hostfs/hostfs_user.c
index 6777aa0..68ead6f 100644
--- a/fs/hostfs/hostfs_user.c
+++ b/fs/hostfs/hostfs_user.c
@@ -94,8 +94,7 @@ void *open_dir(char *path, int *err_out)
 
 	dir = opendir(path);
 	*err_out = errno;
-	if (dir == NULL)
-		return NULL;
+
 	return dir;
 }
 
@@ -205,7 +204,7 @@ int set_attr(const char *file, struct hostfs_iattr *attrs, int fd)
 	if (attrs->ia_valid & HOSTFS_ATTR_MODE) {
 		if (fd >= 0) {
 			if (fchmod(fd, attrs->ia_mode) != 0)
-				return (-errno);
+				return -errno;
 		} else if (chmod(file, attrs->ia_mode) != 0) {
 			return -errno;
 		}
-- 
1.6.6.1

