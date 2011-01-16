Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab1APNLY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 08:11:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48314 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab1APNJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 08:09:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pWbrNDwCLs0uZRawWDaWsRdX8mcUc6Vq/vn59AAuy8Z4F1wc9Ycvcn9gbyDuv7viLV
         Rq/TfX09oHaXgfHeiEuYbkH5jPUXWf+67OPrrUVNhzDBxPpDLh0arCO1APGkROlPjkpd
         UeIk2apLiUP558YTemoRTGf8maXbimhRdZx6A=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH v4 16/24] nilfs2: use little-endian bitops
Date: Sun, 16 Jan 2011 22:08:45 +0900
Message-Id: <1295183333-13802-17-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295183333-13802-1-git-send-email-akinobu.mita@gmail.com>
References: <1295183333-13802-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h.  This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

Change from v3:
 - change to the post-fix notation e.g. s/test_le_bit/test_bit_le/

The whole series is available in the git repository at:
 git://git.kernel.org/pub/scm/linux/kernel/git/mita/linux-2.6.git le-bitops-v4

 fs/nilfs2/alloc.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/alloc.h b/fs/nilfs2/alloc.h
index 9af34a7..8255a42 100644
--- a/fs/nilfs2/alloc.h
+++ b/fs/nilfs2/alloc.h
@@ -74,7 +74,8 @@ int nilfs_palloc_freev(struct inode *, __u64 *, size_t);
 
 #define nilfs_set_bit_atomic		ext2_set_bit_atomic
 #define nilfs_clear_bit_atomic		ext2_clear_bit_atomic
-#define nilfs_find_next_zero_bit	ext2_find_next_zero_bit
+#define nilfs_find_next_zero_bit(addr, size, off)	\
+	find_next_zero_bit_le((unsigned long *)(addr), (size), (off))
 
 /*
  * persistent object allocator cache
-- 
1.7.3.4

