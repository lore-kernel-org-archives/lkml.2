Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab2HYHMX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 03:12:23 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33427 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab2HYHMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 03:12:15 -0400
MIME-Version: 1.0
In-Reply-To: <1345654398-5932-1-git-send-email-manoj.iyer@canonical.com>
References: <1345654310-5895-1-git-send-email-manoj.iyer@canonical.com>
	<1345654398-5932-1-git-send-email-manoj.iyer@canonical.com>
Date: Sat, 25 Aug 2012 15:12:14 +0800
Message-ID: <CAOvWMLa9XPXh2f=d6XSXMLJC6Ljd=fEAFhm1HKr4pcg38+MRjg@mail.gmail.com>
Subject: Re: [PATCH 1/1] xhci: Recognize USB 3.0 devices as superspeed at powerup
From: Andiry Xu <andiry@gmail.com>
To: manoj.iyer@canonical.com
Cc: linux-kernel@vger.kernel.org, sarah.a.sharp@linux.intel.com,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 12:53 AM,  <manoj.iyer@canonical.com> wrote:
> From: Manoj Iyer <manoj.iyer@canonical.com>
>
> On Intel Panther Point chipset USB 3.0 devices show up as
> high-speed devices on powerup, but after an s3 cycle they are
> correctly recognized as SuperSpeed. At powerup switch the port
> to xHCI so that USB 3.0 devices are correctly recognized.
>
> BugLink: http://bugs.launchpad.net/bugs/1000424
>
> Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>

This one looks OK to me.

Thanks,
Andiry

> ---
>  drivers/usb/host/pci-quirks.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
> index c5e9e4a..486e812 100644
> --- a/drivers/usb/host/pci-quirks.c
> +++ b/drivers/usb/host/pci-quirks.c
> @@ -870,9 +870,10 @@ static void __devinit quirk_usb_handoff_xhci(struct pci_dev *pdev)
>         /* Disable any BIOS SMIs and clear all SMI events*/
>         writel(val, base + ext_cap_offset + XHCI_LEGACY_CONTROL_OFFSET);
>
> +hc_init:
>         if (usb_is_intel_switchable_xhci(pdev))
>                 usb_enable_xhci_ports(pdev);
> -hc_init:
> +
>         op_reg_base = base + XHCI_HC_LENGTH(readl(base));
>
>         /* Wait for the host controller to be ready before writing any
> --
> 1.7.9.5
>
