Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab0JUJEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 05:04:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65180 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab0JUJE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 05:04:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Vg2c3tpWykTZaVqINRNOiMyq4qvO6X4X8tisCM7ccjNnBv7Xh+kBkyOArNW8CBFeih
         o494XEWFpPLJIBUApYuBWyvAi4kEwy2wsZ88XQWR1rIBijHUl9MYNfZuO4kyrK71zil4
         yuBvphb4ssYJikoWfqS/ab40lCVR5XBxvgiJs=
MIME-Version: 1.0
In-Reply-To: <20101020175420.GC3431@legolas.emea.dhcp.ti.com>
References: <4CBD9FD5.506@nokia.com>
	<AANLkTinRRyrXzqEu=u+CCYkmSNGm03SSo1tVG=5_wdpo@mail.gmail.com>
	<4CBE9E69.6060803@nokia.com>
	<AANLkTinOYDBMVZ3ibG3Md7jdOuOC6NkGWaugvHwT6uqF@mail.gmail.com>
	<4CBEB312.7060400@nokia.com>
	<AANLkTikom=eRFqCJmYE+k1zn5K2MR9s8HhNXtjOvUqvr@mail.gmail.com>
	<20101020125407.GE2433@legolas.emea.dhcp.ti.com>
	<AANLkTi=+6bC=JALdCDKW_BS-jnNk3zFPuWuBT+aY=Utx@mail.gmail.com>
	<20101020151527.GF2883@legolas.emea.dhcp.ti.com>
	<AANLkTim-QeP0hfSVGUd-tHWso9HQv25TwapBBZ1KPD3=@mail.gmail.com>
	<20101020175420.GC3431@legolas.emea.dhcp.ti.com>
Date: Thu, 21 Oct 2010 12:04:27 +0300
Message-ID: <AANLkTin31dmD5OfR3-nvZSg82i3H=_xgH_isJc+Epttq@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
From: Felipe Contreras <felipe.contreras@gmail.com>
To: balbi@ti.com
Cc: Roger Quadros <roger.quadros@nokia.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 8:54 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Wed, Oct 20, 2010 at 11:22:17AM -0500, Felipe Contreras wrote:
>>
>> Users would not need to care... if they enable USB and USB_GADGET, it
>> will be selected automatically for OMAP3, which is what users would
>> expect.
>
> wouldn't a user expect USB to be enabled if the board _has_ a USB
> connector ?

Not if it's not going to be used.

>> I was talking more about developers.
>>
>> How should the help be fixed?
>> "Select y if you are using an OMAP3 system that has TWL4030"
>
> If you have the TWL4030 family of PMIC chips and want to use USB, you
> probably need this. If unsure, say Y.

If you see TWL4030_USB, it's because you have enabled USB_SUPPORT, so
you want to use USB. And that help still doesn't say anything to most
people.

>> 1) Do you think all the OMAP3 boards should add that?
>
> why not ?

You prefer a patch that adds one line per board rather than a patch
that adds one line in total... That is exactly the opposite of Linus's
complaint regarding big ARM changesets.

>> 2) What if you don't want to use USB?
>
> what if you don't want to use USB and we use your choice of:
>
> default y if ARCH_OMAP3 ??
>
> what's the big difference ? The default will be "USB enabled" and if you
> don't want, just drop it. The thing is that in most cases we want to
> support what is wired on the board.

For "most cases" there is 'default'.

> RX51 has a USB micro-B connector, so
> by default we want USB peripheral enabled and host disabled. If a user
> (or developer for that matter) wants to play with the unsupported host
> mode on RX51, he will enable that part by himself and pray for it to
> work. If, on the other hand, a camera developer doesn't need USB at all
> and decides to save a few bytes on the binary, he will make sure to
> disable it.

Your patch would not allow such camera developer to disable USB
through the kernel configuration.

> The thing is that there's no way to make everybody happy, so we stick to
> what the board is wired to do.

I don't understand, currently TWL4030_USB is not selected in any way,
you are saying it should always be enabled (which I disagree with),
but that's not currently happening. If anything, my patch is changing
things to go into the direction you want, not the opposite.

My patch shuffles _one_ line that:
1) Allows clueless OMAP3 users to have TWL4030_USB enabled by default
_if_ they enable USB and USB_GADGET regardless of which board is being
used
2) Still allow people to build kernels without USB, nor TWL4030_USB
3) Simplify defconfgs by removing one line
4) Don't need extra changes in the board configurations
5) Doesn't increase the total lines in Kconfigs

Compared to the current situation 1) would actually change things into
the direction you advocated to: TWL4030_USB is enabled by default.

-- 
Felipe Contreras
