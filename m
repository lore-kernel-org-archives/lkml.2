Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab2JEIYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:24:03 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56189 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533Ab2JEIX7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:23:59 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 23/28] leds-lp5521/5523: clean up definitions
Thread-Topic: [PATCH 23/28] leds-lp5521/5523: clean up definitions
Thread-Index: Ac2i0r9WtijE+N7WQYK2DefWUNZXYA==
Date: Fri, 5 Oct 2012 08:23:50 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F64176841@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Remove unused definitions and make hex values capital letters

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |   26 +++------------------
 drivers/leds/leds-lp5523.c |   54 ++++++--------------------------------------
 2 files changed, 10 insertions(+), 70 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index f810712..8b29d6b 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -39,18 +39,9 @@
 
 #include "leds-lp55xx-common.h"
 
-#define LP5521_PROGRAM_LENGTH		32	/* in bytes */
-
-#define LP5521_MAX_LEDS			3	/* Maximum number of LEDs */
-#define LP5521_MAX_ENGINES		3	/* Maximum number of engines */
-
-#define LP5521_ENG_MASK_BASE		0x30	/* 00110000 */
-#define LP5521_ENG_STATUS_MASK		0x07	/* 00000111 */
-
-#define LP5521_CMD_LOAD			0x15	/* 00010101 */
-#define LP5521_CMD_RUN			0x2a	/* 00101010 */
-#define LP5521_CMD_DIRECT		0x3f	/* 00111111 */
-#define LP5521_CMD_DISABLED		0x00	/* 00000000 */
+#define LP5521_PROGRAM_LENGTH		32
+#define LP5521_MAX_LEDS			3
+#define LP5521_CMD_DIRECT		0x3F
 
 /* Registers */
 #define LP5521_REG_ENABLE		0x00
@@ -62,22 +53,14 @@
 #define LP5521_REG_G_CURRENT		0x06
 #define LP5521_REG_B_CURRENT		0x07
 #define LP5521_REG_CONFIG		0x08
-#define LP5521_REG_R_CHANNEL_PC		0x09
-#define LP5521_REG_G_CHANNEL_PC		0x0A
-#define LP5521_REG_B_CHANNEL_PC		0x0B
 #define LP5521_REG_STATUS		0x0C
 #define LP5521_REG_RESET		0x0D
-#define LP5521_REG_GPO			0x0E
 #define LP5521_REG_R_PROG_MEM		0x10
 #define LP5521_REG_G_PROG_MEM		0x30
 #define LP5521_REG_B_PROG_MEM		0x50
 
-#define LP5521_PROG_MEM_BASE		LP5521_REG_R_PROG_MEM
-#define LP5521_PROG_MEM_SIZE		0x20
-
 /* Base register to set LED current */
 #define LP5521_REG_LED_CURRENT_BASE	LP5521_REG_R_CURRENT
-
 /* Base register to set the brightness */
 #define LP5521_REG_LED_PWM_BASE		LP5521_REG_R_PWM
 
@@ -96,9 +79,6 @@
 /* default R channel current register value */
 #define LP5521_REG_R_CURR_DEFAULT	0xAF
 
-/* Pattern Mode */
-#define PATTERN_OFF	0
-
 /* Reset register value */
 #define LP5521_RESET			0xFF
 
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 463ab72..bad85a9 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -39,78 +39,38 @@
 
 #include "leds-lp55xx-common.h"
 
+#define LP5523_PROGRAM_LENGTH		32
 #define LP5523_MAX_LEDS			9
 
+/* Registers */
 #define LP5523_REG_ENABLE		0x00
 #define LP5523_REG_OP_MODE		0x01
-#define LP5523_REG_RATIOMETRIC_MSB	0x02
-#define LP5523_REG_RATIOMETRIC_LSB	0x03
 #define LP5523_REG_ENABLE_LEDS_MSB	0x04
 #define LP5523_REG_ENABLE_LEDS_LSB	0x05
