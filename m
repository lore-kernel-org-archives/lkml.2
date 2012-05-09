Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760527Ab2EIRW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:22:58 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:51118 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760483Ab2EIRW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:22:56 -0400
Message-ID: <4FAAA7CC.7050208@mvista.com>
Date: Wed, 09 May 2012 21:22:20 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        plagnioj@jcrosoft.com, gregkh@linuxfoundation.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: ohci-at91: add a reset function to fix race condition
References: <1336553334-31058-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1336553334-31058-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09-05-2012 12:48, Nicolas Ferre wrote:

> A possible race condition appears because we are not initializing
> the ohci->regs before calling usb_hcd_request_irqs().
> We move the call to ohci_init() in hcd->driver->reset() instead of
> hcd->driver->start() to fix this.
> This was experienced when we share the same IRQ line between OHCI and EHCI
> controllers.

> Signed-off-by: Nicolas Ferre<nicolas.ferre@atmel.com>
> Tested-by: Christian Eggers<christian.eggers@kathrein.de>
> Cc: stable<stable@vger.kernel.org>
> ---
>   drivers/usb/host/ohci-at91.c |   11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)

> diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
> index 13ebeca..55d3d64 100644
> --- a/drivers/usb/host/ohci-at91.c
> +++ b/drivers/usb/host/ohci-at91.c
> @@ -223,7 +223,7 @@ static void __devexit usb_hcd_at91_remove(struct usb_hcd *hcd,
>   /*-------------------------------------------------------------------------*/
>
>   static int __devinit
> -ohci_at91_start (struct usb_hcd *hcd)
> +ohci_at91_reset (struct usb_hcd *hcd)

    Have you run the patch thru scripts/checkpatch.pl? There should be no 
space between function name and '('.

>   {
>   	struct at91_usbh_data	*board = hcd->self.controller->platform_data;
>   	struct ohci_hcd		*ohci = hcd_to_ohci (hcd);
> @@ -233,6 +233,14 @@ ohci_at91_start (struct usb_hcd *hcd)
>   		return ret;
>
>   	ohci->num_ports = board->ports;
> +	return 0;
> +}
> +
> +static int __devinit
> +ohci_at91_start (struct usb_hcd *hcd)

    Same here.

> +{
> +	struct ohci_hcd		*ohci = hcd_to_ohci (hcd);

    And here.

WBR, Sergei
