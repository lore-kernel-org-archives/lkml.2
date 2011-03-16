Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab1CPKnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 06:43:47 -0400
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:44974 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab1CPKnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 06:43:39 -0400
Message-ID: <4D809455.9060901@ahsoftware.de>
Date: Wed, 16 Mar 2011 11:43:33 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Felipe Balbi <balbi@ti.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: musb as module broken in 2.6.38
References: <4D8018A9.6000800@ahsoftware.de> <20110316090327.GA2325@legolas.emea.dhcp.ti.com> <4D808729.9060608@ahsoftware.de> <20110316095541.GD2325@legolas.emea.dhcp.ti.com> <4D808E41.8040402@ahsoftware.de> <E19651BD-B634-4BD4-96EC-70E10CD975CD@ti.com> <4D809150.4000600@ahsoftware.de> <AF1846C5-739D-4598-83C0-34C3CBD5B9BB@ti.com>
In-Reply-To: <AF1846C5-739D-4598-83C0-34C3CBD5B9BB@ti.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.03.2011 11:38, schrieb Felipe Balbi:
> hi,
>
> On Mar 16, 2011, at 12:30 PM, Alexander Holler wrote:
>> Am 16.03.2011 11:24, schrieb Felipe Balbi:
>>> Hi,
>>>
>>> On Mar 16, 2011, at 12:17 PM, Alexander Holler wrote:
>>>>> static int __init omap2430_probe(struct platform_device *pdev)
>>>>
>>>> Neither omap2430_init() nor omap2430_probe() will be called here.
>>>
>>> and why is that ? It's even in sysfs already:
>>>
>>>>>> beagle linux # ls /sys/devices/platform/ | grep musb
>>>>>> musb-omap2430
>>
>> Don't know, I haven't written or changed the driver. ;)
>
> hehe, Just thought that you had something in mind already.
>
> probe() functions are called when, in case of platform_devices,
> the name matches with driver name. musb-omap2430 platform_device
> is allocated in arch/arm/mach-omap2/usb-musb.c, then musb-2430
> driver lives in drivers/usb/musb/omap2430.c. musb-2430 allocates a
> platform_device for musb-hdrc core driver.
>
> We did that because the same core is used in many different platforms
> (OMAP, discrete chips, ST-Ericsson, DaVinci, PCI cards, etc) so we
> needed to "abstract" platform-specific details such as clock handling
> and power management.
>
> There's still work to be done, for sure, e.g. the DMA part is still quite
> screwed up, but the drivers are correctly named which means they
> should be matching and probing. Now, musb-hdrc isn't probing, as
> you say, and I'd like to know why. I'll try to spend some time in
> it when I get back to the office.

I currently assume it's something with

subsys_initcall(omap2430_init);

Have to read about subsys_initcall() and why omap2430_init isn't called 
here.

Regards,

Alexander Holler
