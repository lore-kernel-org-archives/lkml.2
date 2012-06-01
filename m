Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965637Ab2FAWCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 18:02:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964869Ab2FAWCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 18:02:32 -0400
Message-ID: <4FC93BF4.8040207@redhat.com>
Date: Fri, 01 Jun 2012 18:02:28 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Myron Stowe <myron.stowe@redhat.com>
CC: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, xudong.hao@linux.intel.com,
        yu.zhao@intel.com
Subject: Re: [PATCH 1/4] PCI: make pci_ltr_supported static.
References: <20120601211619.20328.36769.stgit@amt.stowe> <20120601211625.20328.37250.stgit@amt.stowe>
In-Reply-To: <20120601211625.20328.37250.stgit@amt.stowe>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2012 05:16 PM, Myron Stowe wrote:
> The PCI Express Latency Tolerance Reporting (LTR) feature's
> pci_ltr_supported() routine is currently only used within
> drivers/pci/pci.c so make it static.
>
> Signed-off-by: Myron Stowe<myron.stowe@redhat.com>
> ---
>
Acked-by: Donald Dutile <ddutile@redhat.com>

>   drivers/pci/pci.c   |    4 ++--
>   include/linux/pci.h |    1 -
>   2 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 447e834..64471b1 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -39,6 +39,7 @@ EXPORT_SYMBOL(pci_pci_problems);
>
>   unsigned int pci_pm_d3_delay;
>
> +static bool pci_ltr_supported(struct pci_dev *dev);
>   static void pci_pme_list_scan(struct work_struct *work);
>
>   static LIST_HEAD(pci_pme_list);
> @@ -2169,7 +2170,7 @@ EXPORT_SYMBOL(pci_disable_obff);
>    * RETURNS:
>    * True if @dev supports latency tolerance reporting, false otherwise.
>    */
> -bool pci_ltr_supported(struct pci_dev *dev)
> +static bool pci_ltr_supported(struct pci_dev *dev)
>   {
>   	int pos;
>   	u32 cap;
> @@ -2185,7 +2186,6 @@ bool pci_ltr_supported(struct pci_dev *dev)
>
>   	return cap&  PCI_EXP_DEVCAP2_LTR;
>   }
> -EXPORT_SYMBOL(pci_ltr_supported);
>
>   /**
>    * pci_enable_ltr - enable latency tolerance reporting
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index d8c379d..b2bec26 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -875,7 +875,6 @@ enum pci_obff_signal_type {
>   int pci_enable_obff(struct pci_dev *dev, enum pci_obff_signal_type);
>   void pci_disable_obff(struct pci_dev *dev);
>
> -bool pci_ltr_supported(struct pci_dev *dev);
>   int pci_enable_ltr(struct pci_dev *dev);
>   void pci_disable_ltr(struct pci_dev *dev);
>   int pci_set_ltr(struct pci_dev *dev, int snoop_lat_ns, int nosnoop_lat_ns);
>

