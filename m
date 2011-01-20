Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab1ATUtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 15:49:46 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:25354 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab1ATUto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 15:49:44 -0500
Date: Thu, 20 Jan 2011 12:48:36 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, platform-driver-x86@vger.kernel.org
Cc: akpm <akpm@linux-foundation.org>, David Woodhouse <dwmw2@infradead.org>,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] platform/x86: ideapad-laptop depends on INPUT
Message-Id: <20110120124836.b36a7c24.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Most platform/x86 drivers that use INPUT_SPARSEKMAP also depend on INPUT,
so do the same for ideapad-laptop.  This fixes a kconfig warning and
subsequent build errors when CONFIG_INPUT is disabled.

warning: (ACER_WMI && ASUS_LAPTOP && DELL_WMI && HP_WMI && PANASONIC_LAPTOP && IDEAPAD_LAPTOP && EEEPC_LAPTOP && EEEPC_WMI && MSI_WMI && TOPSTAR_LAPTOP && ACPI_TOSHIBA) selects INPUT_SPARSEKMAP which has unmet direct dependencies (!S390 && INPUT)

ERROR: "input_free_device" [drivers/platform/x86/ideapad-laptop.ko] undefined!
ERROR: "input_register_device" [drivers/platform/x86/ideapad-laptop.ko] undefined!
ERROR: "sparse_keymap_setup" [drivers/platform/x86/ideapad-laptop.ko] undefined!
ERROR: "input_allocate_device" [drivers/platform/x86/ideapad-laptop.ko] undefined!
ERROR: "input_unregister_device" [drivers/platform/x86/ideapad-laptop.ko] undefined!
ERROR: "sparse_keymap_free" [drivers/platform/x86/ideapad-laptop.ko] undefined!
ERROR: "sparse_keymap_report_event" [drivers/platform/x86/ideapad-laptop.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org
---
 drivers/platform/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-2638-rc1.orig/drivers/platform/x86/Kconfig
+++ lnx-2638-rc1/drivers/platform/x86/Kconfig
@@ -227,7 +227,7 @@ config SONYPI_COMPAT
 config IDEAPAD_LAPTOP
 	tristate "Lenovo IdeaPad Laptop Extras"
 	depends on ACPI
-	depends on RFKILL
+	depends on RFKILL && INPUT
 	select INPUT_SPARSEKMAP
 	help
 	  This is a driver for the rfkill switches on Lenovo IdeaPad netbooks.
