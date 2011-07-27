Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab1G0EHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 00:07:35 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:57681 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751873Ab1G0EFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 00:05:35 -0400
X-Sasl-enc: 5Rcd1SP0yM5IUsDjcLZVGNRI+3r1KMSV+DLPKxziTTJu 1311739534
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: matt mooney <mfm@muteddisk.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/11] driver-core: Kconfig grammar corrections in firmware configuration
Date: Tue, 26 Jul 2011 21:05:14 -0700
Message-Id: <1311739521-11014-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311739521-11014-1-git-send-email-gregkh@suse.de>
References: <20110726045707.GA2321@kroah.com>
 <1311739521-11014-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matt mooney <mfm@muteddisk.com>

Fix some grammatical errors and reword a few sentences.

Signed-off-by: matt mooney <mfm@muteddisk.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/Kconfig |   59 ++++++++++++++++++++++++-------------------------
 1 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index d57e8d0..5fe7fd2 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -65,17 +65,17 @@ config PREVENT_FIRMWARE_BUILD
 	default y
 	help
 	  Say yes to avoid building firmware. Firmware is usually shipped
-	  with the driver, and only when updating the firmware a rebuild
-	  should be made.
-	  If unsure say Y here.
+	  with the driver and only when updating the firmware should a
+	  rebuild be made.
+	  If unsure, say Y here.
 
 config FW_LOADER
 	tristate "Userspace firmware loading support" if EXPERT
 	default y
 	---help---
-	  This option is provided for the case where no in-kernel-tree modules
-	  require userspace firmware loading support, but a module built outside
-	  the kernel tree does.
+	  This option is provided for the case where none of the in-tree modules
+	  require userspace firmware loading support, but a module built
+	  out-of-tree does.
 
 config FIRMWARE_IN_KERNEL
 	bool "Include in-kernel firmware blobs in kernel binary"
@@ -83,22 +83,22 @@ config FIRMWARE_IN_KERNEL
 	default y
 	help
 	  The kernel source tree includes a number of firmware 'blobs'
-	  which are used by various drivers. The recommended way to
+	  that are used by various drivers. The recommended way to
 	  use these is to run "make firmware_install" and to copy the
-	  resulting binary files created in usr/lib/firmware directory
-	  of the kernel tree to the /lib/firmware on your system so
-	  that they can be loaded by userspace helpers on request.
+	  resulting binary files created in usr/lib/firmware/ of the
+	  kernel tree to /lib/firmware/ on your system so that they can
+	  be loaded by userspace helpers on request.
 
 	  Enabling this option will build each required firmware blob
 	  into the kernel directly, where request_firmware() will find
 	  them without having to call out to userspace. This may be
-	  useful if your root file system requires a device which uses
-	  such firmware, and do not wish to use an initrd.
+	  useful if your root file system requires a device that uses
+	  such firmware and do not wish to use an initrd.
 
 	  This single option controls the inclusion of firmware for
-	  every driver which uses request_firmware() and ships its
-	  firmware in the kernel source tree, to avoid a proliferation
-	  of 'Include firmware for xxx device' options.
+	  every driver that uses request_firmware() and ships its
+	  firmware in the kernel source tree, which avoids a
+	  proliferation of 'Include firmware for xxx device' options.
 
 	  Say 'N' and let firmware be loaded from userspace.
 
@@ -106,27 +106,27 @@ config EXTRA_FIRMWARE
 	string "External firmware blobs to build into the kernel binary"
 	depends on FW_LOADER
 	help
-	  This option allows firmware to be built into the kernel, for the
-	  cases where the user either cannot or doesn't want to provide it from
+	  This option allows firmware to be built into the kernel for the case
+	  where the user either cannot or doesn't want to provide it from
 	  userspace at runtime (for example, when the firmware in question is
 	  required for accessing the boot device, and the user doesn't want to
 	  use an initrd).
 
-	  This option is a string, and takes the (space-separated) names of the
-	  firmware files -- the same names which appear in MODULE_FIRMWARE()
+	  This option is a string and takes the (space-separated) names of the
+	  firmware files -- the same names that appear in MODULE_FIRMWARE()
 	  and request_firmware() in the source. These files should exist under
 	  the directory specified by the EXTRA_FIRMWARE_DIR option, which is
-	  by default the firmware/ subdirectory of the kernel source tree.
+	  by default the firmware subdirectory of the kernel source tree.
 
-	  So, for example, you might set CONFIG_EXTRA_FIRMWARE="usb8388.bin",
-	  copy the usb8388.bin file into the firmware/ directory, and build the
-	  kernel. Then any request_firmware("usb8388.bin") will be
-	  satisfied internally without needing to call out to userspace.
+	  For example, you might set CONFIG_EXTRA_FIRMWARE="usb8388.bin", copy
+	  the usb8388.bin file into the firmware directory, and build the kernel.
+	  Then any request_firmware("usb8388.bin") will be satisfied internally
+	  without needing to call out to userspace.
 
 	  WARNING: If you include additional firmware files into your binary
-	  kernel image which are not available under the terms of the GPL,
+	  kernel image that are not available under the terms of the GPL,
 	  then it may be a violation of the GPL to distribute the resulting
-	  image -- since it combines both GPL and non-GPL work. You should
+	  image since it combines both GPL and non-GPL work. You should
 	  consult a lawyer of your own before distributing such an image.
 
 config EXTRA_FIRMWARE_DIR
@@ -136,10 +136,9 @@ config EXTRA_FIRMWARE_DIR
 	help
 	  This option controls the directory in which the kernel build system
 	  looks for the firmware files listed in the EXTRA_FIRMWARE option.
-	  The default is the firmware/ directory in the kernel source tree,
-	  but by changing this option you can point it elsewhere, such as
-	  the /lib/firmware/ directory or another separate directory
-	  containing firmware files.
+	  The default is firmware/ in the kernel source tree, but by changing
+	  this option you can point it elsewhere, such as /lib/firmware/ or
+	  some other directory containing the firmware files.
 
 config DEBUG_DRIVER
 	bool "Driver Core verbose debug messages"
-- 
1.7.6

