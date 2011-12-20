Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab1LTFAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 00:00:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61100 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab1LTFAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 00:00:47 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 1/2] gpio-pch: fix a bug in the interrupt handler
Date: Tue, 20 Dec 2011 13:58:52 +0900
Message-Id: <1324357133-16086-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also need the following patch for gpio-pch

commit 4d052213ff8f71a4a70fc4eed71b773cfde51fcf
Author: Feng Tang <feng.tang@intel.com>
Date:   Tue Dec 13 23:53:50 2011 +0800

    gpio-ml-ioh: Add the irq_disable/irq_enable hooks for ml-ioh irq chip

    These hooks will be needed by the general disabl/enable_irq();

    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Reported-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/gpio/gpio-pch.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-pch.c b/drivers/gpio/gpio-pch.c
index f060329..01bd405 100644
--- a/drivers/gpio/gpio-pch.c
+++ b/drivers/gpio/gpio-pch.c
@@ -320,7 +320,7 @@ static irqreturn_t pch_gpio_handler(int irq, void *dev_id)
 	int i;
 	int ret = IRQ_NONE;
 
-	for (i = 0; i < gpio_pins[chip->ioh]; i++) {
+	for (i = 0; i < gpio_pins[chip->ioh]; i++, chip++) {
 		if (reg_val & BIT(i)) {
 			dev_dbg(chip->dev, "%s:[%d]:irq=%d  status=0x%x\n",
 				__func__, i, irq, reg_val);
-- 
1.7.4.4

