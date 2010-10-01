Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab0JAKGC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 06:06:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:23651 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab0JAKGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 06:06:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,264,1283756400"; 
   d="scan'208";a="842676437"
Date: Fri, 1 Oct 2010 12:06:20 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linux-kernel@vger.kernel.org, laforge@gnumonks.org
Subject: Re: [PATCH 1/3] MFD: allow for bypass of cell resource conflict
 check
Message-ID: <20101001100619.GA3064@sortiz-mobl>
References: <20100930205536.4E29E9D401B@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930205536.4E29E9D401B@zog.reactivated.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Thu, Sep 30, 2010 at 09:55:36PM +0100, Daniel Drake wrote:
> The upcoming VIA VX855 MFD driver needs to communicate resources
> to subdevices where the resources may be claimed by ACPI.
> 
> Add a flag to mfd_cell to request that resources are not policed.
Thanks a lot. All 3 patches applied.

Cheers,
Samuel.


> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
>  drivers/mfd/mfd-core.c   |    8 +++++---
>  include/linux/mfd/core.h |    3 +++
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
> index 1823a57..d1c8605 100644
> --- a/drivers/mfd/mfd-core.c
> +++ b/drivers/mfd/mfd-core.c
> @@ -65,9 +65,11 @@ static int mfd_add_device(struct device *parent, int id,
>  			res[r].end   = cell->resources[r].end;
>  		}
>  
> -		ret = acpi_check_resource_conflict(res);
> -		if (ret)
> -			goto fail_res;
> +		if (!cell->ignore_resource_conflicts) {
> +			ret = acpi_check_resource_conflict(res);
> +			if (ret)
> +				goto fail_res;
> +		}
>  	}
>  
>  	ret = platform_device_add_resources(pdev, res, cell->num_resources);
> diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
> index 11d740b..cb93d80 100644
> --- a/include/linux/mfd/core.h
> +++ b/include/linux/mfd/core.h
> @@ -44,6 +44,9 @@ struct mfd_cell {
>  	 */
>  	int			num_resources;
>  	const struct resource	*resources;
> +
> +	/* don't check for resource conflicts */
> +	bool			ignore_resource_conflicts;
>  };
>  
>  extern int mfd_add_devices(struct device *parent, int id,
> -- 
> 1.7.2.3
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
