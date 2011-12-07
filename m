Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab1LGPJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 10:09:08 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56602 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab1LGPJG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 10:09:06 -0500
MIME-Version: 1.0
In-Reply-To: <20111207170533.3dea865573c916e79d274eca@canb.auug.org.au>
References: <20111207170533.3dea865573c916e79d274eca@canb.auug.org.au>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 7 Dec 2011 08:08:43 -0700
Message-ID: <CAErSpo59CuEBbu4QWMkK23TyXafhMLOh1G7Z8YxojqiQmCM0Fw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (pci tree related)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 11:05 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the final tree, today's linux-next build (sparc64 defconfig)
> failed like this:
>
> arch/sparc/kernel/pci.c: In function 'pci_scan_one_pbm':
> arch/sparc/kernel/pci.c:697:7: error: incompatible type for argument 5 of 'pci_create_root_bus'
> include/linux/pci.h:665:17: note: expected 'struct list_head *' but argument is of type 'struct list_head'
>
> Caused by commit fa3cec8aff53 ("sparc/PCI: convert to pci_create_root_bus
> ()"). Same typo as for the powerpc tree. :-(  Please double check the
> rest of those changes, please.
>
> I applied the following patch for today.

Thanks for doing that, sorry for the trouble.  I don't have a set of
cross-compilers, unfortunately, but I will inspect the rest manually.
Do we have to discover problems one-by-one, or can you tell us about
any other arch build problems at the same time?

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 7 Dec 2011 17:02:12 +1100
> Subject: [PATCH] sparc/PCI: fix up typo from pci_create_root_bus conversion
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/sparc/kernel/pci.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
> index 0905dbd..bb8bc2e 100644
> --- a/arch/sparc/kernel/pci.c
> +++ b/arch/sparc/kernel/pci.c
> @@ -694,7 +694,7 @@ struct pci_bus * __devinit pci_scan_one_pbm(struct pci_pbm_info *pbm,
>        pci_add_resource(&resources, &pbm->io_space);
>        pci_add_resource(&resources, &pbm->mem_space);
>        bus = pci_create_root_bus(parent, pbm->pci_first_busno, pbm->pci_ops,
> -                                 pbm, resources);
> +                                 pbm, &resources);
>        if (!bus) {
>                printk(KERN_ERR "Failed to create bus for %s\n",
>                       node->full_name);
> --
> 1.7.7.3
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
