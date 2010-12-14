Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab0LNAKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 19:10:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:36981 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756138Ab0LNAKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 19:10:14 -0500
Date: Tue, 14 Dec 2010 00:09:52 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        stable@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        hjl.tools@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        hjl.tools@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, gcc-4.6: Use gcc -m options when building vdso
Message-ID: <tip-de2a8cf98ecdde25231d6c5e7901e2cffaf32af9@git.kernel.org>
Git-Commit-ID: de2a8cf98ecdde25231d6c5e7901e2cffaf32af9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 14 Dec 2010 00:09:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  de2a8cf98ecdde25231d6c5e7901e2cffaf32af9
Gitweb:     http://git.kernel.org/tip/de2a8cf98ecdde25231d6c5e7901e2cffaf32af9
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Mon, 13 Dec 2010 16:01:38 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 13 Dec 2010 16:08:37 -0800

x86, gcc-4.6: Use gcc -m options when building vdso

The vdso Makefile passes linker-style -m options not to the linker but
to gcc.  This happens to work with earlier gcc, but fails with gcc
4.6.  Pass gcc-style -m options, instead.

Note: all currently supported versions of gcc supports -m32, so there
is no reason to conditionalize it any more.

Reported-by: H. J. Lu <hjl.tools@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
LKML-Reference: <tip-*@git.kernel.org>
Cc: <stable@kernel.org>
---
 arch/x86/vdso/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 4a2afa1..b6552b1 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -25,7 +25,7 @@ targets += vdso.so vdso.so.dbg vdso.lds $(vobjs-y)
 
 export CPPFLAGS_vdso.lds += -P -C
 
-VDSO_LDFLAGS_vdso.lds = -m elf_x86_64 -Wl,-soname=linux-vdso.so.1 \
+VDSO_LDFLAGS_vdso.lds = -m64 -Wl,-soname=linux-vdso.so.1 \
 		      	-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
 
 $(obj)/vdso.o: $(src)/vdso.S $(obj)/vdso.so
@@ -69,7 +69,7 @@ vdso32.so-$(VDSO32-y)		+= sysenter
 vdso32-images			= $(vdso32.so-y:%=vdso32-%.so)
 
 CPPFLAGS_vdso32.lds = $(CPPFLAGS_vdso.lds)
-VDSO_LDFLAGS_vdso32.lds = -m elf_i386 -Wl,-soname=linux-gate.so.1
+VDSO_LDFLAGS_vdso32.lds = -m32 -Wl,-soname=linux-gate.so.1
 
 # This makes sure the $(obj) subdirectory exists even though vdso32/
 # is not a kbuild sub-make subdirectory.
