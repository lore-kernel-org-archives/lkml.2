Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab2EBVC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 17:02:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47123 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab2EBVCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 17:02:25 -0400
From: Sasikantha babu <sasikanth.v19@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Sasikantha babu <sasikanth.v19@gmail.com>
Subject: [PATCH v3] sysfs: Removed dup_name entirely in sysfs_rename
Date: Thu,  3 May 2012 02:26:14 +0530
Message-Id: <1335992174-4880-1-git-send-email-sasikanth.v19@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since no one using "dup_name", removed it completely in sysfs_rename.

Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
---
 fs/sysfs/dir.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 35a36d3..24fa995 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -858,7 +858,6 @@ int sysfs_rename(struct sysfs_dirent *sd,
 	struct sysfs_dirent *new_parent_sd, const void *new_ns,
 	const char *new_name)
 {
-	const char *dup_name = NULL;
 	int error;
 
 	mutex_lock(&sysfs_mutex);
@@ -875,11 +874,11 @@ int sysfs_rename(struct sysfs_dirent *sd,
 	/* rename sysfs_dirent */
 	if (strcmp(sd->s_name, new_name) != 0) {
 		error = -ENOMEM;
-		new_name = dup_name = kstrdup(new_name, GFP_KERNEL);
+		new_name = kstrdup(new_name, GFP_KERNEL);
 		if (!new_name)
 			goto out;
 
-		dup_name = sd->s_name;
+		kfree(sd->s_name);
 		sd->s_name = new_name;
 	}
 
@@ -895,7 +894,6 @@ int sysfs_rename(struct sysfs_dirent *sd,
 	error = 0;
  out:
 	mutex_unlock(&sysfs_mutex);
-	kfree(dup_name);
 	return error;
 }
 
-- 
1.7.3.4

