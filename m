Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871Ab2GLGrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 02:47:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56980 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082Ab2GLGrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 02:47:46 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 1/2] isofs: avoid info leak on export
Date: Thu, 12 Jul 2012 08:46:54 +0200
Message-Id: <1342075615-24683-2-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1342075615-24683-1-git-send-email-minipli@googlemail.com>
References: <1342075615-24683-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For type 1 the parent_offset member in struct isofs_fid gets copied
uninitialized to userland. Fix this by initializing it to 0.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 fs/isofs/export.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/isofs/export.c b/fs/isofs/export.c
index aa4356d..1d38044 100644
--- a/fs/isofs/export.c
+++ b/fs/isofs/export.c
@@ -134,6 +134,7 @@ isofs_export_encode_fh(struct inode *inode,
 	len = 3;
 	fh32[0] = ei->i_iget5_block;
  	fh16[2] = (__u16)ei->i_iget5_offset;  /* fh16 [sic] */
+	fh16[3] = 0;  /* avoid leaking uninitialized data */
 	fh32[2] = inode->i_generation;
 	if (parent) {
 		struct iso_inode_info *eparent;
-- 
1.7.10.4

