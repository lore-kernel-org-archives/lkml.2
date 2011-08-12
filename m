Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab1HLIvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:51:14 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:47165 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317Ab1HLIvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:51:05 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 02/23] mfd/db8500-prcmu: extend DB8500 PRCMU mailbox defs
Date: Fri, 12 Aug 2011 10:27:41 +0200
Message-ID: <1313137661-30650-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Nilsson <mattias.i.nilsson@stericsson.com>

We have a few more mailboxes and fixed messages in the
DB8500 PRCMU, update to match the latest specification.

Signed-off-by: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db8500-prcmu.c |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index b5bd245..dcc690e 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -131,12 +131,14 @@
 #define MB1H_REQUEST_APE_OPP_100_VOLT 0x3
 #define MB1H_RELEASE_APE_OPP_100_VOLT 0x4
 #define MB1H_RELEASE_USB_WAKEUP 0x5
+#define MB1H_PLL_ON_OFF 0x6
 
 /* Mailbox 1 Requests */
 #define PRCM_REQ_MB1_ARM_OPP			(PRCM_REQ_MB1 + 0x0)
 #define PRCM_REQ_MB1_APE_OPP			(PRCM_REQ_MB1 + 0x1)
-#define PRCM_REQ_MB1_APE_OPP_100_RESTORE	(PRCM_REQ_MB1 + 0x4)
-#define PRCM_REQ_MB1_ARM_OPP_100_RESTORE	(PRCM_REQ_MB1 + 0x8)
+#define PRCM_REQ_MB1_PLL_ON_OFF			(PRCM_REQ_MB1 + 0x4)
+#define PLL_SOC1_OFF	0x4
+#define PLL_SOC1_ON	0x8
 
 /* Mailbox 1 ACKs */
 #define PRCM_ACK_MB1_CURRENT_ARM_OPP	(PRCM_ACK_MB1 + 0x0)
@@ -184,6 +186,11 @@
 #define MB4H_HOTDOG	0x12
 #define MB4H_HOTMON	0x13
 #define MB4H_HOT_PERIOD	0x14
+#define MB4H_A9WDOG_CONF 0x16
+#define MB4H_A9WDOG_EN   0x17
+#define MB4H_A9WDOG_DIS  0x18
+#define MB4H_A9WDOG_LOAD 0x19
+#define MB4H_A9WDOG_KICK 0x20
 
 /* Mailbox 4 Requests */
 #define PRCM_REQ_MB4_DDR_ST_AP_SLEEP_IDLE	(PRCM_REQ_MB4 + 0x0)
@@ -196,6 +203,13 @@
 #define PRCM_REQ_MB4_HOT_PERIOD			(PRCM_REQ_MB4 + 0x0)
 #define HOTMON_CONFIG_LOW			BIT(0)
 #define HOTMON_CONFIG_HIGH			BIT(1)
+#define PRCM_REQ_MB4_A9WDOG_0			(PRCM_REQ_MB4 + 0x0)
+#define PRCM_REQ_MB4_A9WDOG_1			(PRCM_REQ_MB4 + 0x1)
+#define PRCM_REQ_MB4_A9WDOG_2			(PRCM_REQ_MB4 + 0x2)
+#define PRCM_REQ_MB4_A9WDOG_3			(PRCM_REQ_MB4 + 0x3)
+#define A9WDOG_AUTO_OFF_EN			BIT(7)
+#define A9WDOG_AUTO_OFF_DIS			0
+#define A9WDOG_ID_MASK				0xf
 
 /* Mailbox 5 Requests */
 #define PRCM_REQ_MB5_I2C_SLAVE_OP	(PRCM_REQ_MB5 + 0x0)
@@ -1638,6 +1652,11 @@ static bool read_mailbox_4(void)
 	case MB4H_HOTDOG:
 	case MB4H_HOTMON:
 	case MB4H_HOT_PERIOD:
+	case MB4H_A9WDOG_CONF:
+	case MB4H_A9WDOG_EN:
+	case MB4H_A9WDOG_DIS:
+	case MB4H_A9WDOG_LOAD:
+	case MB4H_A9WDOG_KICK:
 		break;
 	default:
 		print_unknown_header_warning(4, header);
-- 
1.7.3.2

