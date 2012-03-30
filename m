Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab2C3HOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 03:14:45 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46481 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250Ab2C3HOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 03:14:36 -0400
Message-ID: <4F755D53.1070102@gmail.com>
Date: Fri, 30 Mar 2012 15:14:27 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs/ctree.c: remove the unnecessary 'return -1;' at the
 end of bin_search
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code path should not reach there. Remove it.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/ctree.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 0639a55..c1be2da 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -829,20 +829,18 @@ static noinline int generic_bin_search(struct extent_buffer *eb,
 static int bin_search(struct extent_buffer *eb, struct btrfs_key *key,
 		      int level, int *slot)
 {
-	if (level == 0) {
+	if (level == 0)
 		return generic_bin_search(eb,
 					  offsetof(struct btrfs_leaf, items),
 					  sizeof(struct btrfs_item),
 					  key, btrfs_header_nritems(eb),
 					  slot);
-	} else {
+	else
 		return generic_bin_search(eb,
 					  offsetof(struct btrfs_node, ptrs),
 					  sizeof(struct btrfs_key_ptr),
 					  key, btrfs_header_nritems(eb),
 					  slot);
-	}
-	return -1;
 }
 
 int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key *key,
-- 
1.7.1



