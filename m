Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab0IMIdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:33:54 -0400
Received: from ist.d-labs.de ([213.239.218.44]:45704 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab0IMIdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:33:53 -0400
From: florian@mickler.org
To: x86@kernel.org
Cc: Florian Mickler <florian@mickler.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] x86: don't compile with gcc-3.3.3
Date: Mon, 13 Sep 2010 10:31:47 +0200
Message-Id: <1284366708-30154-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hpa commented on bug 16506[1] :
"Please note that gcc-3.3.3 is known broken on x86; gcc-3.4 is the oldest
version which is known to *not* be broken."

References: 
	[0]: https://bugzilla.kernel.org/show_bug.cgi?id=16633
	[1]: https://bugzilla.kernel.org/show_bug.cgi?id=16506#c28

If that is indeed so, we should abort the build? No?


---
 arch/x86/Makefile |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 8aa1b59..1eb2d99 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -153,7 +153,7 @@ all: bzImage
 # KBUILD_IMAGE specify target image being built
 KBUILD_IMAGE := $(boot)/bzImage
 
-bzImage: vmlinux
+bzImage: checkgccversion vmlinux
 ifeq ($(CONFIG_X86_DECODER_SELFTEST),y)
 	$(Q)$(MAKE) $(build)=arch/x86/tools posttest
 endif
@@ -172,6 +172,12 @@ PHONY += vdso_install
 vdso_install:
 	$(Q)$(MAKE) $(build)=arch/x86/vdso $@
 
+checkgccversion:
+	$(Q)if test "$(call cc-fullversion)" = "040403" ; then \
+		echo "*** GCC-3.3.3 is known broken. Please upgrade." ; \
+		echo "*** GCC-3.4 is the earliest version known *not* broken." ; \
+		false ; \
+	fi
 archclean:
 	$(Q)rm -rf $(objtree)/arch/i386
 	$(Q)rm -rf $(objtree)/arch/x86_64
-- 
1.7.2

