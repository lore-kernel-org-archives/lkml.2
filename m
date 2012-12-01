Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab2LANYz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 08:24:55 -0500
Received: from smtp-out-239.synserver.de ([212.40.185.239]:1202 "EHLO
	smtp-out-239.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab2LANYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 08:24:17 -0500
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
Subject: [PATCH resend 5/5] xtensa: Use generic asm/mmu.h for nommu
Date: Sat,  1 Dec 2012 14:24:44 +0100
Message-Id: <1354368284-11625-5-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1354368284-11625-1-git-send-email-lars@metafoo.de>
References: <1354368284-11625-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nommu portion of mmu.h of the extensa platform is basically the same as the
asm-generic mmu.h. So use it instead.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

---
Note, due to lack of toolchain, etc this patch is completely untested.
---
 arch/xtensa/include/asm/mmu.h   |    2 +-
 arch/xtensa/include/asm/nommu.h |    3 ---
 2 files changed, 1 insertions(+), 4 deletions(-)
 delete mode 100644 arch/xtensa/include/asm/nommu.h

diff --git a/arch/xtensa/include/asm/mmu.h b/arch/xtensa/include/asm/mmu.h
index 04890d6..8554b2c 100644
--- a/arch/xtensa/include/asm/mmu.h
+++ b/arch/xtensa/include/asm/mmu.h
@@ -12,7 +12,7 @@
 #define _XTENSA_MMU_H
 
 #ifndef CONFIG_MMU
-#include <asm/nommu.h>
+#include <asm-generic/mmu.h>
 #else
 
 /* Default "unsigned long" context */
diff --git a/arch/xtensa/include/asm/nommu.h b/arch/xtensa/include/asm/nommu.h
deleted file mode 100644
index dce2c43..0000000
--- a/arch/xtensa/include/asm/nommu.h
+++ /dev/null
@@ -1,3 +0,0 @@
-typedef struct {
-	unsigned long end_brk;
-} mm_context_t;
-- 
1.7.2.5

