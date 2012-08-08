Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759Ab2HHOS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 10:18:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755721Ab2HHOSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:18:24 -0400
From: Peter Jones <pjones@redhat.com>
To: dhowells@redhat.com
Cc: jwboyer@redhat.com, linux-kernel@vger.kernel.org,
        Peter Jones <pjones@redhat.com>
Subject: [PATCH] Use the UEFI shim to load grub.
Date: Wed,  8 Aug 2012 10:18:17 -0400
Message-Id: <1344435497-6728-1-git-send-email-pjones@redhat.com>
In-Reply-To: <1344432179-31974-1-git-send-email-pjones@redhat.com>
References: <1344432179-31974-1-git-send-email-pjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For UEFI Secure Boot support, we need to install the shim pre-boot
loader, and use it to load grub2.
---
 pyanaconda/bootloader.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/pyanaconda/bootloader.py b/pyanaconda/bootloader.py
index ea4de5e..02d0ea8 100644
--- a/pyanaconda/bootloader.py
+++ b/pyanaconda/bootloader.py
@@ -1749,7 +1749,7 @@ class GRUB2(GRUB):
         self.stage2_device.format.sync(root=ROOT_PATH)
 
 class EFIGRUB(GRUB2):
-    packages = ["grub2-efi", "efibootmgr"]
+    packages = ["grub2-efi", "efibootmgr", "shim"]
     can_dual_boot = False
 
     @property
@@ -1809,7 +1809,7 @@ class EFIGRUB(GRUB2):
         rc = self.efibootmgr("-c", "-w", "-L", productName,
                              "-d", boot_disk.path, "-p", boot_part_num,
                              "-l",
-                             self.efi_dir_as_efifs_dir + "\\grubx64.efi",
+                             self.efi_dir_as_efifs_dir + "\\shim.efi",
                              root=ROOT_PATH,
                              stdout="/dev/tty5", stderr="/dev/tty5")
         if rc:
-- 
1.7.11.2

