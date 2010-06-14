Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab0FNU0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 16:26:53 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43718 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab0FNU0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 16:26:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TfAAwmb5L2tlxzexKd3S87YSz1WlFBHOq/m1zyawNrmfqZPLOcvgt71IFGZWWiP+UE
         8p98Jz+bbzlEh2TwNi13Nz1h5HQxgn1gG2YNWzcelbfT0aN3JTiaKO1AfoWURf9EMGY0
         iRqVj3yk914spBVJP44xUlX6OEbY1A2kxHmgM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: reiserfs-devel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
       clemens@ladisch.de, debora@linux.vnet.ibm.com,
       dri-devel@lists.freedesktop.org, linux-i2c@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, linux-media@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 1/8]reiserfs:stree.c Fix variable set but not used.
Date: Mon, 14 Jun 2010 13:26:41 -0700
Message-Id: <1276547208-26569-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if this is correct or not.
the below patch gets rid of this warning message
produced by gcc 4.6.0

fs/reiserfs/stree.c: In function 'search_by_key':
fs/reiserfs/stree.c:602:6: warning: variable 'right_neighbor_of_leaf_node' set but not used

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 fs/reiserfs/stree.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index 313d39d..73086ad 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -599,7 +599,6 @@ int search_by_key(struct super_block *sb, const struct cpu_key *key,	/* Key to s
 	struct buffer_head *bh;
 	struct path_element *last_element;
 	int node_level, retval;
-	int right_neighbor_of_leaf_node;
 	int fs_gen;
 	struct buffer_head *reada_bh[SEARCH_BY_KEY_READA];
 	b_blocknr_t reada_blocks[SEARCH_BY_KEY_READA];
@@ -617,8 +616,7 @@ int search_by_key(struct super_block *sb, const struct cpu_key *key,	/* Key to s
 
 	pathrelse(search_path);
 
-	right_neighbor_of_leaf_node = 0;
-
+	
 	/* With each iteration of this loop we search through the items in the
 	   current node, and calculate the next current node(next path element)
 	   for the next iteration of this loop.. */
@@ -695,8 +693,7 @@ int search_by_key(struct super_block *sb, const struct cpu_key *key,	/* Key to s
 			   starting from the root. */
 			block_number = SB_ROOT_BLOCK(sb);
 			expected_level = -1;
-			right_neighbor_of_leaf_node = 0;
-
+			
 			/* repeat search from the root */
 			continue;
 		}
-- 
1.7.1.rc1.21.gf3bd6

