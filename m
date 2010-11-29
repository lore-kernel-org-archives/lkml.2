Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab0K2P3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:29:36 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36071 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab0K2P3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:29:34 -0500
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-janitors@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: plat-omap: counter_32k: use IS_ERR() instead of NULL check
Organization: Deep Root Systems, LLC
References: <1290791163-21190-1-git-send-email-segoon@openwall.com>
Date: Mon, 29 Nov 2010 16:29:22 +0100
In-Reply-To: <1290791163-21190-1-git-send-email-segoon@openwall.com> (Vasiliy
	Kulikov's message of "Fri, 26 Nov 2010 20:06:02 +0300")
Message-ID: <87tyj0ywq5.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vasiliy Kulikov <segoon@openwall.com> writes:

> clk_get() returns ERR_PTR() on error, not NULL.
>
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

Acked-by: Kevin Hilman <khilman@deeprootsystems.com>

> ---
>  Cannot compile this driver, so it is not tested at all.
>
>  arch/arm/plat-omap/counter_32k.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/plat-omap/counter_32k.c b/arch/arm/plat-omap/counter_32k.c
> index 155fe43..c1e0d00 100644
> --- a/arch/arm/plat-omap/counter_32k.c
> +++ b/arch/arm/plat-omap/counter_32k.c
> @@ -164,7 +164,7 @@ static int __init omap_init_clocksource_32k(void)
>  			return -ENODEV;
>  
>  		sync_32k_ick = clk_get(NULL, "omap_32ksync_ick");
> -		if (sync_32k_ick)
> +		if (!IS_ERR(sync_32k_ick))
>  			clk_enable(sync_32k_ick);
>  
>  		clocksource_32k.mult = clocksource_hz2mult(32768,
