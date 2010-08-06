Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761104Ab0HFKAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 06:00:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48609 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab0HFKAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 06:00:46 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] microblaze: Add missing header to prom.h
Date: Fri,  6 Aug 2010 11:55:22 +0200
Message-Id: <1281088522-18310-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_serial and physmap_of require of_address_to_resource.

CC      drivers/serial/of_serial.o
drivers/serial/of_serial.c: In function 'of_platform_serial_setup':
drivers/serial/of_serial.c:47: error: implicit declaration of function 'of_address_to_resource'
make[5]: *** [drivers/serial/of_serial.o] Error 1

CC      drivers/mtd/maps/physmap_of.o
drivers/mtd/maps/physmap_of.c: In function 'of_flash_probe':
drivers/mtd/maps/physmap_of.c:268: error: implicit declaration of function 'of_address_to_resource'
make[6]: *** [drivers/mtd/maps/physmap_of.o] Error 1
make[5]: *** [drivers/mtd/maps] Error 2
make[4]: *** [drivers/mtd] Error 2
make[3]: *** [drivers] Error 2

Signed-off-by: Michal Simek <monstr@monstr.eu>
CC: Grant Likely <grant.likely@secretlab.ca>
---
 arch/microblaze/include/asm/prom.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/microblaze/include/asm/prom.h b/arch/microblaze/include/asm/prom.h
index 101fa09..5012b22 100644
--- a/arch/microblaze/include/asm/prom.h
+++ b/arch/microblaze/include/asm/prom.h
@@ -22,6 +22,7 @@
 #include <linux/types.h>
 #include <asm/irq.h>
 #include <asm/atomic.h>
+#include <linux/of_address.h>
 
 #define HAVE_ARCH_DEVTREE_FIXUPS
 
-- 
1.5.5.6

