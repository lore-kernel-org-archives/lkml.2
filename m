Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab2ILIMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 04:12:01 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:40484 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754768Ab2ILIL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 04:11:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120912155231.716530c364bb20bd43efec0d@canb.auug.org.au>
References: <20120912155231.716530c364bb20bd43efec0d@canb.auug.org.au>
Date: Wed, 12 Sep 2012 11:11:55 +0300
Message-ID: <CAGF5oy9yPedug0=N5W=47qaN6D1vOr9xje98jm3NBv6qDxof5w@mail.gmail.com>
Subject: Re: linux-next: manual merge of the staging tree with the thermal tree
From: "Valentin, Eduardo" <eduardo.valentin@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephen,


On Wed, Sep 12, 2012 at 8:52 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Greg,
>
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/omap-thermal/omap-thermal-common.c between commit
> 76f726fb24bd ("Thermal: Remove tc1/tc2 in generic thermal layer") from
> the thermal tree and commit 765a1939a364 ("staging: omap-thermal: fix
> polling period settings") from the staging tree.
>
> I fixed it up (I think - see below) and can carry the fix as necessary
> (no action is required).

Just to confirm that the fix is correct.

>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc drivers/staging/omap-thermal/omap-thermal-common.c
> index b4cd6cc,46ee0a9..0000000
> --- a/drivers/staging/omap-thermal/omap-thermal-common.c
> +++ b/drivers/staging/omap-thermal/omap-thermal-common.c
> @@@ -248,7 -268,9 +270,8 @@@ int omap_thermal_expose_sensor(struct o
>         /* Create thermal zone */
>         data->omap_thermal = thermal_zone_device_register(domain,
>                                 OMAP_TRIP_NUMBER, 0, data, &omap_thermal_ops,
> -                               0, FAST_TEMP_MONITORING_RATE);
>  -                              1, 2, /*TODO: remove this when FW allows */
> +                               FAST_TEMP_MONITORING_RATE,
> +                               FAST_TEMP_MONITORING_RATE);
>         if (IS_ERR_OR_NULL(data->omap_thermal)) {
>                 dev_err(bg_ptr->dev, "thermal zone device is NULL\n");
>                 return PTR_ERR(data->omap_thermal);



-- 

Eduardo Valentin
