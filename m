Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab1CCMcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 07:32:43 -0500
Received: from sputnik.urmx.de ([88.198.51.18]:39917 "EHLO sputnik.urmx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756354Ab1CCMcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 07:32:42 -0500
From: Dirk Eibach <eibach@gdsys.de>
To: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, rdunlap@xenotime.net,
        devicetree-discuss@lists.ozlabs.org, w.sang@pengutronix.de,
        khali@linux-fr.org, Dirk Eibach <eibach@gdsys.de>
Subject: [PATCH v3] hwmon: (ads1015) Add devicetree documentation
Date: Thu,  3 Mar 2011 13:32:37 +0100
Message-Id: <1299155557-13715-1-git-send-email-eibach@gdsys.de>
In-Reply-To: <20110303115151.GF3649@pengutronix.de>
References: <20110303115151.GF3649@pengutronix.de>
X-SafeGuard_MailGateway: Version: 5.60.3.10058 SGMG Date: 20110303123241Z
X-AntiVirus: checked by AntiVir MailGate (version: 2.0.2-5; AVE: 7.9.4.178; VDF: 7.11.4.51; host: mailrelay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dirk Eibach <eibach@gdsys.de>
---
Changes since v1:
- removed sysfs from description
- explain channels 

Changes since v2:
- Replaced 'accessable' by 'accessible'.

 Documentation/devicetree/bindings/i2c/ads1015.txt |   29 +++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/ads1015.txt

diff --git a/Documentation/devicetree/bindings/i2c/ads1015.txt b/Documentation/devicetree/bindings/i2c/ads1015.txt
new file mode 100644
index 0000000..985e24d
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/ads1015.txt
@@ -0,0 +1,29 @@
+ADS1015 (I2C)
+
+This device is a 12-bit A-D converter with 4 inputs.
+
+The inputs can be used single ended or in certain differential combinations.
+
+For configuration all possible combinations are mapped to 8 channels:
+0: Voltage over AIN0 and AIN1.
+1: Voltage over AIN0 and AIN3.
+2: Voltage over AIN1 and AIN3.
+3: Voltage over AIN2 and AIN3.
+4: Voltage over AIN0 and GND.
+5: Voltage over AIN1 and GND.
+6: Voltage over AIN2 and GND.
+7: Voltage over AIN3 and GND.
+
+Optional properties:
+
+ - exported-channels : exported_channels is a bitmask that specifies which
+		       channels should be accessible by the user.
+
+Example:
+ads1015@49 {
+	compatible = "ti,ads1015";
+	reg = <0x49>;
+	exported-channels = <0x14>;
+};
+
+In this example only channel 2 and 4 would be accessible by the user.
-- 
1.5.6.5

