Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab0JVS2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:28:11 -0400
Received: from kroah.org ([198.145.64.141]:37827 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758967Ab0JVSZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:39 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 19/31] FW_LOADER: fix kconfig dependency warning on HOTPLUG
Date: Fri, 22 Oct 2010 11:25:04 -0700
Message-Id: <1287771916-15016-19-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index ef38aff..fd96345 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -71,7 +71,6 @@ config PREVENT_FIRMWARE_BUILD
 
 config FW_LOADER
 	tristate "Userspace firmware loading support" if EMBEDDED
-	depends on HOTPLUG
 	default y
 	---help---
 	  This option is provided for the case where no in-kernel-tree modules
-- 
1.7.2

