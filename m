Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab0FUWRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 18:17:43 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:47153 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab0FUWRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 18:17:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DaTLN5LGiBfVAKxXTPDnKiIR77KtMC88gaYwphiGleppwfJHKVHpS2/mz9+1r2r14E
         uMTn5tMq/UyYhouUIAK2WVtpemA858lo59p9Cqk1n488TgJxAHfTz1Zq9HdAzThnZKaj
         LEn2lWZooW/DwzAobJ+8QDUClSGM4rS5ZfHMU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 4/6 v2]hfs Fix variable set but not used
Date: Mon, 21 Jun 2010 15:17:30 -0700
Message-Id: <1277158650-19219-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a redu from the original due to whitespace issues
for extents.c which fixes this warning:

 CC [M]  fs/hfsplus/extents.o
fs/hfsplus/extents.c: In function 'hfsplus_get_block':
fs/hfsplus/extents.c:178:6: warning: variable 'shift' set but not used

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 fs/hfsplus/extents.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
index 0022eec..824c6a5 100644
--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -175,12 +175,10 @@ int hfsplus_get_block(struct inode *inode, sector_t iblock,
 	struct super_block *sb;
 	int res = -EIO;
 	u32 ablock, dblock, mask;
-	int shift;
 
 	sb = inode->i_sb;
 
 	/* Convert inode block to disk allocation block */
-	shift = HFSPLUS_SB(sb).alloc_blksz_shift - sb->s_blocksize_bits;
 	ablock = iblock >> HFSPLUS_SB(sb).fs_shift;
 
 	if (iblock >= HFSPLUS_I(inode).fs_blocks) {
-- 
1.7.1.rc1.21.gf3bd6

