Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab0DIPdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 11:33:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:34104 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937Ab0DIPdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 11:33:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,178,1270450800"; 
   d="scan'208";a="787826776"
Subject: Re: [PATCH 1/6] pci/dmar: Don't complain that IOPAIC is not
 supported
From: David Woodhouse <david.woodhouse@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
In-Reply-To: <1270753107-15881-2-git-send-email-yinghai@kernel.org>
References: <1270753107-15881-1-git-send-email-yinghai@kernel.org>
	 <1270753107-15881-2-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation. Pipers Way, Swindon, Wiltshire, SN3 1RJ,
 UK.
Date: Fri, 09 Apr 2010 16:33:35 +0100
Message-ID: <1270827215.4478.10436.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-08 at 19:58 +0100, Yinghai Lu wrote:
> INTR_REMAP handle that type, so if that is used, we should not complain that
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/dmar.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
> index 33ead97..3bd013f 100644
> --- a/drivers/pci/dmar.c
> +++ b/drivers/pci/dmar.c
> @@ -131,9 +131,13 @@ static int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
>  		if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT ||
>  		    scope->entry_type == ACPI_DMAR_SCOPE_TYPE_BRIDGE)
>  			(*cnt)++;
> -		else
> -			printk(KERN_WARNING PREFIX
> -				"Unsupported device scope\n");
> +		else  {
> +#ifdef CONFIG_INTR_REMAP
> +			if (scope->entry_type != ACPI_DMAR_SCOPE_TYPE_IOAPIC)
> +#endif
> +				printk(KERN_WARNING PREFIX
> +					"Unsupported device scope\n");
> +		}
>  		start += scope->length;
>  	}
>  	if (*cnt == 0)

Applied, without the ifdef and slightly cleaned up.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

