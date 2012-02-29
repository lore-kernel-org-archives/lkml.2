Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab2B2I74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 03:59:56 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:43314 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752486Ab2B2I7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 03:59:55 -0500
Message-ID: <4F4DE997.4050900@st.com>
Date: Wed, 29 Feb 2012 10:02:15 +0100
From: Vincenzo Frascino <vincenzo.frascino@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Viresh KUMAR <viresh.kumar@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] thermal: spear13xx: checking for NULL instead of IS_ERR()
References: <20120229063151.GA18031@elgon.mountain>
In-Reply-To: <20120229063151.GA18031@elgon.mountain>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Dan.

Il 29/02/2012 07:31, Dan Carpenter ha scritto:
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

Reviewed-by: Vincenzo Frascino <vincenzo.frascino@st.com>


