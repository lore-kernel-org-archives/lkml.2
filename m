Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab2EXOac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 10:30:32 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:4847 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755306Ab2EXOab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 10:30:31 -0400
Message-ID: <1337869829.22505.15.camel@x61.thuisdomein>
Subject: [PATCH] at91: set i2c_board_info.type to "ds1339" directly
From: Paul Bolle <pebolle@tiscali.nl>
To: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 24 May 2012 16:30:29 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 24 May 2012 14:30:29.0947 (UTC) FILETIME=[C4F0F0B0:01CD39B9]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The single element of the cpu9krea_i2c_devices array (of type struct
i2c_board_info) has its "type" member set twice. First to "rtc-ds1307"
(through the I2C_BOARD_INFO macro) and then directly to "ds1339". Just
set it (once and) directly to "ds1339" instead.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) This is just something I stumbled upon while researching a different
issue. (An unrelated board apparently uses a ds1307 compatible RTC but
the kernel doesn't see it. I hope to submit a patch for that issue one
of these days.)

1) Entirely untested. I'm unsure what toolchain is needed to compile
this and I am certain that I don't have this hardware.

2) This is apparently legal. Doesn't gcc issue a warning for this?

 arch/arm/mach-at91/board-cpu9krea.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-at91/board-cpu9krea.c b/arch/arm/mach-at91/board-cpu9krea.c
index 5f3680e..f680755 100644
--- a/arch/arm/mach-at91/board-cpu9krea.c
+++ b/arch/arm/mach-at91/board-cpu9krea.c
@@ -281,8 +281,7 @@ static struct gpio_led cpu9krea_leds[] = {
 
 static struct i2c_board_info __initdata cpu9krea_i2c_devices[] = {
 	{
-		I2C_BOARD_INFO("rtc-ds1307", 0x68),
-		.type	= "ds1339",
+		I2C_BOARD_INFO("ds1339", 0x68),
 	},
 };
 
-- 
1.7.7.6

