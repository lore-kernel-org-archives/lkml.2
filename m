Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab1BGL00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 06:26:26 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32856 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab1BGL0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 06:26:25 -0500
Message-ID: <4D4FD695.5050507@mvista.com>
Date: Mon, 07 Feb 2011 14:25:09 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Maciej Szmigiero <mhej@o2.pl>
CC: Greg KH <gregkh@suse.de>, Johan Hovold <jhovold@gmail.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [USB]Add Samsung SGH-I500/Android modem ID switch to visor driver
References: <4D4D9F37.4010201@o2.pl> <20110205192831.GA334@suse.de> <4D4DC400.2040302@o2.pl> <4D4DDD54.1010905@ru.mvista.com> <4D4EFEC3.5030702@o2.pl>
In-Reply-To: <4D4EFEC3.5030702@o2.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06-02-2011 23:04, Maciej Szmigiero wrote:

>>> New version of patch which autodetects devices with ACM class.
>>> Tested on Galaxy Spica.

>>> Signed-off-by: Maciej Szmigiero<mhej@o2.pl>

>>> diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
>>> index 15a5d89..e1c4527 100644
>>> --- a/drivers/usb/serial/visor.c
>>> +++ b/drivers/usb/serial/visor.c
>> [...]
>>> @@ -479,6 +480,15 @@ static int visor_probe(struct usb_serial *serial,
>>>
>>>        dbg("%s", __func__);
>>>
>>> +    /* some Samsung Android phones in modem mode have the same ID */
>>> +    /* as SPH-I500, but they are ACM devices, so dont bind to them */

>>     The preferred style for the multi-line comments is this:

>> /*
>>  * bla
>>  * bla
>>  */

>>> +    if ((id->idVendor == SAMSUNG_VENDOR_ID)&&
>>> +        (id->idProduct == SAMSUNG_SPH_I500_ID)&&
>>> +        (serial->dev->descriptor.bDeviceClass == USB_CLASS_COMM)&&
>>> +        (serial->dev->descriptor.bDeviceSubClass ==
>>> +            USB_CDC_SUBCLASS_ACM))
>>
>>     Parens around == not necessary...

>> WBR, Sergei

> Thanks for comments, new version of this patch with style fixes follows.

> Best regards,
> Maciej Szmigiero

> Signed-off-by: Maciej Szmigiero<mhej@o2.pl>

> diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
> index 15a5d89..0f75948 100644
> --- a/drivers/usb/serial/visor.c
> +++ b/drivers/usb/serial/visor.c
[...]
> @@ -479,6 +480,17 @@ static int visor_probe(struct usb_serial *serial,
>
>   	dbg("%s", __func__);
>
> +	/*
> +	 * some Samsung Android phones in modem mode have the same ID
> +	 * as SPH-I500, but they are ACM devices, so dont bind to them
> +	*/

    Space is missing. You were close. :-)

WBR, Sergei
