Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab1ABIKx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:10:53 -0500
Received: from mail.windriver.com ([147.11.1.11]:34314 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab1ABHVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:21:53 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 009/260] ext4: fix quota accounting in case of fallocate
Date: Sun,  2 Jan 2011 02:15:05 -0500
Message-Id: <1293952756-15010-10-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:16.0381 (UTC) FILETIME=[81025AD0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit 35121c9860316d7799cea0fbc359a9186e7c2747 upstream.

allocated_meta_data is already included in 'used' variable.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/inode.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 81d6054..55bfcd9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1126,7 +1126,8 @@ void ext4_da_update_reserve_space(struct inode *inode,
 		 */
 		if (allocated_meta_blocks)
 			dquot_claim_block(inode, allocated_meta_blocks);
-		dquot_release_reservation_block(inode, mdb_free + used);
+		dquot_release_reservation_block(inode, mdb_free + used -
+						allocated_meta_blocks);
 	}
 
 	/*
-- 
1.7.3.3

