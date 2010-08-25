Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab0HYHFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 03:05:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45348 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab0HYHFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 03:05:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=tkoxnog9z9Ufn4othCtJ2K09/xlA7LDIsZnfoShsqE6dwkkn/Ifaxg0ogec7WHwq/Y
         GPgDV0fUuGNAVaEE+OB5oIFoNoocV/Cw0KYRziyZvgeMuY1Kt4SbjTp2rVP5z6J3vn+i
         e7hs0uKMw8pEka05jibxCB6g9K5gfzrwZpMvM=
Date: Wed, 25 Aug 2010 09:05:27 +0200
From: Dan Carpenter <error27@gmail.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] affs: testing the wrong variable
Message-ID: <20100825070350.GN29330@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Roman Zippel <zippel@linux-m68k.org>,
	Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intent was to verify that bh = affs_bread_ino(...) returned a valid
pointer.  We checked "ext_bh" earlier in the function and it's valid
here.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/affs/file.c b/fs/affs/file.c
index c4a9875..0a90dcd 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -894,9 +894,9 @@ affs_truncate(struct inode *inode)
 		if (AFFS_SB(sb)->s_flags & SF_OFS) {
 			struct buffer_head *bh = affs_bread_ino(inode, last_blk, 0);
 			u32 tmp;
-			if (IS_ERR(ext_bh)) {
+			if (IS_ERR(bh)) {
 				affs_warning(sb, "truncate", "unexpected read error for last block %u (%d)",
-					     ext, PTR_ERR(ext_bh));
+					     ext, PTR_ERR(bh));
 				return;
 			}
 			tmp = be32_to_cpu(AFFS_DATA_HEAD(bh)->next);
