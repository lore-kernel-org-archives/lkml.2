Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105Ab0JLIEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 04:04:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43463 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080Ab0JLIEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 04:04:04 -0400
Date: Tue, 12 Oct 2010 10:03:54 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Russell King <rmk@arm.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>
Subject: Re: linux-next: manual merge of the arm tree with the arm-current
	tree
Message-ID: <20101012080354.GC29673@pengutronix.de>
References: <20101012103314.41b00cbe.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101012103314.41b00cbe.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 10:33:14AM +1100, Stephen Rothwell wrote:
> Hi Russell,
> 
> Today's linux-next merge of the arm tree got a conflict in
> arch/arm/mach-imx/mach-cpuimx27.c between commit
> 4793ca4028e4dcdbf2740db50995c9378ded3cf8 ("cpuimx27: fix i2c bus
> selection") from the arm-current tree and commit
> 77a406da5a5b76445a816d5f043fc9aef4026ff1 ("ARM: imx: fix name of macros
> to add imx-i2c devices") from the arm tree.
> 
> I fixed it up (see below) can can carry the fix for a while.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/mach-imx/mach-cpuimx27.c
> index 6830afd,28f73a1..0000000
> --- a/arch/arm/mach-imx/mach-cpuimx27.c
> +++ b/arch/arm/mach-imx/mach-cpuimx27.c
> @@@ -259,8 -258,9 +258,9 @@@ static void __init eukrea_cpuimx27_init
>   	i2c_register_board_info(0, eukrea_cpuimx27_i2c_devices,
>   				ARRAY_SIZE(eukrea_cpuimx27_i2c_devices));
>   
> - 	imx27_add_i2c_imx0(&cpuimx27_i2c1_data);
>  -	imx27_add_imx_i2c(1, &cpuimx27_i2c1_data);
> ++	imx27_add_imx_i2c(0, &cpuimx27_i2c1_data);
>   
> + 	imx27_add_fec(NULL);
>   	platform_add_devices(platform_devices, ARRAY_SIZE(platform_devices));
>   
>   #if defined(CONFIG_MACH_EUKREA_CPUIMX27_USESDHC2)
> 
This is resolved correctly.

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
