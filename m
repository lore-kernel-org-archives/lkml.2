Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab2KRVF5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 16:05:57 -0500
Received: from vms173019pub.verizon.net ([206.46.173.19]:63407 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab2KRVEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 16:04:50 -0500
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Nov 2012 16:04:49 EST
From: pefoley2@verizon.net
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, mmarek@suse.cz
Cc: Peter Foley <pefoley2@verizon.net>
Subject: [PATCH 3/5] add eboot.o and efi_stub_$(BITS).o to $(targets)
Date: Sun, 18 Nov 2012 15:05:15 -0500
Message-id: <1353269117-39917-3-git-send-email-pefoley2@verizon.net>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1353269117-39917-1-git-send-email-pefoley2@verizon.net>
References: <1353269117-39917-1-git-send-email-pefoley2@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Foley <pefoley2@verizon.net>

eboot.o and efi_stub_$(BITS).o are not in $(targets) so they are rebuilt
every time make is invoked. Add them to $(targets) to prevent unnecessary
rebuilding of bzImage.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 arch/x86/boot/compressed/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 8a84501..9d7a898 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -4,7 +4,7 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
-targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.xz vmlinux.bin.lzo head_$(BITS).o misc.o string.o cmdline.o early_serial_console.o piggy.o
+targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.xz vmlinux.bin.lzo head_$(BITS).o misc.o string.o cmdline.o early_serial_console.o piggy.o eboot.o efi_stub_$(BITS).o
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
-- 
1.8.0

