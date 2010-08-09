Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab0HIRk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 13:40:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab0HIRkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 13:40:25 -0400
Message-ID: <4C603DB1.9030706@redhat.com>
Date: Mon, 09 Aug 2010 14:41:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.7) Gecko/20100720 Red Hat/3.1.1-1.el6 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-media@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 7 (IR)
References: <20100807160710.b7c8d838.sfr@canb.auug.org.au>	<20100807203920.83134a60.randy.dunlap@oracle.com>	<20100808135511.269f670c.randy.dunlap@oracle.com>	<4C5F9C2E.50001@redhat.com> <20100809075255.97d18a66.randy.dunlap@oracle.com>
In-Reply-To: <20100809075255.97d18a66.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 09-08-2010 11:52, Randy Dunlap escreveu:
> On Mon, 09 Aug 2010 03:11:58 -0300 Mauro Carvalho Chehab wrote:
> 
>> Em 08-08-2010 17:55, Randy Dunlap escreveu:
>>> On Sat, 7 Aug 2010 20:39:20 -0700 Randy Dunlap wrote:
>>>
>>> [adding linux-media]
>>>
>>>> On Sat, 7 Aug 2010 16:07:10 +1000 Stephen Rothwell wrote:
>>>>
>>>>> Hi all,
>>>>>
>>>>> As the merge window is open, please do not add 2.6.37 material to your
>>>>> linux-next included trees until after 2.6.36-rc1.
>>>>>
>>>>> Changes since 20100806:
>>>>
>>>> 2 sets of IR build errors (2 .config files attached):
>>>>
>>>> #5091:
>>>> ERROR: "ir_keydown" [drivers/media/video/ir-kbd-i2c.ko] undefined!
>>>> ERROR: "__ir_input_register" [drivers/media/video/ir-kbd-i2c.ko] undefined!
>>>> ERROR: "get_rc_map" [drivers/media/video/ir-kbd-i2c.ko] undefined!
>>>> ERROR: "ir_input_unregister" [drivers/media/video/ir-kbd-i2c.ko] undefined!
>>>> ERROR: "get_rc_map" [drivers/media/video/cx88/cx88xx.ko] undefined!
>>>> ERROR: "ir_repeat" [drivers/media/video/cx88/cx88xx.ko] undefined!
>>>> ERROR: "ir_input_unregister" [drivers/media/video/cx88/cx88xx.ko] undefined!
>>>> ERROR: "ir_keydown" [drivers/media/video/cx88/cx88xx.ko] undefined!
>>>> ERROR: "__ir_input_register" [drivers/media/video/cx88/cx88xx.ko] undefined!
>>>> ERROR: "get_rc_map" [drivers/media/video/bt8xx/bttv.ko] undefined!
>>>> ERROR: "ir_input_unregister" [drivers/media/video/bt8xx/bttv.ko] undefined!
>>>> ERROR: "__ir_input_register" [drivers/media/video/bt8xx/bttv.ko] undefined!
>>>> ERROR: "ir_g_keycode_from_table" [drivers/media/IR/ir-common.ko] undefined!
>>>>
>>>>
>>>> #5101:
>>>> (.text+0x8306e2): undefined reference to `ir_core_debug'
>>>> (.text+0x830729): undefined reference to `ir_core_debug'
>>>> ir-functions.c:(.text+0x830906): undefined reference to `ir_core_debug'
>>>> (.text+0x8309d8): undefined reference to `ir_g_keycode_from_table'
>>>> (.text+0x830acf): undefined reference to `ir_core_debug'
>>>> (.text+0x830b92): undefined reference to `ir_core_debug'
>>>> (.text+0x830bef): undefined reference to `ir_core_debug'
>>>> (.text+0x830c6a): undefined reference to `ir_core_debug'
>>>> (.text+0x830cf7): undefined reference to `ir_core_debug'
>>>> budget-ci.c:(.text+0x89f5c8): undefined reference to `ir_keydown'
>>>> budget-ci.c:(.text+0x8a0c58): undefined reference to `get_rc_map'
>>>> budget-ci.c:(.text+0x8a0c80): undefined reference to `__ir_input_register'
>>>> budget-ci.c:(.text+0x8a0ee0): undefined reference to `get_rc_map'
>>>> budget-ci.c:(.text+0x8a11cd): undefined reference to `ir_input_unregister'
>>>> (.text+0x8a8adb): undefined reference to `ir_input_unregister'
>>>> dvb-usb-remote.c:(.text+0x8a9188): undefined reference to `get_rc_map'
>>>> dvb-usb-remote.c:(.text+0x8a91b1): undefined reference to `__ir_input_register'
>>>> dvb-usb-remote.c:(.text+0x8a9238): undefined reference to `get_rc_map'
>>>> dib0700_core.c:(.text+0x8b04ca): undefined reference to `ir_keydown'
>>>> dib0700_devices.c:(.text+0x8b2ea8): undefined reference to `ir_keydown'
>>>> dib0700_devices.c:(.text+0x8b2ef0): undefined reference to `ir_keydown'
>>
>> Hmm... clearly, there are some bad dependencies at the Kconfig. Maybe ir-core were compiled
>> as module, while some drivers as built-in.
>>
>> Could you please pass the .config file for this build?
> 
> 
> Sorry, config-r5101 is now attached.

Hmm... when building it, I'm getting an interesting warning:

warning: (VIDEO_BT848 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_DEV && PCI && I2C && VIDEO_V4L2 && INPUT || VIDEO_SAA7134 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_DEV && PCI && I2C && INPUT || VIDEO_CX88 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_DEV && PCI && I2C && INPUT || VIDEO_IVTV && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && PCI && I2C && INPUT || VIDEO_CX18 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && PCI && I2C && EXPERIMENTAL && INPUT || VIDEO_EM28XX && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && V4L_USB_DRIVERS && USB && VIDEO_DEV && I2C && INPUT || VIDEO_TLG2300 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && V4L_USB_DRIVERS && USB && VIDEO_DEV && I2C && INPUT && SND && DVB_CORE || VIDEO_CX231XX && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && V4L_USB_DRIVERS && USB && VIDEO_DEV && I2C && INPUT || DVB_BUDGET_CI && MEDIA_SUPPORT && DVB_CAPT
URE_DRIVERS && DVB_CORE && DVB_BUDGET_CORE && I2C && INPUT || DVB_DM1105 && MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && DVB_CORE && PCI && I2C && INPUT || VIDEO_GO7007 && STAGING && !STAGING_EXCLUDE_BUILD && VIDEO_DEV && PCI && I2C && INPUT && SND || VIDEO_CX25821 && STAGING && !STAGING_EXCLUDE_BUILD && DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT) selects VIDEO_IR which has unmet direct dependencies (IR_CORE)

This warning seems to explain what's going wrong.

I'll make patch(es) to address this issue.

Thanks,
Mauro.
