Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab2HGIJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 04:09:55 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:28025 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab2HGIJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 04:09:51 -0400
Message-ID: <5020CD7A.4060808@laposte.net>
Date: Tue, 07 Aug 2012 10:10:34 +0200
From: Yann Cantin <yann.cantin@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120717 Thunderbird/10.0.6
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC ebeam PATCH v3 1/2] hid: Blacklist new eBeam classic device
References: <1344288104-20731-1-git-send-email-yann.cantin@laposte.net> <1344288104-20731-2-git-send-email-yann.cantin@laposte.net> <20120806214340.GA30355@kroah.com> <1975621.3ErbANJ9at@dtor-d630.eng.vmware.com> <50206DA9.1070503@laposte.net> <20120807014510.GB21477@core.coreip.homeip.net>
In-Reply-To: <20120807014510.GB21477@core.coreip.homeip.net>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 07/08/2012 03:45, Dmitry Torokhov a écrit :
> On Tue, Aug 07, 2012 at 03:21:45AM +0200, Yann Cantin wrote:
>> Le 07/08/2012 00:07, Dmitry Torokhov a écrit :
>>> On Monday, August 06, 2012 02:43:40 PM Greg KH wrote:
>>>> On Mon, Aug 06, 2012 at 11:21:43PM +0200, Yann Cantin wrote:
>>>>> Signed-off-by: Yann Cantin <yann.cantin@laposte.net>
>>>>> ---
>>>>>
>>>>>  drivers/hid/hid-core.c |    3 +++
>>>>>  drivers/hid/hid-ids.h  |    3 +++
>>>>>  2 files changed, 6 insertions(+)
>>>>>
>>>>> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
>>>>> index 60ea284..b1ed8ee 100644
>>>>> --- a/drivers/hid/hid-core.c
>>>>> +++ b/drivers/hid/hid-core.c
>>>>> @@ -1908,6 +1908,9 @@ static const struct hid_device_id hid_ignore_list[]
>>>>> = {> 
>>>>>  	{ HID_USB_DEVICE(USB_VENDOR_ID_DELORME, USB_DEVICE_ID_DELORME_EM_LT20)
>>>>>  	},
>>>>>  	{ HID_USB_DEVICE(USB_VENDOR_ID_DREAM_CHEEKY, 0x0004) },
>>>>>  	{ HID_USB_DEVICE(USB_VENDOR_ID_DREAM_CHEEKY, 0x000a) },
>>>>>
>>>>> +#if defined(CONFIG_INPUT_EBEAM_USB)
>>>>> +	{ HID_USB_DEVICE(USB_VENDOR_ID_EFI, USB_DEVICE_ID_EFI_CLASSIC) },
>>>>> +#endif
>>>>
>>>> Why is this #if in here?  Just always do it, how could it not be
>>>> defined?
>>>
>>> User might disable the driver and CONFIG_INPUT_EBEAM_USB will not be
>>> set. But I agree, since the device is unusable with generic HID driver
>>> there is no point in doing this conditionally.
>>
>> There's a closed-source user-space stack (libusb based daemon + xorg driver
>> + wine apps) provided for some distro (Ubuntu 10.04, works on mandriva 2010,
>> maybe others but break on recent xorg).
>>
>> I don't know exactly what to do : i don't want to break hypothetical support,
>> even proprietary.
>> Leaving the choice at kernel compile time seems to be safer, no ?
> 
> If they are using libusb that means that they use userspace solution and
> do not require HID or any other in-kernel driver. They should still be
> able to claim the port even if your driver is in use.

Ok, that solve one of my issue.
But if the driver isn't built, there will be absolutely no kernel support,
even basic hiddev/hidraw. Is there a kernel policy for that situation ?

-- 
Yann Cantin
A4FEB47F
--
