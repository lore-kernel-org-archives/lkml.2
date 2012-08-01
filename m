Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab2HAPCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:02:24 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25207 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab2HAPCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:02:23 -0400
Date: Wed, 1 Aug 2012 10:52:58 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, tim@xen.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        catalin.marinas@arm.com, arnd@arndb.de
Subject: Re: [PATCH 21/24] arm/v2m: initialize arch_timers even if v2m_timer
 is not present
Message-ID: <20120801145257.GQ7227@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
 <1343316846-25860-21-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343316846-25860-21-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 04:34:03PM +0100, Stefano Stabellini wrote:
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Should the maintainer of the v2m be CC-ed here?
This looks like a bug-fix of itself?

> ---
>  arch/arm/mach-vexpress/v2m.c |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
> index fde26ad..dee1451 100644
> --- a/arch/arm/mach-vexpress/v2m.c
> +++ b/arch/arm/mach-vexpress/v2m.c
> @@ -637,16 +637,17 @@ static void __init v2m_dt_timer_init(void)
>  	node = of_find_compatible_node(NULL, NULL, "arm,sp810");
>  	v2m_sysctl_init(of_iomap(node, 0));
>  
> -	err = of_property_read_string(of_aliases, "arm,v2m_timer", &path);
> -	if (WARN_ON(err))
> -		return;
> -	node = of_find_node_by_path(path);
> -	v2m_sp804_init(of_iomap(node, 0), irq_of_parse_and_map(node, 0));
>  	if (arch_timer_of_register() != 0)
>  		twd_local_timer_of_register();
>  
>  	if (arch_timer_sched_clock_init() != 0)
>  		versatile_sched_clock_init(v2m_sysreg_base + V2M_SYS_24MHZ, 24000000);
> +
> +	err = of_property_read_string(of_aliases, "arm,v2m_timer", &path);
> +	if (WARN_ON(err))
> +		return;
> +	node = of_find_node_by_path(path);
> +	v2m_sp804_init(of_iomap(node, 0), irq_of_parse_and_map(node, 0));
>  }
>  
>  static struct sys_timer v2m_dt_timer = {
> -- 
> 1.7.2.5
