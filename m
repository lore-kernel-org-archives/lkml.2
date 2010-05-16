Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab0EPWpN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 18:45:13 -0400
Received: from www.tglx.de ([62.245.132.106]:34471 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755Ab0EPWpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 18:45:09 -0400
Date: Mon, 17 May 2010 00:44:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 7/8] x86/mrst: add nop functions to x86_init mpparse
 functions
In-Reply-To: <1273873281-17489-8-git-send-email-jacob.jun.pan@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1005170044430.3368@localhost.localdomain>
References: <1273873281-17489-1-git-send-email-jacob.jun.pan@linux.intel.com> <1273873281-17489-8-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010, Jacob Pan wrote:

> Moorestown does not have BIOS provided MP tables, we can save some time
> by avoiding scaning of these tables. e.g.
> [    0.000000] Scan SMP from c0000000 for 1024 bytes.
> [    0.000000] Scan SMP from c009fc00 for 1024 bytes.
> [    0.000000] Scan SMP from c00f0000 for 65536 bytes.
> [    0.000000] Scan SMP from c00bfff0 for 1024 bytes.
> 
> Searching EBDA with the base at 0x40E will also result in random pointer
> deferencing within 1MB. This can be a problem in Lincroft if the pointer
> hits VGA area and VGA mode is not enabled.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

> ---
>  arch/x86/kernel/mrst.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
> index 83c23d6..9b62d32 100644
> --- a/arch/x86/kernel/mrst.c
> +++ b/arch/x86/kernel/mrst.c
> @@ -311,4 +311,9 @@ void __init x86_mrst_early_setup(void)
>  	x86_init.pci.fixup_irqs = x86_init_noop;
>  
>  	legacy_pic = &null_legacy_pic;
> +
> +	/* Avoid searching for BIOS MP tables */
> +	x86_init.mpparse.find_smp_config = x86_init_noop;
> +	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
> +
>  }
> -- 
> 1.6.3.3
> 
