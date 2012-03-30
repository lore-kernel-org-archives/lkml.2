Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965200Ab2C3VOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:14:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965214Ab2C3VOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:14:48 -0400
Message-Id: <20120330194858.894511838@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Theodore Tso" <tytso@mit.edu>
Subject: [ 115/149] ext4: check for zero length extent
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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

---
 fs/ext4/extents.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -301,6 +301,8 @@ static int ext4_valid_extent(struct inod
 	ext4_fsblk_t block = ext4_ext_pblock(ext);
 	int len = ext4_ext_get_actual_len(ext);
 
+	if (len == 0)
+		return 0;
 	return ext4_data_block_valid(EXT4_SB(inode->i_sb), block, len);
 }
 


