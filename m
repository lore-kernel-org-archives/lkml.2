Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab2DPP2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:28:16 -0400
Received: from mga14.intel.com ([143.182.124.37]:16901 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059Ab2DPP2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:28:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="89594205"
Date: Mon, 16 Apr 2012 17:37:08 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] mfd: Silence uninitialized variable warning for
 wm8994-core
Message-ID: <20120416153708.GG24130@sortiz-mobl>
References: <1333597752.10597.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333597752.10597.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Thu, Apr 05, 2012 at 11:49:12AM +0800, Axel Lin wrote:
> Fix below build warning:
>   CC      drivers/mfd/wm8994-core.o
> drivers/mfd/wm8994-core.c: In function 'wm8994_i2c_probe':
> drivers/mfd/wm8994-core.c:582:7: warning: 'patch_regs' may be used uninitialized in this function [-Wuninitialized]
> drivers/mfd/wm8994-core.c:393:14: note: 'patch_regs' was declared here
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/wm8994-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
> index 9d7ca1e..bd02202 100644
> --- a/drivers/mfd/wm8994-core.c
> +++ b/drivers/mfd/wm8994-core.c
> @@ -390,7 +390,7 @@ static __devinit int wm8994_device_init(struct wm8994 *wm8994, int irq)
>  	struct regmap_config *regmap_config;
>  	const struct reg_default *regmap_patch = NULL;
>  	const char *devname;
> -	int ret, i, patch_regs;
> +	int ret, i, patch_regs = 0;
I'd agree with Mark here. I don't particularily like this kind of fix as it
basically turns potentially useful gcc warnings off.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
