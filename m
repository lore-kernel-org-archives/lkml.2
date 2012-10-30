Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423025Ab2JaXMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 19:12:55 -0400
Received: from mailserver6.natinst.com ([130.164.80.6]:53354 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab2JaXMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 19:12:52 -0400
Message-Id: <61e872b2cd4abc25c2dab82668e5094b590571a0.1351721190.git.josh.cartwright@ni.com>
In-Reply-To: <cover.1351721190.git.josh.cartwright@ni.com>
References: <cover.1351721190.git.josh.cartwright@ni.com>
From: Josh Cartwright <josh.cartwright@ni.com>
Date: Tue, 30 Oct 2012 06:25:59 -0600
Subject: [PATCH 6/8] serial: xilinx_uartps: kill CONFIG_OF conditional
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Linn <John.Linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/31/2012 06:12:27 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/31/2012 06:12:27 PM,
	Serialize complete at 10/31/2012 06:12:27 PM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-31_03:2012-10-31,2012-10-31,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Zynq platform requires the use of CONFIG_OF.  Remove the #ifdef
conditionals in the uartps driver.

Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
---
 drivers/tty/serial/xilinx_uartps.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index b627363..23efe17 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -946,15 +946,11 @@ static int __devinit xuartps_probe(struct platform_device *pdev)
 	struct resource *res, *res2;
 	int clk = 0;
 
-#ifdef CONFIG_OF
 	const unsigned int *prop;
 
 	prop = of_get_property(pdev->dev.of_node, "clock", NULL);
 	if (prop)
 		clk = be32_to_cpup(prop);
-#else
-	clk = *((unsigned int *)(pdev->dev.platform_data));
-#endif
 	if (!clk) {
 		dev_err(&pdev->dev, "no clock specified\n");
 		return -ENODEV;
@@ -1044,16 +1040,11 @@ static int xuartps_resume(struct platform_device *pdev)
 }
 
 /* Match table for of_platform binding */
-
-#ifdef CONFIG_OF
 static struct of_device_id xuartps_of_match[] __devinitdata = {
 	{ .compatible = "xlnx,xuartps", },
 	{}
 };
 MODULE_DEVICE_TABLE(of, xuartps_of_match);
-#else
-#define xuartps_of_match NULL
-#endif
 
 static struct platform_driver xuartps_platform_driver = {
 	.probe   = xuartps_probe,		/* Probe method */
-- 
1.8.0


