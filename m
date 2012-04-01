Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab2DASyq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 14:54:46 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:55629 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab2DASyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 14:54:44 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: davem@davemloft.net, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: mroos@linux.ee
Subject: [PATCH] sparc: pgtable_64: change include order
Date: Sun,  1 Apr 2012 21:54:38 +0300
Message-Id: <1333306478-26266-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following build breakage in v3.4-rc1:

  CC      arch/sparc/kernel/cpu.o
In file included from /home/aaro/git/linux/arch/sparc/include/asm/pgtable_64.h:15:0,
                 from /home/aaro/git/linux/arch/sparc/include/asm/pgtable.h:4,
                 from arch/sparc/kernel/cpu.c:15:
include/asm-generic/pgtable-nopud.h:13:16: error: unknown type name 'pgd_t'
include/asm-generic/pgtable-nopud.h:25:28: error: unknown type name 'pgd_t'
include/asm-generic/pgtable-nopud.h:26:27: error: unknown type name 'pgd_t'
include/asm-generic/pgtable-nopud.h:27:31: error: unknown type name 'pgd_t'
include/asm-generic/pgtable-nopud.h:28:30: error: unknown type name 'pgd_t'
include/asm-generic/pgtable-nopud.h:38:34: error: unknown type name 'pgd_t'
In file included from /home/aaro/git/linux/arch/sparc/include/asm/pgtable_64.h:783:0,
                 from /home/aaro/git/linux/arch/sparc/include/asm/pgtable.h:4,
                 from arch/sparc/kernel/cpu.c:15:
include/asm-generic/pgtable.h: In function 'pgd_none_or_clear_bad':
include/asm-generic/pgtable.h:258:2: error: implicit declaration of function 'pgd_none' [-Werror=implicit-function-declaration]
include/asm-generic/pgtable.h:260:2: error: implicit declaration of function 'pgd_bad' [-Werror=implicit-function-declaration]
include/asm-generic/pgtable.h: In function 'pud_none_or_clear_bad':
include/asm-generic/pgtable.h:269:6: error: request for member 'pgd' in something not a structure or union

Reported-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 arch/sparc/include/asm/pgtable_64.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 6fa2f79..76e4a52 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -12,8 +12,6 @@
  * the SpitFire page tables.
  */
 
-#include <asm-generic/pgtable-nopud.h>
-
 #include <linux/compiler.h>
 #include <linux/const.h>
 #include <asm/types.h>
@@ -22,6 +20,8 @@
 #include <asm/page.h>
 #include <asm/processor.h>
 
+#include <asm-generic/pgtable-nopud.h>
+
 /* The kernel image occupies 0x4000000 to 0x6000000 (4MB --> 96MB).
  * The page copy blockops can use 0x6000000 to 0x8000000.
  * The TSB is mapped in the 0x8000000 to 0xa000000 range.
-- 
1.7.2.5

