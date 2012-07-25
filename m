Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933431Ab2GYPIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:08:38 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:39712 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933160Ab2GYPI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:08:27 -0400
From: Roland Stigge <stigge@antcom.de>
To: vitalywool@gmail.com, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, grant.likely@secretlab.ca,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, aletes.xgr@gmail.com,
        jonsmirl@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 1/2] i2c: pnx: Fix bit definitions
Date: Wed, 25 Jul 2012 17:07:42 +0200
Message-Id: <1343228863-11553-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The I2C Control Register bits RFDAIE and RFFIE were mixed up. In addition to
this fix, this patch adds the missing bit DRSIE for completeness.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
Applies to v3.5

This patch for i2c-pnx applies to: PNX4008, LPC31xx, LPC32xx. Can you please
test and double-check the manuals of PNX4008 and LPC31xx? I only found this via
the manual of LPC32xx but assume it's the same for the others, also.

Thanks in advance!

 drivers/i2c/busses/i2c-pnx.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.orig/drivers/i2c/busses/i2c-pnx.c
+++ linux-2.6/drivers/i2c/busses/i2c-pnx.c
@@ -48,8 +48,9 @@ enum {
 	mcntrl_afie = 0x00000002,
 	mcntrl_naie = 0x00000004,
 	mcntrl_drmie = 0x00000008,
-	mcntrl_daie = 0x00000020,
-	mcntrl_rffie = 0x00000040,
+	mcntrl_drsie = 0x00000010,
+	mcntrl_rffie = 0x00000020,
+	mcntrl_daie = 0x00000040,
 	mcntrl_tffie = 0x00000080,
 	mcntrl_reset = 0x00000100,
 	mcntrl_cdbmode = 0x00000400,
