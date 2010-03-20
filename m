Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739Ab0CTStN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 14:49:13 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:53192 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab0CTStL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 14:49:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=FpSvk+3IAic9WjD4y06lVy/uiMssHgLXHlGvUMMpPwWG/3/FpdDJnYJw4oFEK33E/2
         fuULAYy9xRATg9URdB8PVcJ7AxXGPW9LR78qYo4Ugq71V3q25Jsc5vsZ8kaYpWXdCaeh
         f8cjbeeXk9TzMuJ0l1Pn31KMDZdl7oXUY6Cp4=
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
Subject: [PATCH] uImage: Allow to specify MKIMAGE
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       microblaze-uclinux@itee.uq.edu.au, linux-sh@vger.kernel.org,
       hskinnemoen@atmel.com
Date: Sat, 20 Mar 2010 20:49:07 +0200
Message-ID: <20100320184907.8036.82488.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paulius Zaleckas <paulius.zaleckas@gmail.com>
---

 arch/arm/boot/Makefile          |    4 ++--
 arch/avr32/boot/images/Makefile |    4 ++--
 arch/blackfin/boot/Makefile     |    4 ++--
 arch/microblaze/boot/Makefile   |    4 ++--
 arch/sh/boot/Makefile           |    4 ++--
 scripts/mkuboot.sh              |    1 +
 6 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/Makefile b/arch/arm/boot/Makefile
index 4a590f4..8659463 100644
--- a/arch/arm/boot/Makefile
+++ b/arch/arm/boot/Makefile
@@ -11,7 +11,7 @@
 # Copyright (C) 1995-2002 Russell King
 #
 
-MKIMAGE         := $(srctree)/scripts/mkuboot.sh
+MKIMAGE         := $(CONFIG_SHELL) $(srctree)/scripts/mkuboot.sh
 
 ifneq ($(MACHINE),)
 include $(srctree)/$(MACHINE)/Makefile.boot
@@ -60,7 +60,7 @@ $(obj)/zImage:	$(obj)/compressed/vmlinux FORCE
 endif
 
 quiet_cmd_uimage = UIMAGE  $@
-      cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A arm -O linux -T kernel \
+      cmd_uimage = $(MKIMAGE) -A arm -O linux -T kernel \
 		   -C none -a $(LOADADDR) -e $(STARTADDR) \
 		   -n 'Linux-$(KERNELRELEASE)' -d $< $@
 
diff --git a/arch/avr32/boot/images/Makefile b/arch/avr32/boot/images/Makefile
index 1848bf0..f89c51d 100644
--- a/arch/avr32/boot/images/Makefile
+++ b/arch/avr32/boot/images/Makefile
@@ -6,7 +6,7 @@
 # for more details.
 #
 
-MKIMAGE		:= $(srctree)/scripts/mkuboot.sh
+MKIMAGE		:= $(CONFIG_SHELL) $(srctree)/scripts/mkuboot.sh
 
 extra-y		:= vmlinux.bin vmlinux.gz
 
@@ -18,7 +18,7 @@ $(obj)/vmlinux.gz: $(obj)/vmlinux.bin FORCE
 	$(call if_changed,gzip)
 
 quiet_cmd_uimage = UIMAGE $@
-      cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A avr32 -O linux -T kernel	\
+      cmd_uimage = $(MKIMAGE) -A avr32 -O linux -T kernel	\
 		-C gzip -a $(CONFIG_LOAD_ADDRESS) -e $(CONFIG_ENTRY_ADDRESS)	\
 		-n 'Linux-$(KERNELRELEASE)' -d $< $@
 
diff --git a/arch/blackfin/boot/Makefile b/arch/blackfin/boot/Makefile
index d1b3d60..cc82dc6 100644
--- a/arch/blackfin/boot/Makefile
+++ b/arch/blackfin/boot/Makefile
@@ -6,7 +6,7 @@
 # for more details.
 #
 
