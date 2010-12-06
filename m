Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab0LFRg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:36:27 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38872 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab0LFRgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:36:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pd+kC9sMGSWFQ6atR3wjDIGfjTgOi5kx97V8rfxAZQpvsJZRWvUnseDKg4bPGCKYua
         2sIhmX3Wm8n9rkDrO680rR5ZV7/jyS1rY/225fn5NZIJ5CVvgyKgrpDPXBuQeX1acJfK
         IOnqMLPjot+qJTkt9lJKYPRlcUs8h5N8wQ63o=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, sodaville@linutronix.de,
        linuxppc-dev@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au,
        linux-arch@vger.kernel.org, mmarek@suse.cz,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 4/4] microblaze/of: Use generic rule to build dtb's
Date: Mon,  6 Dec 2010 09:36:02 -0800
Message-Id: <166d47e864aa8a41b2aa0f9ebc42d9b60afba21f.1291656753.git.dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1291656753.git.dirk.brandewie@gmail.com>
References: <cover.1291656753.git.dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Modify arch/powerpc/boot/Makefile to use dtc command in
scripts/Makefile.lib

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 arch/microblaze/boot/Makefile |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/microblaze/boot/Makefile b/arch/microblaze/boot/Makefile
index be01d78..52430e5 100644
--- a/arch/microblaze/boot/Makefile
+++ b/arch/microblaze/boot/Makefile
@@ -10,9 +10,6 @@ targets := linux.bin linux.bin.gz simpleImage.%
 
 OBJCOPYFLAGS := -O binary
 
-# Where the DTS files live
-dtstree         := $(srctree)/$(src)/dts
-
 # Ensure system.dtb exists
 $(obj)/linked_dtb.o: $(obj)/system.dtb
 
@@ -51,14 +48,11 @@ $(obj)/simpleImage.%: vmlinux FORCE
 	$(call if_changed,strip)
 	@echo 'Kernel: $@ is ready' ' (#'`cat .version`')'
 
-# Rule to build device tree blobs
-DTC = $(objtree)/scripts/dtc/dtc
 
 # Rule to build device tree blobs
-quiet_cmd_dtc = DTC     $@
-	cmd_dtc = $(DTC) -O dtb -o $(obj)/$*.dtb -b 0 -p 1024 $(dtstree)/$*.dts
+DTC_FLAGS := -p 1024
 
-$(obj)/%.dtb: $(dtstree)/%.dts FORCE
+$(obj)/%.dtb: $(src)/dts/%.dts FORCE
 	$(call if_changed,dtc)
 
 clean-files += *.dtb simpleImage.*.unstrip linux.bin.ub
-- 
1.7.2.3

