Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab0LCPhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:37:23 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:56775 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752747Ab0LCPhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:37:13 -0500
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>, <dmitry.torokhov@gmail.com>,
        <sameo@linux.intel.com>, <ben-linux@fluff.org>
Cc: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sundar Iyer <sundar.iyer@stericsson.com>
Subject: [PATCH 12/20] mfd/tc3589x: undo gpio module reset during chip init
Date: Fri, 3 Dec 2010 20:35:45 +0530
Message-ID: <1291388753-14662-13-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
References: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Skip putting the GPIO module into a reset during the chip init.  This makes
sure to preserve any existing GPIO configurations done by pre-kernel boot code.

Signed-off-by: Sundar Iyer <sundar.iyer@stericsson.com>
---
 drivers/mfd/tc3589x.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
index e173f33..fd206fd 100644
--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -247,12 +247,15 @@ static int tc3589x_chip_init(struct tc3589x *tc3589x)
 
 	dev_info(tc3589x->dev, "manufacturer: %#x, version: %#x\n", manf, ver);
 
-	/* Put everything except the IRQ module into reset */
+	/*
+	 * Put everything except the IRQ module into reset;
+	 * also spare the GPIO module for any pin initialization
+	 * done during pre-kernel boot
+	 */
 	ret = tc3589x_reg_write(tc3589x, TC3589x_RSTCTRL,
 				TC3589x_RSTCTRL_TIMRST
 				| TC3589x_RSTCTRL_ROTRST
-				| TC3589x_RSTCTRL_KBDRST
-				| TC3589x_RSTCTRL_GPIRST);
+				| TC3589x_RSTCTRL_KBDRST);
 	if (ret < 0)
 		return ret;
 
-- 
1.7.2.dirty

