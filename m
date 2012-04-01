Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab2DAUjE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 16:39:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:54115 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab2DAUjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 16:39:01 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: dhowells@redhat.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 03/11] avr32: fix nop compile fails from system.h split up
Date: Sun,  1 Apr 2012 16:38:39 -0400
Message-Id: <1333312727-11428-4-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
References: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To fix:

  In file included from kernel/exit.c:61:
  arch/avr32/include/asm/mmu_context.h: In function 'enable_mmu':
  arch/avr32/include/asm/mmu_context.h:135: error: implicit
  declaration of function 'nop'

It needs an include of the new file created in:

commit ae473946586680b01c13975a3b674de23ad7c93e

    "Disintegrate asm/system.h for AVR32"

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/avr32/include/asm/mmu_context.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/include/asm/mmu_context.h b/arch/avr32/include/asm/mmu_context.h
index 27ff234..f1b2fec 100644
--- a/arch/avr32/include/asm/mmu_context.h
+++ b/arch/avr32/include/asm/mmu_context.h
@@ -14,6 +14,7 @@
 
 #include <asm/tlbflush.h>
 #include <asm/sysreg.h>
+#include <asm/special_insns.h>
 #include <asm-generic/mm_hooks.h>
 
 /*
-- 
1.7.9.1

