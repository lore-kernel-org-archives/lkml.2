Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab1IVGim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 02:38:42 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:57254 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab1IVGik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 02:38:40 -0400
X-SpamScore: -5
X-BigFish: VS-5(z78cMzzz1202hzz8275dhz2dh87h2a8h668h839h65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Shawn Guo <shawn.guo@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <patches@linaro.org>, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH] serial/imx: add of_alias_get_id() reference back
Date: Thu, 22 Sep 2011 14:48:13 +0800
Message-ID: <1316674093-14802-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20110921204545.19871.99088.stgit@ponder>
References: <20110921204545.19871.99088.stgit@ponder>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of_alias_get_id() gets fixed and ready for use, the patch adds the
of_alias_get_id() reference back to imx serial driver.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/tty/serial/imx.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 4a36470..b550cff 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1318,17 +1318,22 @@ static int serial_imx_resume(struct platform_device *dev)
 static int serial_imx_probe_dt(struct imx_port *sport,
 		struct platform_device *pdev)
 {
-	static int portnum = 0;
 	struct device_node *np = pdev->dev.of_node;
 	const struct of_device_id *of_id =
 			of_match_device(imx_uart_dt_ids, &pdev->dev);
+	int ret;
 
 	if (!np)
 		return -ENODEV;
 
-	sport->port.line = portnum++;
-	if (sport->port.line >= UART_NR)
-		return -EINVAL;
+	ret = of_alias_get_id(np, "serial");
+	if (ret < 0) {
+		pr_err("%s: failed to get alias id, errno %d\n",
+			__func__, ret);
+		return -ENODEV;
+	} else {
+		sport->port.line = ret;
+	}
 
 	if (of_get_property(np, "fsl,uart-has-rtscts", NULL))
 		sport->have_rtscts = 1;
-- 
1.7.4.1


