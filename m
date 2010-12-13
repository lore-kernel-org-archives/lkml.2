Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292Ab0LMWYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 17:24:34 -0500
Received: from moo.zerodeux.net ([91.121.167.76]:43498 "EHLO moo.zerodeux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758219Ab0LMWYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 17:24:32 -0500
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Dec 2010 17:24:31 EST
Subject: Re: [PATCH] xen: disable ACPI NUMA for PV guests
From: Vincent Caron <vcaron@bearstech.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1291370043-3075-1-git-send-email-ian.campbell@citrix.com>
References: <1291369764.5514.15168.camel@zakaz.uk.xensource.com>
	 <1291370043-3075-1-git-send-email-ian.campbell@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Bearstech
Date: Mon, 13 Dec 2010 23:17:38 +0100
Message-ID: <1292278658.28988.161.camel@zerohal>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-03 at 09:54 +0000, Ian Campbell wrote:
> Xen does not currently expose PV-NUMA information to PV
> guests. Therefore disable NUMA for the time being to prevent the
> kernel picking up on an host-level NUMA information which it might
> come across in the firmware.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> ---
>  arch/x86/xen/enlighten.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index fbb35cd..7cdf2f3 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1195,6 +1195,10 @@ asmlinkage void __init xen_start_kernel(void)
>  
>  	xen_smp_init();
>  
> +#ifdef CONFIG_ACPI_NUMA
> +	acpi_numa = -1;
> +#endif
> +
>  	pgd = (pgd_t *)xen_start_info->pt_base;
>  
>  	__supported_pte_mask |= _PAGE_IOMAP;

  This made it thru 2.6.32-29 in Debian on 10 dec and works like a
charm, Dell R410 properly booting with hypervisor Xen 4.0.1.

  Thanks a lot for your help and responsiveness.


