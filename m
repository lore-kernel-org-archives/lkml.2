Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab1IPFbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 01:31:42 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:47109 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752100Ab1IPFbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 01:31:41 -0400
Message-ID: <4E72DF1E.3080301@st.com>
Date: Fri, 16 Sep 2011 11:01:10 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Barry Song <Baohua.Song@csr.com>
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "workgroup.linux@csr.com" <workgroup.linux@csr.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Piotr Ziecik <kosmo@semihalf.com>, Yong Wang <yong.y.wang@intel.com>,
        Jaswinder Singh <jassi.brar@samsung.com>,
        Pelagicore AB <info@pelagicore.com>
Subject: Re: [PATCH] dmaengine: delete redundant chan_id and chancnt initialization
 in dma drivers
References: <1316081190-29777-1-git-send-email-Baohua.Song@csr.com>
In-Reply-To: <1316081190-29777-1-git-send-email-Baohua.Song@csr.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/15/2011 3:36 PM, Barry Song wrote:
> dma_async_device_register will re-init chan_id and chancnt,
> so whatever chan_id and chancnt are set in drivers, they will
> be re-written by dma_async_device_register.
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 4d180ca..9bfd6d3 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1407,12 +1407,11 @@ static int __init dw_probe(struct platform_device *pdev)
>  	dw->all_chan_mask = (1 << pdata->nr_channels) - 1;
>  
>  	INIT_LIST_HEAD(&dw->dma.channels);
> -	for (i = 0; i < pdata->nr_channels; i++, dw->dma.chancnt++) {
> +	for (i = 0; i < pdata->nr_channels; i++) {
>  		struct dw_dma_chan	*dwc = &dw->chan[i];
>  
>  		dwc->chan.device = &dw->dma;
>  		dwc->chan.cookie = dwc->completed = 1;
> -		dwc->chan.chan_id = i;
>  		if (pdata->chan_allocation_order == CHAN_ALLOCATION_ASCENDING)
>  			list_add_tail(&dwc->chan.device_node,
>  					&dw->dma.channels);
> @@ -1468,7 +1467,7 @@ static int __init dw_probe(struct platform_device *pdev)
>  	dma_writel(dw, CFG, DW_CFG_DMA_EN);
>  
>  	printk(KERN_INFO "%s: DesignWare DMA Controller, %d channels\n",
> -			dev_name(&pdev->dev), dw->dma.chancnt);
> +			dev_name(&pdev->dev), pdata->nr_channels);
>  
>  	dma_async_device_register(&dw->dma);
>  

Acked-by: Viresh Kumar <viresh.kumar@st.com>

-- 
viresh
