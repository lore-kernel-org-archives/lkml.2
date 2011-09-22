Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab1IVUNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 16:13:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59145 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab1IVUNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 16:13:31 -0400
Date: Thu, 22 Sep 2011 13:11:55 -0700
From: Greg KH <gregkh@suse.de>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, joro@8bytes.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] Driver core: Add iommu_ops to bus_type
Message-ID: <20110922201155.GA12788@suse.de>
References: <1316708102-16250-1-git-send-email-joerg.roedel@amd.com>
 <1316708102-16250-3-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316708102-16250-3-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 06:14:54PM +0200, Joerg Roedel wrote:
> This is the starting point to make the iommu_ops used for
> the iommu-api a per-bus-type structure. It is required to
> easily implement bus-specific setup in the iommu-layer.
> The first user will be the iommu-group attribute in sysfs.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  drivers/base/bus.c     |   29 +++++++++++++++++++++++++++++
>  drivers/iommu/iommu.c  |    4 ++++
>  include/linux/device.h |   10 ++++++++++
>  include/linux/iommu.h  |    2 ++
>  4 files changed, 45 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> index 000e7b2..b3014fe 100644
> --- a/drivers/base/bus.c
> +++ b/drivers/base/bus.c
> @@ -1028,6 +1028,35 @@ void bus_sort_breadthfirst(struct bus_type *bus,
>  }
>  EXPORT_SYMBOL_GPL(bus_sort_breadthfirst);
>  
> +#ifdef CONFIG_IOMMU_API
> +/**

This ifdef really isn't needed, is it?  I think you can remove it.

Other than that, looks much better, thanks.

greg k-h
