Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab1AFA3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:29:40 -0500
Received: from kroah.org ([198.145.64.141]:35648 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720Ab1AFA3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:38 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:01 2011
Message-Id: <20110106002301.222040099@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [048/152] sparc64: Delete prom_setcallback().
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit c540ee70e49b573535c7ddfd0e9a0fc9d549c8b7 ]

Unused.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/include/asm/oplib_64.h |    8 --------
 arch/sparc/prom/misc_64.c         |   14 --------------
 2 files changed, 22 deletions(-)

--- a/arch/sparc/include/asm/oplib_64.h
+++ b/arch/sparc/include/asm/oplib_64.h
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
--- a/arch/sparc/prom/misc_64.c
+++ b/arch/sparc/prom/misc_64.c
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


