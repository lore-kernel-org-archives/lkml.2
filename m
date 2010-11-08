Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab0KHBVo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 20:21:44 -0500
Received: from mail.redflag-linux.com ([219.237.229.196]:43780 "EHLO
	mail.redflag-linux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab0KHBVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 20:21:42 -0500
Message-ID: <4CD75033.7080902@redflag-linux.com>
Date: Mon, 08 Nov 2010 09:19:47 +0800
From: =?UTF-8?B?Iua9mOWNq+W5syhQZXRlciBQYW4pIg==?= 
	<wppan@redflag-linux.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100324 RedFlag/3.0.1-1rf2.dt8 Thunderbird/3.0.1
MIME-Version: 1.0
To: tytso@mit.edu, adilger.kernel@dilger.ca
CC: linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ext4:memset is needless in ext4_ext_remove_space()
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


memset is needless because path is allocated by kzalloc.

Signed-off-by: Peter Pan(潘卫平) <wppan@redflag-linux.com>
---
  fs/ext4/extents.c |    1 -
  1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0554c48..37cdb6e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2375,7 +2375,6 @@ again:
  			/* go to the next level */
  			ext_debug("move to level %d (block %llu)\n",
  				  i + 1, ext4_idx_pblock(path[i].p_idx));
-			memset(path + i + 1, 0, sizeof(*path));
  			bh = sb_bread(sb, ext4_idx_pblock(path[i].p_idx));
  			if (!bh) {
  				/* should we reset i_size? */
-- 
1.6.6


