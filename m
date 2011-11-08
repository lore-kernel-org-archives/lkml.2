Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628Ab1KHOPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:15:37 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:25654 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab1KHOPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:15:34 -0500
X-RZG-AUTH: :KXokZlStbvrPCC8w2n2KADUjx90tFpDbrwvi3rISAmCHBWiKTAoKIqY5gZEywA==
X-RZG-CLASS-ID: mo05
Message-Id: <8124c370151faa10dd4ef6970be1dfb79039071c.1320753142.git.n.voss@weinmann.de>
In-Reply-To: <cover.1320753142.git.n.voss@weinmann.de>
References: <cover.1320753142.git.n.voss@weinmann.de>
From: Nikolaus Voss <n.voss@weinmann.de>
Date: Tue, 8 Nov 2011 12:11:03 +0100
Subject: [PATCH V3 3/4] G45 TWI: remove open drain setting for twi function
 gpios
To: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: ben-linux@fluff.org, khali@linux-fr.org, nicolas.ferre@atmel.com,
        rmallon@gmail.com, balbi@ti.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The G45 datasheets explicitly states that setting the open drain property
on peripheral function gpios is not allowed. (How about other A91 chips?)

Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
---
 arch/arm/mach-at91/at91sam9g45_devices.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 117393f..4dfdc70 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -679,18 +679,12 @@ void __init at91_add_device_i2c(short i2c_id, struct i2c_board_info *devices, in
 	/* pins used for TWI interface */
 	if (i2c_id == 0) {
 		at91_set_A_periph(AT91_PIN_PA20, 0);		/* TWD */
-		at91_set_multi_drive(AT91_PIN_PA20, 1);
-
 		at91_set_A_periph(AT91_PIN_PA21, 0);		/* TWCK */
-		at91_set_multi_drive(AT91_PIN_PA21, 1);
 
 		platform_device_register(&at91sam9g45_twi0_device);
 	} else {
 		at91_set_A_periph(AT91_PIN_PB10, 0);		/* TWD */
-		at91_set_multi_drive(AT91_PIN_PB10, 1);
-
 		at91_set_A_periph(AT91_PIN_PB11, 0);		/* TWCK */
-		at91_set_multi_drive(AT91_PIN_PB11, 1);
 
 		platform_device_register(&at91sam9g45_twi1_device);
 	}
-- 
1.7.5.4

