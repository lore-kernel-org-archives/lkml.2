Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab2KUPvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 10:51:09 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49460 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab2KUPvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 10:51:08 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of: Have of_device_add call platform_device_add rather than device_add
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devicetree-discuss@lists.ozlabs.org
In-Reply-To: <20121121072448.GG19837@obsidianresearch.com>
References: <20121121072448.GG19837@obsidianresearch.com>
Date: Wed, 21 Nov 2012 15:51:04 +0000
Message-Id: <20121121155104.726B83E0AE2@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2012 00:24:48 -0700, Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
> This allows platform_device_add a chance to call insert_resource
> on all of the resources from OF. At a minimum this fills in proc/iomem
> and presumably makes resource tracking and conflict detection work
> better.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> ---
>  drivers/of/device.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Tested on PPC32 and ARM32 embedded kernels.
> 
> diff --git a/drivers/of/device.c b/drivers/of/device.c
> index 4c74e4f..a5b67dc 100644
> --- a/drivers/of/device.c
> +++ b/drivers/of/device.c
> @@ -62,7 +62,7 @@ int of_device_add(struct platform_device *ofdev)
>  	if (!ofdev->dev.parent)
>  		set_dev_node(&ofdev->dev, of_node_to_nid(ofdev->dev.of_node));
>  
> -	return device_add(&ofdev->dev);
> +	return platform_device_add(ofdev);
>  }
>  
>  int of_device_register(struct platform_device *pdev)

This has the side effect of moving all devices at the root of the tree
from /sys/devices/ to /sys/devices/platform. It also has the possibility
of breaking if any devices get registered with overlapping regions. I
think there are some powerpc 5200 boards that do this, and I'm not sure
about the larger Power boxen.

I've got a more nuanced version of this patch that I'm trying to get
published today for review. I'll add you to the cc list.

g.

> -- 
> 1.7.4.1
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
