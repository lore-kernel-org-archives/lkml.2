Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445Ab2K2GgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:36:12 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64404 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2K2GgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:36:11 -0500
From: Abhijit Pawar <abhi.c.pawar@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Abhijit Pawar <abhi.c.pawar@gmail.com>
Subject: [PATCH 6/6] fs:sysfs pass NULL as second parameter for set_anon_super
Date: Thu, 29 Nov 2012 12:05:45 +0530
Message-Id: <1354170945-12211-1-git-send-email-abhi.c.pawar@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_anon_super does not use the second parameter in its implementation.
So there is no need to pass on the second parameter.

Signed-off-by: Abhijit Pawar <abhi.c.pawar@gmail.com>
---
 fs/sysfs/mount.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index db940a9..3e3f7ea 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -89,7 +89,7 @@ static int sysfs_test_super(struct super_block *sb, void *data)
 static int sysfs_set_super(struct super_block *sb, void *data)
 {
 	int error;
-	error = set_anon_super(sb, data);
+	error = set_anon_super(sb, NULL);
 	if (!error)
 		sb->s_fs_info = data;
 	return error;
-- 
1.7.7.6

