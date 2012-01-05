Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab2AESuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 13:50:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab2AESuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:50:14 -0500
Message-ID: <4F05F0E3.7070802@redhat.com>
Date: Thu, 05 Jan 2012 13:50:11 -0500
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI: Increase resource array mask bit size in pcim_iomap_regions()
References: <1325721002-6094-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1325721002-6094-1-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2012 06:50 PM, Yinghai Lu wrote:
> DEVICE_COUNT_RESOURCE will be bigger than 16 when SRIOV supported is enabled.
>
> Let them pass with int just like pci_enable_resources().
>
> Signed-off-by: Yinghai Lu<yinghai@kernel.org>
>
> ---
>   include/linux/pci.h |    6 +++---
>   lib/devres.c        |    6 +++---
>   2 files changed, 6 insertions(+), 6 deletions(-)
>
> Index: linux-2.6/include/linux/pci.h
> ===================================================================
> --- linux-2.6.orig/include/linux/pci.h
> +++ linux-2.6/include/linux/pci.h
> @@ -1433,10 +1433,10 @@ static inline void pci_fixup_device(enum
>   void __iomem *pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen);
>   void pcim_iounmap(struct pci_dev *pdev, void __iomem *addr);
>   void __iomem * const *pcim_iomap_table(struct pci_dev *pdev);
> -int pcim_iomap_regions(struct pci_dev *pdev, u16 mask, const char *name);
> -int pcim_iomap_regions_request_all(struct pci_dev *pdev, u16 mask,
> +int pcim_iomap_regions(struct pci_dev *pdev, int mask, const char *name);
> +int pcim_iomap_regions_request_all(struct pci_dev *pdev, int mask,
>   				   const char *name);
> -void pcim_iounmap_regions(struct pci_dev *pdev, u16 mask);
> +void pcim_iounmap_regions(struct pci_dev *pdev, int mask);
>
>[...]

I'd recommend u32 since it was u16 initially.
