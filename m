Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284Ab0G3RdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:33:09 -0400
Received: from kroah.org ([198.145.64.141]:51921 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757953Ab0G3RT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:29 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:09 2010
Message-Id: <20100730171509.117308260@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Sandeen <sandeen@redhat.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [105/165] ext4: Fixed inode allocator to correctly track a flex_bgs used_dirs
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit c4caae25187ff3f5e837c6f04eb1acc2723c72d3 upstream (as of v2.6.34-rc3)

When used_dirs was introduced for the flex_groups struct, it looks
like the accounting was not put into place properly, in some places
manipulating free_inodes rather than used_dirs.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/ialloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -268,7 +268,7 @@ void ext4_free_inode(handle_t *handle, s
 					ext4_group_t f;
 
 					f = ext4_flex_group(sbi, block_group);
-					atomic_dec(&sbi->s_flex_groups[f].free_inodes);
+					atomic_dec(&sbi->s_flex_groups[f].used_dirs);
 				}
 
 			}
@@ -779,7 +779,7 @@ static int ext4_claim_inode(struct super
 		if (sbi->s_log_groups_per_flex) {
 			ext4_group_t f = ext4_flex_group(sbi, group);
 
-			atomic_inc(&sbi->s_flex_groups[f].free_inodes);
+			atomic_inc(&sbi->s_flex_groups[f].used_dirs);
 		}
 	}
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);


