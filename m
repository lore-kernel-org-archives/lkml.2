Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564Ab2EIGdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:33:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38674 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754404Ab2EIFwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:42 -0400
Message-Id: <20120509055035.176658030@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:09 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 040/167] [PATCH] ext4: fix endianness breakage in ext4_split_extent_at()
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit af1584f570b19b0285e4402a0b54731495d31784 upstream.

->ee_len is __le16, so assigning cpu_to_le32() to it is going to do
Bad Things(tm) on big-endian hosts...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/extents.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 1421938..1d41838 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2882,7 +2882,7 @@ static int ext4_split_extent_at(handle_t *handle,
 		if (err)
 			goto fix_extent_len;
 		/* update the extent length and mark as initialized */
-		ex->ee_len = cpu_to_le32(ee_len);
+		ex->ee_len = cpu_to_le16(ee_len);
 		ext4_ext_try_to_merge(inode, path, ex);
 		err = ext4_ext_dirty(handle, inode, path + depth);
 		goto out;
-- 
1.7.10



