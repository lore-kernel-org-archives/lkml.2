Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab1LWMnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 07:43:39 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:60303 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab1LWMnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 07:43:37 -0500
Date: Fri, 23 Dec 2011 08:43:30 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Brown, Len" <len.brown@intel.com>,
        "jeremy.fitzhardinge@citrix.com" <jeremy.fitzhardinge@citrix.com>,
        "Jiang, Yunhong" <yunhong.jiang@intel.com>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Zhao, Yakui" <yakui.zhao@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 02/10] xen/mce: Change the machine check point
Message-ID: <20111223124330.GB25286@andromeda.dapyr.net>
References: <DE8DF0795D48FD4CA783C40EC829233596B7@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC829233596B7@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 10:24:29AM +0000, Liu, Jinsong wrote:
> >From 80221e743d1a693670d701f383da26c8e5d5bf98 Mon Sep 17 00:00:00 2001
> From: Liu Jinsong <jinsong.liu@intel.com>
> Date: Wed, 7 Dec 2011 05:26:16 +0800
> Subject: [PATCH 02/10] xen/mce: Change the machine check point
> 
> This patch backport from Jeremy's pvops commit
> 073349667402682c997394b3fcdbbeb6707f368f

Include the git tree address please.
> 
> Enable MCE support in dom0, so that if a MCE happen and that MCE impact

impacts
> dom0, dom0 can receive a vMCE.
> 
> Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
> Signed-off-by: Ke, Liping <liping.ke@intel.com>
> Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  arch/x86/xen/enlighten.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index b073e4c..13e7a16 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -526,7 +526,7 @@ static int cvt_gate_to_trap(int vector, const gate_desc *val,
>  	 * Look for known traps using IST, and substitute them
>  	 * appropriately.  The debugger ones are the only ones we care
>  	 * about.  Xen will handle faults like double_fault and
> -	 * machine_check, so we should never see them.  Warn if
> +	 * nmi, so we should never see them.  Warn if
>  	 * there's an unexpected IST-using fault handler.
>  	 */
>  	if (addr == (unsigned long)debug)
> @@ -541,7 +541,10 @@ static int cvt_gate_to_trap(int vector, const gate_desc *val,
>  		return 0;
>  #ifdef CONFIG_X86_MCE
>  	} else if (addr == (unsigned long)machine_check) {
> -		return 0;
> +		if (xen_initial_domain())

Why can't this be done on DomU?
> +			addr = (unsigned long)machine_check;
> +		else
> +			return 0;
>  #endif
>  	} else {
>  		/* Some other trap using IST? */
> -- 
> 1.6.5.6


> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel

