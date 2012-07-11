Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab2GKGp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 02:45:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44666 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab2GKGpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 02:45:23 -0400
Message-ID: <4FFD20F3.7030906@gmail.com>
Date: Wed, 11 Jul 2012 14:45:07 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs/ioctl.c: set local var past_eof to true instead of integer
 1 in __generic_block_fiemap
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function __generic_block_fiemap, local var past_eof is declared
as bool, so use 'true' instead of number 1 here.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 29167be..e42abb0 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -308,7 +308,7 @@ int __generic_block_fiemap(struct inode *inode,
 			 */
 			if (!past_eof &&
 			    blk_to_logical(inode, start_blk) >= isize)
-				past_eof = 1;
+				past_eof = true;
 
 			/*
 			 * First hole after going past the EOF, this is our
-- 
1.7.1

