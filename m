Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab2DFGgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 02:36:07 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:44919 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab2DFGfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 02:35:54 -0400
Message-ID: <4F7E8EC3.9030306@gmail.com>
Date: Fri, 06 Apr 2012 14:35:47 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] Btrfs: fix the comment for find_first_extent_bit
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of find_first_extent_bit is 1 or 0, no < 0.
And if found something, return 0; if nothing was found, return 1.
Fix the comment.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/extent_io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ddfc1d5..26fbe1c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1288,7 +1288,7 @@ out:
  * returned if we find something, and *start_ret and *end_ret are
  * set to reflect the state struct that was found.
  *
- * If nothing was found, 1 is returned, < 0 on error
+ * If nothing was found, 1 is returned. If found something, return 0.
  */
 int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
 			  u64 *start_ret, u64 *end_ret, int bits)
-- 
1.7.1

