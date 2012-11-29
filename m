Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab2K2G3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:29:04 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49430 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab2K2G3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:29:01 -0500
From: Abhijit Pawar <abhi.c.pawar@gmail.com>
To: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Abhijit Pawar <abhi.c.pawar@gmail.com>
Subject: [PATCH 4/6] fs:btrfs pass NULL as second parameter for set_anon_super
Date: Thu, 29 Nov 2012 11:58:41 +0530
Message-Id: <1354170521-12096-1-git-send-email-abhi.c.pawar@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_anon_super does not use the second parameter in its implementation.
So there is no need to pass on the second parameter. 

Signed-off-by: Abhijit Pawar <abhi.c.pawar@gmail.com>
---
 fs/btrfs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 915ac14..c9994a3 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -954,7 +954,7 @@ static int btrfs_test_super(struct super_block *s, void *data)
 
 static int btrfs_set_super(struct super_block *s, void *data)
 {
-	int err = set_anon_super(s, data);
+	int err = set_anon_super(s, NULL);
 	if (!err)
 		s->s_fs_info = data;
 	return err;
-- 
1.7.7.6

