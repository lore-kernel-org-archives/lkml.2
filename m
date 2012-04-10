Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416Ab2DJVDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 17:03:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381Ab2DJVDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 17:03:43 -0400
Message-ID: <1334091801.3799.387.camel@bling.home>
Subject: Re: [RFC PATCH 0/3] IOMMU groups
From: Alex Williamson <alex.williamson@redhat.com>
To: david@gibson.dropbear.id.au, dwmw2@infradead.org
Cc: iommu@lists.linux-foundation.org, qemu-devel@nongnu.org,
        joerg.roedel@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 10 Apr 2012 15:03:21 -0600
In-Reply-To: <20120402203721.28977.95285.stgit@bling.home>
References: <20120402203721.28977.95285.stgit@bling.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ping.  Does this approach look like it could satisfy your desire for a
more integrated group layer?  I'd really like to move VFIO forward,
we've been stalled on this long enough.  David Woodhouse, I think this
provides the quirking you're looking for for device like the Ricoh, do
you have any other requirements for a group layer?  Thanks,

Alex

On Mon, 2012-04-02 at 15:14 -0600, Alex Williamson wrote:
> This series attempts to make IOMMU device grouping a slightly more
> integral part of the device model.  iommu_device_groups were originally
> introduced to support the VFIO user space driver interface which needs
> to understand the granularity of device isolation in order to ensure
> security of devices when assigned for user access.  This information
> was provided via a simple group identifier from the IOMMU driver allowing
> VFIO to walk devices and assemble groups itself.
> 
> The feedback received from this was that groups should be the effective
> unit of work for the IOMMU API.  The existing model of allowing domains
> to be created and individual devices attached ignores many of the
> restrictions of the IOMMU, whether by design, by topology or by defective
> devices.  Additionally we should be able to use the grouping information
> at the dma ops layer for managing domains and quirking devices.
> 
> This series is a sketch at implementing only those aspects and leaving
> everything else about the multifaceted hairball of Isolation groups for
> another API.  Please comment and let me know if this seems like the
> direction we should be headed.  Thanks,
> 
> Alex
> 
> 
> ---
> 
> Alex Williamson (3):
>       iommu: Create attach/detach group interface
>       iommu: Create basic group infrastructure and update AMD-Vi & Intel VT-d
>       iommu: Introduce iommu_group
> 
> 
>  drivers/iommu/amd_iommu.c   |   50 ++++++----
>  drivers/iommu/intel-iommu.c |   76 ++++++++--------
>  drivers/iommu/iommu.c       |  210 ++++++++++++++++++++++++++++++++++++++-----
>  include/linux/device.h      |    2 
>  include/linux/iommu.h       |   43 +++++++++
>  5 files changed, 301 insertions(+), 80 deletions(-)



