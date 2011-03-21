Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab1CUS6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 14:58:53 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:35844 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab1CUS6w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 14:58:52 -0400
X-Greylist: delayed 527 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Mar 2011 14:58:52 EDT
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chirag.kantharia@hp.com" <chirag.kantharia@hp.com>,
        ISS StorageDev <iss_storagedev@hp.com>
Date: Mon, 21 Mar 2011 18:49:52 +0000
Subject: RE: [PATCH] cpqarray: use pci_dev->revision
Thread-Topic: [PATCH] cpqarray: use pci_dev->revision
Thread-Index: AcviYA2ljUWOrbR7QiyXbzCQtRf41QFmJWEg
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77887D4A6A73B8@GVW0547EXC.americas.hpqcorp.net>
References: <201103141825.44770.sshtylyov@ru.mvista.com>
In-Reply-To: <201103141825.44770.sshtylyov@ru.mvista.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Sergei Shtylyov [mailto:sshtylyov@ru.mvista.com]
> Sent: Monday, March 14, 2011 10:26 AM
> To: linux-kernel@vger.kernel.org; chirag.kantharia@hp.com; ISS
> StorageDev
> Subject: [PATCH] cpqarray: use pci_dev->revision
> 
> This driver uses PCI_CLASS_REVISION instead of PCI_REVISION_ID, so it
> wasn't
> converted by commit 44c10138fd4bbc4b6d6bff0873c24902f2a9da65 (PCI:
> Change all
> drivers to use pci_device->revision).
> 
> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> 

Acked-by: Mike Miller <mike.miller@hp.com>

> ---
> The patch is against the recent Linus' tree.
> 
>  drivers/block/cpqarray.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/block/cpqarray.c
> ===================================================================
> --- linux-2.6.orig/drivers/block/cpqarray.c
> +++ linux-2.6/drivers/block/cpqarray.c
> @@ -620,6 +620,7 @@ static int cpqarray_pci_init(ctlr_info_t
>  	}
>  	vendor_id = pdev->vendor;
>  	device_id = pdev->device;
> +	revision  = pdev->revision;
>  	irq = pdev->irq;
> 
>  	for(i=0; i<6; i++)
> @@ -632,7 +633,6 @@ static int cpqarray_pci_init(ctlr_info_t
>  	}
> 
>  	pci_read_config_word(pdev, PCI_COMMAND, &command);
> -	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
>  	pci_read_config_byte(pdev, PCI_CACHE_LINE_SIZE, &cache_line_size);
>  	pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &latency_timer);
> 
