Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab0HHQHo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 12:07:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53399 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab0HHQHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 12:07:43 -0400
Date: Sun, 8 Aug 2010 18:07:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, mjg@redhat.com, stable@kernel.org,
        ak@linux.intel.com
Subject: [PATCH] Make ACPI_CMPC depend on RFKILL
Message-ID: <20100808160738.GA24188@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make ACPI_CMPC depend on RFKILL

This fixes 

drivers/built-in.o: In function `cmpc_ipml_remove':
classmate-laptop.c:(.text+0xa92be): undefined reference to `rfkill_unregister'
classmate-laptop.c:(.text+0xa92c6): undefined reference to `rfkill_destroy'
drivers/built-in.o: In function `cmpc_rfkill_query':
classmate-laptop.c:(.text+0xa9325): undefined reference to `rfkill_set_sw_state'
drivers/built-in.o: In function `cmpc_ipml_add':                               
classmate-laptop.c:(.text+0xa9499): undefined reference to `rfkill_alloc'       
classmate-laptop.c:(.text+0xa94aa): undefined reference to `rfkill_register'    
classmate-laptop.c:(.text+0xa94b6): undefined reference to `rfkill_destroy'     
make: *** [.tmp_vmlinux1] Error 1                                               
root@son2:~/linux-2.6.35#                      

Cc: stable@kernel.org

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/platform/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35-ak/drivers/platform/x86/Kconfig
===================================================================
--- linux-2.6.35-ak.orig/drivers/platform/x86/Kconfig
+++ linux-2.6.35-ak/drivers/platform/x86/Kconfig
@@ -522,6 +522,7 @@ config ACPI_CMPC
 	depends on X86 && ACPI
 	select INPUT
 	select BACKLIGHT_CLASS_DEVICE
+	depends on RFKILL || RFKILL = n
 	default n
 	help
 	  Support for Intel Classmate PC ACPI devices, including some
