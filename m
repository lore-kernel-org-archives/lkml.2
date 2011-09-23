Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab1IWWc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 18:32:57 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:7688 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab1IWWc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 18:32:56 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-127.messagelabs.com!1316817171!32321400!26
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ext4/extents.c: quiet sparse noise about plain integer as NULL pointer
Date: Fri, 23 Sep 2011 15:32:44 -0700
User-Agent: KMail/1.9.9
CC: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109231532.44363.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The third parameter to ext4_free_blocks is a struct buffer_head *.  This
parameter should be NULL not 0.

This quiets the sparse noise:

warning: Using plain integer as NULL pointer

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>

---

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 57cf568..97e8d2b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2238,7 +2238,7 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 		start = ext4_ext_pblock(ex);
 
 		ext_debug("free first %u blocks starting %llu\n", num, start);
-		ext4_free_blocks(handle, inode, 0, start, num, flags);
+		ext4_free_blocks(handle, inode, NULL, start, num, flags);
 
 	} else {
 		printk(KERN_INFO "strange request: removal(2) "
