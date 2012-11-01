Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab2KAC3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 22:29:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:52541 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab2KAC3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 22:29:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,690,1344236400"; 
   d="scan'208";a="241144582"
Date: Thu, 1 Nov 2012 10:29:04 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zhang Rui <rui.zhang@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thermal: solve compilation errors in rcar_thermal
Message-ID: <20121101022904.GA10464@localhost>
References: <1345566696-21164-1-git-send-email-develkernel412222@gmail.com>
 <87d2zzmin1.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87d2zzmin1.wl%kuninori.morimoto.gx@renesas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 08:21:09PM -0700, Kuninori Morimoto wrote:
> 
> Hi Zhang, Andrew
> 
> This patch is needed on latest linus/master branch.
> Please re-check this patch.

Rui, it'd be better to send Andrew a finalized patch with your
Acked-by or Signed-off-by (because you passed it on), after resolving
the below puzzle:

> And, similar patch was added on linux-next/master branch
> b5da4e6d5603633835a1da267e0e699eea66f317
> (Thermal: Pass zone parameters as argument to tzd_register)
> but it seems wrong (?)

Thanks,
Fengguang

> At Tue, 21 Aug 2012 22:01:36 +0530,
> Devendra Naga wrote:
> > 
> > following were the errors reported
> > 
> > drivers/thermal/rcar_thermal.c: In function ‘rcar_thermal_probe’:
> > drivers/thermal/rcar_thermal.c:214:10: warning: passing argument 3 of ‘thermal_zone_device_register’ makes integer from pointer without a cast [enabled by default]
> > include/linux/thermal.h:166:29: note: expected ‘int’ but argument is of type ‘struct rcar_thermal_priv *’
> > drivers/thermal/rcar_thermal.c:214:10: error: too few arguments to function ‘thermal_zone_device_register’
> > include/linux/thermal.h:166:29: note: declared here
> > make[1]: *** [drivers/thermal/rcar_thermal.o] Error 1
> > make: *** [drivers/thermal/rcar_thermal.o] Error 2
> > 
> > with gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5)
> > 
> > Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
> > ---
> >  drivers/thermal/rcar_thermal.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/thermal/rcar_thermal.c b/drivers/thermal/rcar_thermal.c
> > index d445271..f7a1b57 100644
> > --- a/drivers/thermal/rcar_thermal.c
> > +++ b/drivers/thermal/rcar_thermal.c
> > @@ -210,7 +210,7 @@ static int rcar_thermal_probe(struct platform_device *pdev)
> >  		goto error_free_priv;
> >  	}
> >  
> > -	zone = thermal_zone_device_register("rcar_thermal", 0, priv,
> > +	zone = thermal_zone_device_register("rcar_thermal", 0, 0, priv,
> >  					    &rcar_thermal_zone_ops, 0, 0);
> >  	if (IS_ERR(zone)) {
> >  		dev_err(&pdev->dev, "thermal zone device is NULL\n");
> > -- 
> > 1.7.9.5
> > 
> 
> 
> Best regards
> ---
> Kuninori Morimoto
