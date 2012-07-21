Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab2GULUc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 07:20:32 -0400
Received: from mta05.xtra.co.nz ([210.54.141.250]:40512 "EHLO mta02.xtra.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751686Ab2GULUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 07:20:31 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Alessandro Zumoo <a.zummo@towertech.it>, Alan Cox <alan@linux.intel.com>
Cc: Tony Prisk <linux@prisktech.co.nz>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        VT8500 mailing list 
	<vt8500-wm8505-linux-kernel@googlegroups.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org
Subject: [PATCHv2 1/2] ARM: vt8500: Minor update to vt8500-rtc for devicetree support
Date: Sat, 21 Jul 2012 23:20:21 +1200
Message-Id: <1342869622-11171-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
v2:
Split single patch into seperate patches.
Correct documentation.
 .../devicetree/bindings/rtc/vt8500-rtc.txt         |   14 ++++++++++++++
 drivers/rtc/rtc-vt8500.c                           |    8 ++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rtc/vt8500-rtc.txt

diff --git a/Documentation/devicetree/bindings/rtc/vt8500-rtc.txt b/Documentation/devicetree/bindings/rtc/vt8500-rtc.txt
new file mode 100644
index 0000000..c764d4d
--- /dev/null
+++ b/Documentation/devicetree/bindings/rtc/vt8500-rtc.txt
@@ -0,0 +1,14 @@
+* VIA VT8500 and Wondermedia WM8xxx SoC Real-time clock (RTC) Controller
+
+Required properties:
+- compatible : "via,vt8500-rtc"
+- reg : Address range of the rtc registers
+- interrupt: Should contain the rtc interrupt number
+
+Example:
+
+	rtc@d8100000 {
+		compatible = "via,vt8500-rtc";
+		reg = <0xd8100000 0x2c>;
+		interrupts = <48>;
+	};
diff --git a/drivers/rtc/rtc-vt8500.c b/drivers/rtc/rtc-vt8500.c
index 9e94fb1..d21fcd3 100644
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
 
+static const struct of_device_id vt8500_rtc_ids[] = {
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
+		.of_match_table = of_match_ptr(vt8500_rtc_ids),
 	},
 };
 
@@ -317,3 +324,4 @@ MODULE_AUTHOR("Alexey Charkov <alchark@gmail.com>");
 MODULE_DESCRIPTION("VIA VT8500 SoC Realtime Clock Driver (RTC)");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:vt8500-rtc");
+MODULE_DEVICE_TABLE(of, vt8500_rtc_ids);
-- 
1.7.2.5

