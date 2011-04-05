Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab1DEP2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:28:43 -0400
Received: from mx1.melware.net ([78.47.171.162]:32794 "EHLO mx1.melware.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab1DEP2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:28:41 -0400
X-Greylist: delayed 1086 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Apr 2011 11:28:41 EDT
Date: Tue, 5 Apr 2011 17:10:34 +0200 (CEST)
From: Armin Schindler <armin@melware.de>
To: Michal Marek <mmarek@suse.cz>
cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 12/34] isdn/diva: Drop __TIME__ usage
In-Reply-To: <1302015561-21047-13-git-send-email-mmarek@suse.cz>
Message-ID: <alpine.DEB.2.00.1104051709040.7262@justus.melware.de>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz> <1302015561-21047-13-git-send-email-mmarek@suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Organization: Cytronics & Melware
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Apr 2011, Michal Marek wrote:
> The kernel already prints its build timestamp during boot, no need to
> repeat it in random drivers and produce different object files each
> time.

The module can be build separately from the kernel, therefore it can have
an own build timestamp.

Armin

> Cc: Armin Schindler <mac@melware.de>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
> drivers/isdn/hardware/eicon/divasfunc.c |    5 ++---
> 1 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/isdn/hardware/eicon/divasfunc.c b/drivers/isdn/hardware/eicon/divasfunc.c
> index d36a4c0..0bbee78 100644
> --- a/drivers/isdn/hardware/eicon/divasfunc.c
> +++ b/drivers/isdn/hardware/eicon/divasfunc.c
> @@ -113,9 +113,8 @@ void diva_xdi_didd_remove_adapter(int card)
> static void start_dbg(void)
> {
> 	DbgRegister("DIVAS", DRIVERRELEASE_DIVAS, (debugmask) ? debugmask : DBG_DEFAULT);
> -	DBG_LOG(("DIVA ISDNXDI BUILD (%s[%s]-%s-%s)",
> -		 DIVA_BUILD, diva_xdi_common_code_build, __DATE__,
> -		 __TIME__))
> +	DBG_LOG(("DIVA ISDNXDI BUILD (%s[%s])",
> +		 DIVA_BUILD, diva_xdi_common_code_build))
> }
>
> /*
> -- 
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
