Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab0FXM14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 08:27:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40985 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765Ab0FXM1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 08:27:55 -0400
From: Luotao Fu <l.fu@pengutronix.de>
To: Rabin VINCENT <rabin.vincent@stericsson.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       Luotao Fu <l.fu@pengutronix.de>
Subject: [PATCH 5/6 V2] mfd/stmpexxx: fix stmpe811 enable hook
Date: Thu, 24 Jun 2010 14:27:46 +0200
Message-Id: <1277382466-23603-1-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277378021-16802-7-git-send-email-l.fu@pengutronix.de>
References: <1277378021-16802-7-git-send-email-l.fu@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the stmpe811 enable hook so that we can activate the needed clocks for the
touchscreen controller.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
---
V2 Changes:
separate ADC block enable and ts block enable.

 drivers/mfd/stmpe-devices.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/stmpe-devices.c b/drivers/mfd/stmpe-devices.c
index 3e21c26..ded9dcb 100644
--- a/drivers/mfd/stmpe-devices.c
+++ b/drivers/mfd/stmpe-devices.c
@@ -117,8 +117,8 @@ static int stmpe811_enable(struct stmpe *stmpe, unsigned int blocks,
 	if (blocks & STMPE_BLOCK_ADC)
 		mask |= STMPE811_SYS_CTRL2_ADC_OFF;
 
-	if (blocks & STMPE_BLOCK_KEYPAD)
-		mask |= STMPE811_SYS_CTRL2_TSC_OFF;
+	if (blocks & STMPE_BLOCK_TOUCHSCREEN)
+		mask |= STMPE811_SYS_CTRL2_ADC_OFF;
 
 	return stmpe_set_bits(stmpe, STMPE811_REG_SYS_CTRL2, mask,
 			      enable ? 0 : mask);
-- 
1.7.1

