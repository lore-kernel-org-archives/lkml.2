Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2GZWAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 18:00:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab2GZWA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 18:00:27 -0400
From: Matthew Garrett <mjg@redhat.com>
To: matt.fleming@intel.com
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] efi: Build EFI stub with EFI-appropriate options
Date: Thu, 26 Jul 2012 18:00:00 -0400
Message-Id: <1343340000-7587-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can't assume the presence of the red zone while we're still in a boot
services environment, so we should build with -fno-red-zone to avoid
problems. Change the size of wchar at the same time to make string handling
simpler.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 arch/x86/boot/compressed/Makefile |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index e398bb5..8a84501 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -28,6 +28,9 @@ VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
 	$(obj)/string.o $(obj)/cmdline.o $(obj)/early_serial_console.o \
 	$(obj)/piggy.o
 
+$(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
+$(obj)/efi_stub_$(BITS).o: KBUILD_CLFAGS += -fshort-wchar -mno-red-zone
+
 ifeq ($(CONFIG_EFI_STUB), y)
 	VMLINUX_OBJS += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o
 endif
-- 
1.7.10.4

