Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab1KSLbl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 06:31:41 -0500
Received: from www17.your-server.de ([213.133.104.17]:55705 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab1KSLbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 06:31:39 -0500
Subject: [PATCH] MIPS: Alchemy: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Thu, 17 Nov 2011 23:43:40 +0100
Message-ID: <1321569820.1624.272.camel@localhost.localdomain>
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

diff -u -p a/arch/mips/alchemy/common/platform.c b/arch/mips/alchemy/common/platform.c
--- a/arch/mips/alchemy/common/platform.c 2011-11-07 19:37:22.596233458 +0100
+++ b/arch/mips/alchemy/common/platform.c 2011-11-08 11:02:32.915507198 +0100
@@ -307,13 +307,12 @@ static void __init alchemy_setup_macs(in
 	if (alchemy_get_macs(ctype) < 1)
 		return;
 
-	macres = kmalloc(sizeof(struct resource) * MAC_RES_COUNT, GFP_KERNEL);
+	macres = kmemdup(au1xxx_eth0_resources[ctype],
+			 sizeof(struct resource) * MAC_RES_COUNT, GFP_KERNEL);
 	if (!macres) {
 		printk(KERN_INFO "Alchemy: no memory for MAC0 resources\n");
 		return;
 	}
-	memcpy(macres, au1xxx_eth0_resources[ctype],
-	       sizeof(struct resource) * MAC_RES_COUNT);
 	au1xxx_eth0_device.resource = macres;
 
 	i = prom_get_ethernet_addr(ethaddr);
@@ -329,13 +328,12 @@ static void __init alchemy_setup_macs(in
 	if (alchemy_get_macs(ctype) < 2)
 		return;
 
-	macres = kmalloc(sizeof(struct resource) * MAC_RES_COUNT, GFP_KERNEL);
+	macres = kmemdup(au1xxx_eth1_resources[ctype],
+			 sizeof(struct resource) * MAC_RES_COUNT, GFP_KERNEL);
 	if (!macres) {
 		printk(KERN_INFO "Alchemy: no memory for MAC1 resources\n");
 		return;
 	}
-	memcpy(macres, au1xxx_eth1_resources[ctype],
-	       sizeof(struct resource) * MAC_RES_COUNT);
 	au1xxx_eth1_device.resource = macres;
 
 	ethaddr[5] += 1;	/* next addr for 2nd MAC */
