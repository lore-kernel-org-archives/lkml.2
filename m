Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab1CRFQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 01:16:37 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40088 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab1CRFQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 01:16:30 -0400
Date: Thu, 17 Mar 2011 23:16:27 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Denis Turischev <denis@compulab.co.il>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: manual merge of the spi tree with the mfd tree
Message-ID: <20110318051627.GE18545@angua.secretlab.ca>
References: <20110318154017.e45aa888.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110318154017.e45aa888.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 03:40:17PM +1100, Stephen Rothwell wrote:
> Hi Grant,
> 
> Today's linux-next merge of the spi tree got a conflict in
> drivers/gpio/Kconfig between commit 390ff13830e5 ("gpio: Add Tunnel Creek
> support to sch_gpio") from the mfd tree and commit 61ab3fe57e45 ("gpio;
> Make Intel chipset gpio drivers depend on x86") from the spi tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.  I am assuming that the Tunnel Creek stuff should also depend
> on X86?

It would appear so.  Thanks Stephen.

BTW Samuel, looking at the commit message for 390ff13830e5:

commit 390ff13830e5bcc4f8585b396e3d15b1c04c0282
Author: Denis Turischev <denis@compulab.co.il>
Date:   Mon Mar 14 12:53:05 2011 +0200
[...]
    Signed-off-by: Denis Turischev <denis@compulab.co.il>
    Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

My Acked-by seems to be missing from the commit log.

g.


> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/gpio/Kconfig
> index 7ef9108,b46442d..0000000
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@@ -100,8 -100,8 +100,8 @@@ config GPIO_VR41X
>   	  Say yes here to support the NEC VR4100 series General-purpose I/O Uint
>   
>   config GPIO_SCH
>  -	tristate "Intel SCH GPIO"
>  +	tristate "Intel SCH/TunnelCreek GPIO"
> - 	depends on GPIOLIB && PCI
> + 	depends on GPIOLIB && PCI && X86
>   	select MFD_CORE
>   	select LPC_SCH
>   	help
