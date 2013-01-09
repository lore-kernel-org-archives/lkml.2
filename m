Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab3AIWM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 17:12:59 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60457 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab3AIWM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 17:12:57 -0500
Message-ID: <50EDEB64.4060800@ti.com>
Date: Wed, 9 Jan 2013 16:12:52 -0600
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: unlisted-recipients:"; Tony Lindgren" <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Benoit Cousson <b-cousson@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	unlisted-recipients:;Tony Lindgren <tony@atomide.com>
					     ^-missing end of address
Subject: Re: [PATCH] omap: DT node Timer iteration fix
References: <1357651902-21966-1-git-send-email-panto@antoniou-consulting.com>
In-Reply-To: <1357651902-21966-1-git-send-email-panto@antoniou-consulting.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.157.144.139]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pantelis,

On 01/08/2013 07:31 AM, Pantelis Antoniou wrote:
> The iterator correctly handles of_node_put() calls.
> Remove it before continue'ing the loop.
> Without this patch you get:

Thanks for the fix!

May be worth mentioning that this will only be seen with
"CONFIG_OF_DYNAMIC" (and explains why I did not catch this one!).

> ERROR: Bad of_node_put() on /ocp/timer@44e31000!
> [<c001329c>] (unwind_backtrace+0x0/0xe0) from [<c03dd8f0>] (of_node_release+0x2c/0xa0)!
> [<c03dd8f0>] (of_node_release+0x2c/0xa0) from [<c03ddea0>] (of_find_matching_node_and_match+0x78/0x90)!
> [<c03ddea0>] (of_find_matching_node_and_match+0x78/0x90) from [<c06d349c>] (omap_get_timer_dt+0x78/0x90)!
> [<c06d349c>] (omap_get_timer_dt+0x78/0x90) from [<c06d3664>] (omap_dm_timer_init_one.clone.2+0x34/0x2bc)!
> [<c06d3664>] (omap_dm_timer_init_one.clone.2+0x34/0x2bc) from [<c06d3a2c>] (omap2_gptimer_clocksource_init.clone.4+0x24/0xa8)!
> [<c06d3a2c>] (omap2_gptimer_clocksource_init.clone.4+0x24/0xa8) from [<c06cca58>] (time_init+0x20/0x30)!
> [<c06cca58>] (time_init+0x20/0x30) from [<c06c9690>] (start_kernel+0x1a8/0x2fc)!
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> ---
>  arch/arm/mach-omap2/timer.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
> index 691aa67..b8ad6e6 100644
> --- a/arch/arm/mach-omap2/timer.c
> +++ b/arch/arm/mach-omap2/timer.c
> @@ -165,15 +165,11 @@ static struct device_node * __init omap_get_timer_dt(struct of_device_id *match,
>  	struct device_node *np;
>  
>  	for_each_matching_node(np, match) {
> -		if (!of_device_is_available(np)) {
> -			of_node_put(np);
> +		if (!of_device_is_available(np))
>  			continue;
> -		}
>  
> -		if (property && !of_get_property(np, property, NULL)) {
> -			of_node_put(np);
> +		if (property && !of_get_property(np, property, NULL))
>  			continue;
> -		}
>  
>  		of_add_property(np, &device_disabled);
>  		return np;

Otherwise ...

Acked-by: Jon Hunter <jon-hunter@ti.com>

Cheers
Jon

