Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964985Ab1DNSIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:08:25 -0400
Received: from mail.windriver.com ([147.11.1.11]:42165 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964968Ab1DNR6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:39 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 177/209] x86, gcc-4.6: Use gcc -m options when building vdso
Date: Thu, 14 Apr 2011 13:55:35 -0400
Message-Id: <1302803767-9715-64-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@linux.intel.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit de2a8cf98ecdde25231d6c5e7901e2cffaf32af9 upstream.

The vdso Makefile passes linker-style -m options not to the linker but
to gcc.  This happens to work with earlier gcc, but fails with gcc
4.6.  Pass gcc-style -m options, instead.

Note: all currently supported versions of gcc supports -m32, so there
is no reason to conditionalize it any more.

Reported-by: H. J. Lu <hjl.tools@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
LKML-Reference: <tip-*@git.kernel.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/vdso/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 6b4ffed..dd78ef6 100644
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
-- 
1.7.4.4

