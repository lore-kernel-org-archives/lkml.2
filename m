Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab2HUMM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:12:58 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:62373 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196Ab2HUMM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:12:56 -0400
MIME-Version: 1.0
In-Reply-To: <1345522015-13740-1-git-send-email-manoj.iyer@canonical.com>
References: <1345521975-13708-1-git-send-email-manoj.iyer@canonical.com>
	<1345522015-13740-1-git-send-email-manoj.iyer@canonical.com>
Date: Tue, 21 Aug 2012 20:12:55 +0800
Message-ID: <CAOvWMLaAJrmOKiq=ESXq3wCvFHxWAXMBaeLsK6MUaWBZG+i4Aw@mail.gmail.com>
Subject: Re: [PATCH 1/1] xhci: Unconditionally switch ports to xHCI on powerup
From: Andiry Xu <andiry@gmail.com>
To: manoj.iyer@canonical.com
Cc: linux-kernel@vger.kernel.org, sarah.a.sharp@linux.intel.com,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 12:06 PM,  <manoj.iyer@canonical.com> wrote:
> From: Manoj Iyer <manoj.iyer@canonical.com>
>
> USB 3.0 devices show up as high-speed devices on powerup, after an
> s3 cycle they are correctly recognized as SuperSpeed. At powerup
> unconditionally switch the port to xHCI like we do when we resume
> from suspend.
>
> BugLink: http://bugs.launchpad.net/bugs/1000424
>
> Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
> ---
>  drivers/usb/host/xhci-pci.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
> index 9bfd4ca11..5c8dbea 100644
> --- a/drivers/usb/host/xhci-pci.c
> +++ b/drivers/usb/host/xhci-pci.c
> @@ -48,6 +48,14 @@ static int xhci_pci_reinit(struct xhci_hcd *xhci, struct pci_dev *pdev)
>         if (!pci_set_mwi(pdev))
>                 xhci_dbg(xhci, "MWI active\n");
>
> +       /*
> +        * USB SuperSpeed ports are recognized as HighSpeed ports on powerup
> +        * unconditionally switch the ports to xHCI like we do when resume
> +        * from suspend.
> +        */
> +       if (usb_is_intel_switchable_xhci(pdev))
> +               usb_enable_xhci_ports(pdev);
> +

Strange. This should have been called during system power up, in
quirk_usb_handoff_xhci() of pci_quirks.c. Do you see that routine get
called during power up?

Thanks,
Andiry

>         xhci_dbg(xhci, "Finished xhci_pci_reinit\n");
>         return 0;
>  }
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
