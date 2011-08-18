Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1HRTGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:06:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47462 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab1HRTGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:06:20 -0400
Date: Thu, 18 Aug 2011 20:06:19 +0100
To: richard@nod.at
Subject: Subject: [PATCH 44/91] um: trim detritus from Makefile-i386
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7v1-0007ks-KC@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/Makefile-i386 |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/um/Makefile-i386 b/arch/um/Makefile-i386
index 7e5f1ba..57acfd6 100644
--- a/arch/um/Makefile-i386
+++ b/arch/um/Makefile-i386
@@ -1,13 +1,10 @@
 core-y += arch/um/sys-x86/ arch/x86/crypto/
 
-TOP_ADDR := $(CONFIG_TOP_ADDR)
-
 START := 0x8048000
 
 LDFLAGS			+= -m elf_i386
-ELF_ARCH		:= $(SUBARCH)
-ELF_FORMAT 		:= elf32-$(SUBARCH)
-OBJCOPYFLAGS  		:= -O binary -R .note -R .comment -S
+ELF_ARCH		:= i386
+ELF_FORMAT 		:= elf32-i386
 HEADER_ARCH		:= x86
 CHECKFLAGS	+= -D__i386__
 
@@ -16,9 +13,8 @@ ifneq ("$(shell uname -m | sed -e s/i.86/i386/)", "$(SUBARCH)")
 KBUILD_CFLAGS		+= $(call cc-option,-m32)
 KBUILD_AFLAGS		+= $(call cc-option,-m32)
 LINK-y			+= $(call cc-option,-m32)
-UML_OBJCOPYFLAGS	+= -F $(ELF_FORMAT)
 
-export LDFLAGS HOSTCFLAGS HOSTLDFLAGS UML_OBJCOPYFLAGS
+export LDFLAGS
 endif
 endif
 
-- 
1.7.2.5


