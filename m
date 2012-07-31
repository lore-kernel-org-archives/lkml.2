Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab2GaNdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:33:17 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47955 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab2GaNb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:31:56 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4/6] ARM: ux500: Fix merge error, so such struct 'snd_soc_u8500'
Date: Tue, 31 Jul 2012 14:31:29 +0100
Message-Id: <1343741493-17671-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343741493-17671-1-git-send-email-lee.jones@linaro.org>
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform attempts to register platform device 'snd_soc_u8500'
which doesn't actually exist. Here we change the reference to the
correct one 'snd_soc_mop500'.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-msp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-ux500/board-mop500-msp.c b/arch/arm/mach-ux500/board-mop500-msp.c
index 9960480..1b6a193 100644
--- a/arch/arm/mach-ux500/board-mop500-msp.c
+++ b/arch/arm/mach-ux500/board-mop500-msp.c
@@ -228,7 +228,7 @@ int mop500_msp_init(struct device *parent)
 	struct platform_device *msp1;
 
 	pr_info("%s: Register platform-device 'snd-soc-u8500'.\n", __func__);
-	platform_device_register(&snd_soc_u8500);
+	platform_device_register(&snd_soc_mop500);
 
 	pr_info("Initialize MSP I2S-devices.\n");
 	db8500_add_msp_i2s(parent, 0, U8500_MSP0_BASE, IRQ_DB8500_MSP0,
-- 
1.7.9.5

