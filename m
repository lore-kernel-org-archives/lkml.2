Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab0EQQxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 12:53:43 -0400
Received: from smtp3.epfl.ch ([128.178.224.226]:55859 "HELO smtp3.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754596Ab0EQQxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 12:53:41 -0400
From: =?utf-8?q?Philippe=20R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>
To: s.hauer@pengutronix.de
Cc: u.kleine-koenig@pengutronix.de, maramaopercheseimorto@gmail.com,
       sameo@linux.intel.com, valentin.longchamp@epfl.ch,
       rpurdie@linux.intel.com, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org,
       =?utf-8?q?Philippe=20R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>
Subject: [PATCH 2/2] mx31moboard: Add MC13783 led support
Date: Mon, 17 May 2010 18:40:23 +0200
Message-Id: <1274114423-30020-3-git-send-email-philippe.retornaz@epfl.ch>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1274114423-30020-2-git-send-email-philippe.retornaz@epfl.ch>
References: <1274114423-30020-1-git-send-email-philippe.retornaz@epfl.ch>
 <1274114423-30020-2-git-send-email-philippe.retornaz@epfl.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add two RGB led on mx31moboard using MC13783 led subsystem

Signed-off-by: Philippe Rétornaz <philippe.retornaz@epfl.ch>
---
 arch/arm/mach-mx3/mach-mx31moboard.c |   45 +++++++++++++++++++++++++++++++++-
 1 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-mx3/mach-mx31moboard.c b/arch/arm/mach-mx3/mach-mx31moboard.c
index 33a8d35..62b5e40 100644
--- a/arch/arm/mach-mx3/mach-mx31moboard.c
+++ b/arch/arm/mach-mx3/mach-mx31moboard.c
@@ -220,11 +220,54 @@ static struct mc13783_regulator_init_data moboard_regulators[] = {
 	},
 };
 
+static struct mc13783_led_platform_data moboard_led[] = {
+	{
+		.id = MC13783_LED_R1,
+		.name = "coreboard-led-4:red",
+		.max_current = 2,
+	},
+	{
+		.id = MC13783_LED_G1,
+		.name = "coreboard-led-4:green",
+		.max_current = 2,
+	},
+	{
+		.id = MC13783_LED_B1,
+		.name = "coreboard-led-4:blue",
+		.max_current = 2,
+	},
+	{
+		.id = MC13783_LED_R2,
+		.name = "coreboard-led-5:red",
+		.max_current = 3,
+	},
+	{
+		.id = MC13783_LED_G2,
+		.name = "coreboard-led-5:green",
+		.max_current = 3,
+	},
+	{
+		.id = MC13783_LED_B2,
+		.name = "coreboard-led-5:blue",
+		.max_current = 3,
+	},
+};
+
+static struct mc13783_leds_platform_data moboard_leds = {
+	.num_leds = ARRAY_SIZE(moboard_led),
+	.led = moboard_led,
+	.flags = MC13783_LED_SLEWLIMTC,
+	.abmode = MC13783_LED_AB_DISABLED,
+	.tc1_period = MC13783_LED_PERIOD_10MS,
+	.tc2_period = MC13783_LED_PERIOD_10MS,
+};
+
 static struct mc13783_platform_data moboard_pmic = {
 	.regulators = moboard_regulators,
 	.num_regulators = ARRAY_SIZE(moboard_regulators),
+	.leds = &moboard_leds,
 	.flags = MC13783_USE_REGULATOR | MC13783_USE_RTC |
-		MC13783_USE_ADC,
+		MC13783_USE_ADC | MC13783_USE_LED,
 };
 
 static struct spi_board_info moboard_spi_board_info[] __initdata = {
-- 
1.6.3.3

