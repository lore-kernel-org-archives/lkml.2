Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab0EDR1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 13:27:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:43912 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab0EDR1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 13:27:51 -0400
Date: Tue, 4 May 2010 17:27:34 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <20100503130736.GD26107@aftab>
References: <20100503130736.GD26107@aftab>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/hweight] arch, hweight: Fix compilation errors
Message-ID: <tip-4677d4a53e0d565742277e8913e91c821453e63e@git.kernel.org>
Git-Commit-ID: 4677d4a53e0d565742277e8913e91c821453e63e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 May 2010 17:27:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4677d4a53e0d565742277e8913e91c821453e63e
Gitweb:     http://git.kernel.org/tip/4677d4a53e0d565742277e8913e91c821453e63e
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Mon, 3 May 2010 14:57:11 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 4 May 2010 10:25:27 -0700

arch, hweight: Fix compilation errors

Fix function prototype visibility issues when compiling for non-x86
architectures. Tested with crosstool
(ftp://ftp.kernel.org/pub/tools/crosstool/) with alpha, ia64 and sparc
targets.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <20100503130736.GD26107@aftab>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 include/asm-generic/bitops/arch_hweight.h |    8 ++++----
 include/linux/bitops.h                    |    5 +++++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/bitops/arch_hweight.h b/include/asm-generic/bitops/arch_hweight.h
index 9a81c1e..6a211f4 100644
--- a/include/asm-generic/bitops/arch_hweight.h
+++ b/include/asm-generic/bitops/arch_hweight.h
@@ -3,22 +3,22 @@
 
 #include <asm/types.h>
 
-inline unsigned int __arch_hweight32(unsigned int w)
+static inline unsigned int __arch_hweight32(unsigned int w)
 {
 	return __sw_hweight32(w);
 }
 
-inline unsigned int __arch_hweight16(unsigned int w)
+static inline unsigned int __arch_hweight16(unsigned int w)
 {
 	return __sw_hweight16(w);
 }
 
-inline unsigned int __arch_hweight8(unsigned int w)
+static inline unsigned int __arch_hweight8(unsigned int w)
 {
 	return __sw_hweight8(w);
 }
 
-inline unsigned long __arch_hweight64(__u64 w)
+static inline unsigned long __arch_hweight64(__u64 w)
 {
 	return __sw_hweight64(w);
 }
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index c55d5bc..26caa60 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -10,6 +10,11 @@
 #define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
 #endif
 
+extern unsigned int __sw_hweight8(unsigned int w);
+extern unsigned int __sw_hweight16(unsigned int w);
+extern unsigned int __sw_hweight32(unsigned int w);
+extern unsigned long __sw_hweight64(__u64 w);
+
 /*
  * Include this here because some architectures need generic_ffs/fls in
  * scope
