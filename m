Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143Ab2JKJRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 05:17:32 -0400
Received: from multi.imgtec.com ([194.200.65.239]:17120 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755608Ab2JKJR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 05:17:29 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
CC: <linux-cris-kernel@axis.com>, <linux-kernel@vger.kernel.org>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH] cris: use kbuild.h instead of defining macros in asm-offset.c
Date: Thu, 11 Oct 2012 10:00:58 +0100
Message-ID: <1349946058-26791-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
X-OriginalArrivalTime: 11 Oct 2012 09:01:28.0768 (UTC) FILETIME=[001D1400:01CDA78F]
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_10_11_10_01_29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is modelled on commits such as the one below:

Commit fc1c3a003edb8a6778e64e10ef671a38c76c969e ("sh: use kbuild.h
instead of defining macros in asm-offsets.c") introduced in v2.6.26.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
Note I haven't tested compilation on cris. I'd appreciate if somebody
could check it doesn't break anything.

 arch/cris/kernel/asm-offsets.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/cris/kernel/asm-offsets.c b/arch/cris/kernel/asm-offsets.c
index dd7b8e9..a5fd88d 100644
--- a/arch/cris/kernel/asm-offsets.c
+++ b/arch/cris/kernel/asm-offsets.c
@@ -1,3 +1,4 @@
+#include <linux/kbuild.h>
 #include <linux/sched.h>
 #include <asm/thread_info.h>
 
@@ -7,11 +8,6 @@
  * and format the required data.
  */
 
-#define DEFINE(sym, val) \
-	asm volatile("\n->" #sym " %0 " #val : : "i" (val))
-
-#define BLANK() asm volatile("\n->" : : )
-
 #if !defined(CONFIG_ETRAX_ARCH_V10) && !defined(CONFIG_ETRAX_ARCH_V32)
 #error One of ARCH v10 and ARCH v32 must be true!
 #endif
-- 
1.7.7.6


