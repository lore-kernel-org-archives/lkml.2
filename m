Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab2JaGYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 02:24:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:47180 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab2JaGYp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 02:24:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,685,1344236400"; 
   d="scan'208";a="234987156"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Wu, Fengguang" <fengguang.wu@intel.com>
Subject: RE: [PATCH] thermal: solve compilation errors in rcar_thermal
Thread-Topic: [PATCH] thermal: solve compilation errors in rcar_thermal
Thread-Index: AQHNtxbTQv2ojBxl6kaA2ApJqTbuEZfS8kQg
Date: Wed, 31 Oct 2012 06:24:08 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B90926324F211@SHSMSX101.ccr.corp.intel.com>
References: <1345566696-21164-1-git-send-email-develkernel412222@gmail.com>
 <87d2zzmin1.wl%kuninori.morimoto.gx@renesas.com>
In-Reply-To: <87d2zzmin1.wl%kuninori.morimoto.gx@renesas.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I can not see the original post of this patch.

Can you resend it so that I can apply it?

> -----Original Message-----
> From: kuninori morimoto [mailto:kuninori.morimoto.gx@gmail.com] On
> Behalf Of Kuninori Morimoto
> Sent: Wednesday, October 31, 2012 11:21 AM
> To: Andrew Morton; Zhang, Rui; linux-kernel@vger.kernel.org
> Cc: Wu, Fengguang
> Subject: Re: [PATCH] thermal: solve compilation errors in rcar_thermal
> Importance: High
> 
> 
> Hi Zhang, Andrew
> 
> This patch is needed on latest linus/master branch.
> Please re-check this patch.
> 
> And, similar patch was added on linux-next/master branch
> b5da4e6d5603633835a1da267e0e699eea66f317
> (Thermal: Pass zone parameters as argument to tzd_register) but it
> seems wrong (?)
> 
> At Tue, 21 Aug 2012 22:01:36 +0530,
> Devendra Naga wrote:
> >
> > following were the errors reported
> >
> > drivers/thermal/rcar_thermal.c: In function 'rcar_thermal_probe':
> > drivers/thermal/rcar_thermal.c:214:10: warning: passing argument 3 of
> > 'thermal_zone_device_register' makes integer from pointer without a
> > cast [enabled by default]
> > include/linux/thermal.h:166:29: note: expected 'int' but argument is
> of type 'struct rcar_thermal_priv *'
> > drivers/thermal/rcar_thermal.c:214:10: error: too few arguments to
> function 'thermal_zone_device_register'
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
> > diff --git a/drivers/thermal/rcar_thermal.c
> > b/drivers/thermal/rcar_thermal.c index d445271..f7a1b57 100644
> > --- a/drivers/thermal/rcar_thermal.c
> > +++ b/drivers/thermal/rcar_thermal.c
> > @@ -210,7 +210,7 @@ static int rcar_thermal_probe(struct
> platform_device *pdev)
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
