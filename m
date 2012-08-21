Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506Ab2HUUsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 16:48:50 -0400
Received: from mta06.xtra.co.nz ([210.54.141.249]:47639 "EHLO mta03.xtra.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758422Ab2HUUsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 16:48:15 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: vt8500-wm8505-linux-kernel@googlegroup.com
Cc: Tony Prisk <linux@prisktech.co.nz>, Russell King <linux@arm.linux.org.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mike Turquette <mturquette@ti.com>,
        Stephen Warren <swarren@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-serial@vger.kernel.org, rtc-linux@googlegroups.com,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCHv3 2/9] rtc: vt8500: Add devicetree support for vt8500-rtc
Date: Wed, 22 Aug 2012 08:47:31 +1200
Message-Id: <1345582058-2291-3-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345582058-2291-1-git-send-email-linux@prisktech.co.nz>
References: <1345582058-2291-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 drivers/rtc/rtc-vt8500.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-vt8500.c b/drivers/rtc/rtc-vt8500.c
index 9e94fb1..07bf193 100644
--- a/drivers/rtc/rtc-vt8500.c
+++ b/drivers/rtc/rtc-vt8500.c
@@ -23,6 +23,7 @@
 #include <linux/bcd.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/of.h>
 
 /*
  * Register definitions
@@ -302,12 +303,18 @@ static int __devexit vt8500_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id wmt_dt_ids[] = {
+	{ .compatible = "via,vt8500-rtc", },
+	{}
+};
+
 static struct platform_driver vt8500_rtc_driver = {
 	.probe		= vt8500_rtc_probe,
 	.remove		= __devexit_p(vt8500_rtc_remove),
 	.driver		= {
 		.name	= "vt8500-rtc",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(wmt_dt_ids),
 	},
 };
 
@@ -315,5 +322,5 @@ module_platform_driver(vt8500_rtc_driver);
 
 MODULE_AUTHOR("Alexey Charkov <alchark@gmail.com>");
 MODULE_DESCRIPTION("VIA VT8500 SoC Realtime Clock Driver (RTC)");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:vt8500-rtc");
-- 
1.7.9.5

