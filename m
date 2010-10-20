Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab0JTPPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 11:15:52 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49709 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab0JTPPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 11:15:51 -0400
Date: Wed, 20 Oct 2010 18:15:27 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "Balbi, Felipe" <balbi@ti.com>, Roger Quadros <roger.quadros@nokia.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
Message-ID: <20101020151527.GF2883@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <AANLkTi=+6bC=JALdCDKW_BS-jnNk3zFPuWuBT+aY=Utx@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

On Wed, Oct 20, 2010 at 09:52:06AM -0500, Felipe Contreras wrote:
>TWL4030_USB is inside drivers/usb/Kconfig and drivers/usb/otg/Kconfig,
>which means in order to achieve the same on the board config you would
>have to do:
>
>default y if USB_SUPPORT && (USB || USB_GADGET) && ARCH_OMAP3
>
>Seems to be more convoluted to me.
>
>Besides, I think TWL4030_USB and the full description of it doesn't
>give any hints to the people reading drivers/usb/otg/Kconfig what is
>it used for. 'default y if ARCH_OMAP3' achieves that.

no it doesn't. No user will 'cat drivers/usb/otg/Kconfig | grep -A 10
TWL4030' and check the 'default y if ARCH_OMAP3

if you think help is not enough, fix help.

>Plus, there is no big change:
>
>config USB_MUSB_HDRC
>-	select TWL4030_USB if MACH_OMAP_3430SDP
>
>config TWL4030_USB
>+	default y if ARCH_OMAP3
>

what's the problem with:

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index ab784bf..3af9580 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -215,6 +215,7 @@ config MACH_NOKIA_RX51
         depends on ARCH_OMAP3
         default y
         select OMAP_PACKAGE_CBB
+       select TWL4030_USB
  
  config MACH_OMAP_ZOOM2
         bool "OMAP3 Zoom2 board"

-- 
balbi
