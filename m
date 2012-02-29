Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab2B2GfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 01:35:12 -0500
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:49660 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754426Ab2B2GfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 01:35:10 -0500
Message-ID: <4F4DC6D9.7050204@st.com>
Date: Wed, 29 Feb 2012 12:04:01 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Armando VISCONTI <armando.visconti@st.com>
Subject: Re: [patch] thermal: spear13xx: checking for NULL instead of IS_ERR()
References: <20120229063151.GA18031@elgon.mountain>
In-Reply-To: <20120229063151.GA18031@elgon.mountain>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/29/2012 12:01 PM, Dan Carpenter wrote:
> thermal_zone_device_register() never returns NULL, on error it returns
> and ERR_PTR().
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/thermal/spear_thermal.c b/drivers/thermal/spear_thermal.c
> index 880bf28..7352cf8 100644
> --- a/drivers/thermal/spear_thermal.c
> +++ b/drivers/thermal/spear_thermal.c
> @@ -149,9 +149,9 @@ static int spear_thermal_probe(struct platform_device *pdev)
>  
>  	spear_thermal = thermal_zone_device_register("spear_thermal", 0,
>  				stdev, &ops, 0, 0, 0, 0);
> -	if (!spear_thermal) {
> +	if (IS_ERR(spear_thermal)) {
>  		dev_err(&pdev->dev, "thermal zone device is NULL\n");
> -		ret = -EINVAL;
> +		ret = PTR_ERR(spear_thermal);
>  		goto disable_clk;
>  	}
>  

Thanks.

Reviewed-by: Viresh Kumar <viresh.kumar@st.com>

-- 
viresh
