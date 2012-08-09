Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031362Ab2HIPs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:48:59 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46521 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031333Ab2HIPsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:48:45 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        Lee Jones <lee.jones@linaro.org>, alsa-devel@alsa-project.org
Subject: [PATCH 22/22] Documentation: Add the AB8500 CODEC device to the MFD AB8500 doc
Date: Thu,  9 Aug 2012 16:47:48 +0100
Message-Id: <1344527268-5964-23-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we document the AB8500 Audio CODEC in the existing MFD AB8500 document.

CC: alsa-devel@alsa-project.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/mfd/ab8500.txt |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/ab8500.txt b/Documentation/devicetree/bindings/mfd/ab8500.txt
index 69e757a..ce83c8d 100644
--- a/Documentation/devicetree/bindings/mfd/ab8500.txt
+++ b/Documentation/devicetree/bindings/mfd/ab8500.txt
@@ -23,6 +23,7 @@ Device                     IRQ Names              Supply Names   Description
 ab8500-bm                :                      :              : Battery Manager
 ab8500-btemp             :                      :              : Battery Temperature
 ab8500-charger           :                      :              : Battery Charger
+ab8500-codec             :                      :              : Audio Codec
 ab8500-fg                :                      :              : Fuel Gauge
 ab8500-gpadc             : HW_CONV_END          : vddadc       : Analogue to Digital Converter
                            SW_CONV_END          :              :
@@ -52,6 +53,14 @@ Optional child device properties:
                            supplied in the interrupts property
 - <supply_name>-supply   : contains a phandle to the regulator supply node in Device Tree
 
+Non-standard child device properties:
+ - Audio CODEC:
+   - stericsson,amic[1|2]-type-single-ended : Single-ended Analoge Mic (default: differential)
+   - stericsson,amic1a-bias-vamic2          : Analoge Mic wishes to use a non-standard Vamic
+   - stericsson,amic1b-bias-vamic2          : Analoge Mic wishes to use a non-standard Vamic
+   - stericsson,amic2-bias-vamic1           : Analoge Mic wishes to use a non-standard Vamic
+   - stericsson,earpeice-cmv                : Earpeice voltage (only: 950 | 1100 | 1270 | 1580)
+
 ab8500@5 {
          compatible = "stericsson,ab8500";
          reg = <5>; /* mailbox 5 is i2c */
@@ -110,6 +119,12 @@ ab8500@5 {
                 compatible = "stericsson,ab8500-pwm";
         };
 
+	codec: ab8500-codec {
+		compatible = "stericsson,ab8500-codec";
+
+		stericsson,earpeice-cmv = <950>; /* Units in mV. */
+	};
+
         ab8500-regulators {
                 compatible = "stericsson,ab8500-regulator";
 
-- 
1.7.9.5

