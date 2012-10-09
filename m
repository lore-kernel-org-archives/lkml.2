Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab2JIPKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:10:31 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53763 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab2JIPK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:10:27 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jack@suse.cz
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: [PATCH 6/6] udf: use extent cache when moving to last extent
Date: Wed, 10 Oct 2012 00:10:18 +0900
Message-Id: <1349795418-6533-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Use extent cache when moving to last extent.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/udf/truncate.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
index 8a9657d..95fd9bf 100644
--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -88,6 +88,8 @@ void udf_truncate_tail_extent(struct inode *inode)
 		adsize = sizeof(struct long_ad);
 	else
 		BUG();
+	if (!udf_read_extent_cache(inode, inode->i_size, &lbcount, &epos))
+		epos.block = iinfo->i_location;
 
 	/* Find the last extent in the file */
 	while ((netype = udf_next_aext(inode, &epos, &eloc, &elen, 1)) != -1) {
@@ -139,8 +141,8 @@ void udf_discard_prealloc(struct inode *inode)
 		adsize = sizeof(struct long_ad);
 	else
 		adsize = 0;
-
-	epos.block = iinfo->i_location;
+	if (!udf_read_extent_cache(inode, inode->i_size, &lbcount, &epos))
+		epos.block = iinfo->i_location;
 
 	/* Find the last extent in the file */
 	while ((netype = udf_next_aext(inode, &epos, &eloc, &elen, 1)) != -1) {
-- 
1.7.9.5

