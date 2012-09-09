Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab2IIXYG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:24:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51415 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756261Ab2IIXQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:55 -0400
Message-Id: <20120909224151.925652581@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:41:57 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Theodore Tso <tytso@mit.edu>
Subject: [ 07/95] ext4: avoid kmemcheck complaint from reading uninitialized memory
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 7e731bc9a12339f344cddf82166b82633d99dd86 upstream.

Commit 03179fe923 introduced a kmemcheck complaint in
ext4_da_get_block_prep() because we save and restore
ei->i_da_metadata_calc_last_lblock even though it is left
uninitialized in the case where i_da_metadata_calc_len is zero.

This doesn't hurt anything, but silencing the kmemcheck complaint
makes it easier for people to find real bugs.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=45631
(which is marked as a regression).

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/super.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ccc4bca..56bcaec 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -959,6 +959,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ei->i_reserved_meta_blocks = 0;
 	ei->i_allocated_meta_blocks = 0;
 	ei->i_da_metadata_calc_len = 0;
+	ei->i_da_metadata_calc_last_lblock = 0;
 	spin_lock_init(&(ei->i_block_reservation_lock));
 #ifdef CONFIG_QUOTA
 	ei->i_reserved_quota = 0;


