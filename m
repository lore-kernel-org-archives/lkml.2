Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab0LIUEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:04:22 -0500
Received: from mail.perches.com ([173.55.12.10]:2400 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757053Ab0LIUEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:04:13 -0500
From: Joe Perches <joe@perches.com>
To: David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Jiri Kosina <trivial@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/15] serial: Remove duplicate unlikely from IS_ERR
Date: Thu,  9 Dec 2010 12:03:59 -0800
Message-Id: <102d208d9a7b0de018361a71875da14eab0df2ec.1291923889.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.464.gf80b6
In-Reply-To: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
References: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
In-Reply-To: <cover.1291923888.git.joe@perches.com>
References: <cover.1291923888.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IS_ERR already uses unlikely, remove unlikely from the call sites.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/serial/msm_serial.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/msm_serial.c b/drivers/serial/msm_serial.c
index f8c816e..8e43a7b 100644
--- a/drivers/serial/msm_serial.c
+++ b/drivers/serial/msm_serial.c
@@ -686,7 +686,7 @@ static int __init msm_serial_probe(struct platform_device *pdev)
 	msm_port = UART_TO_MSM(port);
 
 	msm_port->clk = clk_get(&pdev->dev, "uart_clk");
-	if (unlikely(IS_ERR(msm_port->clk)))
+	if (IS_ERR(msm_port->clk))
 		return PTR_ERR(msm_port->clk);
 	port->uartclk = clk_get_rate(msm_port->clk);
 	printk(KERN_INFO "uartclk = %d\n", port->uartclk);
-- 
1.7.3.3.464.gf80b6

