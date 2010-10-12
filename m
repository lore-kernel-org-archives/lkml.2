Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab0JLI2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 04:28:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43621 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756621Ab0JLI2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 04:28:50 -0400
Date: Tue, 12 Oct 2010 09:28:14 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>
Subject: Re: linux-next: manual merge of the arm tree with the arm-current
	tree
Message-ID: <20101012082814.GC12845@flint.arm.linux.org.uk>
References: <20101012103314.41b00cbe.sfr@canb.auug.org.au> <20101012080354.GC29673@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101012080354.GC29673@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 10:03:54AM +0200, Uwe Kleine-König wrote:
> On Tue, Oct 12, 2010 at 10:33:14AM +1100, Stephen Rothwell wrote:
> > Hi Russell,
> > 
> > Today's linux-next merge of the arm tree got a conflict in
> > arch/arm/mach-imx/mach-cpuimx27.c between commit
> > 4793ca4028e4dcdbf2740db50995c9378ded3cf8 ("cpuimx27: fix i2c bus
> > selection") from the arm-current tree and commit
> > 77a406da5a5b76445a816d5f043fc9aef4026ff1 ("ARM: imx: fix name of macros
> > to add imx-i2c devices") from the arm tree.
> > 
> > I fixed it up (see below) can can carry the fix for a while.
> > -- 
> > Cheers,
> > Stephen Rothwell                    sfr@canb.auug.org.au
> > 
> > diff --cc arch/arm/mach-imx/mach-cpuimx27.c
> > index 6830afd,28f73a1..0000000
> > --- a/arch/arm/mach-imx/mach-cpuimx27.c
> > +++ b/arch/arm/mach-imx/mach-cpuimx27.c
> > @@@ -259,8 -258,9 +258,9 @@@ static void __init eukrea_cpuimx27_init
> >   	i2c_register_board_info(0, eukrea_cpuimx27_i2c_devices,
> >   				ARRAY_SIZE(eukrea_cpuimx27_i2c_devices));
> >   
> > - 	imx27_add_i2c_imx0(&cpuimx27_i2c1_data);
> >  -	imx27_add_imx_i2c(1, &cpuimx27_i2c1_data);
> > ++	imx27_add_imx_i2c(0, &cpuimx27_i2c1_data);
> >   
> > + 	imx27_add_fec(NULL);
> >   	platform_add_devices(platform_devices, ARRAY_SIZE(platform_devices));
> >   
> >   #if defined(CONFIG_MACH_EUKREA_CPUIMX27_USESDHC2)
> > 
> This is resolved correctly.

A more concerning question is - these recent conflicts have been happening
as a result of merging people's GIT trees, which tend to be sent close
to the merge window.

If the first time their changes become visible to linux-next is when
they're merged into my tree, something is wrong...

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
