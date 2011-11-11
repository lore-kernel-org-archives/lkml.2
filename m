Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab1KKQZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 11:25:20 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:48127 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab1KKQZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 11:25:19 -0500
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Nov 2011 11:25:19 EST
Message-ID: <4EBD4A31.2070609@hp.com>
Date: Fri, 11 Nov 2011 10:15:45 -0600
From: Mike Miller <mike.miller@hp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ISS StorageDev <iss_storagedev@hp.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCH V2 4/6] block/cciss: Disable ASPM
References: <1321028064-644-1-git-send-email-mjg@redhat.com> <1321028064-644-5-git-send-email-mjg@redhat.com>
In-Reply-To: <1321028064-644-5-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2011 10:14 AM, Matthew Garrett wrote:
> The Windows driver .inf disables ASPM on all cciss devices. Do the same.
>
> Signed-off-by: Matthew Garrett<mjg@redhat.com>
> Cc: mike.miller@hp.com
> Cc: iss_storagedev@hp.com
> Cc: axboe@kernel.dk
> ---
>   drivers/block/cciss.c |    5 +++++
>   1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 486f94e..92d8a2f 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -24,6 +24,7 @@
>   #include<linux/interrupt.h>
>   #include<linux/types.h>
>   #include<linux/pci.h>
> +#include<linux/pci-aspm.h>
>   #include<linux/kernel.h>
>   #include<linux/slab.h>
>   #include<linux/delay.h>
> @@ -4319,6 +4320,10 @@ static int __devinit cciss_pci_init(ctlr_info_t *h)
>   		dev_warn(&h->pdev->dev, "controller appears to be disabled\n");
>   		return -ENODEV;
>   	}
> +
> +	pci_disable_link_state(h->pdev, PCIE_LINK_STATE_L0S |
> +			       PCIE_LINK_STATE_L1 | PCIE_LINK_STATE_CLKPM);
> +
>   	err = pci_enable_device(h->pdev);
>   	if (err) {
>   		dev_warn(&h->pdev->dev, "Unable to Enable PCI device\n");

Acked-by: Mike Miller <mike.miller@hp.com>
