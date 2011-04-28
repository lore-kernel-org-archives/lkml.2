Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab1D1H7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 03:59:17 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:22434
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753429Ab1D1H7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 03:59:15 -0400
X-SpamScore: -12
X-BigFish: VS-12(zz936eK1432N98dKzz1202hzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Subject: Re: [PATCH] PCI: portdrv: fix irq initialization on FSL pcie host
 controller
From: Xu Lei <B33228@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-pci@vger.kernel.org>,
        <kumar.gala@freescale.com>
In-Reply-To: <1303458219-31915-1-git-send-email-B33228@freescale.com>
References: <1303458219-31915-1-git-send-email-B33228@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 16:01:11 +0800
Message-ID: <1303977671.1642.742.camel@xulei-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Any feedback on this patch? Thanks.

On Friday, 2011-04-22 at 15:43 +0800, Lei Xu wrote:
> Root complex ports for Freescale PCIe host controller only receive
> interrupts, so if there is no irq setting for RC, it should not return
> error, otherwise it may result the PCIe host controller is disabled.
> 
> Signed-off-by: Lei Xu <B33228@freescale.com>
> ---
>  drivers/pci/pcie/portdrv_core.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
> index 595654a..95e64c8 100644
> --- a/drivers/pci/pcie/portdrv_core.c
> +++ b/drivers/pci/pcie/portdrv_core.c
> @@ -209,7 +209,10 @@ static int init_service_irqs(struct pci_dev *dev, int *irqs, int mask)
>  		irqs[i] = irq;
>  	irqs[PCIE_PORT_SERVICE_VC_SHIFT] = -1;
>  
> -	if (irq < 0)
> +	/* Root complex ports for Freescale PCIe host controller only
> +	 * receive interrupts, so if there is no irq setting for RC,
> +	 * it should not return error. */
> +	if ((irq < 0) && (dev->pcie_type != PCI_EXP_TYPE_ROOT_PORT))
>  		return -ENODEV;
>  	return 0;
>  }

-- 
Regards

Lei


