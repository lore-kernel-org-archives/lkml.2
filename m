Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab1EGQVU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 12:21:20 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:19258
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755736Ab1EGQVS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 12:21:18 -0400
X-SpamScore: -19
X-BigFish: VS-19(zz936eK9371O1432N98dKzz1202hzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Subject: Re: [PATCH] PCI: portdrv: fix irq initialization on FSL pcie host controller
MIME-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset="us-ascii"
From: Kumar Gala <kumar.gala@freescale.com>
In-Reply-To: <1303977671.1642.742.camel@xulei-desktop>
Date: Sat, 7 May 2011 11:21:16 -0500
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-pci@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-ID: <E8D326F6-7E52-4A20-87B3-6C4CC34406C4@freescale.com>
References: <1303458219-31915-1-git-send-email-B33228@freescale.com> <1303977671.1642.742.camel@xulei-desktop>
To: Xu Lei <B33228@freescale.com>
X-Mailer: Apple Mail (2.1084)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 28, 2011, at 3:01 AM, Xu Lei wrote:

> 
> 	Any feedback on this patch? Thanks.
> 
> On Friday, 2011-04-22 at 15:43 +0800, Lei Xu wrote:
>> Root complex ports for Freescale PCIe host controller only receive
>> interrupts, so if there is no irq setting for RC, it should not return
>> error, otherwise it may result the PCIe host controller is disabled.
>> 
>> Signed-off-by: Lei Xu <B33228@freescale.com>
>> ---
>> drivers/pci/pcie/portdrv_core.c |    5 ++++-
>> 1 files changed, 4 insertions(+), 1 deletions(-)
>> 
>> diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
>> index 595654a..95e64c8 100644
>> --- a/drivers/pci/pcie/portdrv_core.c
>> +++ b/drivers/pci/pcie/portdrv_core.c
>> @@ -209,7 +209,10 @@ static int init_service_irqs(struct pci_dev *dev, int *irqs, int mask)
>> 		irqs[i] = irq;
>> 	irqs[PCIE_PORT_SERVICE_VC_SHIFT] = -1;
>> 
>> -	if (irq < 0)
>> +	/* Root complex ports for Freescale PCIe host controller only
>> +	 * receive interrupts, so if there is no irq setting for RC,
>> +	 * it should not return error. */
>> +	if ((irq < 0) && (dev->pcie_type != PCI_EXP_TYPE_ROOT_PORT))
>> 		return -ENODEV;
>> 	return 0;
>> }
> 
> -- 
> Regards
> 
> Lei
> 

Reviewing this in more detail this is not the right solution.  We should have an dev->irq set and need to fix that.

The means to accomplish that is by fixing up the device tree to properly get the interrupt assigned to the root complex node.

- k
