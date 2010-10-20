Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab0JTQWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 12:22:20 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38757 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab0JTQWT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 12:22:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ko9ZCrO+nx2P2QpDEj7YvfGz5V7NZivHCJ4XZ3+EX6oXuAKpXTDYfK3uiUjklXEGr2
         TseoXoFlTyvSuaFn3DXRXX4oeiisOew8So7WNeUP7wVdwkVbuDticIDHq5g7IPc+dMQV
         5oC0Wc9+IkOnKK5dJYJyxvGQixK7srH7notUY=
MIME-Version: 1.0
In-Reply-To: <20101020151527.GF2883@legolas.emea.dhcp.ti.com>
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>
	<1287482608-11320-4-git-send-email-felipe.contreras@gmail.com>
	<4CBD9FD5.506@nokia.com>
	<AANLkTinRRyrXzqEu=u+CCYkmSNGm03SSo1tVG=5_wdpo@mail.gmail.com>
	<4CBE9E69.6060803@nokia.com>
	<AANLkTinOYDBMVZ3ibG3Md7jdOuOC6NkGWaugvHwT6uqF@mail.gmail.com>
	<4CBEB312.7060400@nokia.com>
	<AANLkTikom=eRFqCJmYE+k1zn5K2MR9s8HhNXtjOvUqvr@mail.gmail.com>
	<20101020125407.GE2433@legolas.emea.dhcp.ti.com>
	<AANLkTi=+6bC=JALdCDKW_BS-jnNk3zFPuWuBT+aY=Utx@mail.gmail.com>
	<20101020151527.GF2883@legolas.emea.dhcp.ti.com>
Date: Wed, 20 Oct 2010 19:22:17 +0300
Message-ID: <AANLkTim-QeP0hfSVGUd-tHWso9HQv25TwapBBZ1KPD3=@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
From: Felipe Contreras <felipe.contreras@gmail.com>
To: balbi@ti.com
Cc: Roger Quadros <roger.quadros@nokia.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 6:15 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Wed, Oct 20, 2010 at 09:52:06AM -0500, Felipe Contreras wrote:
>>
>> TWL4030_USB is inside drivers/usb/Kconfig and drivers/usb/otg/Kconfig,
>> which means in order to achieve the same on the board config you would
>> have to do:
>>
>> default y if USB_SUPPORT && (USB || USB_GADGET) && ARCH_OMAP3
>>
>> Seems to be more convoluted to me.
>>
>> Besides, I think TWL4030_USB and the full description of it doesn't
>> give any hints to the people reading drivers/usb/otg/Kconfig what is
>> it used for. 'default y if ARCH_OMAP3' achieves that.
>
> no it doesn't. No user will 'cat drivers/usb/otg/Kconfig | grep -A 10
> TWL4030' and check the 'default y if ARCH_OMAP3
>
> if you think help is not enough, fix help.

Users would not need to care... if they enable USB and USB_GADGET, it
will be selected automatically for OMAP3, which is what users would
expect.

I was talking more about developers.

How should the help be fixed?
"Select y if you are using an OMAP3 system that has TWL4030"

>> Plus, there is no big change:
>>
>> config USB_MUSB_HDRC
>> -       select TWL4030_USB if MACH_OMAP_3430SDP
>>
>> config TWL4030_USB
>> +       default y if ARCH_OMAP3
>>
>
> what's the problem with:
>
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index ab784bf..3af9580 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -215,6 +215,7 @@ config MACH_NOKIA_RX51
>        depends on ARCH_OMAP3
>        default y
>        select OMAP_PACKAGE_CBB
> +       select TWL4030_USB
>  config MACH_OMAP_ZOOM2
>        bool "OMAP3 Zoom2 board"
>

1) Do you think all the OMAP3 boards should add that?
2) What if you don't want to use USB?

-- 
Felipe Contreras
