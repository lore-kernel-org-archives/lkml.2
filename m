Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760327Ab0G3TAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:00:49 -0400
Received: from kroah.org ([198.145.64.141]:51795 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758272Ab0G3RTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:10 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:07 2010
Message-Id: <20100730171507.624173487@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Theodore Tso" <tytso@mit.edu>
Subject: [088/165] ext4: Fix accounting of reserved metadata blocks
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit ee5f4d9cdf32fd99172d11665c592a288c2b1ff4 upstream (as of v2.6.33-rc3)

Commit 0637c6f had a typo which caused the reserved metadata blocks to
not be released correctly.   Fix this.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1118,9 +1118,9 @@ static void ext4_da_update_reserve_space
 		 * only when we have written all of the delayed
 		 * allocation blocks.
 		 */
-		mdb_free = ei->i_allocated_meta_blocks;
+		mdb_free = ei->i_reserved_meta_blocks;
+		ei->i_reserved_meta_blocks = 0;
 		percpu_counter_sub(&sbi->s_dirtyblocks_counter, mdb_free);
-		ei->i_allocated_meta_blocks = 0;
 	}
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 
@@ -1931,8 +1931,8 @@ static void ext4_da_release_space(struct
 		 * only when we have written all of the delayed
 		 * allocation blocks.
 		 */
-		to_free += ei->i_allocated_meta_blocks;
-		ei->i_allocated_meta_blocks = 0;
+		to_free += ei->i_reserved_meta_blocks;
+		ei->i_reserved_meta_blocks = 0;
 	}
 
 	/* update fs dirty blocks counter */


