Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab1KKQZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 11:25:42 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:13870 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab1KKQZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 11:25:40 -0500
X-Greylist: delayed 531 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Nov 2011 11:25:40 EST
Message-ID: <4EBD4A53.10709@hp.com>
Date: Fri, 11 Nov 2011 10:16:19 -0600
From: Mike Miller <mike.miller@hp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>,
        ISS StorageDev <iss_storagedev@hp.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH V2 5/6] scsi/hpsa: Disable ASPM
References: <1321028064-644-1-git-send-email-mjg@redhat.com> <1321028064-644-6-git-send-email-mjg@redhat.com>
In-Reply-To: <1321028064-644-6-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2011 10:14 AM, Matthew Garrett wrote:
> The Windows driver .inf disables ASPM on hpsa devices. Do the same.
>
> Signed-off-by: Matthew Garrett<mjg@redhat.com>
> Cc: scameron@beardog.cce.hp.com
> Cc: iss_storagedev@hp.com
> Cc: linux-scsi@vger.kernel.org
> ---
>   drivers/scsi/hpsa.c |    5 +++++
>   1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index e76107b..865d452 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -23,6 +23,7 @@
>   #include<linux/interrupt.h>
>   #include<linux/types.h>
>   #include<linux/pci.h>
> +#include<linux/pci-aspm.h>
>   #include<linux/kernel.h>
>   #include<linux/slab.h>
>   #include<linux/delay.h>
> @@ -3922,6 +3923,10 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
>   		dev_warn(&h->pdev->dev, "controller appears to be disabled\n");
>   		return -ENODEV;
>   	}
> +
> +	pci_disable_link_state(h->pdev, PCIE_LINK_STATE_L0S |
> +			       PCIE_LINK_STATE_L1 | PCIE_LINK_STATE_CLKPM);
> +
>   	err = pci_enable_device(h->pdev);
>   	if (err) {
>   		dev_warn(&h->pdev->dev, "unable to enable PCI device\n");

Acked-by: Mike Miller <mike.miller@hp.com>
