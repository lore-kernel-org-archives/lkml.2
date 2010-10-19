Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab0JSUwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 16:52:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52189 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757590Ab0JSUwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 16:52:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=noG4TROhYD2K32fPqGexEkBKjf4nT2L8gj9aO4MaPNG52CRweePXpmIOsrZYphkLbg
         mKSXSXpywmfAXyWU/zXJ7m9bSmUcRxyQzTekMxOLSC6oQYZbF81IFj7Et3s0WYXpAjpN
         HoTKK2GXrvV2u4MF/vu8q70hCPdxwGIsNjwc4=
MIME-Version: 1.0
In-Reply-To: <6ea089ac75d4d15d88698468eacb7fe3@secure211.sgcpanel.com>
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>
	<1287482608-11320-4-git-send-email-felipe.contreras@gmail.com>
	<20101019103234.GI31170@legolas.emea.dhcp.ti.com>
	<AANLkTinXzMQXoyyu+anSCvSuE9w3FWAP5HswDS0kfpzE@mail.gmail.com>
	<20101019111613.GJ31170@legolas.emea.dhcp.ti.com>
	<AANLkTikkMphKa2DGGtWxy-3LpFX0kn92UEYPj==Euzok@mail.gmail.com>
	<20101019115236.GL31170@legolas.emea.dhcp.ti.com>
	<AANLkTim3NsgjC3Nh8VCCrx4cV1Y+kn38=30=en0KCft6@mail.gmail.com>
	<6ea089ac75d4d15d88698468eacb7fe3@secure211.sgcpanel.com>
Date: Tue, 19 Oct 2010 23:52:30 +0300
Message-ID: <AANLkTinYM5aavk9_jcTTymff=OY+Yyv8T6C+dmMih0p_@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: balbi@ti.com, linux-usb@vger.kernel.org,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 6:05 PM, Felipe Balbi <me@felipebalbi.com> wrote:
> On Tue, 19 Oct 2010 17:32:07 +0300, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
>> There are two parts, one part is to fix the Kconfigs, and another was
>> to come up with a way to replace the horrible defconfigs. Part two is
>> mostly fixed thanks to 'make savedefconfig', since the defconfigs are
>> not so horrible any more, but part one is a continued effort.
>>
>> For part two Linus had the idea to use Kconfigs instead of defconfigs,
>> but they would mostly look very similar to the current ones generated
>> by 'make savedefconfig'.
>>
>> I don't know what makes you think Linus didn't want part one to be
>> done. He wanted the Kconfig.rx51 to be human readable, and you are
>> proposing that TWL4030_USB should be manually added there... I don't
>> think TWL4030_USB says anything to human beings.
>
> I don't read anywhere Linus saying we should clutter drivers/*/Kconfig
> with defaults. I think you're inverting things, it's much better
> to select TWL4030_USB when you enable MACH_OMAP_RX51 then default y
> if MACH_OMAP_RX51.

So say, if you have 100 board defconfigs with OMAP3 chips and TWL4030,
each and every one of them should select both USB_MUSB_HDRC and
TWL4030_USB?

And you are saying if somebody is doing 'make menuconfig', that person
should somehow know that _obviously_ he needs TWL4030_USB in order to
use USB_MUSB_HDRC, or USB_G_NOKIA?

That's precisely the opposite to:
---
It's often tedious for other cases too ("I just want to enable a
particular driver, what do I need to do so?")
---
---
In other words, you _can_ encode the information that is in the
xyz_defconfig files by doing it in Kconfig.xyz files instead. But you do
it in a human-readable manner. And the hierarchical thing is absolutely
required for that - otherwise you'd end up with just another form of the
current xyz_defconfig.
---

>> Yes, but how do you get rid of the defconfig while also having a
>> working USB_G_NOKIA? Somehow a transceiver should be automatically
>> selected.
>
> and you do that selection when the board is enabled otherwise the
> drivers Kconfig will be cluttered with default Y if blabla.

If you can imagine a hierarchy like:

 drivers/usb/otg/Kconfig
 arch/arm/mach-omap2/Kconfig
 ^ arch/arm/mach-omap2/boards/Kconfig.n900

You would want TWL4030_USB to be up in the hierarchy, so that you
don't have to add one extra line to each and every board file.

But in fact, you don't want TWL4030_USB on the Kconfig because not
everyone might want/need USB support. That should be selected by the
user, and asking the user to somehow know that he needs both
TWL4030_USB and USB_MUSB_HDRC is way too much to ask in my opinion.

The idea would be to keep Kconfig.n900 so minimal that it's not needed at all.

-- 
Felipe Contreras
