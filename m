Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab1IGT3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 15:29:34 -0400
Received: from 8bytes.org ([88.198.83.132]:39698 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab1IGT3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 15:29:33 -0400
Date: Wed, 7 Sep 2011 21:29:31 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Greg KH <gregkh@suse.de>
Cc: Joerg Roedel <joerg.roedel@amd.com>, iommu@lists.linux-foundation.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] IOMMU: Make iommu_ops per-bus_type
Message-ID: <20110907192931.GB31674@8bytes.org>
References: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com> <20110907184840.GB920@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110907184840.GB920@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 11:48:40AM -0700, Greg KH wrote:
> On Wed, Sep 07, 2011 at 05:41:43PM +0200, Joerg Roedel wrote:
> > Diffstat:
> > 
> >  arch/ia64/kvm/kvm-ia64.c           |    3 +-
> >  arch/x86/kvm/x86.c                 |    3 +-
> >  drivers/base/bus.c                 |   16 ++++++++++
> >  drivers/iommu/amd_iommu.c          |    2 +-
> >  drivers/iommu/intel-iommu.c        |    2 +-
> >  drivers/iommu/iommu.c              |   58 ++++++++++++++++++++++++------------
> >  drivers/iommu/msm_iommu.c          |    2 +-
> >  drivers/iommu/omap-iommu.c         |    2 +-
> >  drivers/media/video/omap3isp/isp.c |    2 +-
> >  include/linux/device.h             |    9 +++++
> >  include/linux/iommu.h              |   21 +++++++------
> >  virt/kvm/iommu.c                   |    4 +-
> >  12 files changed, 86 insertions(+), 38 deletions(-)
> 
> So the overall work here makes for more code, right?  I fail to see the
> benifit, what am I missing?

Yes, the code that moves code out of the IOMMU drivers is not included
here. This is only the infrastructure for future code generalization in
the IOMMU driver. That is why the iommu_bus_init() function in patch 2
is still empty :)
For example, the IOMMU drivers on x86 implement device-notifier
callbacks to know when devices are added or removed to do iommu-specific
setup. The iommu drivers also scan over the devices on a bus to do
initialization. All this device-walking code and the notifiers can be
moved to generic IOMMU code leaving only the specific setup routines in
the iommu drivers.

Regards,

	Joerg

