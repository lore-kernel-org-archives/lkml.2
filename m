Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933712Ab1KCBhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:37:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50806 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933685Ab1KCBhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:37:10 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:58 2011
Message-Id: <20111102221458.824939796@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:15:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <florian@openwrt.org>
Subject: [095/107] Revert "MIPS: MTX-1: Make au1000_eth probe all PHY
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Florian Fainelli <florian@openwrt.org>

Commit ec3eb823 was not applicable in 2.6.32 and introduces a build breakage.
Revert that commit since it is irrelevant for this kernel version.

Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Florian Fainelli <florian@openwrt.org>

---
 arch/mips/alchemy/mtx-1/platform.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/arch/mips/alchemy/mtx-1/platform.c
+++ b/arch/mips/alchemy/mtx-1/platform.c
@@ -28,8 +28,6 @@
 #include <linux/mtd/physmap.h>
 #include <mtd/mtd-abi.h>
 
-#include <asm/mach-au1x00/au1xxx_eth.h>
-
 static struct gpio_keys_button mtx1_gpio_button[] = {
 	{
 		.gpio = 207,
@@ -142,17 +140,10 @@ static struct __initdata platform_device
 	&mtx1_mtd,
 };
 
-static struct au1000_eth_platform_data mtx1_au1000_eth0_pdata = {
-	.phy_search_highest_addr	= 1,
-	.phy1_search_mac0 		= 1,
-};
-
 static int __init mtx1_register_devices(void)
 {
 	int rc;
 
-	au1xxx_override_eth_cfg(0, &mtx1_au1000_eth0_pdata);
-
 	rc = gpio_request(mtx1_gpio_button[0].gpio,
 					mtx1_gpio_button[0].desc);
 	if (rc < 0) {


