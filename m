Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab2DXWii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:38:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38637 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932803Ab2DXWic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:38:32 -0400
Message-Id: <20120424223255.790751925@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>,
        Ted Tso <tytso@mit.edu>
Subject: [ 27/42] ext4: fix endianness breakage in ext4_split_extent_at()
In-Reply-To: <20120424223311.GA8456@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit af1584f570b19b0285e4402a0b54731495d31784 upstream.

->ee_len is __le16, so assigning cpu_to_le32() to it is going to do
Bad Things(tm) on big-endian hosts...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ted Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/extents.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2846,7 +2846,7 @@ static int ext4_split_extent_at(handle_t
 		if (err)
 			goto fix_extent_len;
 		/* update the extent length and mark as initialized */
-		ex->ee_len = cpu_to_le32(ee_len);
+		ex->ee_len = cpu_to_le16(ee_len);
 		ext4_ext_try_to_merge(inode, path, ex);
 		err = ext4_ext_dirty(handle, inode, path + depth);
 		goto out;


