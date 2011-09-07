Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab1IGStQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 14:49:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50100 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756668Ab1IGStM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 14:49:12 -0400
Date: Wed, 7 Sep 2011 11:48:40 -0700
From: Greg KH <gregkh@suse.de>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] IOMMU: Make iommu_ops per-bus_type
Message-ID: <20110907184840.GB920@suse.de>
References: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 05:41:43PM +0200, Joerg Roedel wrote:
> Hi,
> 
> here is the new version of the patch-set to make the iommu_ops used in
> the iommu-api a bus_type property. This will allow us to move code out
> of the iommu drivers into generic code and it simplifies the
> implementation of the Alex' device-group property.
> 
> Greg, can you have a look at patch 2 please and tell me if you have any
> objections?

I object, please see my comments.

> With this version the patch-set is complete (not as the first RFC post).
> It converts all iommu drivers to use the new registration interface and
> completly removes the register_iommu interface.
> 
> Regards,
> 
> 	Joerg
> 
> Diffstat:
> 
>  arch/ia64/kvm/kvm-ia64.c           |    3 +-
>  arch/x86/kvm/x86.c                 |    3 +-
>  drivers/base/bus.c                 |   16 ++++++++++
>  drivers/iommu/amd_iommu.c          |    2 +-
>  drivers/iommu/intel-iommu.c        |    2 +-
>  drivers/iommu/iommu.c              |   58 ++++++++++++++++++++++++------------
>  drivers/iommu/msm_iommu.c          |    2 +-
>  drivers/iommu/omap-iommu.c         |    2 +-
>  drivers/media/video/omap3isp/isp.c |    2 +-
>  include/linux/device.h             |    9 +++++
>  include/linux/iommu.h              |   21 +++++++------
>  virt/kvm/iommu.c                   |    4 +-
>  12 files changed, 86 insertions(+), 38 deletions(-)

So the overall work here makes for more code, right?  I fail to see the
benifit, what am I missing?

greg k-h
