Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965538Ab2FAWCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 18:02:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964869Ab2FAWCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 18:02:11 -0400
Message-ID: <4FC93BDF.8050900@redhat.com>
Date: Fri, 01 Jun 2012 18:02:07 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Myron Stowe <myron.stowe@redhat.com>
CC: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, xudong.hao@linux.intel.com,
        yu.zhao@intel.com
Subject: Re: [PATCH 2/4] PCI: Remove redundant checking in PCI Express capability
 routines
References: <20120601211619.20328.36769.stgit@amt.stowe> <20120601211631.20328.53913.stgit@amt.stowe>
In-Reply-To: <20120601211631.20328.53913.stgit@amt.stowe>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2012 05:16 PM, Myron Stowe wrote:
> There are a number of redundant pci_is_pcie() checks in various PCI
> Express capabilities related routines like the following:
>
>      if (!pci_is_pcie(dev))
> 	return false;
>
>      pos = pci_pcie_cap(dev);
>      if (!pos)
> 	return false;
>
> The current pci_is_pcie() implementation is merely:
>
>      static inline bool pci_is_pcie(struct pci_dev *dev)
>      {
>          return !!pci_pcie_cap(dev);
>      }
>
> so we can just drop the pci_is_pcie() test in such cases.
>
> Suggested by Bjorn Helgaas in -
> http://marc.info/?l=linux-pci&m=130463494319762&w=2
>
> Signed-off-by: Myron Stowe<myron.stowe@redhat.com>
> ---
>
you can add my ack to this patch.

>   drivers/pci/pci.c |   14 +-------------
>   1 files changed, 1 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 64471b1..ff0beb0 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1995,7 +1995,7 @@ void pci_enable_ari(struct pci_dev *dev)
>   		return;
>
>   	bridge = dev->bus->self;
> -	if (!bridge || !pci_is_pcie(bridge))
> +	if (!bridge)
>   		return;
>
>   	pos = pci_pcie_cap(bridge);
> @@ -2055,9 +2055,6 @@ void pci_disable_ido(struct pci_dev *dev, unsigned long type)
>   	int pos;
>   	u16 ctrl;
>
> -	if (!pci_is_pcie(dev))
> -		return;
> -
>   	pos = pci_pcie_cap(dev);
>   	if (!pos)
>   		return;
> @@ -2097,9 +2094,6 @@ int pci_enable_obff(struct pci_dev *dev, enum pci_obff_signal_type type)
>   	u16 ctrl;
>   	int ret;
>
> -	if (!pci_is_pcie(dev))
> -		return -ENOTSUPP;
> -
>   	pos = pci_pcie_cap(dev);
>   	if (!pos)
>   		return -ENOTSUPP;
> @@ -2150,9 +2144,6 @@ void pci_disable_obff(struct pci_dev *dev)
>   	int pos;
>   	u16 ctrl;
>
> -	if (!pci_is_pcie(dev))
> -		return;
> -
>   	pos = pci_pcie_cap(dev);
>   	if (!pos)
>   		return;
> @@ -2175,9 +2166,6 @@ static bool pci_ltr_supported(struct pci_dev *dev)
>   	int pos;
>   	u32 cap;
>
> -	if (!pci_is_pcie(dev))
> -		return false;
> -
>   	pos = pci_pcie_cap(dev);
>   	if (!pos)
>   		return false;
>

