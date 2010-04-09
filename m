Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab0DIPnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 11:43:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:32643 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937Ab0DIPnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 11:43:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,178,1270450800"; 
   d="scan'208";a="611659874"
Subject: Re: [PATCH 6/6] intel-iommu: Don't call domain_exit if can not
 attach with iommu
From: David Woodhouse <david.woodhouse@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
In-Reply-To: <1270753107-15881-7-git-send-email-yinghai@kernel.org>
References: <1270753107-15881-1-git-send-email-yinghai@kernel.org>
	 <1270753107-15881-7-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation. Pipers Way, Swindon, Wiltshire, SN3 1RJ,
 UK.
Date: Fri, 09 Apr 2010 16:43:03 +0100
Message-ID: <1270827783.4478.10459.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-08 at 19:58 +0100, Yinghai Lu wrote:
> 
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -1853,7 +1853,7 @@ static struct dmar_domain
> *get_domain_for_dev(struct pci_dev *pdev, int gaw)
>  
>         ret = iommu_attach_domain(domain, iommu);
>         if (ret) {
> -               domain_exit(domain);
> +               free_domain_mem(domain);
>                 goto error;
>         }
>   

Um, shouldn't the next error have the same change? If domain_init()
fails before it gets round to initialising the domain->devices list, the
same oops in domain_exit() will occur, won't it? It's because
domain->devices.{next,prev} are both NULL?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

