Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab2DMWkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 18:40:07 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:61039 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753773Ab2DMWhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 18:37:40 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, srinivas.bakki@nxp.com, kevin.wells@nxp.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        rtc-linux@googlegroups.com, a.zummo@towertech.it,
        linux-watchdog@vger.kernel.org, wim@iguana.be, jonsmirl@gmail.com
Cc: Roland Stigge <stigge@antcom.de>, stable@vger.kernel.org
Subject: [PATCH RESEND v3 5/8] i2c-pnx.c: Fix suspend
Date: Sat, 14 Apr 2012 00:36:36 +0200
Message-Id: <1334356600-20950-5-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1334356600-20950-1-git-send-email-stigge@antcom.de>
References: <1334356600-20950-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the driver's suspend function, clk_enable() was used instead of
clk_disable(). This is corrected with this patch.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
CC: stable@vger.kernel.org

---

 Applies to v3.4-rc2

 drivers/i2c/busses/i2c-pnx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.orig/drivers/i2c/busses/i2c-pnx.c
+++ linux-2.6/drivers/i2c/busses/i2c-pnx.c
@@ -546,8 +546,7 @@ static int i2c_pnx_controller_suspend(st
 {
 	struct i2c_pnx_algo_data *alg_data = platform_get_drvdata(pdev);
 
-	/* FIXME: shouldn't this be clk_disable? */
-	clk_enable(alg_data->clk);
+	clk_disable(alg_data->clk);
 
 	return 0;
 }
