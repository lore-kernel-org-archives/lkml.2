Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab1BBBFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:05:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:4194 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab1BBAnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="653504967"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [40/139] sparc64: Delete prom_setcallback().
Message-Id: <20110202004355.A63133E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit c540ee70e49b573535c7ddfd0e9a0fc9d549c8b7 ]

Unused.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/sparc/include/asm/oplib_64.h |    8 --------
 arch/sparc/prom/misc_64.c         |   14 --------------
 2 files changed, 22 deletions(-)

Index: linux-2.6.35.y/arch/sparc/include/asm/oplib_64.h
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/include/asm/oplib_64.h
+++ linux-2.6.35.y/arch/sparc/include/asm/oplib_64.h
@@ -88,14 +88,6 @@ extern void prom_halt(void) __attribute_
 /* Halt and power-off the machine. */
 extern void prom_halt_power_off(void) __attribute__ ((noreturn));
 
-/* Set the PROM 'sync' callback function to the passed function pointer.
- * When the user gives the 'sync' command at the prom prompt while the
- * kernel is still active, the prom will call this routine.
- *
- */
-typedef int (*callback_func_t)(long *cmd);
-extern void prom_setcallback(callback_func_t func_ptr);
-
 /* Acquire the IDPROM of the root node in the prom device tree.  This
  * gets passed a buffer where you would like it stuffed.  The return value
  * is the format type of this idprom or 0xff on error.
Index: linux-2.6.35.y/arch/sparc/prom/misc_64.c
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/prom/misc_64.c
+++ linux-2.6.35.y/arch/sparc/prom/misc_64.c
@@ -150,20 +150,6 @@ void prom_halt_power_off(void)
 	prom_halt();
 }
 
-/* Set prom sync handler to call function 'funcp'. */
-void prom_setcallback(callback_func_t funcp)
-{
-	unsigned long args[5];
-	if (!funcp)
-		return;
-	args[0] = (unsigned long) "set-callback";
-	args[1] = 1;
-	args[2] = 1;
-	args[3] = (unsigned long) funcp;
-	args[4] = (unsigned long) -1;
-	p1275_cmd_direct(args);
-}
-
 /* Get the idprom and stuff it into buffer 'idbuf'.  Returns the
  * format type.  'num_bytes' is the number of bytes that your idbuf
  * has space for.  Returns 0xff on error.
