Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab0CQIFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 04:05:19 -0400
Received: from mail-yw0-f201.google.com ([209.85.211.201]:51820 "EHLO
	mail-yw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab0CQIE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 04:04:58 -0400
From: Arun Bhanu <arun@bhanu.net>
To: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au
Cc: Michal Simek <monstr@monstr.eu>, Arun Bhanu <arun@bhanu.net>
Subject: [PATCH 2/2] microblaze: Makefile cleanups
Date: Wed, 17 Mar 2010 16:06:04 +0800
Message-Id: <1268813164-12582-3-git-send-email-arun@bhanu.net>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1268813164-12582-1-git-send-email-arun@bhanu.net>
References: <1268813164-12582-1-git-send-email-arun@bhanu.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_INITRAMFS_SOURCE is set, "scripts/gen_initramfs_list.sh"
checks if the cpio image exists. Remove the duplicate check from the
Makefile.

Remove the "clean-kernel" variable which is unused in the Makefile and
is not used by the Kbuild.

Signed-off-by: Arun Bhanu <arun@bhanu.net>
---
 arch/microblaze/boot/Makefile |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/microblaze/boot/Makefile b/arch/microblaze/boot/Makefile
index a1fc324..57f50c2 100644
--- a/arch/microblaze/boot/Makefile
+++ b/arch/microblaze/boot/Makefile
@@ -23,8 +23,6 @@ $(obj)/system.dtb: $(obj)/$(DTB).dtb
 endif
 
 $(obj)/linux.bin: vmlinux FORCE
-	[ -n $(CONFIG_INITRAMFS_SOURCE) ] && [ ! -e $(CONFIG_INITRAMFS_SOURCE) ] && \
-	touch $(CONFIG_INITRAMFS_SOURCE) || echo "No CPIO image"
 	$(call if_changed,objcopy)
 	$(call if_changed,uimage)
 	@echo 'Kernel: $@ is ready' ' (#'`cat .version`')'
@@ -62,6 +60,4 @@ quiet_cmd_dtc = DTC     $@
 $(obj)/%.dtb: $(dtstree)/%.dts FORCE
 	$(call if_changed,dtc)
 
-clean-kernel += linux.bin linux.bin.gz simpleImage.*
-
 clean-files += *.dtb simpleImage.*.unstrip linux.bin.ub
-- 
1.6.2.5

