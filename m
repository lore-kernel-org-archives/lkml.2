Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab1LTQIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 11:08:01 -0500
Received: from sous-sol.org ([216.99.217.87]:60849 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751832Ab1LTQHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 11:07:54 -0500
Date: Tue, 20 Dec 2011 08:07:30 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: "Hao, Xudong" <xudong.hao@intel.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] intel-iommu: Add device info into list before doing
 context mapping
Message-ID: <20111220160730.GD30205@sequoia.sous-sol.org>
References: <BC00F5384FCFC9499AF06F92E8B78A9E2890486DD3@shsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BC00F5384FCFC9499AF06F92E8B78A9E2890486DD3@shsmsx502.ccr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Hao, Xudong (xudong.hao@intel.com) wrote:
> @@ -2282,6 +2276,14 @@ static int domain_add_dev_info(struct dmar_domain *domain,
>  	pdev->dev.archdata.iommu = info;
>  	spin_unlock_irqrestore(&device_domain_lock, flags);
>  
> +	ret = domain_context_mapping(domain, pdev, translation);
> +	if (ret) {
> +		list_del(&info->link);
> +		list_del(&info->global);

At the very least, this is not correct locking.

> +		free_devinfo_mem(info);
> +		return ret;
> +	}
> +
