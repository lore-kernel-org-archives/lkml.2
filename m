Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab2GFG0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 02:26:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51178 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab2GFG0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 02:26:37 -0400
Message-ID: <4FF68511.9050207@gmail.com>
Date: Fri, 06 Jul 2012 14:26:25 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ext4: fix the comment in ext4_ext_insert_extent for ext4_ext_try_to_merge
 in extents.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The left and right extents merge is done by
ext4_ext_try_to_merge. No specific left/right
fun calls any more.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/ext4/extents.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5207b7b..6c2a37d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1891,12 +1891,10 @@ has_space:
 	nearex->ee_len = newext->ee_len;
 
 merge:
-	/* try to merge extents to the right */
+	/* try to merge extents to the neighbours */
 	if (!(flag & EXT4_GET_BLOCKS_PRE_IO))
 		ext4_ext_try_to_merge(inode, path, nearex);
 
-	/* try to merge extents to the left */
-
 	/* time to correct all indexes above */
 	err = ext4_ext_correct_indexes(handle, inode, path);
 	if (err)
-- 
1.7.1

