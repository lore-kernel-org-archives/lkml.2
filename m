Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab0KGGsS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 01:48:18 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13771 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab0KGGsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 01:48:18 -0500
Date: Sun, 7 Nov 2010 07:37:03 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Greg Kroah-Hartman <gregkh@suse.de>, David Cross <david.cross@cypress.com>
Subject: [PATCH] Cypress WestBridge OMAP3430 Kernel Hal: Remove unneeded
 local variables from alloc functions
Message-ID: <alpine.LNX.2.00.1011070731380.25327@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In 
drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c
the local variables 'ret_p' are not needed and should just go away.

I have no way to test this code, but I believe the change is obviously 
correct. Please consider it.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 cyashalomap_kernel.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c b/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c
index a678029..ad0c61d 100644
--- a/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c
+++ b/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c
@@ -2127,10 +2127,7 @@ void cy_as_hal_pll_lock_loss_handler(cy_as_hal_device_tag tag)
  */
 void *cy_as_hal_alloc(uint32_t cnt)
 {
-	void *ret_p;
-
-	ret_p = kmalloc(cnt, GFP_ATOMIC);
-	return ret_p;
+	return kmalloc(cnt, GFP_ATOMIC);
 }
 
 /*
@@ -2150,10 +2147,7 @@ void cy_as_hal_free(void *mem_p)
  */
 void *cy_as_hal_c_b_alloc(uint32_t cnt)
 {
-	void *ret_p;
-
-	ret_p = kmalloc(cnt, GFP_ATOMIC);
-	return ret_p;
+	return kmalloc(cnt, GFP_ATOMIC);
 }
 
 /*


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

