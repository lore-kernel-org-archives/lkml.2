Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab0EQQ6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 12:58:23 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:36653 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab0EQQ6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 12:58:22 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCH 1/8] x86/mrst/pci: return 0 for non-present pci bars
Date: Mon, 17 May 2010 10:58:06 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <1273873281-17489-1-git-send-email-jacob.jun.pan@linux.intel.com> <1273873281-17489-2-git-send-email-jacob.jun.pan@linux.intel.com>
In-Reply-To: <1273873281-17489-2-git-send-email-jacob.jun.pan@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005171058.07020.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 14, 2010 03:41:14 pm Jacob Pan wrote:
> Moorestown PCI code has special handling of devices with fixed BARs. In
> case of BAR sizing writes, we need to update the fake PCI MMCFG space with real
> size decode value.
> 
> When a BAR is not present, we need to return 0 instead of ~0. ~0 will be
> treated as device error per bugzilla 12006.

It would be more convenient if you included the URL,
https://bugzilla.kernel.org/show_bug.cgi?id=12006,
rather than just the bugzilla number.

You probably noticed already, but we reverted the patch I
proposed in 12006 because it was too aggressive, so you may
not need this patch for that reason.

Per 6.2.5.1 in the PCI 3.0 spec, "unimplemented Base Address
registers are hardwired to zero," so it would make sense to me
to follow that, but your patch affects the *write* path, not
the read path, so I don't know how it's related to what
__pci_read_base() will see when it reads the BAR.

Bjorn

> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
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
> 
