Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab1C3TUD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 15:20:03 -0400
Received: from sous-sol.org ([216.99.217.87]:48381 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754847Ab1C3TUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 15:20:01 -0400
Date: Wed, 30 Mar 2011 12:19:02 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Mike Travis <travis@sgi.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        iommu@lists.linux-foundation.org, Mike Habeck <habeck@sgi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] Intel iommu: Speed up processing of the
 identity_mapping function
Message-ID: <20110330191902.GT18712@sequoia.sous-sol.org>
References: <20110329233602.272459647@gulag1.americas.sgi.com>
 <20110329233602.585251738@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110329233602.585251738@gulag1.americas.sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Travis (travis@sgi.com) wrote:
> @@ -2138,6 +2134,7 @@ static int domain_add_dev_info(struct dm
>  	list_add(&info->global, &device_domain_list);
>  	pdev->dev.archdata.iommu = info;

The si_domain is cached right here...can you not use this instead of
adding an iommu impl. specific bit to pci_dev?

>  	spin_unlock_irqrestore(&device_domain_lock, flags);
> +	pdev->is_identity_mapped = (domain == si_domain);
