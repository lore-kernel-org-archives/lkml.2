Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933412Ab0GAVtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:49:08 -0400
Received: from kroah.org ([198.145.64.141]:60977 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759032Ab0GAVOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:14:01 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:54 2010
Message-Id: <20100701174254.182256084@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:43:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [092/200] eeepc-wmi: depends on BACKLIGHT_CLASS_DEVICE
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <randy.dunlap@oracle.com>

commit 89a7644be2c59eea443b0db2514fd42d5de909f8 upstream.

eeepc-wmi uses backlight*() interfaces so it should depend on
BACKLIGHT_CLASS_DEVICE.

eeepc-wmi.c:(.text+0x2d7f54): undefined reference to `backlight_force_update'
eeepc-wmi.c:(.text+0x2d8012): undefined reference to `backlight_device_register'
eeepc-wmi.c:(.devinit.text+0x1c31c): undefined reference to `backlight_device_unregister'
eeepc-wmi.c:(.devexit.text+0x2f8b): undefined reference to `backlight_device_unregister'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -390,6 +390,7 @@ config EEEPC_WMI
 	depends on ACPI_WMI
 	depends on INPUT
 	depends on EXPERIMENTAL
+	depends on BACKLIGHT_CLASS_DEVICE
 	select INPUT_SPARSEKMAP
 	---help---
 	  Say Y here if you want to support WMI-based hotkeys on Eee PC laptops.


