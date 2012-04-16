Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab2DPUd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:33:29 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36548 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab2DPUd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:33:28 -0400
Date: Mon, 16 Apr 2012 16:28:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Register native mce handler as vMCE bounce back point
Message-ID: <20120416202821.GC14982@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC8292335146A7A@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC8292335146A7A@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4F8C8211.001D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 01:07:35AM +0000, Liu, Jinsong wrote:
> >From 76e40a60878ff72986fd8d92611400195ae0f997 Mon Sep 17 00:00:00 2001
> From: Liu, Jinsong <jinsong.liu@intel.com>
> Date: Mon, 16 Apr 2012 00:16:58 +0800
> Subject: [PATCH 2/2] Register native mce handler as vMCE bounce back point
> 
> When xen hyeprvisor inject vMCE to guest, use native mce handler to handle it

hypervisor

> 
> Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
> Signed-off-by: Ke, Liping <liping.ke@intel.com>
> Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  arch/x86/xen/enlighten.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 15628d4..346ba64 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -614,8 +614,8 @@ static int cvt_gate_to_trap(int vector, const gate_desc *val,
>  	/*
>  	 * Look for known traps using IST, and substitute them
>  	 * appropriately.  The debugger ones are the only ones we care
> -	 * about.  Xen will handle faults like double_fault and
> -	 * machine_check, so we should never see them.  Warn if
> +	 * about.  Xen will handle faults like double_fault,
> +	 * so we should never see them.  Warn if
>  	 * there's an unexpected IST-using fault handler.
>  	 */
>  	if (addr == (unsigned long)debug)
> @@ -630,7 +630,11 @@ static int cvt_gate_to_trap(int vector, const gate_desc *val,
>  		return 0;
>  #ifdef CONFIG_X86_MCE
>  	} else if (addr == (unsigned long)machine_check) {
> -		return 0;
> +		/*
> +		 * when xen hyeprvisor inject vMCE to guest,
> +		 * use native mce handler to handle it
> +		 */
> +		;


Can you just take the check out?


>  #endif
>  	} else {
>  		/* Some other trap using IST? */
> -- 
> 1.7.1


