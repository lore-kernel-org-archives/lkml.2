Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030227Ab2EKKJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:09:16 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47434 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030205Ab2EKKJM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:09:12 -0400
MIME-Version: 1.0
In-Reply-To: <20120511075713.GA14284@arwen.pp.htv.fi>
References: <1336715724-8441-1-git-send-email-josephdanielwalter@gmail.com>
	<20120511075713.GA14284@arwen.pp.htv.fi>
Date: Fri, 11 May 2012 15:39:10 +0530
Message-ID: <CAFDqYy02=wMSqtXxsU0c+sZL++1BPvUz4yMEfGthzGr98O5=xw@mail.gmail.com>
Subject: Re: [PATCH] usb/dwc3: Fix the dwc3 dependency
From: joseph daniel <josephdanielwalter@gmail.com>
To: balbi@ti.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Fri, May 11, 2012 at 1:27 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Fri, May 11, 2012 at 11:25:24AM +0530, joseph daniel wrote:
>> The warning shown up when ran with randconfig,
>>
>> warning: (USB_DWC3) selects USB_XHCI_PLATFORM which has unmet direct dependencies (USB_SUPPORT && USB_XHCI_HCD)
>>
>> Signed-off-by: joseph daniel <josephdanielwalter@gmail.com>
>> ---
>>  drivers/usb/dwc3/Kconfig |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
>> index d8f741f..68271fa 100644
>> --- a/drivers/usb/dwc3/Kconfig
>> +++ b/drivers/usb/dwc3/Kconfig
>> @@ -1,6 +1,6 @@
>>  config USB_DWC3
>>       tristate "DesignWare USB3 DRD Core Support"
>> -     depends on (USB && USB_GADGET)
>> +     depends on (USB && USB_SUPPORT && USB_XCHI_HCD && USB_GADGET)
>                                              ^^^^
>                                              typo
>
> I would prefer the select to change:
>
> select XHCI_PLATFORM if (USB_SUPPORT && USB_XHCI_HCD)
>
will do this and send out a patch shotly.
> or something similar.
>
>>       select USB_OTG_UTILS
>>       select USB_GADGET_DUALSPEED
>>       select USB_GADGET_SUPERSPEED
>
> --
> balbi

Thanks
