Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab1F2NeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 09:34:08 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38164 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab1F2NeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 09:34:05 -0400
Subject: [PATCH] mach-ux500: fix build error due to unknown 'regulator_en'
 field
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Jun 2011 21:33:57 +0800
Message-ID: <1309354437.10872.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build error:

  CC      arch/arm/mach-ux500/board-mop500-u8500uib.o
arch/arm/mach-ux500/board-mop500-u8500uib.c:35: error: unknown field 'regulator_en' specified in initializer
arch/arm/mach-ux500/board-mop500-u8500uib.c:35: warning: excess elements in struct initializer
arch/arm/mach-ux500/board-mop500-u8500uib.c:35: warning: (near initialization for 'rmi4_i2c_dev_platformdata')
make[1]: *** [arch/arm/mach-ux500/board-mop500-u8500uib.o] Error 1
make: *** [arch/arm/mach-ux500] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 arch/arm/mach-ux500/board-mop500-u8500uib.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-u8500uib.c b/arch/arm/mach-ux500/board-mop500-u8500uib.c
index d8a8734..1af7228 100644
--- a/arch/arm/mach-ux500/board-mop500-u8500uib.c
+++ b/arch/arm/mach-ux500/board-mop500-u8500uib.c
@@ -32,7 +32,6 @@ static struct synaptics_rmi4_platform_data rmi4_i2c_dev_platformdata = {
 	.irq_type       = (IRQF_TRIGGER_FALLING | IRQF_SHARED),
 	.x_flip		= false,
 	.y_flip		= true,
-	.regulator_en   = false,
 };
 
 static struct i2c_board_info __initdata mop500_i2c3_devices_u8500[] = {
-- 
1.7.4.1



