Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab0HIGLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 02:11:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab0HIGLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 02:11:23 -0400
Message-ID: <4C5F9C2E.50001@redhat.com>
Date: Mon, 09 Aug 2010 03:11:58 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.7) Gecko/20100720 Red Hat/3.1.1-1.el6 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-media@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 7 (IR)
References: <20100807160710.b7c8d838.sfr@canb.auug.org.au>	<20100807203920.83134a60.randy.dunlap@oracle.com> <20100808135511.269f670c.randy.dunlap@oracle.com>
In-Reply-To: <20100808135511.269f670c.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 08-08-2010 17:55, Randy Dunlap escreveu:
> On Sat, 7 Aug 2010 20:39:20 -0700 Randy Dunlap wrote:
> 
> [adding linux-media]
> 
>> On Sat, 7 Aug 2010 16:07:10 +1000 Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> As the merge window is open, please do not add 2.6.37 material to your
>>> linux-next included trees until after 2.6.36-rc1.
>>>
>>> Changes since 20100806:
>>
>> 2 sets of IR build errors (2 .config files attached):
>>
>> #5091:
>> ERROR: "ir_keydown" [drivers/media/video/ir-kbd-i2c.ko] undefined!
>> ERROR: "__ir_input_register" [drivers/media/video/ir-kbd-i2c.ko] undefined!
>> ERROR: "get_rc_map" [drivers/media/video/ir-kbd-i2c.ko] undefined!
>> ERROR: "ir_input_unregister" [drivers/media/video/ir-kbd-i2c.ko] undefined!
>> ERROR: "get_rc_map" [drivers/media/video/cx88/cx88xx.ko] undefined!
>> ERROR: "ir_repeat" [drivers/media/video/cx88/cx88xx.ko] undefined!
>> ERROR: "ir_input_unregister" [drivers/media/video/cx88/cx88xx.ko] undefined!
>> ERROR: "ir_keydown" [drivers/media/video/cx88/cx88xx.ko] undefined!
>> ERROR: "__ir_input_register" [drivers/media/video/cx88/cx88xx.ko] undefined!
>> ERROR: "get_rc_map" [drivers/media/video/bt8xx/bttv.ko] undefined!
>> ERROR: "ir_input_unregister" [drivers/media/video/bt8xx/bttv.ko] undefined!
>> ERROR: "__ir_input_register" [drivers/media/video/bt8xx/bttv.ko] undefined!
>> ERROR: "ir_g_keycode_from_table" [drivers/media/IR/ir-common.ko] undefined!
>>
>>
>> #5101:
>> (.text+0x8306e2): undefined reference to `ir_core_debug'
>> (.text+0x830729): undefined reference to `ir_core_debug'
>> ir-functions.c:(.text+0x830906): undefined reference to `ir_core_debug'
>> (.text+0x8309d8): undefined reference to `ir_g_keycode_from_table'
>> (.text+0x830acf): undefined reference to `ir_core_debug'
>> (.text+0x830b92): undefined reference to `ir_core_debug'
>> (.text+0x830bef): undefined reference to `ir_core_debug'
>> (.text+0x830c6a): undefined reference to `ir_core_debug'
>> (.text+0x830cf7): undefined reference to `ir_core_debug'
>> budget-ci.c:(.text+0x89f5c8): undefined reference to `ir_keydown'
>> budget-ci.c:(.text+0x8a0c58): undefined reference to `get_rc_map'
>> budget-ci.c:(.text+0x8a0c80): undefined reference to `__ir_input_register'
>> budget-ci.c:(.text+0x8a0ee0): undefined reference to `get_rc_map'
>> budget-ci.c:(.text+0x8a11cd): undefined reference to `ir_input_unregister'
>> (.text+0x8a8adb): undefined reference to `ir_input_unregister'
>> dvb-usb-remote.c:(.text+0x8a9188): undefined reference to `get_rc_map'
>> dvb-usb-remote.c:(.text+0x8a91b1): undefined reference to `__ir_input_register'
>> dvb-usb-remote.c:(.text+0x8a9238): undefined reference to `get_rc_map'
>> dib0700_core.c:(.text+0x8b04ca): undefined reference to `ir_keydown'
>> dib0700_devices.c:(.text+0x8b2ea8): undefined reference to `ir_keydown'
>> dib0700_devices.c:(.text+0x8b2ef0): undefined reference to `ir_keydown'

Hmm... clearly, there are some bad dependencies at the Kconfig. Maybe ir-core were compiled
as module, while some drivers as built-in.

Could you please pass the .config file for this build?
>>
>>
>> ---
>> ~Randy
>> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

