Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab1JVNXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 09:23:18 -0400
Received: from ahm.einfochips.com ([203.76.128.206]:38081 "EHLO
	ahm.einfochips.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab1JVNXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 09:23:16 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Oct 2011 09:23:16 EDT
Message-ID: <4EA2C233.4080500@einfochips.com>
Date: Sat, 22 Oct 2011 18:46:35 +0530
From: Tanmay Upadhyay <tanmay.upadhyay@einfochips.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110921 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Jayachandran C <jayachandranc@netlogicmicro.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org
Subject: Re: [PATCH 48/49] USB: pxa168: xls: irq: Remove IRQF_DISABLED
References: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com> <1319277421-9203-49-git-send-email-yong.zhang0@gmail.com>
In-Reply-To: <1319277421-9203-49-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 22 October 2011 03:27 PM, Yong Zhang wrote:
> Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabled],
> We run all interrupt handlers with interrupts disabled
> and we even check and yell when an interrupt handler
> returns with interrupts enabled (see commit [b738a50a:
> genirq: Warn when handler enables interrupts]).
>
> So now this flag is a NOOP and can be removed.
>
> Signed-off-by: Yong Zhang<yong.zhang0@gmail.com>

Acked-by: Tanmay Upadhyay<tanmay.upadhyay@einfochips.com>

Thanks for updating USB driver for PXA168!

Thanks,

Tanmay


> Cc: Tanmay Upadhyay<tanmay.upadhyay@einfochips.com>
> Cc: Jayachandran C<jayachandranc@netlogicmicro.com>
> Cc: Greg Kroah-Hartman<gregkh@suse.de>
> ---
>   drivers/usb/host/ehci-pxa168.c |    2 +-
>   drivers/usb/host/ohci-xls.c    |    2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/usb/host/ehci-pxa168.c b/drivers/usb/host/ehci-pxa168.c
> index ac0c16e..f0b776d 100644
> --- a/drivers/usb/host/ehci-pxa168.c
> +++ b/drivers/usb/host/ehci-pxa168.c
> @@ -304,7 +304,7 @@ static int __devinit ehci_pxa168_drv_probe(struct platform_device *pdev)
>   	hcd->has_tt = 1;
>   	ehci->sbrn = 0x20;
>
> -	err = usb_add_hcd(hcd, irq, IRQF_SHARED | IRQF_DISABLED);
> +	err = usb_add_hcd(hcd, irq, IRQF_SHARED);
>   	if (err)
>   		goto err5;
>
> diff --git a/drivers/usb/host/ohci-xls.c b/drivers/usb/host/ohci-xls.c
> index a3a9c6f..38b6bda 100644
> --- a/drivers/usb/host/ohci-xls.c
> +++ b/drivers/usb/host/ohci-xls.c
> @@ -56,7 +56,7 @@ static int ohci_xls_probe_internal(const struct hc_driver *driver,
>   		goto err3;
>   	}
>
> -	retval = usb_add_hcd(hcd, irq, IRQF_DISABLED | IRQF_SHARED);
> +	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
>   	if (retval != 0)
>   		goto err4;
>   	return retval;
