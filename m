Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab2EaRjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 13:39:49 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:22587 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab2EaRjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 13:39:48 -0400
Date: Thu, 31 May 2012 13:32:43 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Register native mce handler as vMCE bounce back point
Message-ID: <20120531173243.GB31735@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923351FFB7C@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923351FFB7C@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 05:33:49PM +0000, Liu, Jinsong wrote:
> >From ca1f8a2347eb34acdc7c54b805c78a982a0a590d Mon Sep 17 00:00:00 2001
> From: Liu, Jinsong <jinsong.liu@intel.com>
> Date: Fri, 1 Jun 2012 08:41:00 +0800
> Subject: [PATCH 3/3] Register native mce handler as vMCE bounce back point

You need to have 'xen:' in front of 'register'
> 
> When xen hypervisor inject vMCE to guest, use native mce handler to handle it

And is that still OK?
> 
> Signed-off-by: Ke, Liping <liping.ke@intel.com>
> Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
> ---
>  arch/x86/xen/enlighten.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index ff2d00e..0cb12dd 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -618,8 +618,8 @@ static int cvt_gate_to_trap(int vector, const gate_desc *val,
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
> @@ -634,7 +634,11 @@ static int cvt_gate_to_trap(int vector, const gate_desc *val,
>  		return 0;
>  #ifdef CONFIG_X86_MCE
>  	} else if (addr == (unsigned long)machine_check) {
> -		return 0;
> +		/*
> +		 * when xen hyeprvisor inject vMCE to guest,

<sigh> Pls run a spell checker.

> +		 * use native mce handler to handle it
> +		 */
> +		;
>  #endif
>  	} else {
>  		/* Some other trap using IST? */
> -- 
> 1.7.1


