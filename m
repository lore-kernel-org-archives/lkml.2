Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809Ab0G3RTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:19:47 -0400
Received: from kroah.org ([198.145.64.141]:51986 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758777Ab0G3RTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:39 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:10 2010
Message-Id: <20100730171509.935747800@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Monakhov <dmonakhov@openvz.org>, "Theodore Tso" <tytso@mit.edu>
Subject: [114/165] ext4: fix quota accounting in case of fallocate
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 35121c9860316d7799cea0fbc359a9186e7c2747 upstream (as of v2.6.34-git13)

allocated_meta_data is already included in 'used' variable.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1149,7 +1149,8 @@ void ext4_da_update_reserve_space(struct
 		 */
 		if (allocated_meta_blocks)
 			vfs_dq_claim_block(inode, allocated_meta_blocks);
-		vfs_dq_release_reservation_block(inode, mdb_free + used);
+		vfs_dq_release_reservation_block(inode, mdb_free + used -
+						allocated_meta_blocks);
 	}
 
 	/*


