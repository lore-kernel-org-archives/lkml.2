Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab0KHIST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 03:18:19 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34658 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab0KHISS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 03:18:18 -0500
Date: Mon, 8 Nov 2010 09:18:08 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Joe Perches <joe@perches.com>
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/arm/plat-mxc/cpufreq.c: Fix line continuation
	defect
Message-ID: <20101108081808.GN16938@pengutronix.de>
References: <1289164215.29216.315.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1289164215.29216.315.camel@Joe-Laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Sun, Nov 07, 2010 at 01:10:15PM -0800, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/arm/plat-mxc/cpufreq.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/plat-mxc/cpufreq.c b/arch/arm/plat-mxc/cpufreq.c
> index 039538e..9f358af 100644
> --- a/arch/arm/plat-mxc/cpufreq.c
> +++ b/arch/arm/plat-mxc/cpufreq.c
> @@ -154,8 +154,8 @@ static int __init mxc_cpufreq_init(struct cpufreq_policy *policy)
>  	ret = cpufreq_frequency_table_cpuinfo(policy, imx_freq_table);
>  
>  	if (ret < 0) {
> -		printk(KERN_ERR "%s: failed to register i.MXC CPUfreq \
> -				with error code %d\n", __func__, ret);
> +		printk(KERN_ERR "%s: failed to register i.MXC CPUfreq with error code %d\n",
> +		       __func__, ret);
I'd prefer
+		printk(KERN_ERR "%s: failed to register i.MXC CPUfreq "
+				"with error code %d\n", __func__, ret);

(actually I'd consider

+		pr_err("failed to register i.MXC CPUfreq (error: %d)\n", ret)

even better, but this is out of scope for this patch, isn't it?)

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
