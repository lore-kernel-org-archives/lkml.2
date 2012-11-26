Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933994Ab2KZROQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:14:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48123 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933941Ab2KZROM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:14:12 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bo Shen <voice.shen@atmel.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 229/270] ARM: at91/i2c: change id to let i2c-gpio work
Date: Mon, 26 Nov 2012 14:58:39 -0200
Message-Id: <1353949160-26803-230-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bo Shen <voice.shen@atmel.com>

commit 7840487cd6298f9f931103b558290d8d98d41c49 upstream.

The i2c core driver will turn the platform device ID to busnum
When using platfrom device ID as -1, it means dynamically assigned
the busnum. When writing code, we need to make sure the busnum,
and call i2c_register_board_info(int busnum, ...) to register device
if using -1, we do not know the value of busnum

In order to solve this issue, set the platform device ID as a fix number
Here using 0 to match the busnum used in i2c_regsiter_board_info()

Signed-off-by: Bo Shen <voice.shen@atmel.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/arm/mach-at91/at91rm9200_devices.c  |    2 +-
 arch/arm/mach-at91/at91sam9260_devices.c |    2 +-
 arch/arm/mach-at91/at91sam9261_devices.c |    2 +-
 arch/arm/mach-at91/at91sam9263_devices.c |    2 +-
 arch/arm/mach-at91/at91sam9rl_devices.c  |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-at91/at91rm9200_devices.c b/arch/arm/mach-at91/at91rm9200_devices.c
index e6b7d05..6a466c3 100644
--- a/arch/arm/mach-at91/at91rm9200_devices.c
+++ b/arch/arm/mach-at91/at91rm9200_devices.c
@@ -463,7 +463,7 @@ static struct i2c_gpio_platform_data pdata = {
 
 static struct platform_device at91rm9200_twi_device = {
 	.name			= "i2c-gpio",
-	.id			= -1,
+	.id			= 0,
 	.dev.platform_data	= &pdata,
 };
 
diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
index 0ded951..138feac 100644
--- a/arch/arm/mach-at91/at91sam9260_devices.c
+++ b/arch/arm/mach-at91/at91sam9260_devices.c
@@ -471,7 +471,7 @@ static struct i2c_gpio_platform_data pdata = {
 
 static struct platform_device at91sam9260_twi_device = {
 	.name			= "i2c-gpio",
-	.id			= -1,
+	.id			= 0,
 	.dev.platform_data	= &pdata,
 };
 
diff --git a/arch/arm/mach-at91/at91sam9261_devices.c b/arch/arm/mach-at91/at91sam9261_devices.c
index 9295e90..da8aa8f 100644
--- a/arch/arm/mach-at91/at91sam9261_devices.c
+++ b/arch/arm/mach-at91/at91sam9261_devices.c
@@ -285,7 +285,7 @@ static struct i2c_gpio_platform_data pdata = {
 
 static struct platform_device at91sam9261_twi_device = {
 	.name			= "i2c-gpio",
-	.id			= -1,
+	.id			= 0,
 	.dev.platform_data	= &pdata,
 };
 
diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
index 175e000..a01f9ed 100644
--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -542,7 +542,7 @@ static struct i2c_gpio_platform_data pdata = {
 
 static struct platform_device at91sam9263_twi_device = {
 	.name			= "i2c-gpio",
-	.id			= -1,
+	.id			= 0,
 	.dev.platform_data	= &pdata,
 };
 
diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
index 9c0b148..d25d775 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -314,7 +314,7 @@ static struct i2c_gpio_platform_data pdata = {
 
 static struct platform_device at91sam9rl_twi_device = {
 	.name			= "i2c-gpio",
-	.id			= -1,
+	.id			= 0,
 	.dev.platform_data	= &pdata,
 };
 
-- 
1.7.9.5

