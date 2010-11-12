Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547Ab0KLQHN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 11:07:13 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51085 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438Ab0KLQHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:07:11 -0500
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] davinci: simplify if-statement
Organization: Deep Root Systems, LLC
References: <20101025144118.62ec420c@absol.kitzblitz>
Date: Fri, 12 Nov 2010 08:07:07 -0800
In-Reply-To: <20101025144118.62ec420c@absol.kitzblitz> (Nicolas Kaiser's
	message of "Mon, 25 Oct 2010 14:41:18 +0200")
Message-ID: <8739r6sez8.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Kaiser <nikai@nikai.net> writes:

> A common do-while loop can be factored out from the end of
> the branches.
>
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>

Applied, queueing for 2.6.38.

Kevin

> ---
>  arch/arm/mach-davinci/psc.c |   13 ++++---------
>  1 files changed, 4 insertions(+), 9 deletions(-)
>
> diff --git a/arch/arm/mach-davinci/psc.c b/arch/arm/mach-davinci/psc.c
> index 1b15dbd..a415804 100644
> --- a/arch/arm/mach-davinci/psc.c
> +++ b/arch/arm/mach-davinci/psc.c
> @@ -83,21 +83,16 @@ void davinci_psc_config(unsigned int domain, unsigned int ctlr,
>  		pdctl1 = __raw_readl(psc_base + PDCTL1);
>  		pdctl1 |= 0x100;
>  		__raw_writel(pdctl1, psc_base + PDCTL1);
> -
> -		do {
> -			ptstat = __raw_readl(psc_base +
> -					       PTSTAT);
> -		} while (!(((ptstat >> domain) & 1) == 0));
>  	} else {
>  		ptcmd = 1 << domain;
>  		__raw_writel(ptcmd, psc_base + PTCMD);
> -
> -		do {
> -			ptstat = __raw_readl(psc_base + PTSTAT);
> -		} while (!(((ptstat >> domain) & 1) == 0));
>  	}
>  
>  	do {
> +		ptstat = __raw_readl(psc_base + PTSTAT);
> +	} while (!(((ptstat >> domain) & 1) == 0));
> +
> +	do {
>  		mdstat = __raw_readl(psc_base + MDSTAT + 4 * id);
>  	} while (!((mdstat & MDSTAT_STATE_MASK) == next_state));
