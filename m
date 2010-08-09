Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab0HIPa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 11:30:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29653 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697Ab0HIPaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 11:30:23 -0400
Date: Mon, 9 Aug 2010 08:28:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 7 (IR)
Message-Id: <20100809082813.6ace93de.randy.dunlap@oracle.com>
In-Reply-To: <4C60021B.2070109@redhat.com>
References: <20100807160710.b7c8d838.sfr@canb.auug.org.au>
	<20100807203920.83134a60.randy.dunlap@oracle.com>
	<20100808135511.269f670c.randy.dunlap@oracle.com>
	<4C60021B.2070109@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Aug 2010 10:26:51 -0300 Mauro Carvalho Chehab wrote:

> Hi Randy,
> 
> Em 08-08-2010 17:55, Randy Dunlap escreveu:
> > On Sat, 7 Aug 2010 20:39:20 -0700 Randy Dunlap wrote:
> > 
> > [adding linux-media]
> > 
> >> On Sat, 7 Aug 2010 16:07:10 +1000 Stephen Rothwell wrote:
> >>
> >>> Hi all,
> >>>
> >>> As the merge window is open, please do not add 2.6.37 material to your
> >>> linux-next included trees until after 2.6.36-rc1.
> >>>
> >>> Changes since 20100806:
> >>
> >> 2 sets of IR build errors (2 .config files attached):
> >>
> 
> The patch bellow should fix the issue. The bad thing is that, if you deselect
> IR_CORE, several drivers like bttv would be deselected too.
> 
> So, a further action would be to work on some solution for it.
> 
> The first alternative would be to write some stubs at ir-core.h to allow
> compiling the V4L/DVB drivers without IR support, removing the "depends on"
> for those drivers. The bad thing is that the subsystem headers will have some
> #ifs there.
> 
> Another alternative would be to do this inside the drivers and/or drivers headers.
> In general, at driver level, there are just one or two functions called in order
> to activate/deactivate the remote controllers. So, IMHO, this would provide a cleaner
> way.
> 
> I'll likely do some patches using the second alternative and see how it will look like.
> 
> Cheers,
> Mauro.

With this patch applied, I rebuilt both builds that failed on Saturday...
and they still fail.  Error logs are:

from config-r5091:

ERROR: "ir_keydown" [drivers/media/video/ir-kbd-i2c.ko] undefined!
ERROR: "__ir_input_register" [drivers/media/video/ir-kbd-i2c.ko] undefined!
ERROR: "get_rc_map" [drivers/media/video/ir-kbd-i2c.ko] undefined!
ERROR: "ir_input_unregister" [drivers/media/video/ir-kbd-i2c.ko] undefined!
ERROR: "get_rc_map" [drivers/media/video/cx88/cx88xx.ko] undefined!
ERROR: "ir_repeat" [drivers/media/video/cx88/cx88xx.ko] undefined!
ERROR: "ir_input_unregister" [drivers/media/video/cx88/cx88xx.ko] undefined!
ERROR: "ir_keydown" [drivers/media/video/cx88/cx88xx.ko] undefined!
ERROR: "__ir_input_register" [drivers/media/video/cx88/cx88xx.ko] undefined!
ERROR: "get_rc_map" [drivers/media/video/bt8xx/bttv.ko] undefined!
ERROR: "ir_input_unregister" [drivers/media/video/bt8xx/bttv.ko] undefined!
ERROR: "__ir_input_register" [drivers/media/video/bt8xx/bttv.ko] undefined!
ERROR: "ir_g_keycode_from_table" [drivers/media/IR/ir-common.ko] undefined!


from config-r5101:

