Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933499Ab1JYNyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 09:54:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:33662 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933347Ab1JYNyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 09:54:38 -0400
Date: Tue, 25 Oct 2011 15:54:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel J Blueman <daniel@numascale-asia.com>
cc: Ingo Molnar <mingo@redhat.com>, H Peter Anvin <hpa@zytor.com>,
        Steffen Persvold <sp@numascale.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 3/3] Add NumaChip quirk
In-Reply-To: <1318926156-25504-3-git-send-email-daniel@numascale-asia.com>
Message-ID: <alpine.LFD.2.02.1110251550430.21837@ionos>
References: <1318926156-25504-1-git-send-email-daniel@numascale-asia.com> <1318926156-25504-3-git-send-email-daniel@numascale-asia.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel,

On Tue, 18 Oct 2011, Daniel J Blueman wrote:

> Add quirk for Numascale's NumaChip to prevent resource conflicts.
> 
> v2:
>  - [Daniel] rediffed and validated against 3.1-rc10
> 
> Signed-off-by: Steffen Persvold <sp@numascale.com>

So, who wrote that code? If Steffen, then you should put a From:
.... when sending patches.

> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
> ---
>  drivers/pci/quirks.c    |   14 ++++++++++++++
>  include/linux/pci_ids.h |    4 ++++
>  2 files changed, 18 insertions(+), 0 deletions(-)

Jesse,

can you take that or should I push it through x86 ?

Thanks,

	tglx
 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 1196f61..051b793 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -2679,6 +2679,20 @@ static void __devinit quirk_hotplug_bridge(struct pci_dev *dev)
>  
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_HINT, 0x0020, quirk_hotplug_bridge);
>  
> +/* Clear all resources on NumaChip to avoid conflicts */
> +static void __devinit numachip_resource_fixup(struct pci_dev *pdev)
> +{
> +	int i;
> +
> +	for (i = PCI_STD_RESOURCES; i <= PCI_ROM_RESOURCE; i++)
> +		memset(&pdev->resource[i], 0, sizeof(pdev->resource[i]));
> +
> +	dev_notice(&pdev->dev, "Disabled all PCI resources for NumaChip\n");
> +}
> +
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NUMASCALE,
> +	PCI_DEVICE_ID_NUMASCALE_NUMACHIP0, numachip_resource_fixup);
> +
>  /*
>   * This is a quirk for the Ricoh MMC controller found as a part of
>   * some mulifunction chips.
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index ae96bbe..02e0959 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2400,6 +2400,10 @@
>  
>  #define PCI_VENDOR_ID_AZWAVE		0x1a3b
>  
> +#define PCI_VENDOR_ID_NUMASCALE		0x1b47
> +#define PCI_DEVICE_ID_NUMASCALE_NUMACHIP0 0x0601
> +#define PCI_DEVICE_ID_NUMASCALE_NUMACHIP1 0x0602
> +
>  #define PCI_VENDOR_ID_TEKRAM		0x1de1
>  #define PCI_DEVICE_ID_TEKRAM_DC290	0xdc29
>  
> -- 
> 1.7.5.4
> 
> 
