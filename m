Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab0LIJes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 04:34:48 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:53315 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410Ab0LIJer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 04:34:47 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv1 005/211] unicore32: new file arch/unicore32/boot/Makefile
Date: Thu, 9 Dec 2010 17:34:44 +0800
Message-ID: <01d401cb9784$4ffed890$effc89b0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcuXhEluP65hdt31Q2eAsO5tAQnA9w==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

	Makefile for Image, zImage and uImage

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 arch/unicore32/boot/Makefile |   47
++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/arch/unicore32/boot/Makefile b/arch/unicore32/boot/Makefile
new file mode 100644
index 0000000..79e5f88
--- /dev/null
+++ b/arch/unicore32/boot/Makefile
@@ -0,0 +1,47 @@
+#
+# arch/unicore32/boot/Makefile
+#
+# This file is included by the global makefile so that you can add your own
+# architecture-specific flags and dependencies.
+#
+# This file is subject to the terms and conditions of the GNU General
Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+# Copyright (C) 2001~2010 GUAN Xue-tao
+#
+
+MKIMAGE := $(srctree)/scripts/mkuboot.sh
+
+targets := Image zImage uImage
+
+$(obj)/Image: vmlinux FORCE
+	$(call if_changed,objcopy)
+	@echo '  Kernel: $@ is ready'
+
+$(obj)/compressed/vmlinux: $(obj)/Image FORCE
+	$(Q)$(MAKE) $(build)=$(obj)/compressed $@
+
+$(obj)/zImage: $(obj)/compressed/vmlinux FORCE
+	$(call if_changed,objcopy)
+	@echo '  Kernel: $@ is ready'
+
+quiet_cmd_uimage = UIMAGE  $@
+      cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A unicore -O linux -T kernel
\
+		   -C none -a $(LOADADDR) -e $(STARTADDR) \
+		   -n 'Linux-$(KERNELRELEASE)' -d $< $@
+
+$(obj)/uImage: LOADADDR=0x0
+
+$(obj)/uImage: STARTADDR=$(LOADADDR)
+
+$(obj)/uImage: $(obj)/zImage FORCE
+	$(call if_changed,uimage)
+	@echo '  Image $@ is ready'
+
+PHONY += initrd FORCE
+initrd:
+	@test "$(INITRD)" != "" || \
+	(echo You must specify INITRD; exit -1)
+
+subdir- := compressed

