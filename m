Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab2HAIqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 04:46:23 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44588 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab2HAIqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 04:46:19 -0400
Message-ID: <5018ECD7.5030005@linaro.org>
Date: Wed, 01 Aug 2012 09:46:15 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com
Subject: Re: [PATCH 3/6 v2] ARM: ux500: Fix merge error, no matching driver
 name for, 'snd_soc_u8500'
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org> <1343741493-17671-6-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1343741493-17671-6-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>
Date: Fri, 27 Jul 2012 13:10:52 +0100
Subject: [PATCH 1/1] ARM: ux500: Fix merge error, no matching driver name for
 'snd_soc_u8500'

The platform attempts to register platform device 'snd_soc_u8500'
which doesn't actually exist. Here we change the reference to the
correct one 'snd_soc_mop500'.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-msp.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-msp.c b/arch/arm/mach-ux500/board-mop500-msp.c
index 9960480..df15646 100644
--- a/arch/arm/mach-ux500/board-mop500-msp.c
+++ b/arch/arm/mach-ux500/board-mop500-msp.c
@@ -191,9 +191,9 @@ static struct platform_device *db8500_add_msp_i2s(struct device *parent,
 	return pdev;
 }
 
-/* Platform device for ASoC U8500 machine */
-static struct platform_device snd_soc_u8500 = {
-		.name = "snd-soc-u8500",
+/* Platform device for ASoC MOP500 machine */
+static struct platform_device snd_soc_mop500 = {
+		.name = "snd-soc-mop500",
 		.id = 0,
 		.dev = {
 			.platform_data = NULL,
@@ -227,8 +227,8 @@ int mop500_msp_init(struct device *parent)
 {
 	struct platform_device *msp1;
 
-	pr_info("%s: Register platform-device 'snd-soc-u8500'.\n", __func__);
-	platform_device_register(&snd_soc_u8500);
+	pr_info("%s: Register platform-device 'snd-soc-mop500'.\n", __func__);
+	platform_device_register(&snd_soc_mop500);
 
 	pr_info("Initialize MSP I2S-devices.\n");
 	db8500_add_msp_i2s(parent, 0, U8500_MSP0_BASE, IRQ_DB8500_MSP0,
-- 
1.7.9.5

