Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab1AVNOu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 08:14:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57944 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab1AVNOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 08:14:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qerKJIaGs0fvm8qJxzNbvCgtnxMbp/rbq6fRKcxgl0b43FNMsrI8Q+GVlMWRDwGT0K
         4zO/l9f8/G31VBndJGt8y3uPgtj/Ui4lDD7/dOs3b+Ib5Kt8Kr8mc427RsfqTpPNro+M
         KltYSaIvTcMRGus8PojVN9XuTw3ZLsyoyZ/L4=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH v5 21/27] udf: use little-endian bitops
Date: Sat, 22 Jan 2011 22:13:53 +0900
Message-Id: <1295702039-23186-22-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295702039-23186-1-git-send-email-akinobu.mita@gmail.com>
References: <1295702039-23186-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h.  This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

Change from v4:
 - remove casts to "unsigned long *" due to le-bitops prototype change

The whole series is available in the git branch at:
 git://git.kernel.org/pub/scm/linux/kernel/git/mita/linux-2.6.git le-bitops-v5

 fs/udf/balloc.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index 306ee39..bc79f24 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -27,11 +27,10 @@
 #include "udf_i.h"
 #include "udf_sb.h"
 
-#define udf_clear_bit(nr, addr) ext2_clear_bit(nr, addr)
-#define udf_set_bit(nr, addr) ext2_set_bit(nr, addr)
-#define udf_test_bit(nr, addr) ext2_test_bit(nr, addr)
-#define udf_find_next_one_bit(addr, size, offset) \
-		ext2_find_next_bit(addr, size, offset)
+#define udf_clear_bit	__test_and_clear_bit_le
+#define udf_set_bit	__test_and_set_bit_le
+#define udf_test_bit	test_bit_le
+#define udf_find_next_one_bit	find_next_bit_le
 
 static int read_block_bitmap(struct super_block *sb,
 			     struct udf_bitmap *bitmap, unsigned int block,
-- 
1.7.3.4

