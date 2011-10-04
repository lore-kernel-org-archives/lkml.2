Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab1JDP0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 11:26:43 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41837 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932718Ab1JDP0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 11:26:36 -0400
X-Sasl-enc: IYhi6u/IgZA3vOtlJY7VUJ9/KVILixuHFxgu/Rd2cxc/ 1317741995
Date: Tue, 4 Oct 2011 08:26:11 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: Re: linux-next: manual merge of the usb tree with the arm-soc tree
Message-ID: <20111004152611.GC29994@kroah.com>
References: <20111004165030.ab90295677251fc80bf843a2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111004165030.ab90295677251fc80bf843a2@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 04:50:30PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> arch/arm/mach-omap2/Makefile between commit f41caddbe73f ("omap2+: Use
> Kconfig symbol in Makefile instead of obj-y") from the arm-soc tree and
> commitb 3c3dc22366b ("usb: musb: fix build breakage") from the usb tree.
> 
> I fixed it up (I think, see below) and can carry the fix as necessary.

Ick, what a mess.  Tony and Felipe, is what is below correct?

greg k-h

> diff --cc arch/arm/mach-omap2/Makefile
> index 8bd389d,7317a2b..0000000
> --- a/arch/arm/mach-omap2/Makefile
> +++ b/arch/arm/mach-omap2/Makefile
> @@@ -218,21 -229,24 +218,17 @@@ obj-$(CONFIG_MACH_OMAP_ZOOM3)		+= board
>   					   board-zoom-debugboard.o
>   obj-$(CONFIG_MACH_OMAP_3630SDP)		+= board-3630sdp.o \
>   					   board-zoom-peripherals.o \
>  -					   board-zoom-display.o \
>  -					   board-flash.o \
>  -					   hsmmc.o
>  -obj-$(CONFIG_MACH_CM_T35)		+= board-cm-t35.o \
>  -					   hsmmc.o
>  +					   board-zoom-display.o
>  +obj-$(CONFIG_MACH_CM_T35)		+= board-cm-t35.o
>   obj-$(CONFIG_MACH_CM_T3517)		+= board-cm-t3517.o
>  -obj-$(CONFIG_MACH_IGEP0020)		+= board-igep0020.o \
>  -					   hsmmc.o
>  -obj-$(CONFIG_MACH_OMAP3_TOUCHBOOK)	+= board-omap3touchbook.o \
>  -					   hsmmc.o
>  -obj-$(CONFIG_MACH_OMAP_4430SDP)		+= board-4430sdp.o \
>  -					   hsmmc.o
>  -obj-$(CONFIG_MACH_OMAP4_PANDA)		+= board-omap4panda.o \
>  -					   hsmmc.o
>  +obj-$(CONFIG_MACH_IGEP0020)		+= board-igep0020.o
>  +obj-$(CONFIG_MACH_OMAP3_TOUCHBOOK)	+= board-omap3touchbook.o
> - obj-$(CONFIG_MACH_OMAP_4430SDP)		+= board-4430sdp.o \
> - 					   omap_phy_internal.o
> - obj-$(CONFIG_MACH_OMAP4_PANDA)		+= board-omap4panda.o \
> - 					   omap_phy_internal.o
> ++obj-$(CONFIG_MACH_OMAP_4430SDP)		+= board-4430sdp.o
> ++obj-$(CONFIG_MACH_OMAP4_PANDA)		+= board-omap4panda.o
>  +
> - obj-$(CONFIG_MACH_PCM049)		+= board-omap4pcm049.o \
> - 					   omap_phy_internal.o
> ++obj-$(CONFIG_MACH_PCM049)		+= board-omap4pcm049.o
>   
> - obj-$(CONFIG_MACH_OMAP3517EVM)		+= board-am3517evm.o \
> - 					   omap_phy_internal.o
> + obj-$(CONFIG_MACH_OMAP3517EVM)		+= board-am3517evm.o
>   
>   obj-$(CONFIG_MACH_CRANEBOARD)		+= board-am3517crane.o
>   
