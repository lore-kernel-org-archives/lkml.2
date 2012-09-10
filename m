Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772Ab2IJGiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 02:38:50 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47959 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab2IJGis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 02:38:48 -0400
Message-ID: <504D8AEB.9090401@gmail.com>
Date: Mon, 10 Sep 2012 14:38:35 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: fix disk-io.c/btrfs_read_dev_super with BTRFS_SUPER_MIRROR_MAX
 to control the loops
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To check the duplicated super blocks, use BTRFS_SUPER_MIRROR_MAX
as the loops limit.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/disk-io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 22e98e0..a431144 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2723,7 +2723,7 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
 	 * So, we need to add a special mount option to scan for
 	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
 	 */
-	for (i = 0; i < 1; i++) {
+	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
 		if (bytenr + 4096 >= i_size_read(bdev->bd_inode))
 			break;
-- 
1.7.1

