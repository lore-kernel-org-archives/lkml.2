Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab2IRSqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:46:34 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:60337 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab2IRSq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:46:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Axel Lin <axel.lin@gmail.com>, Kevin Hilman <khilman@ti.com>
Subject: Re: [PATCH] cpufreq: OMAP: Check IS_ERR() instead of NULL for omap_device_get_by_hwmod_name
Date: Tue, 18 Sep 2012 20:52:57 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
References: <1347932747.6562.3.camel@phoenix>
In-Reply-To: <1347932747.6562.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201209182052.57414.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 18, 2012, Axel Lin wrote:
> omap_device_get_by_hwmod_name() returns ERR_PTR on error.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Kevin, should I take this?

Rafael


> ---
>  drivers/cpufreq/omap-cpufreq.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
> index 6e22f44..65f8e9a 100644
> --- a/drivers/cpufreq/omap-cpufreq.c
> +++ b/drivers/cpufreq/omap-cpufreq.c
> @@ -266,9 +266,9 @@ static int __init omap_cpufreq_init(void)
>  	}
>  
>  	mpu_dev = omap_device_get_by_hwmod_name("mpu");
> -	if (!mpu_dev) {
> +	if (IS_ERR(mpu_dev)) {
>  		pr_warning("%s: unable to get the mpu device\n", __func__);
> -		return -EINVAL;
> +		return PTR_ERR(mpu_dev);
>  	}
>  
>  	mpu_reg = regulator_get(mpu_dev, "vcc");
> 

