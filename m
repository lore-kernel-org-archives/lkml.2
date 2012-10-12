Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655Ab2JLO60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 10:58:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:64937 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759613Ab2JLO6Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 10:58:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,576,1344236400"; 
   d="scan'208";a="204848188"
Message-ID: <1350053897.10584.172.camel@smile>
Subject: Re: [PATCH V2 2/3] dmaengine: dw_dmac: Enhance device tree support
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Date: Fri, 12 Oct 2012 17:58:17 +0300
In-Reply-To: <9688d98010716880c1bbd966ead312c446282204.1350051925.git.viresh.kumar@linaro.org>
References: <142ef9170a2c69657d8a05ac127a9970d7b04965.1350051925.git.viresh.kumar@linaro.org>
	 <9688d98010716880c1bbd966ead312c446282204.1350051925.git.viresh.kumar@linaro.org>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-12 at 20:01 +0530, Viresh Kumar wrote:

> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c

> @@ -1179,6 +1179,53 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
>  	dev_vdbg(chan2dev(chan), "%s: done\n", __func__);
>  }
>  
> +bool dw_dma_generic_filter(struct dma_chan *chan, void *param)
> +{
> +	struct dw_dma *dw = to_dw_dma(chan->device);
> +	static struct dw_dma *last_dw;
> +	static char *last_bus_id;
> +	int i = -1;
> +
> +	/*
> +	 * dmaengine framework calls this routine for all channels of all dma
> +	 * controller, until true is returned. If 'param' bus_id is not
> +	 * registered with a dma controller (dw), then there is no need of
> +	 * running below function for all channels of dw.
> +	 *
> +	 * This block of code does this by saving the parameters of last
> +	 * failure. If dw and param are same, i.e. trying on same dw with
> +	 * different channel, return false.
> +	 */
> +	if (last_dw) {
> +		if ((last_bus_id == param) && (last_dw == dw))
> +			return false;
> +	}
Just came to my mind.
dw can't be NULL, can't it?
Then
if (last_dw) {
...
}
is unneeded.

Please, check twice my thought because it's a Friday evening.

> @@ -1462,6 +1509,91 @@ static void dw_dma_off(struct dw_dma *dw)
>  		dw->chan[i].initialized = false;
>  }
>  
> +#ifdef CONFIG_OF
> +static struct dw_dma_platform_data *
> +__devinit dw_dma_parse_dt(struct platform_device *pdev)
> +{
> +	struct device_node *sn, *cn, *np = pdev->dev.of_node;
> +	struct dw_dma_platform_data *pdata;
> +	struct dw_dma_slave *sd;
> +	u32 val, arr[4];
Let me weekend to think about naming. I really can't offer anything else
right now.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
