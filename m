Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab1JYUFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 16:05:41 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:42834 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab1JYUFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 16:05:39 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@uclinux.org>, linux-m68k@vger.kernel.org
Cc: Greg Ungerer <gerg@snapgear.com>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k: Revive lost ARAnyM config options
Date: Tue, 25 Oct 2011 22:05:28 +0200
Message-Id: <1319573128-21127-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 0e152d80507b75c00aac60f2ffc586360687cd52 ("m68k: reorganize Kconfig
options to improve mmu/non-mmu selections") accidentally dropped the ARAnyM
config options. Re-add them to the "Platform devices" section.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Kconfig.devices |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/arch/m68k/Kconfig.devices b/arch/m68k/Kconfig.devices
index 82ddb93..5cf1c54 100644
--- a/arch/m68k/Kconfig.devices
+++ b/arch/m68k/Kconfig.devices
@@ -24,6 +24,37 @@ config PROC_HARDWARE
 	  including the model, CPU, MMU, clock speed, BogoMIPS rating,
 	  and memory size.
 
+config NATFEAT
+	bool "ARAnyM emulator support"
+	depends on ATARI
+	help
+	  This option enables support for ARAnyM native features, such as
+	  access to a disk image as /dev/hda.
+
+config NFBLOCK
+	tristate "NatFeat block device support"
+	depends on BLOCK && NATFEAT
+	help
+	  Say Y to include support for the ARAnyM NatFeat block device
+	  which allows direct access to the hard drives without using
+	  the hardware emulation.
+
+config NFCON
+	tristate "NatFeat console driver"
+	depends on NATFEAT
+	help
+	  Say Y to include support for the ARAnyM NatFeat console driver
+	  which allows the console output to be redirected to the stderr
+	  output of ARAnyM.
+
+config NFETH
+	tristate "NatFeat Ethernet support"
+	depends on ETHERNET && NATFEAT
+	help
+	  Say Y to include support for the ARAnyM NatFeat network device
+	  which will emulate a regular ethernet device while presenting an
+	  ethertap device to the host system.
+
 endmenu
 
 menu "Character devices"
-- 
1.7.0.4

