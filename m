Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab0GVASE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 20:18:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60157 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab0GVAR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 20:17:59 -0400
Date: Wed, 21 Jul 2010 17:07:37 -0700
From: Greg KH <gregkh@suse.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Michal Simek <monstr@monstr.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        microblaze-uclinux@itee.uq.edu.au, sparclinux@vger.kernel.org,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/5] drivercore/of: Add OF style matching to platform
 bus
Message-ID: <20100722000737.GA14249@suse.de>
References: <20100721232817.7782.23410.stgit@angua>
 <20100721233954.7782.81154.stgit@angua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100721233954.7782.81154.stgit@angua>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 05:39:54PM -0600, Grant Likely wrote:
> As part of the merge between platform bus and of_platform bus, add the
> ability to do of-style matching to the platform bus.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> CC: Greg Kroah-Hartman <gregkh@suse.de>
> CC: Michal Simek <monstr@monstr.eu>
> CC: Grant Likely <grant.likely@secretlab.ca>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: Stephen Rothwell <sfr@canb.auug.org.au>
> CC: linux-kernel@vger.kernel.org
> CC: microblaze-uclinux@itee.uq.edu.au
> CC: linuxppc-dev@ozlabs.org
> CC: devicetree-discuss@lists.ozlabs.org
> ---
>  drivers/base/platform.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 4d99c8b..6a9b3dd 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -12,6 +12,7 @@
>  
>  #include <linux/string.h>
>  #include <linux/platform_device.h>
> +#include <linux/of_device.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/dma-mapping.h>
> @@ -673,6 +674,10 @@ static int platform_match(struct device *dev, struct device_driver *drv)
>  	struct platform_device *pdev = to_platform_device(dev);
>  	struct platform_driver *pdrv = to_platform_driver(drv);
>  
> +	/* Attempt an OF style match first */
> +	if (of_driver_match_device(dev, drv))
> +		return 1;
> +
>  	/* match against the id table first */

I think you need to also change this comment, you can't have two
"firsts" :)

If you do that, feel free to add an:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to the patch.

thanks,

greg k-h
