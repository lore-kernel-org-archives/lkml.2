Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab1JBOuK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:50:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57287 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab1JBOrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:47:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, Balaji T K <balajitk@ti.com>,
        Hemanth V <hemanthv@ti.com>
Subject: [PATCH 22/30] mfd: build twl6030 only on omap2
Date: Sun,  2 Oct 2011 16:45:52 +0200
Message-Id: <1317566760-25681-23-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:/io+Tz/DuWJpwUUKOFKZJQr6AQ/UwgLX/Dyd/CB+Kvj
 XNu697pac9EE+6dx52Klc0TUxA3Zo2zx2qBwXUlVDmwymbcUcI
 N4yC1FgMN9kpGZqTdnPqeANL+qH2gaRCi0iQ1juxr5SeVzivox
 hO1SZpKdpP2ktgqO8VsoHA50Ge+50aBpK4sQGKqExT3tv+NquL
 hvCDRQnJoshchXagqcDW9nXmdVvYBAqPzPdEYeqVd/tyJI7bnn
 5nwTDhUKSztuH2OKnaFxljmSzee3y2hGL4rJMSOWft2iQ2IifW
 lGNaVzNCILtITTcDMn9qjKLrtr5ycvoGeEkDUIcv0OQ5SzUqVc
 vWGlk1/Qame3Bgcay87kom40QG2bNeTc9Fzl4xNgfe94trh2a1
 AHodsYP/UnlPw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can only have one pwm driver built into the kernel, so make sure
that this one is only available on omap2 to avoid conflicts with
pwm drivers of other platforms.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Balaji T K <balajitk@ti.com>
Cc: Hemanth V <hemanthv@ti.com>
---
 drivers/mfd/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 48cce35..26bebe8 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -256,8 +256,8 @@ config MFD_TWL4030_AUDIO
 	default n
 
 config TWL6030_PWM
-	tristate "TWL6030 PWM (Pulse Width Modulator) Support"
-	depends on TWL4030_CORE
+	bool "TWL6030 PWM (Pulse Width Modulator) Support"
+	depends on TWL4030_CORE && ARCH_OMAP2
 	select HAVE_PWM
 	default n
 	help
-- 
1.7.5.4

