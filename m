Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254Ab0EKO2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:28:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54581 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab0EKO2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:28:42 -0400
Message-ID: <4BE9697F.80308@ti.com>
Date: Tue, 11 May 2010 09:28:15 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@nokia.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Linux-OMAP <linux-omap@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       ext Tony Lindgren <tony@atomide.com>,
       ext Kevin Hilman <khilman@deeprootsystems.com>,
       Peter De-Schrijver <Peter.De-Schrijver@nokia.com>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       "K, Ambresh" <ambresh@ti.com>,
       "felipe.balbi@nokia.com" <felipe.balbi@nokia.com>,
       Jouni Hogander <jouni.hogander@nokia.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCHv5 2/3] OMAP: export OMAP info under /proc/socinfo
References: <1273587331-24604-1-git-send-email-eduardo.valentin@nokia.com> <1273587331-24604-3-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1273587331-24604-3-git-send-email-eduardo.valentin@nokia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduardo Valentin had written, on 05/11/2010 09:15 AM, the following:
> From: Eduardo Valentin <eduardo.valentin@nokia.com>
> 
> Export OMAP name and rev under /proc/socinfo node.
> 
> Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
> ---
>  arch/arm/Kconfig         |    1 +
>  arch/arm/mach-omap1/id.c |   31 ++++++++++++++++++++++++-------
>  arch/arm/mach-omap2/id.c |   32 ++++++++++++++++++++++++++------
>  3 files changed, 51 insertions(+), 13 deletions(-)
> 
[..]

> diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
> index 37b8a1a..b67486b 100644
> --- a/arch/arm/mach-omap2/id.c
> +++ b/arch/arm/mach-omap2/id.c
[..]

> @@ -356,7 +363,8 @@ void __init omap3_cpuinfo(void)
>  	}
>  
>  	/* Print verbose information */
> -	pr_info("%s ES%s (", cpu_name, cpu_rev);
> +	snprintf(socinfo, SOCINFO_SZ, "%s ES%s", cpu_name, cpu_rev);
> +	pr_info("%s (", socinfo);
>  
>  	OMAP3_SHOW_FEATURE(l2cache);
>  	OMAP3_SHOW_FEATURE(iva);
Just a minor comment -> is it a good idea to pushin the features to SOC 
info as well? currently this is being displayed at bootlog and not 
beyond.. might be a better approach to move it into socinfo..


[..]

-- 
Regards,
Nishanth Menon
