Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab0KDOUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 10:20:21 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38487 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0KDOUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 10:20:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=U92kuAA4rapGDruxI8KQk+hh0OzCLizAs9HekHBnMtOiCCXv9c6516qF2UdJnnWOA3
         Cl8KsXOXtz8TxgmOu0WmBniUQRcfv5MGhHSgEtI60Sg1qNJA6339FZm+kd8vk4MrXxXR
         KiLDFKGwbmS7ShmeZegL/qpyzId6/O0N4qZYk=
Subject: Re: kernel 2.6.33.7 (the highest version with RT patch) does not
 work with b44 ethernet controller
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Wojtek Zabolotny <W.Zabolotny@elka.pw.edu.pl>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4CD2BDE7.2070307@elka.pw.edu.pl>
References: <4CD2BDE7.2070307@elka.pw.edu.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 15:20:13 +0100
Message-ID: <1288880413.2659.103.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 04 novembre 2010 à 15:06 +0100, Wojtek Zabolotny a écrit :
> I have updated my RT-kernel to version 2.6.33.7-rt29 (the newest RT 
> version),
> and I've found that I've lost Ethernet connectivity.
> In the logs I could see messages like this:
> Nov  2 09:30:28 wzlaphp kernel: b44: eth0: powering down PHY
> Nov  2 09:30:28 wzlaphp kernel: b44: eth0: BUG!  Timeout waiting for bit 
> 00000002 of register 42c to clear.
> Nov  2 09:30:32 wzlaphp kernel: b44: eth0: BUG!  Timeout waiting for bit 
> 80000000 of register 428 to clear.
> 
> I was not sure whether the probem is related to the 2.6.33.7 kernel 
> itself or with the RT patch, so I've compiled also the unpatched version 
> of 2.6.33.7
> 
> It is also not able to communicate with my Ethernet controller, but now 
> the error messages are different:
> 
> b44 0000:02:0e.0: PCI INT A disabled
> b44 0000:02:0e.0: BAR 0: set to [mem 0xf4108000-0xf4109fff] (PCI address 
> [0xf4108000-0xf4109fff]
> b44 0000:02:0e.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> ssb: Core 0 found: Fast Ethernet (cc 0x806, rev 0x07, vendor 0x4243)
> ssb: Core 1 found: V90 (cc 0x807, rev 0x03, vendor 0x4243)
> ssb: Core 2 found: PCI (cc 0x804, rev 0x0A, vendor 0x4243)
> ssb: Sonics Silicon Backplane found on PCI device 0000:02:0e.0
> b44.c:v2.0
> b44: Invalid MAC address found in EEPROM
> b44 ssb1:0: Problem fetching invariants of chip, aborting.
> b44: probe of ssb1:0 failed with error -22
> 
> Now I'm using the old 2.6.33.5-rt23 kernel, and everything works perfectly.
> 

Could you print the Invalid MAC address ?


diff --git a/drivers/net/b44.c b/drivers/net/b44.c
index c6e8631..b1b9a2b 100644
--- a/drivers/net/b44.c
+++ b/drivers/net/b44.c
@@ -2092,7 +2092,7 @@ static int __devinit b44_get_invariants(struct b44 *bp)
 	memcpy(bp->dev->dev_addr, addr, 6);
 
 	if (!is_valid_ether_addr(&bp->dev->dev_addr[0])){
-		pr_err("Invalid MAC address found in EEPROM\n");
+		pr_err("Invalid MAC address %pM found in EEPROM\n", bp->dev->dev_addr);
 		return -EINVAL;
 	}
 


