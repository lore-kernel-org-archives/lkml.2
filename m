Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761034Ab2KAKYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 06:24:10 -0400
Received: from smtp-out-183.synserver.de ([212.40.185.183]:1188 "EHLO
	smtp-out-183.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759907Ab2KAKYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 06:24:04 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 27679
From: Lars-Peter Clausen <lars@metafoo.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Salter <msalter@redhat.com>, Aurelien Jacquiot <a-jacquiot@ti.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        linux-c6x-dev@linux-c6x.org, linux-kernel@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, linux-arch@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 3/5] h8300: Use generic asm/mmu.h
Date: Thu,  1 Nov 2012 11:24:25 +0100
Message-Id: <1351765467-29244-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1351765467-29244-1-git-send-email-lars@metafoo.de>
References: <1351765467-29244-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

h8300's asm/mmu.h is basically identical to asm-generic/mmu.h, so use it instead
of the custom version.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

---
Note, due to lack of toolchain, etc this patch is completely untested.
---
 arch/h8300/include/asm/Kbuild |    1 +
 arch/h8300/include/asm/mmu.h  |   10 ----------
 2 files changed, 1 insertions(+), 10 deletions(-)
 delete mode 100644 arch/h8300/include/asm/mmu.h

diff --git a/arch/h8300/include/asm/Kbuild b/arch/h8300/include/asm/Kbuild
index 50bbf38..173de77 100644
--- a/arch/h8300/include/asm/Kbuild
+++ b/arch/h8300/include/asm/Kbuild
@@ -2,4 +2,5 @@ include include/asm-generic/Kbuild.asm
 
 generic-y += clkdev.h
 generic-y += exec.h
+generic-y += mmu.h
 generic-y += module.h
diff --git a/arch/h8300/include/asm/mmu.h b/arch/h8300/include/asm/mmu.h
deleted file mode 100644
index 3130996..0000000
--- a/arch/h8300/include/asm/mmu.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef __MMU_H
-#define __MMU_H
-
-/* Copyright (C) 2002, David McCullough <davidm@snapgear.com> */
-
-typedef struct {
-	unsigned long		end_brk;
-} mm_context_t;
-
-#endif
-- 
1.7.2.5

