Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab2KTAsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 19:48:30 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34951 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab2KTAs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 19:48:29 -0500
Date: Mon, 19 Nov 2012 18:50:36 -0600
From: Josh Cartwright <josh.cartwright@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH V2 2/2] ARM: tegra: move timer.c to drivers/clocksource/
Message-ID: <20121120005036.GA6280@kryptos>
References: <1353371237-2482-1-git-send-email-swarren@wwwdotorg.org>
 <1353371237-2482-2-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353371237-2482-2-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 05:27:17PM -0700, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Move arch/arm/mach-tegra/timer.c to drivers/clocksource/tegra20_timer.c
> so that the code is co-located with other clocksource drivers, and to
> reduce the size of the mach-tegra directory.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> v2: Rebase on ARM sys_timer rework, and addition of clocksource_of_init().
[..]
> diff --git a/drivers/clocksource/clksrc-of.c b/drivers/clocksource/clksrc-of.c
> index aeec8d2..328d18f 100644
> --- a/drivers/clocksource/clksrc-of.c
> +++ b/drivers/clocksource/clksrc-of.c
> @@ -20,6 +20,10 @@
>  #include "clksrc-of.h"
>  
>  static const struct of_device_id clksrc_of_match[] __initconst = {
> +	{
> +		.compatible = "nvidia,tegra20-timer",
> +		.data = tegra20_init_timer,
> +	},

Shouldn't this be wrapped in #if ARCH_TEGRA?

I had suggested this with Thomas Petazzoni's consolidated irq_chip patch
as well:

It seems like it would be a bit cleaner/easier to maintain if we relied
on the linker to stitch together a clksrc_of_match table, based on what
clocksources are being built into the image.  With that approach, at
least, a public initialization header wouldn't have to be exposed, and
this central table wouldn't have to be maintained (as more clocksrcs are
added, I forsee [admittedly trivial] merge conflicts).

Thoughts?

   Josh
