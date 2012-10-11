Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab2JKJT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 05:19:59 -0400
Received: from multi.imgtec.com ([194.200.65.239]:27462 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab2JKJT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 05:19:58 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Jonas Bonn <jonas@southpole.se>
CC: <linux@openrisc.net>, <linux-kernel@vger.kernel.org>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH] openrisc: use kbuild.h instead of defining macros in asm-offset.c
Date: Thu, 11 Oct 2012 10:03:01 +0100
Message-ID: <1349946181-27277-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
X-OriginalArrivalTime: 11 Oct 2012 09:03:16.0674 (UTC) FILETIME=[406E3A20:01CDA78F]
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_10_11_10_03_46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is modelled on commits such as the one below:

Commit fc1c3a003edb8a6778e64e10ef671a38c76c969e ("sh: use kbuild.h
instead of defining macros in asm-offsets.c") introduced in v2.6.26.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
Note I haven't tested compilation on openrisc. I'd appreciate if
somebody could check it doesn't break anything.

 arch/openrisc/kernel/asm-offsets.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/openrisc/kernel/asm-offsets.c b/arch/openrisc/kernel/asm-offsets.c
index 1a242a0..ddb7368 100644
--- a/arch/openrisc/kernel/asm-offsets.c
+++ b/arch/openrisc/kernel/asm-offsets.c
@@ -34,15 +34,11 @@
 #include <linux/mm.h>
 #include <linux/io.h>
 #include <linux/thread_info.h>
+#include <linux/kbuild.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
 
-#define DEFINE(sym, val) \
-		asm volatile("\n->" #sym " %0 " #val : : "i" (val))
-
-#define BLANK() asm volatile("\n->" : : )
-
 int main(void)
 {
 	/* offsets into the task_struct */
-- 
1.7.7.6


