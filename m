Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093Ab1DOMGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 08:06:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35530 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1DOMGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 08:06:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CiGbHB3WeB4SA5YG2MeaX4L6PksiPjZutX+PP0h6Qz5/wwvuyFsm00oKz2hqPyuGFG
         XlnWx/CoEp89GQlXx96WyJIo8Uw33d7MECh2SboPCK/YZMSkrJBI49TpuxyDrBnpb/j8
         s9peY3smgmmrR3VY1y+Jvsr74ws9F9iKxXnjc=
Subject: [PATCH 2/2] mfd: Group NXP PCF50633* drivers together
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Balaji Rao <balajirrao@openmoko.org>, Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <1302869085.7230.1.camel@phoenix>
References: <1302869085.7230.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Apr 2011 20:06:37 +0800
Message-ID: <1302869197.7230.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCF50633_ADC and PCF50633_GPIO depends on MFD_PCF50633.
Thus group NXP PCF50633* drivers together.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/Kconfig |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 8ffd146..89e70d1 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -469,6 +469,20 @@ config MFD_PCF50633
 	  facilities, and registers devices for the various functions
 	  so that function-specific drivers can bind to them.
 
+config PCF50633_ADC
+	tristate "Support for NXP PCF50633 ADC"
+	depends on MFD_PCF50633
+	help
+	 Say yes here if you want to include support for ADC in the
+	 NXP PCF50633 chip.
+
+config PCF50633_GPIO
+	tristate "Support for NXP PCF50633 GPIO"
+	depends on MFD_PCF50633
+	help
+	 Say yes here if you want to include support GPIO for pins on
+	 the PCF50633 chip.
+
 config MFD_MC13783
 	tristate
 
@@ -484,20 +498,6 @@ config MFD_MC13XXX
 	  additional drivers must be enabled in order to use the
 	  functionality of the device.
 
-config PCF50633_ADC
-	tristate "Support for NXP PCF50633 ADC"
-	depends on MFD_PCF50633
-	help
-	 Say yes here if you want to include support for ADC in the
-	 NXP PCF50633 chip.
-
-config PCF50633_GPIO
-	tristate "Support for NXP PCF50633 GPIO"
-	depends on MFD_PCF50633
-	help
-	 Say yes here if you want to include support GPIO for pins on
-	 the PCF50633 chip.
-
 config ABX500_CORE
 	bool "ST-Ericsson ABX500 Mixed Signal Circuit register functions"
 	default y if ARCH_U300 || ARCH_U8500
-- 
1.7.1



