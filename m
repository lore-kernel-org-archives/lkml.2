Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab2HOTSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:18:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65069 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab2HOTSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:18:05 -0400
MIME-Version: 1.0
In-Reply-To: <201208042327.33132.rjw@sisk.pl>
References: <201208042327.33132.rjw@sisk.pl>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 15 Aug 2012 13:17:43 -0600
Message-ID: <CAErSpo4EHK5SEiAquguFV9sZa2-+q2jrF64JeBZqKBjaULNsRQ@mail.gmail.com>
Subject: Re: [Resend][PATCH] PCI / PM: Fix messages printed by acpi_pci_set_power_state()
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-pci@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 4, 2012 at 3:27 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> If a PCI device is put into D3_cold by acpi_bus_set_power(),
> the message printed by acpi_pci_set_power_state() says that its
> power state has been changed to D4, which doesn't make sense.
> In turn, if the device is put into D3_hot, the message simply
> says "D3" without specifying the variant of the D3 state.
>
> Fix this by using the pci_power_name() macro for printing the state
> name instead of building it from the numeric value corresponding to
> the given state directly.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Applied to my for-linus branch, since this fixes a minor issue
introduced with the runtime D3cold support we merged for 3.6.  Thanks!

> ---
>  drivers/pci/pci-acpi.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> Index: linux/drivers/pci/pci-acpi.c
> ===================================================================
> --- linux.orig/drivers/pci/pci-acpi.c
> +++ linux/drivers/pci/pci-acpi.c
> @@ -266,8 +266,8 @@ static int acpi_pci_set_power_state(stru
>         }
>
>         if (!error)
> -               dev_printk(KERN_INFO, &dev->dev,
> -                               "power state changed by ACPI to D%d\n", state);
> +               dev_info(&dev->dev, "power state changed by ACPI to %s\n",
> +                        pci_power_name(state));
>
>         return error;
>  }
