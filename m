Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab1LTBPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:15:41 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36781 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753803Ab1LTBPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:15:35 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Vladimir Zapolskiy <vz@mleia.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com> (supporter:MULTIFUNCTION
	DEV...)
Subject: [PATCH v4 2/4] mfd: simplify twl4030_core config
Date: Tue, 20 Dec 2011 03:15:15 +0200
Message-Id: <1324343717-7292-3-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.8.rc1.14.g248db
In-Reply-To: <1324343717-7292-1-git-send-email-felipe.contreras@gmail.com>
References: <1324343717-7292-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation says it all "These multi-function chips are found on
many OMAP2 and OMAP3 boards", so lets enable it by default.

This simplifies the defconfig from:

 CONFIG_ARCH_OMAP=y
 CONFIG_TWL4030_CORE=y

To:

 CONFIG_ARCH_OMAP=y

Of course, you can always do:

 CONFIG_ARCH_OMAP=y
 CONFIG_TWL4030_CORE=n

If you want, to reduce the size of the kernel. This is just the
*default*.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/mfd/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index c4b6f7d..057abd0 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -200,6 +200,7 @@ config MENELAUS
 config TWL4030_CORE
 	bool "Texas Instruments TWL4030/TWL5030/TWL6030/TPS659x0 Support"
 	depends on I2C=y && GENERIC_HARDIRQS
+	default y if ARCH_OMAP3 || ARCH_OMAP4
 	help
 	  Say yes here if you have TWL4030 / TWL6030 family chip on your board.
 	  This core driver provides register access and IRQ handling
-- 
1.7.8.rc1.14.g248db

