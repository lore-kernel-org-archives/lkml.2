Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab2LANYS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 08:24:18 -0500
Received: from smtp-out-239.synserver.de ([212.40.185.239]:1392 "EHLO
	smtp-out-239.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab2LANYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 08:24:14 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 11086
From: Lars-Peter Clausen <lars@metafoo.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Salter <msalter@redhat.com>, Aurelien Jacquiot <a-jacquiot@ti.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        linux-c6x-dev@linux-c6x.org, linux-kernel@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, linux-arch@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH resend 3/5] c6x: Use generic asm/mmu.h
Date: Sat,  1 Dec 2012 14:24:42 +0100
Message-Id: <1354368284-11625-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1354368284-11625-1-git-send-email-lars@metafoo.de>
References: <1354368284-11625-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

c6x's asm/mmu.h is basically identical to asm-generic/mmu.h, so use it instead
of the custom version.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Mark Salter <msalter@redhat.com>
Tested-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/include/asm/Kbuild |    1 +
 arch/c6x/include/asm/mmu.h  |   22 ----------------------
 2 files changed, 1 insertions(+), 22 deletions(-)
 delete mode 100644 arch/c6x/include/asm/mmu.h

diff --git a/arch/c6x/include/asm/Kbuild b/arch/c6x/include/asm/Kbuild
index 112a496..3c8b660 100644
--- a/arch/c6x/include/asm/Kbuild
+++ b/arch/c6x/include/asm/Kbuild
@@ -25,6 +25,7 @@ generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += local.h
 generic-y += mman.h
+generic-y += mmu.h
 generic-y += mmu_context.h
 generic-y += msgbuf.h
 generic-y += param.h
diff --git a/arch/c6x/include/asm/mmu.h b/arch/c6x/include/asm/mmu.h
deleted file mode 100644
index 4467e77..0000000
--- a/arch/c6x/include/asm/mmu.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/*
- *  Port on Texas Instruments TMS320C6x architecture
- *
- *  Copyright (C) 2004, 2009, 2010 Texas Instruments Incorporated
- *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2 as
- *  published by the Free Software Foundation.
- */
-#ifndef _ASM_C6X_MMU_H
-#define _ASM_C6X_MMU_H
-
-typedef struct {
-	unsigned long		end_brk;
-#ifdef CONFIG_BINFMT_ELF_FDPIC
-	unsigned long	exec_fdpic_loadmap;
-	unsigned long	interp_fdpic_loadmap;
-#endif
-} mm_context_t;
-
-#endif /* _ASM_C6X_MMU_H */
-- 
1.7.2.5

