Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab1ITKyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 06:54:37 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:58621 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab1ITKyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 06:54:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Subject: Re: [PATCH] iommu/omap: Fix build error with !IOMMU_SUPPORT
Date: Tue, 20 Sep 2011 12:54:38 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.3-gentoo; KDE/4.7.1; x86_64; ; )
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Ohad Ben-Cohen" <ohad@wizery.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1316009259-18052-1-git-send-email-joerg.roedel@amd.com> <201109180202.23123.laurent.pinchart@ideasonboard.com> <20110920100146.GA2078@amd.com>
In-Reply-To: <20110920100146.GA2078@amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109201254.39542.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

On Tuesday 20 September 2011 12:01:46 Roedel, Joerg wrote:
> On Sat, Sep 17, 2011 at 08:02:22PM -0400, Laurent Pinchart wrote:
> > On Wednesday 14 September 2011 16:07:39 Joerg Roedel wrote:
> > > Without this patch it is possible to select the VIDEO_OMAP3
> > > driver which then selects OMAP_IOVMM. But the omap iommu
> > > driver is not compiled without IOMMU_SUPPORT enabled. Fix
> > > that by forcing OMAP_IOMMU and OMAP_IOVMM are enabled before
> > > VIDEO_OMAP3 can be selected.
> > 
> > What about making VIDEO_OMAP3 select IOMMU_SUPPORT instead then ? Your
> > patch would make the OMAP3 ISP driver disappear from the menu until
> > IOMMU_SUPPORT gets turned on, which can confuse users.
> 
> Using 'depends on' rather then 'selects' is common standard in Kconfig.
> You can't select PCI drivers without selecting PCI first, for example.

You wouldn't expect a PCI driver to work without PCI support. My concern is 
that most OMAP3 ISP users won't know that IOMMU supports is required. Feel 
free to ignore it though :-)

> Further selecting whole drivers implicitly isn't a good idea. This can
> grow out of control very quickly.

-- 
Regards,

Laurent Pinchart
