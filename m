Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab1IWWT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 18:19:56 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:23027 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab1IWWTz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 18:19:55 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-127.messagelabs.com!1316816391!32614386!7
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ext4/ialloc.c: functions should not be declared extern
Date: Fri, 23 Sep 2011 15:19:45 -0700
User-Agent: KMail/1.9.9
CC: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <201109231519.45350.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function declaration in ext4.h is already marked extern.  The function
definition should not have the tag.

This quiets the sparse noise:

warning: function 'ext4_init_inode_table' with external linkage has definition

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>

---

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index fd96ea1..ef9bdd6 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1235,7 +1235,7 @@ unsigned long ext4_count_dirs(struct super_block * sb)
  * inode allocation from the current group, so we take alloc_sem lock, to
  * block ext4_claim_inode until we are finished.
  */
-extern int ext4_init_inode_table(struct super_block *sb, ext4_group_t group,
+int ext4_init_inode_table(struct super_block *sb, ext4_group_t group,
 				 int barrier)
 {
 	struct ext4_group_info *grp = ext4_get_group_info(sb, group);
