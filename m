Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab2ISPb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:31:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:9447 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756449Ab2ISPaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:30:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,447,1344236400"; 
   d="scan'208";a="146767470"
Date: Wed, 19 Sep 2012 17:30:05 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Patil, Rachna" <rachna@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-iio@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH 2/5] MFD: ti_tscadc: Add support for TI's TSC/ADC MFDevice
Message-ID: <20120919153005.GG28670@sortiz-mobl>
References: <1345718997-18304-1-git-send-email-rachna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345718997-18304-1-git-send-email-rachna@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rachna

A couple of comments:

On Thu, Aug 23, 2012 at 04:19:57PM +0530, Patil, Rachna wrote:
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index d1facef..81eb815 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -94,6 +94,15 @@ config MFD_TI_SSP
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called ti-ssp.
>  
> +config MFD_TI_TSCADC
> +	tristate "TI ADC / Touch Screen chip support"
> +	depends on ARCH_OMAP2PLUS
What makes it OMAP2PLUS or even ARCH specific at all ?


> +static unsigned int tscadc_readl(struct ti_tscadc_dev *tsadc, unsigned int reg)
> +{
> +	return readl(tsadc->tscadc_base + reg);
> +}
> +
> +static void tscadc_writel(struct ti_tscadc_dev *tsadc, unsigned int reg,
> +					unsigned int val)
> +{
> +	writel(val, tsadc->tscadc_base + reg);
> +}
Please use regmap MMIO for that stuff. It won't make the code shorter, but
more robust.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
