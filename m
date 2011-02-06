Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab1BFXqy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:46:54 -0500
Received: from 1wt.eu ([62.212.114.60]:60332 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470Ab1BFXqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:46:53 -0500
Message-Id: <20110206232253.336029706@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 00:23:11 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 19/23] x86, gcc-4.6: Use gcc -m options when building vdso
In-Reply-To: <4beed4da27f06efb2c13d6ed48850634@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.58-stable review patch.  If anyone has any objections, please let us know.

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
LKML-Reference: <tip-*@git.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Index: longterm-2.6.27/arch/x86/vdso/Makefile
===================================================================
--- longterm-2.6.27.orig/arch/x86/vdso/Makefile	2011-01-29 11:19:14.676064283 +0100
+++ longterm-2.6.27/arch/x86/vdso/Makefile	2011-01-29 11:27:24.890063749 +0100
@@ -25,7 +25,7 @@
 
 export CPPFLAGS_vdso.lds += -P -C
 
-VDSO_LDFLAGS_vdso.lds = -m elf_x86_64 -Wl,-soname=linux-vdso.so.1 \
+VDSO_LDFLAGS_vdso.lds = -m64 -Wl,-soname=linux-vdso.so.1 \
 		      	-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
 
 $(obj)/vdso.o: $(src)/vdso.S $(obj)/vdso.so
@@ -69,7 +69,7 @@
 vdso32-images			= $(vdso32.so-y:%=vdso32-%.so)
 
 CPPFLAGS_vdso32.lds = $(CPPFLAGS_vdso.lds)
-VDSO_LDFLAGS_vdso32.lds = -m elf_i386 -Wl,-soname=linux-gate.so.1
+VDSO_LDFLAGS_vdso32.lds = -m32 -Wl,-soname=linux-gate.so.1
 
 # This makes sure the $(obj) subdirectory exists even though vdso32/
 # is not a kbuild sub-make subdirectory.


