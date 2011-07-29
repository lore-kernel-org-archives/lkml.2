Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab1G2S6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 14:58:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61825 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab1G2S6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 14:58:39 -0400
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org,
        Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@arndb.de>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de
Cc: Sedat Dilek <sedat.dilek@gmail.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] usercopy: Fixup patch to commit 4df97ff66a102a89ecfa2f88051e30bdd54ad864
Date: Fri, 29 Jul 2011 20:58:12 +0200
Message-Id: <1311965892-17026-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building with CONFIG_BINFMT_MISC=m linux-next (next-20110728) breaks:
ERROR: "copy_from_user_overflow" [fs/binfmt_misc.ko] undefined!

The issue was introduced by commit ab3b49d018924085e5d949c1af53fae0da9a8d94:
"The help text for this config is duplicated across the x86, parisc, and s390 Kconfig.debug files."

After reporting the issue to linux-next/LKML mailing-lists, Stephen Boyd
told me he had already sent a fix [1] which should be folded into [2].
Unfortunately, Stephen's fixup didn't get into Andrew's mmotm-tree and
find its way from there to linux-next.

Tested on x86_64 (Randy) and i386 (Sedat).

[1] https://lkml.org/lkml/2011/7/6/6
[2] http://userweb.kernel.org/~akpm/mmotm/broken-out/consolidate-config_debug_strict_user_copy_checks.patch

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Tested-by: Randy Dunlap <rdunlap@xenotime.net>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 lib/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/Makefile b/lib/Makefile
index fbf4b06..4ac9e49b 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -14,7 +14,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o find_next_bit.o
 
-lib-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
+obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
 
-- 
1.7.6

