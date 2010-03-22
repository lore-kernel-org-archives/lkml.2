Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab0CVPpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 11:45:42 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:54214 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753482Ab0CVPpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 11:45:41 -0400
X-Greylist: delayed 1816 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Mar 2010 11:45:39 EDT
Message-ID: <4BA78977.6020801@st.com>
Date: Mon, 22 Mar 2010 16:15:03 +0100
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, netdev@vger.kernel.org,
       Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch] stmmac: use resource_size()
References: <20100322121111.GJ21571@bicker>
In-Reply-To: <20100322121111.GJ21571@bicker>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan
Thanks, the patch can also applied against the net-next driver and it's ok.

Regards,
 Giuseppe

Dan Carpenter wrote:
> The size calculation is not correct.  It should be end - start + 1.
> Use resource_size() to calculate it instead.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/net/stmmac/stmmac_main.c b/drivers/net/stmmac/stmmac_main.c
> index a673361..92bef30 100644
> --- a/drivers/net/stmmac/stmmac_main.c
> +++ b/drivers/net/stmmac/stmmac_main.c
> @@ -1685,8 +1685,7 @@ static int stmmac_dvr_probe(struct platform_device *pdev)
>  	}
>  	pr_info("done!\n");
>  
> -	if (!request_mem_region(res->start, (res->end - res->start),
> -				pdev->name)) {
> +	if (!request_mem_region(res->start, resource_size(res),	pdev->name)) {
>  		pr_err("%s: ERROR: memory allocation failed"
>  		       "cannot get the I/O addr 0x%x\n",
>  		       __func__, (unsigned int)res->start);
> @@ -1694,9 +1693,9 @@ static int stmmac_dvr_probe(struct platform_device *pdev)
>  		goto out;
>  	}
>  
> -	addr = ioremap(res->start, (res->end - res->start));
> +	addr = ioremap(res->start, resource_size(res));
>  	if (!addr) {
> -		pr_err("%s: ERROR: memory mapping failed \n", __func__);
> +		pr_err("%s: ERROR: memory mapping failed\n", __func__);
>  		ret = -ENOMEM;
>  		goto out;
>  	}
> @@ -1774,7 +1773,7 @@ static int stmmac_dvr_probe(struct platform_device *pdev)
>  out:
>  	if (ret < 0) {
>  		platform_set_drvdata(pdev, NULL);
> -		release_mem_region(res->start, (res->end - res->start));
> +		release_mem_region(res->start, resource_size(res));
>  		if (addr != NULL)
>  			iounmap(addr);
>  	}
> @@ -1812,7 +1811,7 @@ static int stmmac_dvr_remove(struct platform_device *pdev)
>  
>  	iounmap((void *)ndev->base_addr);
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	release_mem_region(res->start, (res->end - res->start));
> +	release_mem_region(res->start, resource_size(res));
>  
>  	free_netdev(ndev);
>  
> 

