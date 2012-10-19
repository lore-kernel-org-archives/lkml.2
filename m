Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945907Ab2JSUjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 16:39:35 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:56107 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932822Ab2JSUjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 16:39:33 -0400
Message-ID: <201210192039.q9JKdUE5003952@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 19 Oct 2012 16:29:43 -0400
Subject: [PATCH] arch/tile: avoid build warnings from duplicate ELF_R_xxx #defines
To: <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>,
        Sam Ravnborg <sam@ravnborg.org>, Rusty Russell <rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are now provided in <asm-generic/module.h>, so clean up warning
by not re-defining them in module.c.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/module.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/tile/kernel/module.c b/arch/tile/kernel/module.c
index 001cbfa..243ffeb 100644
--- a/arch/tile/kernel/module.c
+++ b/arch/tile/kernel/module.c
@@ -24,16 +24,6 @@
 #include <asm/homecache.h>
 #include <arch/opcode.h>
 
-#ifdef __tilegx__
-# define Elf_Rela Elf64_Rela
-# define ELF_R_SYM ELF64_R_SYM
-# define ELF_R_TYPE ELF64_R_TYPE
-#else
-# define Elf_Rela Elf32_Rela
-# define ELF_R_SYM ELF32_R_SYM
-# define ELF_R_TYPE ELF32_R_TYPE
-#endif
-
 #ifdef MODULE_DEBUG
 #define DEBUGP printk
 #else
-- 
1.7.10.3

