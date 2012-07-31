Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab2GaNj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:39:58 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39211 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab2GaNjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:39:54 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 19/19] Documentation: Add the AB8500 CODEC device to the MFD AB8500 doc
Date: Tue, 31 Jul 2012 14:39:13 +0100
Message-Id: <1343741953-17828-20-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343741953-17828-1-git-send-email-lee.jones@linaro.org>
References: <1343741953-17828-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we document the AB8500 Audio CODEC in the existing MFD AB8500 document.

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

