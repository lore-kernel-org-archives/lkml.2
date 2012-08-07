Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558Ab2HGH7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 03:59:10 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:50534 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab2HGH7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 03:59:07 -0400
Message-ID: <5020CAF4.3040407@laposte.net>
Date: Tue, 07 Aug 2012 09:59:48 +0200
From: Yann Cantin <yann.cantin@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120717 Thunderbird/10.0.6
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC ebeam PATCH v3 2/2] input: misc: New USB eBeam input driver.
References: <1344288104-20731-1-git-send-email-yann.cantin@laposte.net> <1344288104-20731-3-git-send-email-yann.cantin@laposte.net> <20120806214359.GB30355@kroah.com> <502067C8.2020204@laposte.net> <20120807014354.GA21477@core.coreip.homeip.net>
In-Reply-To: <20120807014354.GA21477@core.coreip.homeip.net>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 07/08/2012 03:43, Dmitry Torokhov a écrit :
> On Tue, Aug 07, 2012 at 02:56:40AM +0200, Yann Cantin wrote:
>> Hi,
>>
>> Le 06/08/2012 23:43, Greg KH a écrit :
>>> On Mon, Aug 06, 2012 at 11:21:44PM +0200, Yann Cantin wrote:
>>>>
>>>> Signed-off-by: Yann Cantin <yann.cantin@laposte.net>
>>>> ---
>>>>  drivers/input/misc/ebeam.c |  764 ++++++++++++++++++++++++++++++++++++++++++++
>>>>  1 file changed, 764 insertions(+)
>>>>  create mode 100644 drivers/input/misc/ebeam.c
>>>
>>> What adds this file to the build?
>>  
>> Sorry, i don't get it : what do you mean ?
> 
> Greg meant that you forgot to include Makefile and Kconfig changes with
> this patch.
 
My bad. Looked twice and yet miss that...
Will be in v4. For info :

---
diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 7c0f1ec..1e575e4 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -83,6 +83,22 @@ config INPUT_BMA150
 	  To compile this driver as a module, choose M here: the
 	  module will be called bma150.
 
+config INPUT_EBEAM_USB
+	tristate "USB eBeam driver"
+	depends on USB_ARCH_HAS_HCD
+	select USB
+	help
+	  Say Y here if you have a USB eBeam pointing device and want to
+	  use it without any proprietary user space tools.
+
+	  Have a look at <http://sourceforge.net/projects/ebeam/> for
+	  a usage description and the required user-space tools.
+
+	  Currently, only the Classic Projection model is supported.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ebeam.
+
 config INPUT_PCSPKR
 	tristate "PC Speaker support"
 	depends on PCSPKR_PLATFORM
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 83fe6f5..2aa9813 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_INPUT_CMA3000_I2C)		+= cma3000_d0x_i2c.o
 obj-$(CONFIG_INPUT_COBALT_BTNS)		+= cobalt_btns.o
 obj-$(CONFIG_INPUT_DA9052_ONKEY)	+= da9052_onkey.o
 obj-$(CONFIG_INPUT_DM355EVM)		+= dm355evm_keys.o
+obj-$(CONFIG_INPUT_EBEAM_USB)		+= ebeam.o
 obj-$(CONFIG_INPUT_GP2A)		+= gp2ap002a00f.o
 obj-$(CONFIG_INPUT_GPIO_TILT_POLLED)	+= gpio_tilt_polled.o
 obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o

-- 
Yann Cantin
A4FEB47F
--
