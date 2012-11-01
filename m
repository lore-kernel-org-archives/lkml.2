Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab2KACR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 22:17:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:19482 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726Ab2KACRZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 22:17:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,690,1344236400"; 
   d="scan'208";a="242720752"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        Devendra Naga <develkernel412222@gmail.com>
Subject: RE: [PATCH] thermal: solve compilation errors in rcar_thermal
Thread-Topic: [PATCH] thermal: solve compilation errors in rcar_thermal
Thread-Index: AQHNtxbTQv2ojBxl6kaA2ApJqTbuEZfS8kQg//+hywCAAarj4A==
Date: Thu, 1 Nov 2012 02:17:15 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B90926324F941@SHSMSX101.ccr.corp.intel.com>
References: <1345566696-21164-1-git-send-email-develkernel412222@gmail.com>
	<87d2zzmin1.wl%kuninori.morimoto.gx@renesas.com>
	<744357E9AAD1214791ACBA4B0B90926324F211@SHSMSX101.ccr.corp.intel.com>
 <87390vm3l9.wl%kuninori.morimoto.gx@renesas.com>
In-Reply-To: <87390vm3l9.wl%kuninori.morimoto.gx@renesas.com>
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

Hi, Andrew,

Can you take this patch?
It fixes a real build error, and IMO, we should merge it ASAP. Thanks.

> -----Original Message-----
> From: kuninori morimoto [mailto:kuninori.morimoto.gx@gmail.com] On
> Behalf Of Kuninori Morimoto
> Sent: Wednesday, October 31, 2012 4:46 PM
> To: Zhang, Rui
> Cc: Andrew Morton; linux-kernel@vger.kernel.org; Wu, Fengguang;
> Devendra Naga
> Subject: [PATCH] thermal: solve compilation errors in rcar_thermal
> Importance: High
> 
> From: Devendra Naga <develkernel412222@gmail.com>
> 
> following were the errors reported
> 
> drivers/thermal/rcar_thermal.c: In function 'rcar_thermal_probe':
> drivers/thermal/rcar_thermal.c:214:10: warning: passing argument 3 of
> 'thermal_zone_device_register' makes integer from pointer without a
> cast [enabled by default]
> include/linux/thermal.h:166:29: note: expected 'int' but argument is of
> type 'struct rcar_thermal_priv *'
> drivers/thermal/rcar_thermal.c:214:10: error: too few arguments to
> function 'thermal_zone_device_register'
> include/linux/thermal.h:166:29: note: declared here
> make[1]: *** [drivers/thermal/rcar_thermal.o] Error 1
> make: *** [drivers/thermal/rcar_thermal.o] Error 2
> 
> with gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5)
> 
> Signed-off-by: Devendra Naga <develkernel412222@gmail.com>


Acked-by: Zhang Rui <rui.zhang@intel.com>

Thanks,
rui
> ---
> Hi Zhang
> 
> This is original patch.
> Please check Author's name after "git am"
> 
>  drivers/thermal/rcar_thermal.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/thermal/rcar_thermal.c
> b/drivers/thermal/rcar_thermal.c index d445271..f7a1b57 100644
> --- a/drivers/thermal/rcar_thermal.c
> +++ b/drivers/thermal/rcar_thermal.c
> @@ -210,7 +210,7 @@ static int rcar_thermal_probe(struct
> platform_device *pdev)
>  		goto error_free_priv;
>  	}
> 
> -	zone = thermal_zone_device_register("rcar_thermal", 0, priv,
> +	zone = thermal_zone_device_register("rcar_thermal", 0, 0, priv,
>  					    &rcar_thermal_zone_ops, 0, 0);
>  	if (IS_ERR(zone)) {
>  		dev_err(&pdev->dev, "thermal zone device is NULL\n");
> --
> 1.7.9.5

