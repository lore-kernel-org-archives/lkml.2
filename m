Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab0GVVCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 17:02:34 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:46400 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755601Ab0GVVCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 17:02:31 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAAJOSExQydL7/2dsb2JhbACfc3LDDQ2FKQQ
Date: Thu, 22 Jul 2010 23:02:29 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] wdt_pci.c: move ids to pci_ids.h
Message-ID: <20100722210229.GO11857@infomag.iguana.be>
References: <0D753D10438DA54287A00B0270842697636F3238B3@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D753D10438DA54287A00B0270842697636F3238B3@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi H Hartley,

Patch added to linux-2.6-watchdog-next .

Kind regards,
Wim.

> Move the VENDOR/DEVICE ids to pci_ids.h.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> 
> ---
> 
> diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
> index 7b22e3c..6130c88 100644
> --- a/drivers/watchdog/wdt_pci.c
> +++ b/drivers/watchdog/wdt_pci.c
> @@ -60,19 +60,6 @@
>  
>  #define PFX "wdt_pci: "
>  
> -/*
> - * Until Access I/O gets their application for a PCI vendor ID approved,
> - * I don't think that it's appropriate to move these constants into the
> - * regular pci_ids.h file. -- JPN 2000/01/18
> - */
> -
> -#ifndef PCI_VENDOR_ID_ACCESSIO
> -#define PCI_VENDOR_ID_ACCESSIO 0x494f
> -#endif
> -#ifndef PCI_DEVICE_ID_WDG_CSM
> -#define PCI_DEVICE_ID_WDG_CSM 0x22c0
> -#endif
> -
>  /* We can only use 1 card due to the /dev/watchdog restriction */
>  static int dev_count;
>  
> @@ -743,7 +730,7 @@ static void __devexit wdtpci_remove_one(struct pci_dev *pdev)
>  static struct pci_device_id wdtpci_pci_tbl[] = {
>  	{
>  		.vendor	   = PCI_VENDOR_ID_ACCESSIO,
> -		.device	   = PCI_DEVICE_ID_WDG_CSM,
> +		.device	   = PCI_DEVICE_ID_ACCESSIO_WDG_CSM,
>  		.subvendor = PCI_ANY_ID,
>  		.subdevice = PCI_ANY_ID,
>  	},
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 9f688d2..e4551f0 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2367,6 +2367,9 @@
>  #define PCI_VENDOR_ID_AKS		0x416c
>  #define PCI_DEVICE_ID_AKS_ALADDINCARD	0x0100
>  
> +#define PCI_VENDOR_ID_ACCESSIO		0x494f
> +#define PCI_DEVICE_ID_ACCESSIO_WDG_CSM	0x22c0
> +
>  #define PCI_VENDOR_ID_S3		0x5333
>  #define PCI_DEVICE_ID_S3_TRIO		0x8811
>  #define PCI_DEVICE_ID_S3_868		0x8880
