Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab0JSIZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 04:25:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57693 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab0JSIZ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 04:25:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GcFhxQx2KLeH+7YR8SMxyYGzRrIG7OzqJTAP+TGXA1ZLs/X+svmPpGFhl/wKA74TCE
         qk1Ujs4ExZU2h7apMG5boyK3RF507E6i61RsJJarM36+Zq//cnuf0mnjSWawEplNCn+g
         YPnx16iTXZ31si4q4k50U3ODwrYdb89FqydsE=
MIME-Version: 1.0
In-Reply-To: <20101019081509.GH12470@legolas.emea.dhcp.ti.com>
References: <1287475466-8927-1-git-send-email-felipe.contreras@gmail.com>
	<1287475466-8927-3-git-send-email-felipe.contreras@gmail.com>
	<20101019081509.GH12470@legolas.emea.dhcp.ti.com>
Date: Tue, 19 Oct 2010 11:25:27 +0300
Message-ID: <AANLkTi=XxqfpEnWFZ2h-xqEPc62rfgomhhrvE1Z_ME_d@mail.gmail.com>
Subject: Re: [PATCH 2/3] usb: trivial Kconfig cleanups
From: Felipe Contreras <felipe.contreras@gmail.com>
To: balbi@ti.com
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 11:15 AM, Felipe Balbi <balbi@ti.com> wrote:
> On Tue, Oct 19, 2010 at 03:04:25AM -0500, Felipe Contreras wrote:
>>
>> @@ -125,14 +125,6 @@ config USB_MUSB_OTG
>>
>> endchoice
>>
>> -# enable peripheral support (including with OTG)
>> -config USB_GADGET_MUSB_HDRC
>> -       bool
>> -       depends on USB_MUSB_HDRC && (USB_MUSB_PERIPHERAL || USB_MUSB_OTG)
>> -#      default y
>> -#      select USB_GADGET_DUALSPEED
>> -#      select USB_GADGET_SELECTED
>> -
>
> $ git grep -e CONFIG_USB_GADGET_MUSB_HDRC drivers/usb/
> drivers/usb/gadget/gadget_chips.h:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
> drivers/usb/musb/Makefile:ifeq ($(CONFIG_USB_GADGET_MUSB_HDRC),y)
> drivers/usb/musb/am35x.c:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
> drivers/usb/musb/da8xx.c:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
> drivers/usb/musb/musb_core.c:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
> drivers/usb/musb/musb_core.c:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
> drivers/usb/musb/musb_core.c:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
> drivers/usb/musb/musb_core.c:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
> drivers/usb/musb/musb_core.c:#endif /* CONFIG_USB_GADGET_MUSB_HDRC */
> drivers/usb/musb/musb_core.c:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
> drivers/usb/musb/musb_core.c:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
> drivers/usb/musb/musb_core.c:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
> drivers/usb/musb/musb_core.c:#elif defined(CONFIG_USB_GADGET_MUSB_HDRC)
> drivers/usb/musb/musb_core.h:#ifndef CONFIG_USB_GADGET_MUSB_HDRC
> drivers/usb/musb/musb_core.h:#error bogus Kconfig output ... select
> CONFIG_USB_GADGET_MUSB_HDRC
> drivers/usb/musb/musb_core.h:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
> drivers/usb/musb/musb_core.h:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
> drivers/usb/musb/musb_core.h:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
> drivers/usb/musb/musb_core.h:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
> drivers/usb/musb/musb_core.h:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
> drivers/usb/musb/musb_core.h:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
> drivers/usb/musb/tusb6010.c:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
> drivers/usb/musb/tusb6010.c:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
> drivers/usb/musb/tusb6010.c:#ifdef CONFIG_USB_GADGET_MUSB_HDRC

So?

% git grep USB_GADGET_MUSB_HDRC -- '*/Kconfig'
drivers/usb/gadget/Kconfig:config USB_GADGET_MUSB_HDRC
drivers/usb/musb/Kconfig:# use USB_GADGET_MUSB_HDRC not
USB_MUSB_PERIPHERAL to #ifdef peripheral
drivers/usb/musb/Kconfig:       select USB_GADGET_MUSB_HDRC
drivers/usb/musb/Kconfig:       select USB_GADGET_MUSB_HDRC
drivers/usb/musb/Kconfig:config USB_GADGET_MUSB_HDRC
drivers/usb/musb/Kconfig:       select USB_OTG if USB_GADGET_MUSB_HDRC

(it's defined twice)

-- 
Felipe Contreras
