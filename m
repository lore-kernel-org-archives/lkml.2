Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab1EUACv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 20:02:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:60834 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757403Ab1EUACN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 20:02:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,244,1304319600"; 
   d="scan'208";a="1807303"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, airlied@linux.ie,
        Andi Kleen <ak@linux.intel.com>, viro@zeniv.linux.org.uk,
        fweisbec@gmail.com
Subject: [PATCH 12/12] REISERFS: reiserfs drop unnecessary inlines
Date: Fri, 20 May 2011 17:01:22 -0700
Message-Id: <1305936082-21304-12-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305936082-21304-1-git-send-email-andi@firstfloor.org>
References: <1305936082-21304-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Drop some inlines to shrink code size with force inline

Still some unfixed growth in:

balance_leaf                                7190    8766   +1576
search_by_key                               1963    3317   +1354

Cc: viro@zeniv.linux.org.uk
Cc: fweisbec@gmail.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/reiserfs/do_balan.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/reiserfs/do_balan.c b/fs/reiserfs/do_balan.c
index 60c0804..8b3c44c 100644
--- a/fs/reiserfs/do_balan.c
+++ b/fs/reiserfs/do_balan.c
@@ -21,7 +21,7 @@
 #include <linux/buffer_head.h>
 #include <linux/kernel.h>
 
-static inline void buffer_info_init_left(struct tree_balance *tb,
+static void buffer_info_init_left(struct tree_balance *tb,
                                          struct buffer_info *bi)
 {
 	bi->tb          = tb;
@@ -30,7 +30,7 @@ static inline void buffer_info_init_left(struct tree_balance *tb,
 	bi->bi_position = get_left_neighbor_position(tb, 0);
 }
 
-static inline void buffer_info_init_right(struct tree_balance *tb,
+static void buffer_info_init_right(struct tree_balance *tb,
                                           struct buffer_info *bi)
 {
 	bi->tb          = tb;
@@ -39,7 +39,7 @@ static inline void buffer_info_init_right(struct tree_balance *tb,
 	bi->bi_position = get_right_neighbor_position(tb, 0);
 }
 
-static inline void buffer_info_init_tbS0(struct tree_balance *tb,
+static void buffer_info_init_tbS0(struct tree_balance *tb,
                                          struct buffer_info *bi)
 {
 	bi->tb          = tb;
@@ -48,7 +48,7 @@ static inline void buffer_info_init_tbS0(struct tree_balance *tb,
 	bi->bi_position = PATH_H_POSITION(tb->tb_path, 1);
 }
 
-static inline void buffer_info_init_bh(struct tree_balance *tb,
+static void buffer_info_init_bh(struct tree_balance *tb,
                                        struct buffer_info *bi,
                                        struct buffer_head *bh)
 {
@@ -58,7 +58,7 @@ static inline void buffer_info_init_bh(struct tree_balance *tb,
 	bi->bi_position = 0;
 }
 
-inline void do_balance_mark_leaf_dirty(struct tree_balance *tb,
+void do_balance_mark_leaf_dirty(struct tree_balance *tb,
 				       struct buffer_head *bh, int flag)
 {
 	journal_mark_dirty(tb->transaction_handle,
@@ -1967,7 +1967,7 @@ static void check_internal_levels(struct tree_balance *tb)
 
 */
 
-static inline void do_balance_starts(struct tree_balance *tb)
+static void do_balance_starts(struct tree_balance *tb)
 {
 	/* use print_cur_tb() to see initial state of struct
 	   tree_balance */
@@ -1983,7 +1983,7 @@ static inline void do_balance_starts(struct tree_balance *tb)
 #endif
 }
 
-static inline void do_balance_completed(struct tree_balance *tb)
+static void do_balance_completed(struct tree_balance *tb)
 {
 
 #ifdef CONFIG_REISERFS_CHECK
-- 
1.7.4.4

