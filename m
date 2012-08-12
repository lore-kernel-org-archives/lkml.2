Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805Ab2HLKBq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 06:01:46 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:54010 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab2HLKBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 06:01:43 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Hans-Peter Nilsson <hans-peter.nilsson@axis.com>,
        linux-cris-kernel@axis.com
Subject: [PATCH 1/2] cris: Use "int" for ssize_t to match size_t
Date: Sun, 12 Aug 2012 12:01:33 +0200
Message-Id: <1344765694-7465-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On cris-linux-gcc, __SIZE_TYPE__ expands to "unsigned int", as
gcc-4.6.3-nolibc/cris-linux/lib/gcc/cris-linux/4.6.3/plugin/include/config/cris/linux.h
has

    #define SIZE_TYPE "unsigned int"

Hence __kernel_size_t is also "unsigned int".  But __kernel_ssize_t is
"long", which has a different base type, causing compiler warnings like:

    fs/quota/quota_tree.c:372:4: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'ssize_t' [-Wformat]

To fix this, __kernel_ssize_t should be changed to "int". Hence cris can
just use the generic 32-bit versions from include/asm-generic/posix_types.h
for all size-related types.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com
---
 arch/cris/include/asm/posix_types.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/cris/include/asm/posix_types.h b/arch/cris/include/asm/posix_types.h
index ce4e517..0f22e6a 100644
--- a/arch/cris/include/asm/posix_types.h
+++ b/arch/cris/include/asm/posix_types.h
@@ -22,11 +22,6 @@ typedef unsigned short	__kernel_uid_t;
 typedef unsigned short	__kernel_gid_t;
 #define __kernel_uid_t __kernel_uid_t
 
-typedef __SIZE_TYPE__	__kernel_size_t;
-typedef long		__kernel_ssize_t;
-typedef int		__kernel_ptrdiff_t;
-#define __kernel_size_t __kernel_size_t
-
 typedef unsigned short	__kernel_old_dev_t;
 #define __kernel_old_dev_t __kernel_old_dev_t
 
-- 
1.7.0.4

