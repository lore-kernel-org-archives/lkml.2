Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab2HTH51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 03:57:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52198 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab2HTH5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 03:57:21 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel@pengutronix.de, linux-serial@vger.kernel.org
Subject: [PATCH] serial/imx: improve error diagnosics for clock and pinctrl failures
Date: Mon, 20 Aug 2012 09:57:04 +0200
Message-Id: <1345449424-24075-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These error paths are used more often now after deep changes to the
clock code and pinctrl is still new for imx. So help debugging and give
clues in the boot log.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/tty/serial/imx.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index d5c689d6..ce44de7 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1505,18 +1505,21 @@ static int serial_imx_probe(struct platform_device *pdev)
 	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
 	if (IS_ERR(pinctrl)) {
 		ret = PTR_ERR(pinctrl);
+		dev_err(&pdev->dev, "failed to get default pinctrl: %d\n", ret);
 		goto unmap;
 	}
 
 	sport->clk_ipg = devm_clk_get(&pdev->dev, "ipg");
 	if (IS_ERR(sport->clk_ipg)) {
 		ret = PTR_ERR(sport->clk_ipg);
+		dev_err(&pdev->dev, "failed to get ipg clk: %d\n", ret);
 		goto unmap;
 	}
 
 	sport->clk_per = devm_clk_get(&pdev->dev, "per");
 	if (IS_ERR(sport->clk_per)) {
 		ret = PTR_ERR(sport->clk_per);
+		dev_err(&pdev->dev, "failed to get per clk: %d\n", ret);
 		goto unmap;
 	}
 
-- 
1.7.10.4

