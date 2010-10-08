Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab0JHKBE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:01:04 -0400
Received: from [150.82.175.143] ([150.82.175.143]:53855 "EHLO
	dhcpa11143.tky.aist.go.jp" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756914Ab0JHKAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:00:33 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 5/5] bitops: forbid asm-generic/bitops/le.h direct inclusion
Date: Fri,  8 Oct 2010 19:03:13 +0900
Message-Id: <1286532193-29814-5-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.1.231.gd0b16
In-Reply-To: <1286532193-29814-1-git-send-email-akinobu.mita@gmail.com>
References: <1286532193-29814-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm-generic/bitops/le.h is only intended to be included directly from
asm-generic/bitops/ext2-non-atomic.h or asm-generic/bitops/minix-le.h
which implements generic ext2 or minix bit operations.

But there were some source files that include it directly.
(those are already fixed by other commits)

This forbids asm-generic/bitops/le.h direct inclusion in the future.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 include/asm-generic/bitops/le.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/bitops/le.h b/include/asm-generic/bitops/le.h
index db2be81..f8d0225 100644
--- a/include/asm-generic/bitops/le.h
+++ b/include/asm-generic/bitops/le.h
@@ -1,6 +1,11 @@
 #ifndef _ASM_GENERIC_BITOPS_LE_H_
 #define _ASM_GENERIC_BITOPS_LE_H_
 
+#if !defined(_ASM_GENERIC_BITOPS_MINIX_LE_H_) && \
+	!defined(_ASM_GENERIC_BITOPS_EXT2_NON_ATOMIC_H_)
+#error only minix-le.h and ext2-non-atomic.h can be included directly
+#endif
+
 #include <asm/types.h>
 #include <asm/byteorder.h>
 
-- 
1.7.1.231.gd0b16

