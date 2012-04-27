Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760278Ab2D0O3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 10:29:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59498 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760253Ab2D0O26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 10:28:58 -0400
From: Sasikantha babu <sasikanth.v19@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Sasikantha babu <sasikanth.v19@gmail.com>
Subject: [PATCH] sysfs: Redundant assignment of dup_name in sysfs_rename
Date: Fri, 27 Apr 2012 20:01:02 +0530
Message-Id: <1335537062-7627-1-git-send-email-sasikanth.v19@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is redundant to assign "kstrdup" of "new_value" to "dup_name",
Since we are overwriting "dup_name" with "sd->s_name"

Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
---
 fs/sysfs/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 35a36d3..4abd424 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -875,7 +875,7 @@ int sysfs_rename(struct sysfs_dirent *sd,
 	/* rename sysfs_dirent */
 	if (strcmp(sd->s_name, new_name) != 0) {
 		error = -ENOMEM;
-		new_name = dup_name = kstrdup(new_name, GFP_KERNEL);
+		new_name = kstrdup(new_name, GFP_KERNEL);
 		if (!new_name)
 			goto out;
 
-- 
1.7.3.4

