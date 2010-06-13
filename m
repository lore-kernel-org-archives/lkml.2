Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab0FMDcw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 23:32:52 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52930 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153Ab0FMDcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 23:32:51 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, Tim Abbott <tabbott@ksplice.com>
Cc: Milton Miller <miltonm@bga.com>
Subject: [PATCH] vmlinux.lds.h: lower init ramfs alignment to 4
Date: Sat, 12 Jun 2010 23:33:01 -0400
Message-Id: <1276399981-27524-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new init ramfs format (cpio based) requires an alignment of 4 (per the
documentation and per the source files themselves).  As for compressed
sources, the decompressors can all deal with unaligned buffers.

The cpio source is also found in the __init sections of the kernel, so
once they are read and expanded into a tmpfs, the source is freed.  That
means there is no need to force page alignment here either.

This has been used on Blackfin systems for many releases without issue.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/asm-generic/vmlinux.lds.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 48c5299..14a01b6 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -620,7 +620,7 @@
 
 #ifdef CONFIG_BLK_DEV_INITRD
 #define INIT_RAM_FS							\
-	. = ALIGN(PAGE_SIZE);						\
+	. = ALIGN(4);							\
 	VMLINUX_SYMBOL(__initramfs_start) = .;				\
 	*(.init.ramfs)							\
 	VMLINUX_SYMBOL(__initramfs_end) = .;
-- 
1.7.1

