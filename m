Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab0JUKYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 06:24:46 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58382 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102Ab0JUKYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:24:44 -0400
Date: Thu, 21 Oct 2010 13:24:33 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "Balbi, Felipe" <balbi@ti.com>, Roger Quadros <roger.quadros@nokia.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
Message-ID: <20101021102433.GG3958@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <4CBE9E69.6060803@nokia.com>
 <AANLkTinOYDBMVZ3ibG3Md7jdOuOC6NkGWaugvHwT6uqF@mail.gmail.com>
 <4CBEB312.7060400@nokia.com>
 <AANLkTikom=eRFqCJmYE+k1zn5K2MR9s8HhNXtjOvUqvr@mail.gmail.com>
 <20101020125407.GE2433@legolas.emea.dhcp.ti.com>
 <AANLkTi=+6bC=JALdCDKW_BS-jnNk3zFPuWuBT+aY=Utx@mail.gmail.com>
 <20101020151527.GF2883@legolas.emea.dhcp.ti.com>
 <AANLkTim-QeP0hfSVGUd-tHWso9HQv25TwapBBZ1KPD3=@mail.gmail.com>
 <20101020175420.GC3431@legolas.emea.dhcp.ti.com>
 <AANLkTin31dmD5OfR3-nvZSg82i3H=_xgH_isJc+Epttq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <AANLkTin31dmD5OfR3-nvZSg82i3H=_xgH_isJc+Epttq@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

On Thu, Oct 21, 2010 at 04:04:27AM -0500, Felipe Contreras wrote:
>> wouldn't a user expect USB to be enabled if the board _has_ a USB
>> connector ?
>
>Not if it's not going to be used.

and how would you know before hand if it's going to be used or not ?

>>> 1) Do you think all the OMAP3 boards should add that?
>>
>> why not ?
>
>You prefer a patch that adds one line per board rather than a patch
>that adds one line in total... That is exactly the opposite of Linus's
>complaint regarding big ARM changesets.

The thing is that what you are proposing will not scale when we have too
many boards with different transceivers. Then we will end up with things
like:

config USB_ARCH_HAS_OHCI
	boolean
	# ARM:
	default y if SA1111
	default y if ARCH_OMAP
	default y if ARCH_LH7A404
	default y if ARCH_S3C2410
	default y if PXA27x
	default y if PXA3xx
	default y if ARCH_EP93XX
	default y if ARCH_AT91
	default y if ARCH_PNX4008 && I2C
	default y if MFD_TC6393XB
	default y if ARCH_W90X900
	default y if ARCH_DAVINCI_DA8XX
	# PPC:
	default y if STB03xxx
	default y if PPC_MPC52xx
	# MIPS:
	default y if MIPS_ALCHEMY
	default y if MACH_JZ4740
	# SH:
	default y if CPU_SUBTYPE_SH7720
	default y if CPU_SUBTYPE_SH7721
	default y if CPU_SUBTYPE_SH7763
	default y if CPU_SUBTYPE_SH7786
	# more:
	default PCI

which to me would be much better that e.g. SA1111 does a select
USB_ARCH_HAS_OHCI like it's done for HAVE_CLK

-- 
balbi
