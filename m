Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab0JTRyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 13:54:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40872 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab0JTRyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 13:54:50 -0400
Date: Wed, 20 Oct 2010 20:54:20 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "Balbi, Felipe" <balbi@ti.com>, Roger Quadros <roger.quadros@nokia.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
Message-ID: <20101020175420.GC3431@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <AANLkTim-QeP0hfSVGUd-tHWso9HQv25TwapBBZ1KPD3=@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Oct 20, 2010 at 11:22:17AM -0500, Felipe Contreras wrote:
>Users would not need to care... if they enable USB and USB_GADGET, it
>will be selected automatically for OMAP3, which is what users would
>expect.

wouldn't a user expect USB to be enabled if the board _has_ a USB
connector ?

>I was talking more about developers.
>
>How should the help be fixed?
>"Select y if you are using an OMAP3 system that has TWL4030"

If you have the TWL4030 family of PMIC chips and want to use USB, you
probably need this. If unsure, say Y.

>1) Do you think all the OMAP3 boards should add that?

why not ?

>2) What if you don't want to use USB?

what if you don't want to use USB and we use your choice of:

default y if ARCH_OMAP3 ??

what's the big difference ? The default will be "USB enabled" and if you
don't want, just drop it. The thing is that in most cases we want to
support what is wired on the board. RX51 has a USB micro-B connector, so
by default we want USB peripheral enabled and host disabled. If a user
(or developer for that matter) wants to play with the unsupported host
mode on RX51, he will enable that part by himself and pray for it to
work. If, on the other hand, a camera developer doesn't need USB at all
and decides to save a few bytes on the binary, he will make sure to
disable it.

The thing is that there's no way to make everybody happy, so we stick to
what the board is wired to do.

-- 
balbi
