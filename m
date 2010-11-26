Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab0KZPnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:43:13 -0500
Received: from mga14.intel.com ([143.182.124.37]:7032 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab0KZPnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:43:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,261,1288594800"; 
   d="scan'208";a="353581372"
Date: Fri, 26 Nov 2010 16:43:04 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        Ludovic Barre <ludovic.barre@stericsson.com>
Subject: Re: [PATCH] MFD: ab8500 chip id exported to sysfs
Message-ID: <20101126154303.GC27663@sortiz-mobl>
References: <1290773125-9031-1-git-send-email-mattias.wallin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290773125-9031-1-git-send-email-mattias.wallin@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mattias,

On Fri, Nov 26, 2010 at 01:05:25PM +0100, Mattias Wallin wrote:
> This patch adds a file into sysfs for reading out chip id.
> It have been requested for modem silent reboot.
> 
> Change-Id: I8e2c10e740a90ab210e023df4214b422c01f2efb
I suppose this is some internal ID ? Please remove it from the Changelog.


> Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
> Signed-off-by: Ludovic Barre <ludovic.barre@stericsson.com>
> ---
>  drivers/mfd/ab8500-core.c |   27 ++++++++++++++++++++++++++-
>  1 files changed, 26 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
> index e64569e..c59e832 100644
> --- a/drivers/mfd/ab8500-core.c
> +++ b/drivers/mfd/ab8500-core.c
> @@ -98,7 +98,7 @@ static int ab8500_get_chip_id(struct device *dev)
>  	if (!dev)
>  		return -EINVAL;
>  	ab8500 = dev_get_drvdata(dev->parent);
> -	return (int)ab8500->chip_id;
> +	return ab8500 ? (int)ab8500->chip_id : -EINVAL;
Here again, you're squeezing some potential bug fix into this patch.

The rest looks just fine.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
