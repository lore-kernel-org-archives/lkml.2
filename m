Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab1GUQXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:23:35 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:23659 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab1GUQXc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:23:32 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chirag.kantharia@hp.com" <chirag.kantharia@hp.com>,
        ISS StorageDev <iss_storagedev@hp.com>
Date: Thu, 21 Jul 2011 17:21:47 +0100
Subject: RE: [PATCH resend] cpqarray: use pci_dev->revision
Thread-Topic: [PATCH resend] cpqarray: use pci_dev->revision
Thread-Index: AcxHwgO8DWDpjNA3RoSxjdtckpmh8wAADOWQ
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77887D5522D9A8@GVW0547EXC.americas.hpqcorp.net>
References: <201105131909.56428.sshtylyov@ru.mvista.com>
 <201107211951.17610.sshtylyov@ru.mvista.com>
In-Reply-To: <201107211951.17610.sshtylyov@ru.mvista.com>
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



-- mikem

"If men are so wicked with religion, what would they be if without it?" --Benjamin Franklin 


> -----Original Message-----
> From: Sergei Shtylyov [mailto:sshtylyov@ru.mvista.com]
> Sent: Thursday, July 21, 2011 10:51 AM
> To: linux-kernel@vger.kernel.org; chirag.kantharia@hp.com; ISS
> StorageDev
> Subject: [PATCH resend] cpqarray: use pci_dev->revision
> 
> This driver uses PCI_CLASS_REVISION instead of PCI_REVISION_ID, so it
> wasn't
> converted by commit 44c10138fd4bbc4b6d6bff0873c24902f2a9da65 (PCI:
> Change all
> drivers to use pci_device->revision).
> 
> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> 
> ---
> The patch is against the recent Linus' tree.
> It wasn't merged in either 2.6.39 or 3.0 time, hopefully it can be
> merged to
> 3.1...
> 
>  drivers/block/cpqarray.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Acked-by: Mike Miller <mike.miller@hp.com>

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
