Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab0JTJNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 05:13:42 -0400
Received: from smtp.nokia.com ([192.100.122.230]:54621 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab0JTJNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 05:13:40 -0400
Message-ID: <4CBEB312.7060400@nokia.com>
Date: Wed, 20 Oct 2010 12:14:58 +0300
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: "ext felipe.contreras@gmail.com" <felipe.contreras@gmail.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>	<1287482608-11320-4-git-send-email-felipe.contreras@gmail.com>	<4CBD9FD5.506@nokia.com>	<AANLkTinRRyrXzqEu=u+CCYkmSNGm03SSo1tVG=5_wdpo@mail.gmail.com>	<4CBE9E69.6060803@nokia.com> <AANLkTinOYDBMVZ3ibG3Md7jdOuOC6NkGWaugvHwT6uqF@mail.gmail.com>
In-Reply-To: <AANLkTinOYDBMVZ3ibG3Md7jdOuOC6NkGWaugvHwT6uqF@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Oct 2010 09:13:30.0632 (UTC) FILETIME=[10214880:01CB7037]
X-Nokia-AV: Unscannable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2010 11:53 AM, ext felipe.contreras@gmail.com wrote:
> On Wed, Oct 20, 2010 at 10:46 AM, Roger Quadros<roger.quadros@nokia.com>  wrote:
>> On 10/19/2010 05:33 PM, ext Felipe Contreras wrote:
>>> On Tue, Oct 19, 2010 at 4:40 PM, Roger Quadros<roger.quadros@nokia.com>
>>>   wrote:
>>>>>
>>>>> @@ -843,6 +841,7 @@ config USB_CDC_COMPOSITE
>>>>>   config USB_G_NOKIA
>>>>>         tristate "Nokia composite gadget"
>>>>>         depends on PHONET
>>>>> +       depends on USB_GADGET_MUSB_HDRC
>>>>
>>>> This is wrong. Is there a build problem or run-time problem without this?
>>>
>>> Try:
>>> CONFIG_USB_G_NOKIA=y
>>> CONFIG_USB_GADGET_MUSB_HDRC=n
>>>
>>> At least g_nokia doesn't seem to work correctly on my N900.
>>>
>> It won't work on N900 because N900 has MUSB USB gadget controller and it
>> needs to be selected somehow while building for N900.
>>
>> You should set CONFIG_USB_GADGET_MUSB_HDRC to y somewhere else while
>> building for N900 and not here because g_nokia is not MUSB specific.
>
> How do you expect people to know that? The Kconfig should define what
> USB_G_NOKIA needs to work, so that people can enable those things
> without go Googling hunting for a workable defconfig. Right now people
> can build g_nokia modules that don't work, and that shouldn't be
> allowed by the Kconfig.
>

USB_G_NOKIA just needs a USB gadget controller to work. The gadget controller 
used for the board should come from the board's Kconfig which will ideally be 
supplied by the board's vendor.

For example, can't USB_GADGET_MUSB_HDRC be selected in MACH_NOKIA_RX51 in 
arch/arm/mach-omap2/Kconfig? or is there a better place to put it?

-- 
regards,
-roger
