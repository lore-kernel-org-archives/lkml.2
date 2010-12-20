Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab0LTM2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 07:28:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55401 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755491Ab0LTM2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 07:28:33 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Arun Murthy <arun.murthy@stericsson.com>
Cc: linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] misc: Make AB8500_PWM driver depend on U8500 due to PWM breakage
Date: Mon, 20 Dec 2010 12:28:11 +0000
Message-Id: <1292848091-29959-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101220192121.47767525.sfr@canb.auug.org.au>
References: <20101220192121.47767525.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we don't have a PWM API every PWM driver ends up exporting its
own version and we need to limit the platforms we try to build them on
in order to avoid multiple definitions. As the AB8500 is normally a
companion chip for the U8500 CPU depend on that architecture.

Previously the driver was relying on the AB8500 core only being built
on U8500 but this did not give us build coverage of any of the other
functions for the device.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

Here's a better way of solving the problem, it means we can build the
MFD and all the other functions on other platforms and still exclude the
problematic PWM driver.

 drivers/misc/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 4d073f1..736004d 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -64,7 +64,7 @@ config ATMEL_PWM
 
 config AB8500_PWM
 	bool "AB8500 PWM support"
-	depends on AB8500_CORE
+	depends on AB8500_CORE && ARCH_U8500
 	select HAVE_PWM
 	help
 	  This driver exports functions to enable/disble/config/free Pulse
-- 
1.7.1

