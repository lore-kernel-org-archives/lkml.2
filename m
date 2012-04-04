Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab2DDGU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 02:20:29 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:51521 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526Ab2DDGU2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 02:20:28 -0400
Date: Wed, 4 Apr 2012 09:20:26 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Dave Airlie <airlied@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix warnings from vgaarb.h
Message-ID: <alpine.SOC.1.00.1204040912210.26551@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in 3.4-rc1-144, I get the following warnings. Fix them by including 
<linux/pci.h> to get struct pci_dev.

  CC [M]  drivers/gpu/drm/i915/intel_display.o
In file included from drivers/gpu/drm/i915/intel_display.c:33:0:
include/linux/vgaarb.h:66:9: warning: ¡struct pci_dev¢ declared inside parameter list [enabled by default]
include/linux/vgaarb.h:66:9: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
include/linux/vgaarb.h:97:27: warning: ¡struct pci_dev¢ declared inside parameter list [enabled by default]
include/linux/vgaarb.h:109:6: warning: ¡struct pci_dev¢ declared inside parameter list [enabled by default]
include/linux/vgaarb.h: In function ¡vga_get_interruptible¢:
include/linux/vgaarb.h:111:8: warning: passing argument 1 of ¡vga_get¢ from incompatible pointer type [enabled by default]
include/linux/vgaarb.h:97:12: note: expected ¡struct pci_dev *¢ but argument is of type ¡struct pci_dev *¢
include/linux/vgaarb.h: At top level:
include/linux/vgaarb.h:121:8: warning: ¡struct pci_dev¢ declared inside parameter list [enabled by default]
include/linux/vgaarb.h: In function ¡vga_get_uninterruptible¢:
include/linux/vgaarb.h:123:8: warning: passing argument 1 of ¡vga_get¢ from incompatible pointer type [enabled by default]
include/linux/vgaarb.h:97:12: note: expected ¡struct pci_dev *¢ but argument is of type ¡struct pci_dev *¢
include/linux/vgaarb.h: At top level:
include/linux/vgaarb.h:138:30: warning: ¡struct pci_dev¢ declared inside parameter list [enabled by default]
include/linux/vgaarb.h:157:28: warning: ¡struct pci_dev¢ declared inside parameter list [enabled by default]
drivers/gpu/drm/i915/intel_display.c: In function ¡i915_disable_vga¢:
drivers/gpu/drm/i915/intel_display.c:9127:2: warning: passing argument 1 of ¡vga_get_uninterruptible¢ from incompatible pointer type [enabled by default]
include/linux/vgaarb.h:120:19: note: expected ¡struct pci_dev *¢ but argument is of type ¡struct pci_dev *¢
drivers/gpu/drm/i915/intel_display.c:9131:2: warning: passing argument 1 of ¡vga_put¢ from incompatible pointer type [enabled by default]
include/linux/vgaarb.h:157:13: note: expected ¡struct pci_dev *¢ but argument is of type ¡struct pci_dev *¢

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/include/linux/vgaarb.h b/include/linux/vgaarb.h
index 9c3120d..c23ba57 100644
--- a/include/linux/vgaarb.h
+++ b/include/linux/vgaarb.h
@@ -31,6 +31,7 @@
 #ifndef LINUX_VGA_H
 #define LINUX_VGA_H
 
+#include <linux/pci.h>
 
 /* Legacy VGA regions */
 #define VGA_RSRC_NONE	       0x00

-- 
Meelis Roos (mroos@linux.ee)
