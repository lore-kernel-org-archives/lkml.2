Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab2FSFMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 01:12:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58856 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab2FSFMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 01:12:23 -0400
Date: Mon, 18 Jun 2012 22:10:32 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Len Brown <lenb@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Durgadoss R <durgadoss.r@intel.com>,
        Jenny TC <jenny.tc@intel.com>
Subject: Re: linux-next: build failure after merge of the final tree (acpi
 and battery trees related)
Message-ID: <20120619051032.GB16286@lizard>
References: <20120619145425.6f825e142856ca808927ca45@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120619145425.6f825e142856ca808927ca45@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 02:54:25PM +1000, Stephen Rothwell wrote:
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig, i386 defconfig) failed like this:
> 
> drivers/power/power_supply_core.c:204:6: error: too few arguments to function 'thermal_zone_device_register'
> 
> Caused by commit a9e7402dd2e4 ("ACPI-Thermal: Make Thermal trip points
> writeable") from the acpi tree interacting with commit 3be330bf8860
> ("power_supply: Register battery as a thermal zone") from the battery
> tree.
> 
> I have added the following patch and will carry it as a merge fix to the
> battery tree:

Thanks for noticing, Stephen! Although, I wonder what would be the
best way to fix this?.. I would happily cherry-pick the ACPI change
into my tree and then re-apply the battery thermal zone support patch,
but ACPI change doesn't apply cleanly on the battery tree. Heh.

Is there thermal zone git tree? Or maybe I would just let ACPI
folks take the battery patch in question?

Thanks,

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 19 Jun 2012 14:46:17 +1000
> Subject: [PATCH] ACPI-Thermal: fix for an API change
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/power/power_supply_core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
> index ff990d2..85689fb 100644
> --- a/drivers/power/power_supply_core.c
> +++ b/drivers/power/power_supply_core.c
> @@ -201,7 +201,7 @@ static int psy_register_thermal(struct power_supply *psy)
>  	for (i = 0; i < psy->num_properties; i++) {
>  		if (psy->properties[i] == POWER_SUPPLY_PROP_TEMP) {
>  			psy->tzd = thermal_zone_device_register(psy->name, 0,
> -					psy, &psy_tzd_ops, 0, 0, 0, 0);
> +					0, psy, &psy_tzd_ops, 0, 0, 0, 0);
>  			if (IS_ERR(psy->tzd))
>  				return PTR_ERR(psy->tzd);
>  			break;
> -- 
> 1.7.10.280.gaa39
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
