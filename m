Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab1AVNOk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 08:14:40 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57944 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab1AVNOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 08:14:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IeX4bR97/g+bRE5woco7kbaIrs7mhpjnOfct/WEQ20ujMLaiReZeqHay7JNjwbvjiQ
         LLelGE8oZl+zsQnlmBT1gFMKqJNzfNsleUKcVVREGfkCYvVjbnLMXsmQTfpkBghecNrB
         gOeSHHHspWtDVr/qZDZt95beA++OZUr2CSWTQ=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <joel.becker@oracle.com>
Subject: [PATCH v5 18/27] ocfs2: use little-endian bitops
Date: Sat, 22 Jan 2011 22:13:50 +0900
Message-Id: <1295702039-23186-19-git-send-email-akinobu.mita@gmail.com>
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
Acked-by: Joel Becker <joel.becker@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

Change from v4:
 - remove casts to "unsigned long *" due to le-bitops prototype change

The whole series is available in the git branch at:
 git://git.kernel.org/pub/scm/linux/kernel/git/mita/linux-2.6.git le-bitops-v5

 fs/ocfs2/ocfs2.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 51cd689..1a97ba1 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -831,18 +831,18 @@ static inline unsigned int ocfs2_clusters_to_megabytes(struct super_block *sb,
 
 static inline void _ocfs2_set_bit(unsigned int bit, unsigned long *bitmap)
 {
-	ext2_set_bit(bit, bitmap);
+	__test_and_set_bit_le(bit, bitmap);
 }
 #define ocfs2_set_bit(bit, addr) _ocfs2_set_bit((bit), (unsigned long *)(addr))
 
 static inline void _ocfs2_clear_bit(unsigned int bit, unsigned long *bitmap)
 {
-	ext2_clear_bit(bit, bitmap);
+	__test_and_clear_bit_le(bit, bitmap);
 }
 #define ocfs2_clear_bit(bit, addr) _ocfs2_clear_bit((bit), (unsigned long *)(addr))
 
-#define ocfs2_test_bit ext2_test_bit
-#define ocfs2_find_next_zero_bit ext2_find_next_zero_bit
-#define ocfs2_find_next_bit ext2_find_next_bit
+#define ocfs2_test_bit test_bit_le
+#define ocfs2_find_next_zero_bit find_next_zero_bit_le
+#define ocfs2_find_next_bit find_next_bit_le
 #endif  /* OCFS2_H */
 
-- 
1.7.3.4

