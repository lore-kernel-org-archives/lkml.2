Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab2IUFK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 01:10:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50917 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915Ab2IUFK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 01:10:27 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <rpurdie@rpsys.net>, <thierry.reding@avionic-design.de>
CC: <broonie@opensource.wolfsonmicro.com>, <shawn.guo@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>,
        <gururaja.hebbar@ti.com>, "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH v2] pwm_backlight: Add device tree support for Low Threshold Brightness
Date: Fri, 21 Sep 2012 10:21:20 +0530
Message-ID: <1348203080-16348-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some backlights perform poorly when driven by a PWM with a short
duty-cycle. For such devices, the low threshold can be used to specify a
lower bound for the duty-cycle and should be chosen to exclude the
problematic range.

This patch adds support for an optional low-threshold-brightness
property.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
---
Changes since v1:
        - Updated commit message.
	- Changes to low-threshold-brightness.
	- Merged example section to original.

:100644 100644 1e4fc72... 5baebff... M	Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
:100644 100644 995f016... 29e6fe1... M	drivers/video/backlight/pwm_bl.c
 .../bindings/video/backlight/pwm-backlight.txt     |    4 ++++
 drivers/video/backlight/pwm_bl.c                   |    5 +++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
index 1e4fc72..5baebff 100644
--- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
+++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
@@ -14,6 +14,9 @@ Required properties:
 Optional properties:
   - pwm-names: a list of names for the PWM devices specified in the
                "pwms" property (see PWM binding[0])
+  - low-threshold-brightness: brightness threshold low level. Low threshold
+    brightness set to value so that backlight present on low end of
+    brightness.
 
 [0]: Documentation/devicetree/bindings/pwm/pwm.txt
 
@@ -25,4 +28,5 @@ Example:
 
 		brightness-levels = <0 4 8 16 32 64 128 255>;
 		default-brightness-level = <6>;
+		low-threshold-brightness = <50>;
 	};
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 995f016..29e6fe1 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -143,6 +143,11 @@ static int pwm_backlight_parse_dt(struct device *dev,
 
 		data->dft_brightness = value;
 		data->max_brightness--;
+
+		ret = of_property_read_u32(node, "low-threshold-brightness",
+					   &value);
+		if (!ret)
+			data->lth_brightness = value;
 	}
 
 	/*
-- 
1.7.0.4

