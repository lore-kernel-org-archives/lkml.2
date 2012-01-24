Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab2AXOZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 09:25:26 -0500
Received: from 8bytes.org ([88.198.83.132]:58398 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756694Ab2AXOZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 09:25:22 -0500
Date: Tue, 24 Jan 2012 15:25:21 +0100
From: "joro@8bytes.org" <joro@8bytes.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Hiroshi Doyu <hdoyu@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-mm-sig-bounces@lists.linaro.org" 
	<linaro-mm-sig-bounces@lists.linaro.org>
Subject: Re: [PATCH 2/2] ARM: IOMMU: Tegra30: Add iommu_ops for SMMU driver
Message-ID: <20120124142521.GE6269@8bytes.org>
References: <1325747509-29665-1-git-send-email-hdoyu@nvidia.com> <1325747509-29665-3-git-send-email-hdoyu@nvidia.com> <20120123154310.GC6269@8bytes.org> <20120124.154121.1062920821192552748.hdoyu@nvidia.com> <20120124134601.GT27414@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124134601.GT27414@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 03:46:01PM +0200, Felipe Balbi wrote:
> On Tue, Jan 24, 2012 at 02:41:21PM +0100, Hiroshi Doyu wrote:
> > Actually I really like the concept of this "domain" now, which hides
> > the H/W hierarchy from users.
> > 
> > But in Tegra SMMU/GART case, there's a single one IOMMU device in the
> > system. Keeping a iommu device list in a domain and iterating iommu
> > device list in each iommu_ops seem to be so nice, but I'm afraid that
> > this may be a bit too much when one already knows that there's only
> > one IOMMU device in the system.
> >
> > If there's no actual problem for 1-1 mapping between IOMMU H/Ws and
> > domains, I think that it may not so bad to keep the original code(1-1)
> > for GART and SMMU. What do you think?
> 
> I think it boils down to "extensability". If you can truly/fully
> guarantee that there will *always* be a single IOMMU on all upcoming
> Tegras, then it's really overkill.
> 
> But if there's even a remote possibility of the HW being changed and you
> end up with more IOMMUs, things start to feel necessary for the sake of
> making it easy to extend.

Right. But I am fine with the logic as-is when there is only one SMMU in
the system. But please also change the IOMMU driver so that it really
only initializes a single SMMU. When boards pop up with more than one
you we notice that assumption in the code again and are reminded to
change it.


	Joerg

