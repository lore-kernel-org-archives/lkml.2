Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab2GLGsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 02:48:21 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57989 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757089Ab2GLGrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 02:47:48 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 2/2] udf: avoid info leak on export
Date: Thu, 12 Jul 2012 08:46:55 +0200
Message-Id: <1342075615-24683-3-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1342075615-24683-1-git-send-email-minipli@googlemail.com>
References: <1342075615-24683-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For type 0x51 the udf.parent_partref member in struct fid gets copied
uninitialized to userland. Fix this by initializing it to 0.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 fs/udf/namei.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 1802417..c31deb3 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1279,6 +1279,7 @@ static int udf_encode_fh(struct inode *inode, __u32 *fh, int *lenp,
 	*lenp = 3;
 	fid->udf.block = location.logicalBlockNum;
 	fid->udf.partref = location.partitionReferenceNum;
+	fid->udf.parent_partref = 0;
 	fid->udf.generation = inode->i_generation;
 
 	if (parent) {
-- 
1.7.10.4

