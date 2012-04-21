Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab2DUJge (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 05:36:34 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:31626 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752031Ab2DUJfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 05:35:21 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, thierry.reding@avionic-design.de, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com,
        marek.vasut@gmail.com, devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v5 7/10] iio: lpc32xx-adc: Remove driver conflict due to device tree
Date: Sat, 21 Apr 2012 11:34:25 +0200
Message-Id: <1335000868-21974-8-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1335000868-21974-1-git-send-email-stigge@antcom.de>
References: <1335000868-21974-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, the touchscreen and ADC drivers of the LPC32xx SoC had a Kconfig
conflict declared because they use the same hardware. Upon the introduction of
device tree support in both drivers, the conflict must be removed to enable
the same kernel to support different hardware (configured via the device tree).

Signed-off-by: Roland Stigge <stigge@antcom.de>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

Applies to v3.4-rc3

 drivers/staging/iio/adc/Kconfig |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- linux-2.6.orig/drivers/staging/iio/adc/Kconfig
+++ linux-2.6/drivers/staging/iio/adc/Kconfig
@@ -195,11 +195,13 @@ config MAX1363_RING_BUFFER
 
 config LPC32XX_ADC
 	tristate "NXP LPC32XX ADC"
-	depends on ARCH_LPC32XX && !TOUCHSCREEN_LPC32XX
+	depends on ARCH_LPC32XX
 	help
 	  Say yes here to build support for the integrated ADC inside the
 	  LPC32XX SoC. Note that this feature uses the same hardware as the
-	  touchscreen driver, so you can only select one of the two drivers
-	  (lpc32xx_adc or lpc32xx_ts). Provides direct access via sysfs.
+	  touchscreen driver, so you should either select only one of the two
+	  drivers (lpc32xx_adc or lpc32xx_ts) or, in the OpenFirmware case,
+	  activate only one via device tree selection.  Provides direct access
+	  via sysfs.
 
 endmenu