drivers/built-in.o: In function `ir_rc5_decode':
(.text+0x8306e2): undefined reference to `ir_core_debug'
drivers/built-in.o: In function `ir_rc5_decode':
(.text+0x830729): undefined reference to `ir_core_debug'
drivers/built-in.o: In function `ir_input_key_event':
ir-functions.c:(.text+0x830906): undefined reference to `ir_core_debug'
drivers/built-in.o: In function `ir_input_keydown':
(.text+0x8309d8): undefined reference to `ir_g_keycode_from_table'
drivers/built-in.o: In function `ir_rc5_timer_keyup':
(.text+0x830acf): undefined reference to `ir_core_debug'
drivers/built-in.o: In function `ir_rc5_timer_end':
(.text+0x830b92): undefined reference to `ir_core_debug'
drivers/built-in.o: In function `ir_rc5_timer_end':
(.text+0x830bef): undefined reference to `ir_core_debug'
drivers/built-in.o: In function `ir_rc5_timer_end':
(.text+0x830c6a): undefined reference to `ir_core_debug'
drivers/built-in.o: In function `ir_rc5_timer_end':
(.text+0x830cf7): undefined reference to `ir_core_debug'
drivers/built-in.o: In function `msp430_ir_interrupt':
budget-ci.c:(.text+0x8770d8): undefined reference to `ir_keydown'
drivers/built-in.o: In function `msp430_ir_init':
budget-ci.c:(.text+0x878768): undefined reference to `get_rc_map'
budget-ci.c:(.text+0x878790): undefined reference to `__ir_input_register'
budget-ci.c:(.text+0x8789f0): undefined reference to `get_rc_map'
drivers/built-in.o: In function `budget_ci_detach':
budget-ci.c:(.text+0x878cdd): undefined reference to `ir_input_unregister'


The config files are available in this email archive:
  http://marc.info/?l=linux-kernel&m=128123907508042&w=2


