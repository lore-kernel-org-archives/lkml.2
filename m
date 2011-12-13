Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab1LMGc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 01:32:57 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:54891 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246Ab1LMGcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 01:32:53 -0500
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 12/19] cpuimx35: fix touchscreen support
Date: Tue, 13 Dec 2011 07:31:44 +0100
Message-Id: <1323757911-25217-12-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1323757911-25217-1-git-send-email-eric@eukrea.com>
References: <1323757911-25217-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Eric Bénard <eric@eukrea.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
---
 arch/arm/mach-imx/mach-cpuimx35.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-imx/mach-cpuimx35.c b/arch/arm/mach-imx/mach-cpuimx35.c
index 66af2e8..362aae7 100644
--- a/arch/arm/mach-imx/mach-cpuimx35.c
+++ b/arch/arm/mach-imx/mach-cpuimx35.c
@@ -53,12 +53,18 @@ static const struct imxi2c_platform_data
 	.bitrate =		100000,
 };
 
+#define TSC2007_IRQGPIO		IMX_GPIO_NR(3, 2)
+static int tsc2007_get_pendown_state(void)
+{
+	return !gpio_get_value(TSC2007_IRQGPIO);
+}
+
 static struct tsc2007_platform_data tsc2007_info = {
 	.model			= 2007,
 	.x_plate_ohms		= 180,
+	.get_pendown_state = tsc2007_get_pendown_state,
 };
 
-#define TSC2007_IRQGPIO		IMX_GPIO_NR(3, 2)
 static struct i2c_board_info eukrea_cpuimx35_i2c_devices[] = {
 	{
 		I2C_BOARD_INFO("pcf8563", 0x51),
-- 
1.7.6.4

