Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab0HQGAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 02:00:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38992 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab0HQGAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 02:00:17 -0400
Subject: [PATCH] of: Fix missing includes
To: linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Michal Simek <monstr@monstr.eu>
Date: Tue, 17 Aug 2010 00:00:14 -0600
Message-ID: <20100817055754.20330.73078.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes missing includes from a number of .c files because
the code (wrongfully) depended on prom.h including them.  The include
of linux/of_address.h was removed in microblaze prom.h in commit
"of/address: Clean up function declarations" (sha1 id 22ae782f8), but
not fixed in some users.  This patch fixes them up.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

Hi Michal, here's my patch that fixes the microblaze include issues.  I've
got it in my merge-devicetree branch which I'll be asking Linus to pull on
tommorrow after it has been through cross-arch build testing (unless I hear
otherwise from you).

Cheers,
g.

 arch/microblaze/pci/pci-common.c           |    3 ++-
 arch/microblaze/pci/xilinx_pci.c           |    1 +
 drivers/char/xilinx_hwicap/xilinx_hwicap.c |    1 +
 drivers/serial/of_serial.c                 |    3 +--
 4 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index 6ca8531..55ef532 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -27,10 +27,11 @@
 #include <linux/irq.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
 
 #include <asm/processor.h>
 #include <asm/io.h>
-#include <asm/prom.h>
 #include <asm/pci-bridge.h>
 #include <asm/byteorder.h>
 
diff --git a/arch/microblaze/pci/xilinx_pci.c b/arch/microblaze/pci/xilinx_pci.c
index 7869a41..0687a42 100644
--- a/arch/microblaze/pci/xilinx_pci.c
+++ b/arch/microblaze/pci/xilinx_pci.c
@@ -16,6 +16,7 @@
 
 #include <linux/ioport.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/pci.h>
 #include <asm/io.h>
 
diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
index 0ed763c..b663d57 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -94,6 +94,7 @@
 
 #ifdef CONFIG_OF
 /* For open firmware. */
+#include <linux/of_address.h>
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
 #endif
diff --git a/drivers/serial/of_serial.c b/drivers/serial/of_serial.c
index 659a695..2af8fd1 100644
--- a/drivers/serial/of_serial.c
+++ b/drivers/serial/of_serial.c
@@ -14,11 +14,10 @@
 #include <linux/slab.h>
 #include <linux/serial_core.h>
 #include <linux/serial_8250.h>
+#include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <linux/nwpserial.h>
 
-#include <asm/prom.h>
-
 struct of_serial_info {
 	int type;
 	int line;

