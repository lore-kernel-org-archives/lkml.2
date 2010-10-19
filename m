Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449Ab0JSIe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 04:34:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57427 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab0JSIe4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 04:34:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VcnhNAoGxNQvi1l1D0p6rGUxzqhF171PeiT4ar9jz2gTbY/O4F2LDwvO+8Mez8Jezk
         jfxzyavJYroiZ+oVIwle8MZ8ReqRXbH/2bm+4QLoPKFxlT/sXKqnfHZsBrw3kkw6xXwr
         9lcppssfEF8O/cRH6qa2J2+i3F0yQ56O76jwc=
MIME-Version: 1.0
In-Reply-To: <20101019081855.GI12470@legolas.emea.dhcp.ti.com>
References: <1287475466-8927-1-git-send-email-felipe.contreras@gmail.com>
	<1287475466-8927-4-git-send-email-felipe.contreras@gmail.com>
	<20101019081855.GI12470@legolas.emea.dhcp.ti.com>
Date: Tue, 19 Oct 2010 11:34:55 +0300
Message-ID: <AANLkTi=8=M+egdo5o6nyMOaCyMCLaZdwJF3WKFwZnbd4@mail.gmail.com>
Subject: Re: [PATCH 3/3] drivers: cleanup Kconfig stuff
From: Felipe Contreras <felipe.contreras@gmail.com>
To: balbi@ti.com
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 11:18 AM, Felipe Balbi <balbi@ti.com> wrote:
> On Tue, Oct 19, 2010 at 03:04:26AM -0500, Felipe Contreras wrote:
>>
>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>> index db51ea1..523df52 100644
>> --- a/drivers/mfd/Kconfig
>> +++ b/drivers/mfd/Kconfig
>> @@ -156,6 +156,8 @@ config MENELAUS
>> config TWL4030_CORE
>>        bool "Texas Instruments TWL4030/TWL5030/TWL6030/TPS659x0 Support"
>>        depends on I2C=y && GENERIC_HARDIRQS
>> +       depends on ARCH_OMAP3 || ARCH_OMAP4
>
> It's just an i2c chip, not depending on OMAP will allow us for a much
> needed compile test on linux-next with different architectures.

Ok.

>> @@ -842,7 +840,8 @@ config USB_CDC_COMPOSITE
>>
>> config USB_G_NOKIA
>>        tristate "Nokia composite gadget"
>> -       depends on PHONET
>> +       depends on PHONET && MACH_NOKIA_RX51
>
> no. g_nokia only depends on PHONET, if someone else wants to use on
> another board, it's fine by me. Otherwise we will have to keep on adding
> more and more boards.

Ok.

>> +       depends on USB_GADGET_MUSB_HDRC
>
> this gadget also works on controllers other than musb. As long as they
> support enough endpoints and alternate settings, it should just work.
>
> It was fine as it was before. NAK

It's not fine. You can build with CONFIG_USB_G_NOKIA=y, and it doesn't
work. Definitely some dependency is missing.

>> diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
>> index 20895c4..5484258 100644
>> --- a/drivers/usb/musb/Kconfig
>> +++ b/drivers/usb/musb/Kconfig
>> @@ -12,7 +12,7 @@ config USB_MUSB_HDRC
>>        depends on (USB || USB_GADGET)
>>        depends on (ARM || (BF54x && !BF544) || (BF52x && !BF522 &&
>> !BF523))
>>        select NOP_USB_XCEIV if (ARCH_DAVINCI || MACH_OMAP3EVM || BLACKFIN)
>> -       select TWL4030_USB if MACH_OMAP_3430SDP
>> +       select TWL4030_USB if ARCH_OMAP3
>
> we have omap3-based boards which don't use twl4030-usb, they use
> nop-usb-xceiv. How do you want to handle that ?? NAK

How do you handle USB_MUSB_HDRC=y and NOP_USB_XCEIV=n and TWL4030_USB=n?

depends on (NOP_USB_XCEIV || TWL4030_USB) ?

-- 
Felipe Contreras
