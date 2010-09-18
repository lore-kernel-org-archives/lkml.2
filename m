Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab0IRUYy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 16:24:54 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36454 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab0IRUYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 16:24:53 -0400
Date: Sat, 18 Sep 2010 13:23:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de, akpm <akpm@linux-foundation.org>
Subject: [PATCH] FW_LOADER: fix kconfig dependency warning on HOTPLUG
Message-Id: <20100918132308.074b6c01.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kconfig dependency warning for FW_LOADER.

Lots of drivers select FW_LOADER without bothering to depend on
HOTPLUG and/or without selecting HOTPLUG.  A kernel builds fine
when FW_LOADER is enabled, whether HOTPLUG is enabled or not, and
a kernel config file (make oldconfig) is not changed by this patch.
(Yes, drivers/base/firmware_class.c uses interfaces from linux/kobject.h,
which does have some CONFIG_HOTPLUG dependencies, but this patch does
not change that.)

warning: (MICROCODE || MICROCODE_INTEL && MICROCODE || MICROCODE_AMD && MICROCODE || PCMCIA_LOAD_CIS && PCCARD && PCMCIA && EXPERIMENTAL || USB_IRDA && NET && IRDA && USB || BT_HCIBCM203X && NET && BT && USB || BT_HCIBFUSB && NET && BT && USB || BT_HCIBT3C && NET && BT && PCMCIA || BT_MRVL_SDIO && NET
...
!STAGING_EXCLUDE_BUILD && USB && (X86 || ARM) && WLAN || DRM_NOUVEAU && STAGING && !STAGING_EXCLUDE_BUILD && DRM && PCI || TI_ST && STAGING && !STAGING_EXCLUDE_BUILD && RFKILL || DELL_RBU && X86) selects FW_LOADER which has unmet direct dependencies (HOTPLUG)
(5200 byte line reduced a lot)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/base/Kconfig |    1 -
 1 file changed, 1 deletion(-)

BTW, drivers/base/firmware_class.c should #include <linux/kobject.h>.

--- linux-next-20100917.orig/drivers/base/Kconfig
+++ linux-next-20100917/drivers/base/Kconfig
@@ -71,7 +71,6 @@ config PREVENT_FIRMWARE_BUILD
 
 config FW_LOADER
 	tristate "Userspace firmware loading support" if EMBEDDED
-	depends on HOTPLUG
 	default y
 	---help---
 	  This option is provided for the case where no in-kernel-tree modules
