Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab3AJPev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 10:34:51 -0500
Received: from multi.imgtec.com ([194.200.65.239]:52711 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435Ab3AJPc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:32:57 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 36/44] Kconfig.debug: add METAG to dependency lists
Date: Thu, 10 Jan 2013 15:31:04 +0000
Message-ID: <1357831872-29451-37-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_01_10_15_32_34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add [!]METAG to a couple of Kconfig dependencies in lib/Kconfig.debug.
Don't allow stack utilization instrumentation on metag, and allow
building with frame pointers.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
---
 lib/Kconfig.debug |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 07fd5a0..a6b7175 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -730,7 +730,7 @@ config STACKTRACE
 
 config DEBUG_STACK_USAGE
 	bool "Stack utilization instrumentation"
-	depends on DEBUG_KERNEL && !IA64 && !PARISC
+	depends on DEBUG_KERNEL && !IA64 && !PARISC && !METAG
 	help
 	  Enables the display of the minimum amount of free stack which each
 	  task has ever had available in the sysrq-T and sysrq-P debug output.
@@ -911,7 +911,7 @@ config FRAME_POINTER
 	bool "Compile the kernel with frame pointers"
 	depends on DEBUG_KERNEL && \
 		(CRIS || M68K || FRV || UML || \
-		 AVR32 || SUPERH || BLACKFIN || MN10300) || \
+		 AVR32 || SUPERH || BLACKFIN || MN10300 || METAG) || \
 		ARCH_WANT_FRAME_POINTERS
 	default y if (DEBUG_INFO && UML) || ARCH_WANT_FRAME_POINTERS
 	help
-- 
1.7.7.6


