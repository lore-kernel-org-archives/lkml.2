Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab2ETNX7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 09:23:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50441 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab2ETNX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 09:23:58 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 02/10] minixfs: use memweight()
Date: Sun, 20 May 2012 22:23:15 +0900
Message-Id: <1337520203-29147-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1337520203-29147-1-git-send-email-akinobu.mita@gmail.com>
References: <1337520203-29147-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use memweight() to count the total number of bits clear in memory area.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 fs/minix/bitmap.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/minix/bitmap.c b/fs/minix/bitmap.c
index 4bc50da..564f1a5 100644
--- a/fs/minix/bitmap.c
+++ b/fs/minix/bitmap.c
@@ -29,10 +29,8 @@ static __u32 count_free(struct buffer_head *map[], unsigned blocksize, __u32 num
 	unsigned blocks = DIV_ROUND_UP(numbits, blocksize * 8);
 
 	while (blocks--) {
-		unsigned words = blocksize / 2;
-		__u16 *p = (__u16 *)(*map++)->b_data;
-		while (words--)
-			sum += 16 - hweight16(*p++);
+		sum += blocksize * BITS_PER_BYTE -
+			memweight((*map++)->b_data, blocksize);
 	}
 
 	return sum;
-- 
1.7.7.6

