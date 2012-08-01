Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab2HAB4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 21:56:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58647 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab2HAB43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 21:56:29 -0400
Date: Tue, 31 Jul 2012 22:56:22 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nishanth Menon <nm@ti.com>,
        Steve Sakoman <steve@sakoman.com>, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>
Subject: Re: [ 28/73] ARM: OMAP2+: OPP: Fix to ensure check of right oppdef
 after bad one
Message-ID: <20120801015621.GF3111@herton-Z68MA-D2H-B3>
References: <20120731044310.013763753@decadent.org.uk>
 <20120731044315.770748839@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731044315.770748839@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 05:43:38AM +0100, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Nishanth Menon <nm@ti.com>
> 
> commit b110547e586eb5825bc1d04aa9147bff83b57672 upstream.

This change is uneeded in 3.2, but doesn't do any harm either... it just
seems to fix the code because of the continue added in 9fa2df6b (ARM:
OMAP2+: OPP: allow OPP enumeration to continue if device is not present),
change which 3.2 doesn't have. A noop for 3.2 anyway, so either way it's
fine, applying or not, just commenting on it.

> 
> Commit 9fa2df6b90786301b175e264f5fa9846aba81a65
> (ARM: OMAP2+: OPP: allow OPP enumeration to continue if device is not present)
> makes the logic:
> for (i = 0; i < opp_def_size; i++) {
> 	<snip>
> 	if (!oh || !oh->od) {
> 		<snip>
> 		continue;
> 	}
> <snip>
> opp_def++;
> }
> 
> In short, the moment we hit a "Bad OPP", we end up looping the list
> comparing against the bad opp definition pointer for the rest of the
> iteration count. Instead, increment opp_def in the for loop itself
> and allow continue to be used in code without much thought so that
> we check the next set of OPP definition pointers :)
> 
> Cc: Steve Sakoman <steve@sakoman.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Kevin Hilman <khilman@ti.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  arch/arm/mach-omap2/opp.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/opp.c b/arch/arm/mach-omap2/opp.c
> index de6d464..d8f6dbf 100644
> --- a/arch/arm/mach-omap2/opp.c
> +++ b/arch/arm/mach-omap2/opp.c
> @@ -53,7 +53,7 @@ int __init omap_init_opp_table(struct omap_opp_def *opp_def,
>  	omap_table_init = 1;
>  
>  	/* Lets now register with OPP library */
> -	for (i = 0; i < opp_def_size; i++) {
> +	for (i = 0; i < opp_def_size; i++, opp_def++) {
>  		struct omap_hwmod *oh;
>  		struct device *dev;
>  
> @@ -86,7 +86,6 @@ int __init omap_init_opp_table(struct omap_opp_def *opp_def,
>  					__func__, opp_def->freq,
>  					opp_def->hwmod_name, i, r);
>  		}
> -		opp_def++;
>  	}
>  
>  	return 0;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
[]'s
Herton
