Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab1AVNOo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 08:14:44 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43821 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab1AVNOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 08:14:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JRyxDqEQEuiCqY5WIQ0CP2anViBa9UNnvsdrb8uFmsbDYbaoyXZntbp3Ce3r757bcV
         FRWgGDht2kJCWMYkgwoU5LGfp4BJAdUyQ+qFs0dOps9Sh4ti8RSHE/Aj1IKL7s67kpUc
         ovuLg/giL6RyiEmmY1oVopCiW564i1a87i4WY=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH v5 19/27] nilfs2: use little-endian bitops
Date: Sat, 22 Jan 2011 22:13:51 +0900
Message-Id: <1295702039-23186-20-git-send-email-akinobu.mita@gmail.com>
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
Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

Change from v4:
 - remove casts to "unsigned long *" due to le-bitops prototype change

The whole series is available in the git branch at:
 git://git.kernel.org/pub/scm/linux/kernel/git/mita/linux-2.6.git le-bitops-v5

 fs/nilfs2/alloc.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/alloc.h b/fs/nilfs2/alloc.h
index 9af34a7..f5fde36 100644
--- a/fs/nilfs2/alloc.h
+++ b/fs/nilfs2/alloc.h
@@ -74,7 +74,7 @@ int nilfs_palloc_freev(struct inode *, __u64 *, size_t);
 
 #define nilfs_set_bit_atomic		ext2_set_bit_atomic
 #define nilfs_clear_bit_atomic		ext2_clear_bit_atomic
-#define nilfs_find_next_zero_bit	ext2_find_next_zero_bit
+#define nilfs_find_next_zero_bit	find_next_zero_bit_le
 
 /*
  * persistent object allocator cache
-- 
1.7.3.4

