Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab1IWU43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 16:56:29 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:7219 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab1IWU41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 16:56:27 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-131.messagelabs.com!1316811377!1904756!12
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ext3/balloc.c: local functions should be static
Date: Fri, 23 Sep 2011 13:55:52 -0700
User-Agent: KMail/1.9.9
CC: <linux-ext4@vger.kernel.org>, <jack@suse.cz>, <akpm@linux-foundation.org>,
        <adilger.kernel@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109231355.52431.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This quites the sparse noise:

warning: symbol 'ext3_trim_all_free' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>

---

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 6386d76..8e62ec5 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -1924,9 +1924,10 @@ unsigned long ext3_bg_num_gdb(struct super_block *sb, int group)
  * reaches any used block. Then issue a TRIM command on this extent and free
  * the extent in the block bitmap. This is done until whole group is scanned.
  */
-ext3_grpblk_t ext3_trim_all_free(struct super_block *sb, unsigned int group,
-				ext3_grpblk_t start, ext3_grpblk_t max,
-				ext3_grpblk_t minblocks)
+static ext3_grpblk_t ext3_trim_all_free(struct super_block *sb,
+					unsigned int group,
+					ext3_grpblk_t start, ext3_grpblk_t max,
+					ext3_grpblk_t minblocks)
 {
 	handle_t *handle;
 	ext3_grpblk_t next, free_blocks, bit, freed, count = 0;
