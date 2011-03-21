Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab1CUXP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:15:26 -0400
Received: from kroah.org ([198.145.64.141]:49265 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754880Ab1CUXPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:16 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:11 2011
Message-Id: <20110321230711.037243920@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, linux-mips@linux-mips.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Florian Fainelli <florian@openwrt.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [18/87] MIPS: MTX-1: Make au1000_eth probe all PHY addresses
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Florian Fainelli <florian@openwrt.org>

commit bf3a1eb85967dcbaae42f4fcb53c2392cec32677 upstream.

When au1000_eth probes the MII bus for PHY address, if we do not set
au1000_eth platform data's phy_search_highest_address, the MII probing
logic will exit early and will assume a valid PHY is found at address 0.
For MTX-1, the PHY is at address 31, and without this patch, the link
detection/speed/duplex would not work correctly.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
To: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/2111/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/mips/alchemy/mtx-1/platform.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/mips/alchemy/mtx-1/platform.c
+++ b/arch/mips/alchemy/mtx-1/platform.c
@@ -28,6 +28,8 @@
 #include <linux/mtd/physmap.h>
 #include <mtd/mtd-abi.h>
 
+#include <asm/mach-au1x00/au1xxx_eth.h>
+
 static struct gpio_keys_button mtx1_gpio_button[] = {
 	{
 		.gpio = 207,
@@ -140,10 +142,17 @@ static struct __initdata platform_device
 	&mtx1_mtd,
 };
 
+static struct au1000_eth_platform_data mtx1_au1000_eth0_pdata = {
+	.phy_search_highest_addr	= 1,
+	.phy1_search_mac0 		= 1,
+};
+
 static int __init mtx1_register_devices(void)
 {
 	int rc;
 
+	au1xxx_override_eth_cfg(0, &mtx1_au1000_eth0_pdata);
+
 	rc = gpio_request(mtx1_gpio_button[0].gpio,
 					mtx1_gpio_button[0].desc);
 	if (rc < 0) {


