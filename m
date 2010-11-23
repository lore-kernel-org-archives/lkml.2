Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab0KWTno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 14:43:44 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:39133 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab0KWTnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 14:43:42 -0500
Message-ID: <4CEC18FF.9030807@oracle.com>
Date: Tue, 23 Nov 2010 11:41:51 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Zimny Lech <napohybelskurwysynom2010@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux kbuild list <linux-kbuild@vger.kernel.org>
Subject: Re: linux-next: Tree for November 23 (randconfig problem?)
References: <20101123140609.2b6503ff.sfr@canb.auug.org.au>	<AANLkTi===xonvuovLS5Ch=coMDjzLQ4XSsPRDowDJ4L2@mail.gmail.com>	<20101123091551.f3ed937f.randy.dunlap@oracle.com> <AANLkTikLJW0be+kVgEnAZDbiDMVbYOrA7f5VYs+KHSe_@mail.gmail.com>
In-Reply-To: <AANLkTikLJW0be+kVgEnAZDbiDMVbYOrA7f5VYs+KHSe_@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/10 11:04, Zimny Lech wrote:
> 2010/11/23 Randy Dunlap <randy.dunlap@oracle.com>:
>> On Tue, 23 Nov 2010 16:43:22 +0100 Zimny Lech wrote:
>>
>>> Ave
>>>
>>> 2010/11/23 Stephen Rothwell <sfr@canb.auug.org.au>:
>>>> Hi all,
>>>>
>>>> Changes since 20101122:
>>>>
>>>
>>>
>>> Random config generator has failed :)
>>
>> Hi,
>> What do you mean by this?
> 
> This is what I get from "make" after "make randconfig".
> 
>>  I'm not seeing any randconfig generator problems.
>> Are you using any options or inputs to kconfig?
> 
> No.
> 
> I'm using script below to build kernel - nothing really unusual. Log
> and config for this failed build are attached to previous email

[script deleted]

OK, I see what you mean (I can reproduce it), but I don't see how it
happens.  It looks like, from drivers/usb/gadget/Kconfig:

#
# USB Gadget Drivers
#
choice
	tristate "USB Gadget Drivers"
	depends on USB_GADGET && USB_GADGET_SELECTED
	default USB_ETH

none of the choices inside this choice block was enabled by the randconfig.

Anybody in linux-kbuild land see how that can happen?

Zimny, one way that you can work around this is to run:

$ yes '' | make

or
$ yes '' | make oldconfig
after the 'make randconfig'.  That sets the unknown kconfig symbol(s) to their
default values.


>>> USB Gadget Support (USB_GADGET) [Y/n/?] y
>>>   Debugging messages (DEVELOPMENT) (USB_GADGET_DEBUG) [Y/n/?] y
>>>   Debugging information files (DEVELOPMENT) (USB_GADGET_DEBUG_FILES) [N/y/?] n
>>>   Debugging information files in debugfs (DEVELOPMENT)
>>> (USB_GADGET_DEBUG_FS) [Y/n/?] y
>>>   Maximum VBUS Power usage (2-500 mA) (USB_GADGET_VBUS_DRAW) [2] 2
>>>   USB Peripheral Controller
>>>   > 1. Renesas R8A66597 USB Peripheral Controller (USB_GADGET_R8A66597)
>>>     2. Renesas M66592 USB Peripheral Controller (USB_GADGET_M66592)
>>>   choice[1-2?]: 1
>>>   USB Gadget Drivers
>>>     1. Gadget Zero (DEVELOPMENT) (USB_ZERO)
>>>     2. Audio Gadget (EXPERIMENTAL) (USB_AUDIO)
>>>   > 3. Ethernet Gadget (with CDC Ethernet support) (USB_ETH)
>>>     4. Serial Gadget (with CDC ACM and CDC OBEX support) (USB_G_SERIAL)
>>>     5. Printer Gadget (USB_G_PRINTER)
>>>     6. CDC Composite Device (Ethernet and ACM) (USB_CDC_COMPOSITE)
>>>     7. HID Gadget (USB_G_HID)
>>>     8. EHCI Debug Device Gadget (USB_G_DBGP)
>>>   choice[1-8?]: 3
>>>     RNDIS support (USB_ETH_RNDIS) [Y/n/?] (NEW) aborted!
>>>
>>> Console input/output is redirected. Run 'make oldconfig' to update
>>> configuration.
>>>
>>> make[3]: *** [silentoldconfig] Error 1
>>> make[2]: *** [silentoldconfig] Error 2
>>> make[1]: *** No rule to make target `include/config/auto.conf', needed
>>> by `include/config/kernel.release'.  Stop.
>>> make: *** [sub-make] Error 2


CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
# CONFIG_USB_GADGET_DEBUG_FILES is not set
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_SELECTED=y
CONFIG_USB_GADGET_R8A66597=y
CONFIG_USB_R8A66597=y
# CONFIG_USB_GADGET_M66592 is not set
CONFIG_USB_GADGET_DUALSPEED=y
# CONFIG_USB_ZERO is not set
# CONFIG_USB_AUDIO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
