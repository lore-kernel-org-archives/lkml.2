Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab1BPUID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 15:08:03 -0500
Received: from pqueuea.post.tele.dk ([193.162.153.9]:55105 "EHLO
	pqueuea.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab1BPUIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 15:08:00 -0500
Date: Wed, 16 Feb 2011 21:07:34 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] ARM: reenable DEBUG_SECTION_MISMATCH
Message-ID: <20110216200734.GA25184@merkur.ravnborg.org>
References: <1297876993-4146-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1297876993-4146-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 06:23:13PM +0100, Uwe Kleine-König wrote:
> For 2.6.38-rc4-git9 only 29 out of 133 defconfigs still produce section
> mismatches.  These defconfigs produce 55 mismatches (weighted sum, so
> maybe less uniq mismatches).
> 
> This is in my opinion enough to start scaring people about the remaining
> problems.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  lib/Kconfig.debug |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 3967c23..1130dd4 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -102,7 +102,7 @@ config HEADERS_CHECK
>  
>  config DEBUG_SECTION_MISMATCH
>  	bool "Enable full Section mismatch analysis"
> -	depends on UNDEFINED || (BLACKFIN)
> +	depends on ARM || BLACKFIN
>  	default y
>  	# This option is on purpose disabled for now.
>  	# It will be enabled when we are down to a reasonable number

If we are deciding to make this ARCH dependent then a blacklist is
much preferred.

I know that we have warnings lingering in the kernel for a long time.
But throwing these waring in the face of people for each build will
be eoung incentive to get most fixed.

Last I took a deeper look at this I had allyesconfig + allmodconfig
almost warning free on x86. But I recall that especially the HOTPLUG_CPU
stuff was tricky as they misuse the annotation.

We could try to enable it per default - and seem if people scream too much.

	Sam
