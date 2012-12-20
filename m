Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab2LTXEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 18:04:12 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:50537 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab2LTXEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 18:04:02 -0500
Date: Thu, 20 Dec 2012 23:04:01 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Sasha Levin <sasha.levin@oracle.com>
cc: Venkatraman S <svenkatr@ti.com>, t-kristo@ti.com,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: omap_hsmmc: correct precedence of operators
In-Reply-To: <1356030701-16284-18-git-send-email-sasha.levin@oracle.com>
Message-ID: <alpine.DEB.2.00.1212202302470.20441@utopia.booyaka.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com> <1356030701-16284-18-git-send-email-sasha.levin@oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc Tero)

Hi,

On Thu, 20 Dec 2012, Sasha Levin wrote:

> With the current code, the condition in the if() doesn't make much sense due to
> precedence of operators.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  drivers/mmc/host/omap_hsmmc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index bc58078..3ee2664 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -611,7 +611,7 @@ static int omap_hsmmc_context_restore(struct omap_hsmmc_host *host)
>  	if (host->context_loss == context_loss)
>  		return 1;
>  
> -	if (!OMAP_HSMMC_READ(host->base, SYSSTATUS) & RESETDONE)
> +	if (!(OMAP_HSMMC_READ(host->base, SYSSTATUS) & RESETDONE))
>  		return 1;
>  
>  	if (host->pdata->controller_flags & OMAP_HSMMC_SUPPORTS_DUAL_VOLT) {

Makes sense to me, but I wonder if this code is even necessary after:

commit 613ad0e98c3596cd2524172fae2a795c3fc57e4a
Author: Tero Kristo <t-kristo@ti.com>
Date:   Mon Oct 29 22:02:13 2012 -0600

    ARM: OMAP: hwmod: wait for sysreset complete after enabling hwmod
    

?  You might just be able to drop those lines completely now.



- Paul
