Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab1FJUxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 16:53:05 -0400
Received: from sous-sol.org ([216.99.217.87]:44230 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757733Ab1FJUxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 16:53:01 -0400
Date: Fri, 10 Jun 2011 13:52:26 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] x86/amd-iommu: Search for existind dev_data before
 allocting a new one
Message-ID: <20110610205226.GN23047@sequoia.sous-sol.org>
References: <1307707729-29767-1-git-send-email-joerg.roedel@amd.com>
 <1307707729-29767-9-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307707729-29767-9-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joerg Roedel (joerg.roedel@amd.com) wrote:
> +static struct iommu_dev_data *search_dev_data(u16 devid)
> +{
> +     struct iommu_dev_data *dev_data;
> +     unsigned long flags;
> +
> +	spin_lock_irqsave(&dev_data_list_lock, flags);
> +	list_for_each_entry(dev_data, &dev_data_list, dev_data_list) {
> +		if (dev_data->devid == devid)

This devid match on a global list is not going to work in a multi-segment
machine.  I guess non-zero segment function would either not exist or go
through swiotlb since it's not supported by hw def'n, so only a concern
for the future (along with the other devid based lookup tables).

thanks,
-chris
