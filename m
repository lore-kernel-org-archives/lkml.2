Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab1KRJ2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:28:50 -0500
Received: from www17.your-server.de ([213.133.104.17]:48614 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591Ab1KRJ2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:28:47 -0500
Subject: [PATCH] ARM: LPC32XX: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Thu, 17 Nov 2011 23:43:40 +0100
Message-ID: <1321569820.1624.267.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/arch/arm/mach-lpc32xx/pm.c b/arch/arm/mach-lpc32xx/pm.c
--- a/arch/arm/mach-lpc32xx/pm.c 2011-11-07 19:37:19.236182427 +0100
+++ b/arch/arm/mach-lpc32xx/pm.c 2011-11-08 11:03:32.769642874 +0100
@@ -87,7 +87,8 @@ static int lpc32xx_pm_enter(suspend_stat
 	void *iram_swap_area;
 
 	/* Allocate some space for temporary IRAM storage */
-	iram_swap_area = kmalloc(lpc32xx_sys_suspend_sz, GFP_KERNEL);
+	iram_swap_area = kmemdup((void *)TEMP_IRAM_AREA,
+				 lpc32xx_sys_suspend_sz, GFP_KERNEL);
 	if (!iram_swap_area) {
 		printk(KERN_ERR
 		       "PM Suspend: cannot allocate memory to save portion "
@@ -95,10 +96,6 @@ static int lpc32xx_pm_enter(suspend_stat
 		return -ENOMEM;
 	}
 
-	/* Backup a small area of IRAM used for the suspend code */
-	memcpy(iram_swap_area, (void *) TEMP_IRAM_AREA,
-		lpc32xx_sys_suspend_sz);
-
 	/*
 	 * Copy code to suspend system into IRAM. The suspend code
 	 * needs to run from IRAM as DRAM may no longer be available
