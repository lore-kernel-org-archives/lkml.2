Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab0KPWmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 17:42:46 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38110 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758260Ab0KPWmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 17:42:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YdF8imRk9H2sDtso+LpF0GNYpLydFSyn9TjbLj2lFVifA0Ti9S5z8Q9O+9LhQi+G2e
         G+lA3rI5ff4g1c3Qq4KWCjnM86mRqRbnEPoVM05dO3rcInZ1FCi/7VT3CJTwdyujzHKa
         YbvGroWS/SL6KAVG4fesSnkQurdZYw6F6LGuc=
From: dirk.brandewie@gmail.com
To: devicetree-discuss@lists.ozlabs.org
Cc: sodaville@linutronix.de, arjan@linux.intel.com, dirk.brandewie@gmail.com,
        linuxppc-dev@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au,
        linux-arch@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] of/microblaze: Move build to use generic dts->dtb rule
Date: Tue, 16 Nov 2010 14:41:40 -0800
Message-Id: <7828dfd67fafcc2bb41e5bde40ac2ed7ef429142.1289943240.git.dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1289943240.git.dirk.brandewie@gmail.com>
References: <cover.1289943240.git.dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

This patch changes arch/microblaze/boot/Makefile to use the generic
rule build the device tree blobs in scripts/Makefile.lib

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 arch/microblaze/boot/Makefile |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/arch/microblaze/boot/Makefile b/arch/microblaze/boot/Makefile
index be01d78..4fda765 100644
--- a/arch/microblaze/boot/Makefile
+++ b/arch/microblaze/boot/Makefile
@@ -10,9 +10,6 @@ targets := linux.bin linux.bin.gz simpleImage.%
 
 OBJCOPYFLAGS := -O binary
 
-# Where the DTS files live
-dtstree         := $(srctree)/$(src)/dts
-
 # Ensure system.dtb exists
 $(obj)/linked_dtb.o: $(obj)/system.dtb
 
@@ -51,14 +48,6 @@ $(obj)/simpleImage.%: vmlinux FORCE
 	$(call if_changed,strip)
 	@echo 'Kernel: $@ is ready' ' (#'`cat .version`')'
 
-# Rule to build device tree blobs
-DTC = $(objtree)/scripts/dtc/dtc
-
-# Rule to build device tree blobs
-quiet_cmd_dtc = DTC     $@
-	cmd_dtc = $(DTC) -O dtb -o $(obj)/$*.dtb -b 0 -p 1024 $(dtstree)/$*.dts
-
-$(obj)/%.dtb: $(dtstree)/%.dts FORCE
-	$(call if_changed,dtc)
+DTS_FLAGS := -p 1024
 
 clean-files += *.dtb simpleImage.*.unstrip linux.bin.ub
-- 
1.7.2.3

