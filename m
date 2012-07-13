Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab2GMVUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 17:20:48 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:47400 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758166Ab2GMVUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 17:20:41 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Hirokazu Takata <takata@linux-m32r.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m32r@ml.linux-m32r.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 4/6] m32r: Consistently use "suffix-$(...)"
Date: Fri, 13 Jul 2012 23:20:25 +0200
Message-Id: <1342214427-17607-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1342214427-17607-1-git-send-email-geert@linux-m68k.org>
References: <1342214427-17607-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit a556bec9955c8e47b40a87dbfeef6f24d3b2228f ("m32r: fix
arch/m32r/boot/compressed/Makefile") changed "$(suffix_y)" to
"$(suffix-y)", but didn't update any location where "suffix_y" is set,
causing:

make[5]: *** No rule to make target `arch/m32r/boot/compressed/vmlinux.bin.', needed by `arch/m32r/boot/compressed/piggy.o'.  Stop.
make[4]: *** [arch/m32r/boot/compressed/vmlinux] Error 2
make[3]: *** [zImage] Error 2

Correct the other locations to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m32r/boot/compressed/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/m32r/boot/compressed/Makefile b/arch/m32r/boot/compressed/Makefile
index 177716b..01729c2 100644
--- a/arch/m32r/boot/compressed/Makefile
+++ b/arch/m32r/boot/compressed/Makefile
@@ -43,9 +43,9 @@ endif
 
 OBJCOPYFLAGS += -R .empty_zero_page
 
-suffix_$(CONFIG_KERNEL_GZIP)	= gz
-suffix_$(CONFIG_KERNEL_BZIP2)	= bz2
-suffix_$(CONFIG_KERNEL_LZMA)	= lzma
+suffix-$(CONFIG_KERNEL_GZIP)	= gz
+suffix-$(CONFIG_KERNEL_BZIP2)	= bz2
+suffix-$(CONFIG_KERNEL_LZMA)	= lzma
 
 $(obj)/piggy.o: $(obj)/vmlinux.scr $(obj)/vmlinux.bin.$(suffix-y) FORCE
 	$(call if_changed,ld)
-- 
1.7.0.4

