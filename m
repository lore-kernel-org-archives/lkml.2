Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab1IGQBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:01:18 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:3749 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab1IGQBC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:01:02 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Yong Zhang <yong.zhang0@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@elte.hu" <mingo@elte.hu>,
        Chirag Kantharia <chirag.kantharia@hp.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Ralf Baechle <ralf@linux-mips.org>,
        "ISS StorageDev" <iss_storagedev@hp.com>
Date: Wed, 7 Sep 2011 15:26:48 +0100
Subject: RE: [PATCH 29/62] block: irq: Remove IRQF_DISABLED
Thread-Topic: [PATCH 29/62] block: irq: Remove IRQF_DISABLED
Thread-Index: AcxtNn8Onv7af+kfQhiCAHsWmuWfegAM55MA
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77887D5818A727@GVW0547EXC.americas.hpqcorp.net>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
 <1315383059-3673-30-git-send-email-yong.zhang0@gmail.com>
In-Reply-To: <1315383059-3673-30-git-send-email-yong.zhang0@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: P4aR P+iI QQiG Q1Ev YeXP g/fJ jJmt s1f1 wgjL wm4f xB9e
 zCri AALQnQ== AA4oeA== AFRy1A==
 AGG7/Q==;7;YwBoAGkAcgBhAGcALgBrAGEAbgB0AGgAYQByAGkAYQBAAGgAcAAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAdQBjAGEAcwAuAGQAZQBtAGEAcgBjAGgAaQBAAHAAcgBvAGYAdQBzAGkAbwBuAC4AbQBvAGIAaQA7AG0AaQBuAGcAbwBAAGUAbAB0AGUALgBoAHUAOwByAGEAbABmAEAAbABpAG4AdQB4AC0AbQBpAHAAcwAuAG8AcgBnADsAdABnAGwAeABAAGwAaQBuAHUAdAByAG8AbgBpAHgALgBkAGUAOwB5AG8AbgBnAC4AegBoAGEAbgBnADAAQABnAG0AYQBpAGwALgBjAG8AbQA=;Sosha1_v1;7;{41D61109-8C3C-4E2C-A0E4-D694F5D9BADB};bQBpAGsAZQAuAG0AaQBsAGwAZQByAEAAaABwAC4AYwBvAG0A;Wed,
 07 Sep 2011 14:26:48
 GMT;UgBFADoAIABbAFAAQQBUAEMASAAgADIAOQAvADYAMgBdACAAYgBsAG8AYwBrADoAIABpAHIAcQA6ACAAUgBlAG0AbwB2AGUAIABJAFIAUQBGAF8ARABJAFMAQQBCAEwARQBEAA==
x-cr-puzzleid: {41D61109-8C3C-4E2C-A0E4-D694F5D9BADB}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Yong Zhang [mailto:yong.zhang0@gmail.com]
> Sent: Wednesday, September 07, 2011 3:10 AM
> To: linux-kernel@vger.kernel.org
> Cc: tglx@linutronix.de; mingo@elte.hu; Miller, Mike (OS Dev); Chirag
> Kantharia; Lucas De Marchi; Yong Zhang; Ralf Baechle; ISS StorageDev
> Subject: [PATCH 29/62] block: irq: Remove IRQF_DISABLED
> 
> This flag is a NOOP and can be removed now.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Acked-by: Mike Miller <mike.miller@hp.com>


> ---
>  drivers/block/cciss.c    |    4 ++--
>  drivers/block/cpqarray.c |    2 +-
>  drivers/block/hd.c       |    7 +------
>  drivers/block/mg_disk.c  |    2 +-
>  4 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 8f4ef65..ca23653 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -4844,7 +4844,7 @@ static int cciss_request_irq(ctlr_info_t *h,
>  {
>  	if (h->msix_vector || h->msi_vector) {
>  		if (!request_irq(h->intr[PERF_MODE_INT], msixhandler,
> -				IRQF_DISABLED, h->devname, h))
> +				0, h->devname, h))
>  			return 0;
>  		dev_err(&h->pdev->dev, "Unable to get msi irq %d"
>  			" for %s\n", h->intr[PERF_MODE_INT],
> @@ -4853,7 +4853,7 @@ static int cciss_request_irq(ctlr_info_t *h,
>  	}
> 
>  	if (!request_irq(h->intr[PERF_MODE_INT], intxhandler,
> -			IRQF_DISABLED, h->devname, h))
> +			0, h->devname, h))
>  		return 0;
>  	dev_err(&h->pdev->dev, "Unable to get irq %d for %s\n",
>  		h->intr[PERF_MODE_INT], h->devname);
> diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
> index b2fceb5..33afbd7 100644
> --- a/drivers/block/cpqarray.c
> +++ b/drivers/block/cpqarray.c
> @@ -406,7 +406,7 @@ static int __devinit cpqarray_register_ctlr( int i,
> struct pci_dev *pdev)
>  	}
>  	hba[i]->access.set_intr_mask(hba[i], 0);
>  	if (request_irq(hba[i]->intr, do_ida_intr,
> -		IRQF_DISABLED|IRQF_SHARED, hba[i]->devname, hba[i]))
> +		IRQF_SHARED, hba[i]->devname, hba[i]))
>  	{
>  		printk(KERN_ERR "cpqarray: Unable to get irq %d for %s\n",
>  				hba[i]->intr, hba[i]->devname);
> diff --git a/drivers/block/hd.c b/drivers/block/hd.c
> index b52c9ca..c30d1f9 100644
> --- a/drivers/block/hd.c
> +++ b/drivers/block/hd.c
> @@ -696,11 +696,6 @@ static const struct block_device_operations hd_fops
> = {
>  };
> 
>  /*
> - * This is the hard disk IRQ description. The IRQF_DISABLED in sa_flags
> - * means we run the IRQ-handler with interrupts disabled:  this is bad
> for
> - * interrupt latency, but anything else has led to problems on some
> - * machines.
> - *
>   * We enable interrupts in some of the routines after making sure it's
>   * safe.
>   */
> @@ -762,7 +757,7 @@ static int __init hd_init(void)
>  			p->cyl, p->head, p->sect);
>  	}
> 
> -	if (request_irq(HD_IRQ, hd_interrupt, IRQF_DISABLED, "hd", NULL)) {
> +	if (request_irq(HD_IRQ, hd_interrupt, 0, "hd", NULL)) {
>  		printk("hd: unable to get IRQ%d for the hard disk driver\n",
>  			HD_IRQ);
>  		goto out1;
> diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
> index 76fa3de..3c80cba 100644
> --- a/drivers/block/mg_disk.c
> +++ b/drivers/block/mg_disk.c
> @@ -930,7 +930,7 @@ static int mg_probe(struct platform_device
> *plat_dev)
>  			goto probe_err_3b;
>  		}
>  		err = request_irq(host->irq, mg_irq,
> -				IRQF_DISABLED | IRQF_TRIGGER_RISING,
> +				IRQF_TRIGGER_RISING,
>  				MG_DEV_NAME, host);
>  		if (err) {
>  			printk(KERN_ERR "%s:%d fail (request_irq err=%d)\n",
> --
> 1.7.4.1

