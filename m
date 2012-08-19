Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab2HSDAP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:00:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:1635 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516Ab2HSC5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="210415453"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>, wim@iguana.be
Subject: [PATCH 38/74] lto, watchdog/hpwdt.c: Make assembler label global
Date: Sat, 18 Aug 2012 19:56:34 -0700
Message-Id: <1345345030-22211-39-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

We cannot assume that the inline assembler code always ends up
in the same file as the original C file. So make any assembler labels
that are called with "extern" by C global

Cc: wim@iguana.be
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/watchdog/hpwdt.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 1eff743..68bda60 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -161,7 +161,8 @@ extern asmlinkage void asminline_call(struct cmn_registers *pi86Regs,
 #define HPWDT_ARCH	32
 
 asm(".text                          \n\t"
-    ".align 4                       \n"
+    ".align 4                       \n\t"
+    ".globl asminline_call	    \n"
     "asminline_call:                \n\t"
     "pushl       %ebp               \n\t"
     "movl        %esp, %ebp         \n\t"
@@ -351,7 +352,8 @@ static int __devinit detect_cru_service(void)
 #define HPWDT_ARCH	64
 
 asm(".text                      \n\t"
-    ".align 4                   \n"
+    ".align 4                   \n\t"
+    ".globl asminline_call	\n"
     "asminline_call:            \n\t"
     "pushq      %rbp            \n\t"
     "movq       %rsp, %rbp      \n\t"
-- 
1.7.7.6

