Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587Ab2JAXcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:32:15 -0400
Received: from 1wt.eu ([62.212.114.60]:35175 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932653Ab2JAXAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:31 -0400
Message-Id: <20121001225200.277864732@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:00 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Theodore Tso" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 063/180] ext4: check for zero length extent
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 31d4f3a2f3c73f279ff96a7135d7202ef6833f12 upstream.

Explicitly test for an extent whose length is zero, and flag that as a
corrupted extent.

This avoids a kernel BUG_ON assertion failure.

Tested: Without this patch, the file system image found in
tests/f_ext_zero_len/image.gz in the latest e2fsprogs sources causes a
kernel panic.  With this patch, an ext4 file system error is noted
instead, and the file system is marked as being corrupted.

https://bugzilla.kernel.org/show_bug.cgi?id=42859

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/ext4/extents.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 93f7999..b4402c8 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -358,6 +358,8 @@ static int ext4_valid_extent(struct inode *inode, struct ext4_extent *ext)
 	ext4_fsblk_t block = ext_pblock(ext);
 	int len = ext4_ext_get_actual_len(ext);
 
+	if (len == 0)
+		return 0;
 	return ext4_data_block_valid(EXT4_SB(inode->i_sb), block, len);
 }
 
-- 
1.7.2.1.45.g54fbc



