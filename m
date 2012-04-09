Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab2DIOvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 10:51:22 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:34397 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218Ab2DIOvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 10:51:21 -0400
Message-ID: <4F82F765.4010705@pobox.com>
Date: Mon, 09 Apr 2012 10:51:17 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: philby john <pjohn@mvista.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com
Subject: Re: [PATCH] sil3531: has no PM capability, remove support.
References: <1333980849.11209.5.camel@localhost.localdomain>
In-Reply-To: <1333980849.11209.5.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2012 10:14 AM, philby john wrote:
> From: Philby John<pjohn@mvista.com>
> Date: Mon, 9 Apr 2012 19:09:51 +0530
> Subject: [PATCH] sil3531: has no PM capability, remove support.
>
> SATA sil3531 does not support Power Management Capability and
> as per the manual Bit [31:27] is hardwired to 00h.
> Otherwise, when the device goes into suspend/resume the Power
> Management Control + Status registers are accessed and the
> arch specific readl()/__raw_readl() calls block indefinitely.
>
> This patch sets the PCI_DEV_FLAGS_NO_D3 flag by which the if
> condition in pci_set_power_state() evaluates to true and
> pci_raw_set_power_state() functions are not executed.
>
> Signed-off-by: Philby John<pjohn@mvista.com>
> Signed-off-by: Johnny Chiang<Johnny.Chiang@caviumnetworks.com>
> ---
>   drivers/pci/pci.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 8156744..129120d 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1863,6 +1863,7 @@ void pci_pm_init(struct pci_dev *dev)
>   		pci_pme_active(dev, false);
>   	} else {
>   		dev->pme_support = 0;
> +		dev->dev_flags |= PCI_DEV_FLAGS_NO_D3;

This patch applies to -every- piece of PCI hardware out there, not just 
the sil3531...

	Jeff




