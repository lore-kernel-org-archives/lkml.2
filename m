Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab0FAMS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:18:59 -0400
Received: from www.telegraphics.com.au ([204.15.192.19]:34012 "EHLO
	mail.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab0FAMS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:18:58 -0400
Date: Tue, 1 Jun 2010 22:18:56 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: David Miller <davem@davemloft.net>
cc: geert@linux-m68k.org, joe@perches.com, p_gortmaker@yahoo.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org
Subject: [PATCH 2/2] mac8390: raise error logging priority
In-Reply-To: <20100531.060225.68146363.davem@davemloft.net>
Message-ID: <alpine.OSX.2.00.1006011739160.299@localhost>
References: <alpine.LNX.2.00.1005312011210.469@nippy.intranet> <20100531.043056.258120791.davem@davemloft.net> <alpine.OSX.2.00.1005312244520.1490@localhost> <20100531.060225.68146363.davem@davemloft.net>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Log error conditions using KERN_ERR priority.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---

This patch doesn't address the KERN_INFO messages conditional on ei_debug. 
I don't know how those can be improved to the satisfaction of all 
interested parties.

These two patches should be applied in sequence.

Index: linux-2.6.34/drivers/net/mac8390.c
===================================================================
--- linux-2.6.34.orig/drivers/net/mac8390.c	2010-06-01 20:22:23.000000000 +1000
+++ linux-2.6.34/drivers/net/mac8390.c	2010-06-01 20:22:25.000000000 +1000
@@ -556,7 +556,7 @@ static int __init mac8390_initdev(struct
 	case MAC8390_APPLE:
 		switch (mac8390_testio(dev->mem_start)) {
 		case ACCESS_UNKNOWN:
-			pr_info("Don't know how to access card memory!\n");
+			pr_err("Don't know how to access card memory!\n");
 			return -ENODEV;
 			break;
 
@@ -648,7 +648,7 @@ static int mac8390_open(struct net_devic
 	__ei_open(dev);
 	err = request_irq(dev->irq, __ei_interrupt, 0, "8390 Ethernet", dev);
 	if (err)
-		pr_info("%s: unable to get IRQ %d\n", dev->name, dev->irq);
+		pr_err("%s: unable to get IRQ %d\n", dev->name, dev->irq);
 	return err;
 }
 
