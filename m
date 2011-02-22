Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab1BVWVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:21:20 -0500
Received: from kroah.org ([198.145.64.141]:46600 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab1BVWVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:18 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:38 2011
Message-Id: <20110222221838.372146737@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:16:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jochen Friedrich <jochen@scram.de>,
        Kristoffer Ericson <kristoffer.ericson@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [13/70] ARM: 6606/1: sa1100: Fix platform device registration
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jochen Friedrich <jochen@scram.de>

commit 4f444e2b59dd4255d121b57ec41a4a8c5d6bce46 upstream.

Since commit 7a5b4e16c880f8350d255dc188f81622905618c1, simpad devices don't
boot anymore, since platform devices are registered too early. Fix by moving
the registration from map_io to arch_initcall as done on other sa1100 boards.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
Acked-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-sa1100/simpad.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/arm/mach-sa1100/simpad.c
+++ b/arch/arm/mach-sa1100/simpad.c
@@ -166,9 +166,6 @@ static void __init simpad_map_io(void)
 	PCFR = 0;
 	PSDR = 0;
 
-	sa11x0_register_mtd(&simpad_flash_data, simpad_flash_resources,
-			      ARRAY_SIZE(simpad_flash_resources));
-	sa11x0_register_mcp(&simpad_mcp_data);
 }
 
 static void simpad_power_off(void)
@@ -216,6 +213,10 @@ static int __init simpad_init(void)
 
 	pm_power_off = simpad_power_off;
 
+	sa11x0_register_mtd(&simpad_flash_data, simpad_flash_resources,
+			      ARRAY_SIZE(simpad_flash_resources));
+	sa11x0_register_mcp(&simpad_mcp_data);
+
 	ret = platform_add_devices(devices, ARRAY_SIZE(devices));
 	if(ret)
 		printk(KERN_WARNING "simpad: Unable to register mq200 framebuffer device");


