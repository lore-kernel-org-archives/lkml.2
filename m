Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab1JAUFe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:05:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55871 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab1JAUFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:05:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 23/26] ARM: pxa: viper: select I2C_GPIO only when I2C is on
Date: Sat,  1 Oct 2011 22:03:55 +0200
Message-Id: <1317499438-14058-24-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317499438-14058-1-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:J8UwxIytqHWn4lwsO8Tp2s1d4k86V4X/0EA7OfBSl9q
 Wl7o+URLeIGMPgxo0bfV4kkxoxwbJBFRzvtpKw/9I74frusfoa
 PNfGWoUfNBJh0aAaypqePblvp/V8E9SLtnZS5CvV82lAURezZJ
 TkXs10oTh8kp5ij3OK7+F8ya5O5dvDvGwHPjSf9QeWjT3olYis
 R63vwPmLlTEO1EaxDiYMNBsrB+g4BBVNqPvVKud5OD4emOIH+G
 iAhZ9TceroMjnRgn8DHhx/4IAvaoYkPMcCncjYoMWVjAGcb6BB
 D39/BRcKbKJUGfjKgFieZGe38V9YNSl/8hEWB7Rh14QTvob7qM
 OQrvolZAf/8fyqXHFp8j5/uUTW1E188GpxlQuKp8e5GLM1Yo3s
 hzQSGKsb8Etqw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The viper platform selects the i2c_gpio driver, but that does
not build when i2c itself is disabled. Rather than also selecting
i2c, this makes the select conditional.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-pxa/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index ef35ce9..568b7f6 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -81,7 +81,7 @@ config ARCH_VIPER
 	bool "Arcom/Eurotech VIPER SBC"
 	select PXA25x
 	select ISA
-	select I2C_GPIO
+	select I2C_GPIO if I2C
 	select HAVE_PWM
 	select PXA_HAVE_ISA_IRQS
 	select ARCOM_PCMCIA
-- 
1.7.5.4

