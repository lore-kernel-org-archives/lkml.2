Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab1KHM52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 07:57:28 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50002 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab1KHM5X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 07:57:23 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.63.171]
In-Reply-To: <1318850846-16066-1-git-send-email-ohad@wizery.com>
References: <1318850846-16066-1-git-send-email-ohad@wizery.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 8 Nov 2011 14:57:02 +0200
Message-ID: <CAK=Wgbb5K+rqPNdM2sC8z+9d4-hdcPwV-vXk6gcAYWaO+dVx3w@mail.gmail.com>
Subject: Re: [PATCH v4 0/7] iommu: split mapping to page sizes as supported by
 the hardware
To: iommu@lists.linux-foundation.org, Joerg Roedel <Joerg.Roedel@amd.com>
Cc: linux-omap@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, Hiroshi Doyu <hdoyu@nvidia.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        KyongHo Cho <pullip.cho@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg, gentle reminder. thanks.

On Mon, Oct 17, 2011 at 1:27 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> v3->v4:
> - simplify splitter logic (Joerg)
> - declare supported page-sizes in the iommu_ops, without extending iommu_register (Joerg)
> - iommu_unmap should now return bytes too (Joerg)
> - don't cache min_pgsize anymore (Joerg)
> - handle cases when ->unmap() actually unmaps more than requested (Joerg)
> - unroll iommu_unmap completely in case it fails (KyongHo)
> - use size_t for size parameters (KyongHo)
> - add a patch to remove the bytes->order->bytes conversion we had
> - rabase to master branch of the iommu tree (Joerg)
>
> v2->v3:
> - s/KB/KiB/ (David W)
>
> v1->v2:
> - split to patches (by keeping the old code around until all drivers are converted) (Joerg)
>
> Tested with OMAP3 (omap3isp) and OMAP4 (rpmsg/remoteproc).
> Compile tested with X86_64.
>
> Ohad Ben-Cohen (7):
>  iommu/core: stop converting bytes to page order back and forth
>  iommu/core: split mapping to page sizes as supported by the hardware
>  iommu/omap: announce supported page sizes
>  iommu/msm: announce supported page sizes
>  iommu/amd: announce supported page sizes
>  iommu/intel: announce supported page sizes
>  iommu/core: remove the temporary pgsize settings
>
>  drivers/iommu/amd_iommu.c   |   32 +++++++++---
>  drivers/iommu/intel-iommu.c |   30 ++++++++---
>  drivers/iommu/iommu.c       |  119 ++++++++++++++++++++++++++++++++++++++----
>  drivers/iommu/msm_iommu.c   |   25 ++++-----
>  drivers/iommu/omap-iommu.c  |   18 +++---
>  drivers/iommu/omap-iovmm.c  |   17 ++----
>  include/linux/iommu.h       |   26 +++++++--
>  virt/kvm/iommu.c            |    8 ++--
>  8 files changed, 205 insertions(+), 70 deletions(-)
>
> --
> 1.7.4.1
>
>
