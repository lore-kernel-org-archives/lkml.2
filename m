Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab0EPWhM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 18:37:12 -0400
Received: from www.tglx.de ([62.245.132.106]:39610 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593Ab0EPWhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 18:37:11 -0400
Date: Mon, 17 May 2010 00:35:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 1/8] x86/mrst/pci: return 0 for non-present pci bars
In-Reply-To: <1273873281-17489-2-git-send-email-jacob.jun.pan@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1005170034400.3368@localhost.localdomain>
References: <1273873281-17489-1-git-send-email-jacob.jun.pan@linux.intel.com> <1273873281-17489-2-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010, Jacob Pan wrote:

> Moorestown PCI code has special handling of devices with fixed BARs. In
> case of BAR sizing writes, we need to update the fake PCI MMCFG space with real
> size decode value.
> 
> When a BAR is not present, we need to return 0 instead of ~0. ~0 will be
> treated as device error per bugzilla 12006.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

> ---
>  arch/x86/pci/mrst.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
> index 8bf2fcb..d5c7aef 100644
> --- a/arch/x86/pci/mrst.c
> +++ b/arch/x86/pci/mrst.c
> @@ -109,7 +109,7 @@ static int pci_device_update_fixed(struct pci_bus *bus, unsigned int devfn,
>  			decode++;
>  			decode = ~(decode - 1);
>  		} else {
> -			decode = ~0;
> +			decode = 0;
>  		}
>  
>  		/*
> -- 
> 1.6.3.3
> 
