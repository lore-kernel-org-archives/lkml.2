Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab2GFUur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 16:50:47 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44333 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab2GFUup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 16:50:45 -0400
Message-ID: <4FF74FA3.4000008@acm.org>
Date: Fri, 06 Jul 2012 15:50:43 -0500
From: Corey Minyard <tcminyard@gmail.com>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM mailing list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        openipmi-developer@lists.sourceforge.net
Subject: Re: [PATCH] PM / IPMI: Remove empty legacy PCI PM callbacks
References: <201207062202.39202.rjw@sisk.pl>
In-Reply-To: <201207062202.39202.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks fine to me.

Acked-by: Corey Minyard <cminyard@mvista.com>

On 07/06/2012 03:02 PM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> The legacy PM callbacks provided by the IPMI PCI driver are
> empty routines returning 0, so they can be safely dropped.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>   drivers/char/ipmi/ipmi_si_intf.c |   16 ----------------
>   1 file changed, 16 deletions(-)
>
> Index: linux/drivers/char/ipmi/ipmi_si_intf.c
> ===================================================================
> --- linux.orig/drivers/char/ipmi/ipmi_si_intf.c
> +++ linux/drivers/char/ipmi/ipmi_si_intf.c
> @@ -2503,18 +2503,6 @@ static void __devexit ipmi_pci_remove(st
>   	cleanup_one_si(info);
>   }
>   
> -#ifdef CONFIG_PM
> -static int ipmi_pci_suspend(struct pci_dev *pdev, pm_message_t state)
> -{
> -	return 0;
> -}
> -
> -static int ipmi_pci_resume(struct pci_dev *pdev)
> -{
> -	return 0;
> -}
> -#endif
> -
>   static struct pci_device_id ipmi_pci_devices[] = {
>   	{ PCI_DEVICE(PCI_HP_VENDOR_ID, PCI_MMC_DEVICE_ID) },
>   	{ PCI_DEVICE_CLASS(PCI_ERMC_CLASSCODE, PCI_ERMC_CLASSCODE_MASK) },
> @@ -2527,10 +2515,6 @@ static struct pci_driver ipmi_pci_driver
>   	.id_table =     ipmi_pci_devices,
>   	.probe =        ipmi_pci_probe,
>   	.remove =       __devexit_p(ipmi_pci_remove),
> -#ifdef CONFIG_PM
> -	.suspend =      ipmi_pci_suspend,
> -	.resume =       ipmi_pci_resume,
> -#endif
>   };
>   #endif /* CONFIG_PCI */
>   


