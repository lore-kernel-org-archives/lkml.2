Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab1G3XCR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 19:02:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:48823 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab1G3XCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 19:02:06 -0400
Subject: [PATCH 1/5] um: Use __i386__ in ifdef for vsyscall exports, not
 SUBARCH_i386
From: David Woodhouse <dwmw2@infradead.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Date: Sun, 31 Jul 2011 00:02:02 +0100
In-Reply-To: <1312066693.22074.50.camel@i7.infradead.org>
References: <1312066693.22074.50.camel@i7.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312066923.22074.53.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 arch/um/os-Linux/Makefile    |    2 --
 arch/um/os-Linux/user_syms.c |    2 +-
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/um/os-Linux/Makefile b/arch/um/os-Linux/Makefile
index b33f4df..78658a7 100644
--- a/arch/um/os-Linux/Makefile
+++ b/arch/um/os-Linux/Makefile
@@ -13,8 +13,6 @@ USER_OBJS := $(user-objs-y) aio.o elf_aux.o execvp.o file.o helper.o irq.o \
 	main.o mem.o process.o registers.o sigio.o signal.o start_up.o time.o \
 	tty.o tls.o uaccess.o umid.o util.o
 
-CFLAGS_user_syms.o += -DSUBARCH_$(SUBARCH)
-
 HAVE_AIO_ABI := $(shell [ -r /usr/include/linux/aio_abi.h ] && \
 	echo -DHAVE_AIO_ABI )
 CFLAGS_aio.o += $(HAVE_AIO_ABI)
diff --git a/arch/um/os-Linux/user_syms.c b/arch/um/os-Linux/user_syms.c
index 45ffe46..9165513 100644
--- a/arch/um/os-Linux/user_syms.c
+++ b/arch/um/os-Linux/user_syms.c
@@ -45,7 +45,7 @@ EXPORT_SYMBOL(readdir64);
 extern void truncate64(void) __attribute__((weak));
 EXPORT_SYMBOL(truncate64);
 
-#ifdef SUBARCH_i386
+#ifdef __i386__
 EXPORT_SYMBOL(vsyscall_ehdr);
 EXPORT_SYMBOL(vsyscall_end);
 #endif
-- 
1.7.6



