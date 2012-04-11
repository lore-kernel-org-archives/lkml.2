Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975Ab2DKCXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 22:23:38 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39787 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798Ab2DKCXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 22:23:37 -0400
Date: Tue, 10 Apr 2012 22:23:33 -0400
Message-Id: <E1SHnDZ-0006Za-Kh@tytso-glaptop.cam.corp.google.com>
To: linux-kernel@vger.kernel.org, hjl.tools@gmail.com
Subject: Trying to make a working kernel with the gold linker
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So I was trying to see if I could make the kernel build with the gold
linker (since until it can, I can't install it on my system).

I saw a message from HJ indicating one of the problems was x86_64 gold
used an incompatible max-page-size setting, so I tried changing it in
hopes that would make a bootable kernel.

No dice, it didn't work.  (At least not with a 2.20 binutils-gold.)

Does anybody know what the other issues with the gold linker?  Is the
2.22 binutils-gold more likely to work?

Thanks,

					- Ted


diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 41a7237..ad769ed 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -119,7 +119,11 @@ asinstr := $(call as-instr,fxsaveq (%rax),-DCONFIG_AS_FXSAVEQ=1)
 KBUILD_AFLAGS += $(cfi) $(cfi-sigframe) $(cfi-sections) $(asinstr)
 KBUILD_CFLAGS += $(cfi) $(cfi-sigframe) $(cfi-sections) $(asinstr)
 
+ifeq ($(CONFIG_X86_32),y)
 LDFLAGS := -m elf_$(UTS_MACHINE)
+else
+LDFLAGS := -m elf_$(UTS_MACHINE) -z max-page-size=0x200000
+endif
 
 # Speed up the build
 KBUILD_CFLAGS += -pipe
