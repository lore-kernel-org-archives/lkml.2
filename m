Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab0JTOwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 10:52:10 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36364 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab0JTOwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 10:52:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=er19eD5eOTdo60FAUcThHafh5SGAzmUGZ+JBbvAv6s9JgUR+gqKAS505TqaalLaVH+
         jx29iQwhPOxbldjMXWS/BwqGMJASZjBCqsy6vwVN991Hnna4TI31VuOJiVHsNSUAsyw4
         JZ3yGCHqnnllvrY6Vpe5qlUyM5X3j1U4jC1HI=
MIME-Version: 1.0
In-Reply-To: <20101020125407.GE2433@legolas.emea.dhcp.ti.com>
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>
	<1287482608-11320-4-git-send-email-felipe.contreras@gmail.com>
	<4CBD9FD5.506@nokia.com>
	<AANLkTinRRyrXzqEu=u+CCYkmSNGm03SSo1tVG=5_wdpo@mail.gmail.com>
	<4CBE9E69.6060803@nokia.com>
	<AANLkTinOYDBMVZ3ibG3Md7jdOuOC6NkGWaugvHwT6uqF@mail.gmail.com>
	<4CBEB312.7060400@nokia.com>
	<AANLkTikom=eRFqCJmYE+k1zn5K2MR9s8HhNXtjOvUqvr@mail.gmail.com>
	<20101020125407.GE2433@legolas.emea.dhcp.ti.com>
Date: Wed, 20 Oct 2010 17:52:06 +0300
Message-ID: <AANLkTi=+6bC=JALdCDKW_BS-jnNk3zFPuWuBT+aY=Utx@mail.gmail.com>
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

On Wed, Oct 20, 2010 at 3:54 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Wed, Oct 20, 2010 at 04:23:13AM -0500, Felipe Contreras wrote:
>>
>> Ok, but USB_OMAP is not supposed to work on the N900? (I tried and it
>> didn't)
>
> ooooh, that's old. That's from the omap1. It's the old omap_udc.c

Ok, then the dependency should be ARCH_OMAP1, not ARCH_OMAP.

>> I don't think so, because people might not want USB at all. The ideal
>> case would be for USB_GADGET_MUSB_HDRC to be selected automatically
>> when the user selects USB and USB_GADGET, but that's not happening
>> because USB_GADGET_OMAP is selected first (all the dependencies are
>> met).
>
> And how is that different from:
>
> default y if ARCH_OMAP3 ? If you don't want USB at all, you'll disable
> it by hand, the default is on. Select on board Kconfig.

TWL4030_USB is inside drivers/usb/Kconfig and drivers/usb/otg/Kconfig,
which means in order to achieve the same on the board config you would
have to do:

default y if USB_SUPPORT && (USB || USB_GADGET) && ARCH_OMAP3

Seems to be more convoluted to me.

Besides, I think TWL4030_USB and the full description of it doesn't
give any hints to the people reading drivers/usb/otg/Kconfig what is
it used for. 'default y if ARCH_OMAP3' achieves that.

Plus, there is no big change:

config USB_MUSB_HDRC
-	select TWL4030_USB if MACH_OMAP_3430SDP

config TWL4030_USB
+	default y if ARCH_OMAP3

-- 
Felipe Contreras
