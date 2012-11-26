Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab2KZSRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:17:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47122 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185Ab2KZRBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:01:32 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tao Ma <boyu.mt@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 028/270] ext4: remove erroneous ext4_superblock_csum_set() in update_backups()
Date: Mon, 26 Nov 2012 14:55:18 -0200
Message-Id: <1353949160-26803-29-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Ma <boyu.mt@taobao.com>

commit bef53b01faeb791e27605cba1a71ba21364cb23e upstream.

The update_backups() function is used to backup all the metadata
blocks, so we should not take it for granted that 'data' is pointed to
a super block and use ext4_superblock_csum_set to calculate the
checksum there.  In case where the data is a group descriptor block,
it will corrupt the last group descriptor, and then e2fsck will
complain about it it.

As all the metadata checksums should already be OK when we do the
backup, remove the wrong ext4_superblock_csum_set and it should be
just fine.

Reported-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/ext4/resize.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index b0bdd10..dc1affc 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -979,8 +979,6 @@ static void update_backups(struct super_block *sb,
 		goto exit_err;
 	}
 
-	ext4_superblock_csum_set(sb, (struct ext4_super_block *)data);
-
 	while ((group = ext4_list_backups(sb, &three, &five, &seven)) < last) {
 		struct buffer_head *bh;
 
-- 
1.7.9.5

