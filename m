Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099Ab1IBCN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 22:13:27 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:41679 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933059Ab1IBCN0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 22:13:26 -0400
From: Philip Rakity <prakity@marvell.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 1 Sep 2011 19:10:29 -0700
Subject: [PATCH 1/2] power: max8925_power:  Do not read random data from
 chip  registers
Thread-Topic: [PATCH 1/2] power: max8925_power:  Do not read random data
 from chip  registers
Thread-Index: AcxpFXjI/eItPkOvTByFLdpNqjredw==
Message-ID: <E1322B23-1B84-4E72-A106-1F6B1F6F8504@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reading the voltage, charge etc requires that we tell the chip
what property we want to read before reading it according to
maxim.

Signed-off-by: Philip Rakity <prakity@marvell.com>
Signed-off-by: Thomas Liu <Thomas.Liu@maxim-ic.com>
Tested-by: Ted Bennett <tbennett@marvell.com>
---
 drivers/power/max8925_power.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
index f808608..b56c78a 100644
--- a/drivers/power/max8925_power.c
+++ b/drivers/power/max8925_power.c
@@ -245,25 +245,30 @@ irqreturn_t max8925_charger_handler(int irq, void *data)
 static int start_measure(struct max8925_power_info *info, int type)
 {
 	unsigned char buf[2] = {0, 0};
-	int meas_reg = 0, ret;
+	int meas_reg = 0, meas_cmd = 0, ret;
 
 	switch (type) {
 	case MEASURE_VCHG:
+		meas_cmd = MAX8925_CMD_VCHG;
 		meas_reg = MAX8925_ADC_VCHG;
 		break;
 	case MEASURE_VBBATT:
+		meas_cmd = MAX8925_CMD_VBBATT;
 		meas_reg = MAX8925_ADC_VBBATT;
 		break;
 	case MEASURE_VMBATT:
+		meas_cmd = MAX8925_CMD_VMBATT;
 		meas_reg = MAX8925_ADC_VMBATT;
 		break;
 	case MEASURE_ISNS:
+		meas_cmd = MAX8925_CMD_ISNS;
 		meas_reg = MAX8925_ADC_ISNS;
 		break;
 	default:
 		return -EINVAL;
 	}
 
+	max8925_reg_write(info->adc, meas_cmd, 0);
 	max8925_bulk_read(info->adc, meas_reg, 2, buf);
 	ret = ((buf[0]<<8) | buf[1]) >> 4;
 
-- 
1.7.6


