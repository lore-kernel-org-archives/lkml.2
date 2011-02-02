Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab1BBA5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:57:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:10285 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529Ab1BBAog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="598622526"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: hpa@linux.intel.com, ak@linux.intel.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [89/139] x86, gcc-4.6: Use gcc -m options when building vdso
Message-Id: <20110202004446.E269C3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: H. Peter Anvin <hpa@linux.intel.com>

commit de2a8cf98ecdde25231d6c5e7901e2cffaf32af9 upstream.

The vdso Makefile passes linker-style -m options not to the linker but
to gcc.  This happens to work with earlier gcc, but fails with gcc
4.6.  Pass gcc-style -m options, instead.

Note: all currently supported versions of gcc supports -m32, so there
is no reason to conditionalize it any more.

Reported-by: H. J. Lu <hjl.tools@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <tip-*@git.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/vdso/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/arch/x86/vdso/Makefile
===================================================================
--- linux-2.6.35.y.orig/arch/x86/vdso/Makefile
+++ linux-2.6.35.y/arch/x86/vdso/Makefile
@@ -25,7 +25,7 @@ targets += vdso.so vdso.so.dbg vdso.lds 
 
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
