Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab1JMXK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 19:10:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:49036 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755879Ab1JMXI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 19:08:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,343,1315206000"; 
   d="scan'208";a="62400429"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>, viro@zeniv.linux.org.uk,
        fweisbec@gmail.com
Subject: [PATCH 10/12] REISERFS: reiserfs drop unnecessary inlines
Date: Thu, 13 Oct 2011 16:08:50 -0700
Message-Id: <1318547332-23155-10-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1318547332-23155-1-git-send-email-andi@firstfloor.org>
References: <1318547332-23155-1-git-send-email-andi@firstfloor.org>
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

