Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933672Ab1KBShZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:37:25 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18091 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932593Ab1KBShO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:37:14 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133707021"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
Subject: [RFC PATCH 34/34] msm_serial: fix clock rate on DMA-based uarts
Date: Wed,  2 Nov 2011 11:36:31 -0700
Message-Id: <1320258991-22325-35-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver explicitly requests a clock rate for the UART, but it is
off by a factor of four from the dividers that it programs into the
UART.  Fix this by setting the rate to 1/4 of the current value.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 drivers/tty/serial/msm_serial.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 29cbfd8..b7baceb 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -891,7 +891,7 @@ static int __init msm_serial_probe(struct platform_device *pdev)
 			return PTR_ERR(msm_port->clk);
 
 	if (msm_port->is_uartdm)
-		clk_set_rate(msm_port->clk, 7372800);
+		clk_set_rate(msm_port->clk, 1843200);
 
 	port->uartclk = clk_get_rate(msm_port->clk);
 	printk(KERN_INFO "uartclk = %d\n", port->uartclk);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

