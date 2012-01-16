Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab2APQLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 11:11:19 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:39644 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab2APQLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 11:11:17 -0500
From: jhbird.choi@samsung.com
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Sangbeom Kim <sbkim73@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH] mfd: s5m: Fix possible null pointer dereference
Date: Mon, 16 Jan 2012 09:08:42 +0900
Message-Id: <1326672522-10947-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwan Choi <jhbird.choi@samsung.com>

This patch checks for pdata to using it.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/mfd/s5m-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/s5m-core.c b/drivers/mfd/s5m-core.c
index e075c11..caadabe 100644
--- a/drivers/mfd/s5m-core.c
+++ b/drivers/mfd/s5m-core.c
@@ -105,7 +105,7 @@ static int s5m87xx_i2c_probe(struct i2c_client *i2c,
 	s5m87xx->rtc = i2c_new_dummy(i2c->adapter, RTC_I2C_ADDR);
 	i2c_set_clientdata(s5m87xx->rtc, s5m87xx);
 
-	if (pdata->cfg_pmic_irq)
+	if (pdata && pdata->cfg_pmic_irq)
 		pdata->cfg_pmic_irq();
 
 	s5m_irq_init(s5m87xx);
-- 
1.7.1

