Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab2KEVYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 16:24:21 -0500
Received: from mailserver6.natinst.com ([130.164.80.6]:55835 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2KEVYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 16:24:19 -0500
Date: Mon, 5 Nov 2012 15:24:26 -0600
From: Josh Cartwright <josh.cartwright@ni.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] serial: xilinx_uartps: kill CONFIG_OF conditional
Message-ID: <20121105212426.GA1972@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/05/2012 03:24:17 PM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/05/2012 03:24:17 PM,
	Serialize complete at 11/05/2012 03:24:17 PM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-11-05_03:2012-11-05,2012-11-05,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Zynq platform requires the use of CONFIG_OF.  Remove the #ifdef
conditionals in the uartps driver.  Make dependency explicit in Kconfig.

Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
---
Michal-

Here's a version of this patch outside of my COMMON_CLK patchset as you
requested ontop of your arm-next branch.  An explicit dependency was
added in Kconfig as you had suggested.

Thanks,
   Josh

 drivers/tty/serial/Kconfig         | 1 +
 drivers/tty/serial/xilinx_uartps.c | 9 ---------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 2a53be5..8cb29b5 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1376,6 +1376,7 @@ config SERIAL_MXS_AUART_CONSOLE
 
 config SERIAL_XILINX_PS_UART
 	tristate "Xilinx PS UART support"
+	depends on OF
 	select SERIAL_CORE
 	help
 	  This driver supports the Xilinx PS UART port.
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
