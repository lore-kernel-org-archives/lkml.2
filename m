Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077Ab2IGX26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 19:28:58 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55262 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756864Ab2IGX2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 19:28:55 -0400
MIME-Version: 1.0
In-Reply-To: <201209072328.30553.rjw@sisk.pl>
References: <201209072328.30553.rjw@sisk.pl>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 7 Sep 2012 16:28:33 -0700
Message-ID: <CAErSpo7-6PEEt+pDV-XRrfHVKDuw+_CbtKK-fEguyGhd_qapdw@mail.gmail.com>
Subject: Re: [Resend][PATCH] pciehp: always implement resume
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oliver@neukum.org>, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 2:28 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Oliver Neukum <oliver@neukum.org>
> Subject: pciehp: always implement resume
>
> The driver by default ignores resume. On some laptops
> that means that interrupts are not delivered after S3.
> So card removals and insertions will not be handled. Requiring
> a forced load isn't right.
>
> Signed-off-by: Oliver Neukum <oneukum@suse.de>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

I applied this (with fixed From: email address and slightly modified
changelog) to http://git.kernel.org/?p=linux/kernel/git/helgaas/pci.git;a=shortlog;h=refs/heads/pci/oliver-pciehp-resume
and will merge it to "next" after Fengguang's build/smoke tests.

Thanks!

Bjorn

> ---
> drivers/pci/hotplug/pciehp_core.c |   28 ++++++++++++++--------------
>  drivers/pci/hotplug/pciehp_core.c |   28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
>
> Index: linux/drivers/pci/hotplug/pciehp_core.c
> ===================================================================
> --- linux.orig/drivers/pci/hotplug/pciehp_core.c
> +++ linux/drivers/pci/hotplug/pciehp_core.c
> @@ -300,24 +300,24 @@ static int pciehp_suspend (struct pcie_d
>
>  static int pciehp_resume (struct pcie_device *dev)
>  {
> +       struct controller *ctrl;
> +       struct slot *slot;
> +       u8 status;
> +
>         dev_info(&dev->device, "%s ENTRY\n", __func__);
> -       if (pciehp_force) {
> -               struct controller *ctrl = get_service_data(dev);
> -               struct slot *slot;
> -               u8 status;
> +       ctrl = get_service_data(dev);
>
> -               /* reinitialize the chipset's event detection logic */
> -               pcie_enable_notification(ctrl);
> +       /* reinitialize the chipset's event detection logic */
> +       pcie_enable_notification(ctrl);
>
> -               slot = ctrl->slot;
> +       slot = ctrl->slot;
>
> -               /* Check if slot is occupied */
> -               pciehp_get_adapter_status(slot, &status);
> -               if (status)
> -                       pciehp_enable_slot(slot);
> -               else
> -                       pciehp_disable_slot(slot);
> -       }
> +       /* Check if slot is occupied */
> +       pciehp_get_adapter_status(slot, &status);
> +       if (status)
> +               pciehp_enable_slot(slot);
> +       else
> +               pciehp_disable_slot(slot);
>         return 0;
>  }
>  #endif /* PM */