> ---
> 
> commit c4cc9655223f7592a310d897429a4d8dfbf2259b
> Author: Mauro Carvalho Chehab <mchehab@redhat.com>
> Date:   Mon Aug 9 10:07:20 2010 -0300
> 
>     V4L/DVB: Fix IR_CORE dependencies
>     
>     As pointed by Randy Dunlap <randy.dunlap@oracle.com>:
>     > ERROR: "ir_keydown" [drivers/media/video/ir-kbd-i2c.ko] undefined!
>     > ERROR: "__ir_input_register" [drivers/media/video/ir-kbd-i2c.ko] undefined!
>     > ERROR: "get_rc_map" [drivers/media/video/ir-kbd-i2c.ko] undefined!
>     > ERROR: "ir_input_unregister" [drivers/media/video/ir-kbd-i2c.ko] undefined!
>     > ERROR: "get_rc_map" [drivers/media/video/cx88/cx88xx.ko] undefined!
>     > ERROR: "ir_repeat" [drivers/media/video/cx88/cx88xx.ko] undefined!
>     > ERROR: "ir_input_unregister" [drivers/media/video/cx88/cx88xx.ko] undefined!
>     > ERROR: "ir_keydown" [drivers/media/video/cx88/cx88xx.ko] undefined!
>     > ERROR: "__ir_input_register" [drivers/media/video/cx88/cx88xx.ko] undefined!
>     > ERROR: "get_rc_map" [drivers/media/video/bt8xx/bttv.ko] undefined!
>     > ERROR: "ir_input_unregister" [drivers/media/video/bt8xx/bttv.ko] undefined!
>     > ERROR: "__ir_input_register" [drivers/media/video/bt8xx/bttv.ko] undefined!
>     > ERROR: "ir_g_keycode_from_table" [drivers/media/IR/ir-common.ko] undefined!
>     >
>     >
>     > #5101:
>     > (.text+0x8306e2): undefined reference to `ir_core_debug'
>     > (.text+0x830729): undefined reference to `ir_core_debug'
>     > ir-functions.c:(.text+0x830906): undefined reference to `ir_core_debug'
>     > (.text+0x8309d8): undefined reference to `ir_g_keycode_from_table'
>     > (.text+0x830acf): undefined reference to `ir_core_debug'
>     > (.text+0x830b92): undefined reference to `ir_core_debug'
>     > (.text+0x830bef): undefined reference to `ir_core_debug'
>     > (.text+0x830c6a): undefined reference to `ir_core_debug'
>     > (.text+0x830cf7): undefined reference to `ir_core_debug'
>     > budget-ci.c:(.text+0x89f5c8): undefined reference to `ir_keydown'
>     > budget-ci.c:(.text+0x8a0c58): undefined reference to `get_rc_map'
>     > budget-ci.c:(.text+0x8a0c80): undefined reference to `__ir_input_register'
>     > budget-ci.c:(.text+0x8a0ee0): undefined reference to `get_rc_map'
>     > budget-ci.c:(.text+0x8a11cd): undefined reference to `ir_input_unregister'
>     > (.text+0x8a8adb): undefined reference to `ir_input_unregister'
>     > dvb-usb-remote.c:(.text+0x8a9188): undefined reference to `get_rc_map'
>     > dvb-usb-remote.c:(.text+0x8a91b1): undefined reference to `__ir_input_register'
>     > dvb-usb-remote.c:(.text+0x8a9238): undefined reference to `get_rc_map'
>     > dib0700_core.c:(.text+0x8b04ca): undefined reference to `ir_keydown'
>     > dib0700_devices.c:(.text+0x8b2ea8): undefined reference to `ir_keydown'
>     > dib0700_devices.c:(.text+0x8b2ef0): undefined reference to `ir_keydown'
>     
>     Those breakages seem to be caused by two bad things at IR_CORE Kconfig:
>     
>     1) cx23885 is using select for IR_CORE;
>     2) the dvb-usb and sms dependency for IR_CORE were missing.
>     
>     While here, allow users to un-select IR.
>     
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/drivers/media/IR/Kconfig b/drivers/media/IR/Kconfig
> index 30e0491..490c57c 100644
> --- a/drivers/media/IR/Kconfig
> +++ b/drivers/media/IR/Kconfig
> @@ -2,14 +2,21 @@ menuconfig IR_CORE
>  	tristate "Infrared remote controller adapters"
>  	depends on INPUT
>  	default INPUT
> +	---help---
> +	  Enable support for Remote Controllers on Linux. This is
> +	  needed in order to support several video capture adapters.
>  
> -if IR_CORE
> +	  Enable this option if you have a video capture board even
> +	  if you don't need IR, as otherwise, you may not be able to
> +	  compile the driver for your adapter.
>  
>  config VIDEO_IR
>  	tristate
>  	depends on IR_CORE
>  	default IR_CORE
>  
> +if IR_CORE
> +
>  config LIRC
>  	tristate
>  	default y
> diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
> index 553b48a..fdc19bb 100644
> --- a/drivers/media/dvb/dvb-usb/Kconfig
> +++ b/drivers/media/dvb/dvb-usb/Kconfig
> @@ -1,6 +1,6 @@
>  config DVB_USB
>  	tristate "Support for various USB DVB devices"
> -	depends on DVB_CORE && USB && I2C && INPUT
> +	depends on DVB_CORE && USB && I2C && IR_CORE
>  	help
>  	  By enabling this you will be able to choose the various supported
>  	  USB1.1 and USB2.0 DVB devices.
> diff --git a/drivers/media/dvb/siano/Kconfig b/drivers/media/dvb/siano/Kconfig
> index 85a222c..e520bce 100644
> --- a/drivers/media/dvb/siano/Kconfig
> +++ b/drivers/media/dvb/siano/Kconfig
> @@ -4,7 +4,7 @@
>  
>  config SMS_SIANO_MDTV
>  	tristate "Siano SMS1xxx based MDTV receiver"
> -	depends on DVB_CORE && INPUT && HAS_DMA
> +	depends on DVB_CORE && IR_CORE && HAS_DMA
>  	---help---
>  	  Choose Y or M here if you have MDTV receiver with a Siano chipset.
>  
> diff --git a/drivers/media/video/cx23885/Kconfig b/drivers/media/video/cx23885/Kconfig
> index 768f000..e1367b3 100644
> --- a/drivers/media/video/cx23885/Kconfig
> +++ b/drivers/media/video/cx23885/Kconfig
> @@ -5,7 +5,7 @@ config VIDEO_CX23885
>  	select VIDEO_BTCX
>  	select VIDEO_TUNER
>  	select VIDEO_TVEEPROM
> -	select IR_CORE
> +	depends on IR_CORE
>  	select VIDEOBUF_DVB
>  	select VIDEOBUF_DMA_SG
>  	select VIDEO_CX25840
> --

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
