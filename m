Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861Ab0JUXAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 19:00:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:58611 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab0JUXAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 19:00:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,219,1286175600"; 
   d="scan'208";a="619121247"
Date: Fri, 22 Oct 2010 01:00:40 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH] mfd: Add free max8998->ono irq in max8998_irq_exit()
Message-ID: <20101021230039.GG11685@sortiz-mobl>
References: <1287565796.7849.6.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287565796.7849.6.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Wed, Oct 20, 2010 at 05:09:56PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
Patch applied, many thanks.

Cheers,
Samuel.


> ---
>  drivers/mfd/max8998-irq.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/max8998-irq.c b/drivers/mfd/max8998-irq.c
> index 346fd29..45bfe77 100644
> --- a/drivers/mfd/max8998-irq.c
> +++ b/drivers/mfd/max8998-irq.c
> @@ -250,6 +250,9 @@ int max8998_irq_init(struct max8998_dev *max8998)
>  
>  void max8998_irq_exit(struct max8998_dev *max8998)
>  {
> +	if (max8998->ono)
> +		free_irq(max8998->ono, max8998);
> +
>  	if (max8998->irq)
>  		free_irq(max8998->irq, max8998);
>  }
> -- 
> 1.7.2
> 
> 
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