-MKIMAGE := $(srctree)/scripts/mkuboot.sh
+MKIMAGE := $(CONFIG_SHELL) $(srctree)/scripts/mkuboot.sh
 
 targets := vmImage vmImage.bin vmImage.bz2 vmImage.gz vmImage.lzma vmImage.xip
 extra-y += vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.xip
@@ -16,7 +16,7 @@ UIMAGE_OPTS-$(CONFIG_RAMKERNEL) += -a $(CONFIG_BOOT_LOAD)
 UIMAGE_OPTS-$(CONFIG_ROMKERNEL) += -a $(CONFIG_ROM_BASE) -x
 
 quiet_cmd_uimage = UIMAGE  $@
-      cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A $(ARCH) -O linux -T kernel \
+      cmd_uimage = $(MKIMAGE) -A $(ARCH) -O linux -T kernel \
                    -C $(2) -n '$(MACHINE)-$(KERNELRELEASE)' \
                    -e $(shell $(NM) vmlinux | awk '$$NF == "__start" {print $$1}') \
                    $(UIMAGE_OPTS-y) -d $< $@
diff --git a/arch/microblaze/boot/Makefile b/arch/microblaze/boot/Makefile
index 902cf98..2674b84 100644
--- a/arch/microblaze/boot/Makefile
+++ b/arch/microblaze/boot/Makefile
@@ -2,7 +2,7 @@
 # arch/microblaze/boot/Makefile
 #
 
-MKIMAGE := $(srctree)/scripts/mkuboot.sh
+MKIMAGE := $(CONFIG_SHELL) $(srctree)/scripts/mkuboot.sh
 
 obj-y += linked_dtb.o
 
@@ -40,7 +40,7 @@ quiet_cmd_strip = STRIP   $@
       cmd_strip = $(STRIP) -K _start -K _end -K __log_buf -K _fdt_start vmlinux -o $@
 
 quiet_cmd_uimage = UIMAGE  $@.ub
-      cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A microblaze -O linux -T kernel \
+      cmd_uimage = $(MKIMAGE) -A microblaze -O linux -T kernel \
                    -C none -n 'Linux-$(KERNELRELEASE)' \
                    -a $(CONFIG_KERNEL_BASE_ADDR) -e $(CONFIG_KERNEL_BASE_ADDR) \
                    -d $@ $@.ub
diff --git a/arch/sh/boot/Makefile b/arch/sh/boot/Makefile
index 1ce6362..a3d5cc5 100644
--- a/arch/sh/boot/Makefile
+++ b/arch/sh/boot/Makefile
@@ -8,7 +8,7 @@
 # Copyright (C) 1999 Stuart Menefy
 #
 
-MKIMAGE := $(srctree)/scripts/mkuboot.sh
+MKIMAGE := $(CONFIG_SHELL) $(srctree)/scripts/mkuboot.sh
 
 #
 # Assign safe dummy values if these variables are not defined,
@@ -60,7 +60,7 @@ KERNEL_ENTRY	:= $(shell /bin/bash -c 'printf "0x%08x" \
 			$(CONFIG_ZERO_PAGE_OFFSET) + $(CONFIG_ENTRY_OFFSET)]')
 
 quiet_cmd_uimage = UIMAGE  $@
-      cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A sh -O linux -T kernel \
+      cmd_uimage = $(MKIMAGE) -A sh -O linux -T kernel \
 		   -C $(2) -a $(KERNEL_LOAD) -e $(KERNEL_ENTRY) \
 		   -n 'Linux-$(KERNELRELEASE)' -d $< $@
 
diff --git a/scripts/mkuboot.sh b/scripts/mkuboot.sh
index 2e3d3cd..690f25f 100755
--- a/scripts/mkuboot.sh
+++ b/scripts/mkuboot.sh
@@ -11,6 +11,7 @@ if [ -z "${MKIMAGE}" ]; then
 	if [ -z "${MKIMAGE}" ]; then
 		# Doesn't exist
 		echo '"mkimage" command not found - U-Boot images will not be built' >&2
+		echo 'You can use MKIMAGE to specify path (eg. MKIMAGE=/tmp/mkimage)' >&2
 		exit 0;
 	fi
 fi

