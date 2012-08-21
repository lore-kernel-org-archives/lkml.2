Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab2HULWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:22:10 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37945 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756661Ab2HULWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:22:07 -0400
Message-ID: <50336F25.80706@mvista.com>
Date: Tue, 21 Aug 2012 15:21:09 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: manoj.iyer@canonical.com
CC: linux-kernel@vger.kernel.org, sarah.a.sharp@linux.intel.com,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/1] xhci: Unconditionally switch ports to xHCI on powerup
References: <1345521975-13708-1-git-send-email-manoj.iyer@canonical.com> <1345522015-13740-1-git-send-email-manoj.iyer@canonical.com>
In-Reply-To: <1345522015-13740-1-git-send-email-manoj.iyer@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 21-08-2012 8:06, manoj.iyer@canonical.com wrote:

> From: Manoj Iyer <manoj.iyer@canonical.com>

> USB 3.0 devices show up as high-speed devices on powerup, after an
> s3 cycle they are correctly recognized as SuperSpeed. At powerup
> unconditionally switch the port to xHCI like we do when we resume
> from suspend.

> BugLink: http://bugs.launchpad.net/bugs/1000424

> Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
> ---
>   drivers/usb/host/xhci-pci.c |    8 ++++++++
>   1 file changed, 8 insertions(+)

> diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
> index 9bfd4ca11..5c8dbea 100644
> --- a/drivers/usb/host/xhci-pci.c
> +++ b/drivers/usb/host/xhci-pci.c
> @@ -48,6 +48,14 @@ static int xhci_pci_reinit(struct xhci_hcd *xhci, struct pci_dev *pdev)
>   	if (!pci_set_mwi(pdev))
>   		xhci_dbg(xhci, "MWI active\n");
>
> +	/*
> +	 * USB SuperSpeed ports are recognized as HighSpeed ports on powerup

    Devices, not ports?

> +	 * unconditionally switch the ports to xHCI like we do when resume

    s/resume/resuming/

> +	 * from suspend.
> +	 */
> +	if (usb_is_intel_switchable_xhci(pdev))
> +		usb_enable_xhci_ports(pdev);
> +

WBR, Sergei

