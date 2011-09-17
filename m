Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab1IQOPq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 10:15:46 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:61076 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab1IQOPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 10:15:45 -0400
Subject: [PATCH] ARM: pxa/cm-x300: properly set bt_reset pin
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Igor Grinberg <grinberg@compulab.co.il>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 17 Sep 2011 22:15:34 +0800
Message-ID: <1316268934.16763.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build warning and properly set bt_reset pin.

  CC      arch/arm/mach-pxa/cm-x300.o
arch/arm/mach-pxa/cm-x300.c: In function 'cm_x300_init_wi2wi':
arch/arm/mach-pxa/cm-x300.c:779: warning: unused variable 'wlan_en'
arch/arm/mach-pxa/cm-x300.c:795: warning: 'bt_reset' may be used uninitialized in this function

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 arch/arm/mach-pxa/cm-x300.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-pxa/cm-x300.c b/arch/arm/mach-pxa/cm-x300.c
index 0f00e01..0e18eb9 100644
--- a/arch/arm/mach-pxa/cm-x300.c
+++ b/arch/arm/mach-pxa/cm-x300.c
@@ -776,7 +776,6 @@ static struct gpio cm_x300_wi2wi_gpios[] __initdata = {
 
 static void __init cm_x300_init_wi2wi(void)
 {
-	int bt_reset, wlan_en;
 	int err;
 
 	if (system_rev < 130) {
@@ -792,12 +791,11 @@ static void __init cm_x300_init_wi2wi(void)
 	}
 
 	udelay(10);
-	gpio_set_value(bt_reset, 0);
+	gpio_set_value(cm_x300_wi2wi_gpios[1].gpio, 0);
 	udelay(10);
-	gpio_set_value(bt_reset, 1);
+	gpio_set_value(cm_x300_wi2wi_gpios[1].gpio, 1);
 
-	gpio_free(wlan_en);
-	gpio_free(bt_reset);
+	gpio_free_array(ARRAY_AND_SIZE(cm_x300_wi2wi_gpios));
 }
 
 /* MFP */
-- 
1.7.4.1



