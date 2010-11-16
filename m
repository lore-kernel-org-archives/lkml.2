Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282Ab0KPWmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 17:42:24 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38110 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757009Ab0KPWmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 17:42:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Tj581bxAzZ4nhy4BmOXrJCYcWHTsiJpJi8f3XXaA1JtT3sa582G0Y5bVPwC08qc5gh
         EBbBm2tq3XsdxvY0KQxa8X7Iho7OCFQfd4l3SfHYf9i+ZYdk3Oizquvw7pZ2gPAUHoiq
         a0RskK4HbSPU5AJQddxiaSW7iuoQvcEIqDwfw=
From: dirk.brandewie@gmail.com
To: devicetree-discuss@lists.ozlabs.org
Cc: sodaville@linutronix.de, arjan@linux.intel.com, dirk.brandewie@gmail.com,
        linuxppc-dev@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au,
        linux-arch@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] of/powerpc: Move build to use generic dts->dtb rule
Date: Tue, 16 Nov 2010 14:41:39 -0800
Message-Id: <dae91d8292876db96f96896b79076c32cd2bf467.1289943240.git.dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1289943240.git.dirk.brandewie@gmail.com>
References: <cover.1289943240.git.dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

This patch changes arch/powerpc/boot/Makefile to use the generic
rule build the device tree blobs in scripts/Makefile.lib

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 arch/powerpc/boot/Makefile |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index fae8192..d90c674 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -147,8 +147,6 @@ targets		+= $(patsubst $(obj)/%,%,$(obj-boot) wrapper.a)
 extra-y		:= $(obj)/wrapper.a $(obj-plat) $(obj)/empty.o \
 		   $(obj)/zImage.lds $(obj)/zImage.coff.lds $(obj)/zImage.ps3.lds
 
-dtstree		:= $(srctree)/$(src)/dts
-
 wrapper		:=$(srctree)/$(src)/wrapper
 wrapperbits	:= $(extra-y) $(addprefix $(obj)/,addnote hack-coff mktree) \
 			$(wrapper) FORCE
@@ -331,11 +329,6 @@ $(obj)/treeImage.initrd.%: vmlinux $(obj)/%.dtb $(wrapperbits)
 $(obj)/treeImage.%: vmlinux $(obj)/%.dtb $(wrapperbits)
 	$(call if_changed,wrap,treeboot-$*,,$(obj)/$*.dtb)
 
-# Rule to build device tree blobs
-DTC = $(objtree)/scripts/dtc/dtc
-
-$(obj)/%.dtb: $(dtstree)/%.dts
-	$(DTC) -O dtb -o $(obj)/$*.dtb -b 0 $(DTS_FLAGS) $(dtstree)/$*.dts
 
 # If there isn't a platform selected then just strip the vmlinux.
 ifeq (,$(image-y))
-- 
1.7.2.3

