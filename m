Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab2GYVRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 17:17:09 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:65455 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751774Ab2GYVRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 17:17:05 -0400
MIME-Version: 1.0
In-Reply-To: <201207251946.q6PJklUm016228@farm-0002.internal.tilera.com>
References: <201207251946.q6PJklUm016228@farm-0002.internal.tilera.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 25 Jul 2012 15:16:43 -0600
Message-ID: <CAErSpo7P4jCw=gTDR3JabY1F46xWiTF6ru90T86NzuT7Pxu1_A@mail.gmail.com>
Subject: Re: [PATCH] tilegx pci: fix semantic merge conflict with 3527ed81c
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 1:40 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> Yinghai Lu removed pci_bus.subordinate in pci-next, which meant that
> the tile-next changes to add tilegx PCI support don't build.  This
> was expected (seen in linux-next) and this one-line fix is along
> the same lines as commit b918c62e for all other architectures.
>
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

You pushed the other tile changes, so I assume you'll do the same with
this one.  But let me know if you want me to push it to Linus.

> ---
>  arch/tile/kernel/pci_gx.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/tile/kernel/pci_gx.c b/arch/tile/kernel/pci_gx.c
> index fa75264..0e213e3 100644
> --- a/arch/tile/kernel/pci_gx.c
> +++ b/arch/tile/kernel/pci_gx.c
> @@ -853,7 +853,7 @@ int __init pcibios_init(void)
>                 bus = pci_scan_root_bus(NULL, next_busno, controller->ops,
>                                         controller, &resources);
>                 controller->root_bus = bus;
> -               next_busno = bus->subordinate + 1;
> +               next_busno = bus->busn_res.end + 1;
>
>         }
>
> --
> 1.7.10.3
>
