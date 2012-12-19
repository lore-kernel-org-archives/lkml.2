Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab2LSRUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 12:20:00 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51914 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab2LSRTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 12:19:53 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/4] ARM: ux500: Provide a means to obtain the SMSC9115 clock when DT is enabled
Date: Wed, 19 Dec 2012 17:19:44 +0000
Message-Id: <1355937587-31730-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device Tree names devices differently to how some frameworks expect
them. Until we can move a platform over to the new way of obtaining
resources, we have to use the OF_DEV_AUXDATA() macros to craft a
device name which can be used in searches during allocation time.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index db0bb75..dfb68ce 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -284,6 +284,7 @@ static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("st,nomadik-i2c", 0x80128000, "nmk-i2c.2", NULL),
 	OF_DEV_AUXDATA("st,nomadik-i2c", 0x80110000, "nmk-i2c.3", NULL),
 	OF_DEV_AUXDATA("st,nomadik-i2c", 0x8012a000, "nmk-i2c.4", NULL),
+	OF_DEV_AUXDATA("smsc,lan9115", 0x50000000, "smsc911x", NULL),
 	/* Requires device name bindings. */
 	OF_DEV_AUXDATA("stericsson,nmk_pinctrl", 0, "pinctrl-db8500", NULL),
 	/* Requires clock name and DMA bindings. */
-- 
1.7.9.5

