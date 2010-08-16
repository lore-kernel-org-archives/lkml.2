Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab0HPUeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 16:34:00 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53721 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab0HPUd6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 16:33:58 -0400
MIME-Version: 1.0
In-Reply-To: <1281947514-25319-2-git-send-email-monstr@monstr.eu>
References: <1281947514-25319-1-git-send-email-monstr@monstr.eu> <1281947514-25319-2-git-send-email-monstr@monstr.eu>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 16 Aug 2010 14:33:38 -0600
X-Google-Sender-Auth: 66GNn_pLcneR-d5yUmo3mXtJNgw
Message-ID: <AANLkTi=ftyRxcxzerRjNPQyqeGjxW++BYk1UK7ajtjJo@mail.gmail.com>
Subject: Re: [PATCH] microblaze: Fix of/address: Merge all of the bus
 translation code
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

Looks good, I'll pick it up.  Same of the of_node patch.

On Mon, Aug 16, 2010 at 2:31 AM, Michal Simek <monstr@monstr.eu> wrote:
> Commit dbbdee94734bf6f1db7af42008a53655e77cab8f removed
> of_irq_pci_swizzle but didn't use pci_swizzle_interrupt_pin
> instead.

Note: when writing commit messages, be friendly to readers who don't
immediately have access to a git tree.  It is good to quote the sha1
id, but you should also quote the patch title like so:

Commit "of/address: Merge all of the bus translation code" (sha1 id:
dbbdee94734bf6f1db7af42008a53655e77cab8f) removed of_irq_pci_swizzle
but didn't use pci_swizzle_interrupt_pin instead.

No need to respin this patch, I'll fix it up.  just a comment for next time.

Cheers,
g.

> ---
>  arch/microblaze/kernel/prom_parse.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/microblaze/kernel/prom_parse.c b/arch/microblaze/kernel/prom_parse.c
> index d33ba17..99d9b61 100644
> --- a/arch/microblaze/kernel/prom_parse.c
> +++ b/arch/microblaze/kernel/prom_parse.c
> @@ -73,7 +73,7 @@ int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq)
>                /* We can only get here if we hit a P2P bridge with no node,
>                 * let's do standard swizzling and try again
>                 */
> -               lspec = of_irq_pci_swizzle(PCI_SLOT(pdev->devfn), lspec);
> +               lspec = pci_swizzle_interrupt_pin(pdev, lspec);
>                pdev = ppdev;
>        }
>
> --
> 1.5.5.6
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