-#define LP5523_REG_LED_CNTRL_BASE	0x06
 #define LP5523_REG_LED_PWM_BASE		0x16
 #define LP5523_REG_LED_CURRENT_BASE	0x26
 #define LP5523_REG_CONFIG		0x36
-#define LP5523_REG_CHANNEL1_PC		0x37
-#define LP5523_REG_CHANNEL2_PC		0x38
-#define LP5523_REG_CHANNEL3_PC		0x39
-#define LP5523_REG_STATUS		0x3a
-#define LP5523_REG_GPO			0x3b
-#define LP5523_REG_VARIABLE		0x3c
-#define LP5523_REG_RESET		0x3d
-#define LP5523_REG_TEMP_CTRL		0x3e
-#define LP5523_REG_TEMP_READ		0x3f
-#define LP5523_REG_TEMP_WRITE		0x40
+#define LP5523_REG_STATUS		0x3A
+#define LP5523_REG_RESET		0x3D
 #define LP5523_REG_LED_TEST_CTRL	0x41
 #define LP5523_REG_LED_TEST_ADC		0x42
-#define LP5523_REG_ENG1_VARIABLE	0x45
-#define LP5523_REG_ENG2_VARIABLE	0x46
-#define LP5523_REG_ENG3_VARIABLE	0x47
-#define LP5523_REG_MASTER_FADER1	0x48
-#define LP5523_REG_MASTER_FADER2	0x49
-#define LP5523_REG_MASTER_FADER3	0x4a
-#define LP5523_REG_CH1_PROG_START	0x4c
-#define LP5523_REG_CH2_PROG_START	0x4d
-#define LP5523_REG_CH3_PROG_START	0x4e
-#define LP5523_REG_PROG_PAGE_SEL	0x4f
+#define LP5523_REG_PROG_PAGE_SEL	0x4F
 #define LP5523_REG_PROG_MEM		0x50
 
-#define LP5523_CMD_LOAD			0x15 /* 00010101 */
-#define LP5523_CMD_RUN			0x2a /* 00101010 */
-#define LP5523_CMD_DISABLED		0x00 /* 00000000 */
-
+/* Bit description in registers */
 #define LP5523_ENABLE			0x40
 #define LP5523_AUTO_INC			0x40
 #define LP5523_PWR_SAVE			0x20
 #define LP5523_PWM_PWR_SAVE		0x04
-#define LP5523_CP_1			0x08
-#define LP5523_CP_1_5			0x10
 #define LP5523_CP_AUTO			0x18
-#define LP5523_INT_CLK			0x01
 #define LP5523_AUTO_CLK			0x02
+
 #define LP5523_EN_LEDTEST		0x80
 #define LP5523_LEDTEST_DONE		0x80
 #define LP5523_RESET			0xFF
-
-#define LP5523_DEFAULT_CURRENT		50 /* microAmps */
-#define LP5523_PROGRAM_LENGTH		32 /* in bytes */
-#define LP5523_PROGRAM_PAGES		6
 #define LP5523_ADC_SHORTCIRC_LIM	80
-
-#define LP5523_LEDS			9
-#define LP5523_ENGINES			3
-
-#define LP5523_ENG_MASK_BASE		0x30 /* 00110000 */
-
-#define LP5523_ENG_STATUS_MASK          0x07 /* 00000111 */
-
-#define LP5523_IRQ_FLAGS                IRQF_TRIGGER_FALLING
-
 #define LP5523_EXT_CLK_USED		0x08
 
-#define LED_ACTIVE(mux, led)		(!!(mux & (0x0001 << led)))
-#define SHIFT_MASK(id)			(((id) - 1) * 2)
-
 /* Memory Page Selection */
 #define LP5523_PAGE_ENG1		0
 #define LP5523_PAGE_ENG2		1
-- 
1.7.9.5


Best Regards,
Milo


