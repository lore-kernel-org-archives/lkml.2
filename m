Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966382Ab2EOSsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:48:16 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1801 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965807Ab2EOSsO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:48:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 15 May 2012 11:48:02 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Date: Tue, 15 May 2012 20:47:58 +0200
Subject: Re: [PATCH 1/2] iommu/tegra: smmu: Simplify allocation at once
Thread-Topic: [PATCH 1/2] iommu/tegra: smmu: Simplify allocation at once
Thread-Index: Ac0yy0AD7RvKjq47RtmN0zdw5dqLHw==
Message-ID: <20120515.214758.1198702094241248784.hdoyu@nvidia.com>
References: <4FB19677.4040702@wwwdotorg.org><20120515.112649.411607744957826949.hdoyu@nvidia.com><4FB27FA9.20106@wwwdotorg.org>
In-Reply-To: <4FB27FA9.20106@wwwdotorg.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Warren <swarren@wwwdotorg.org> wrote @ Tue, 15 May 2012 18:09:13 +0200:

> On 05/15/2012 02:26 AM, Hiroshi Doyu wrote:
> > Stephen Warren <swarren@wwwdotorg.org> wrote @ Tue, 15 May 2012 01:34:15 +0200:
> > 
> >> On 05/14/2012 01:16 PM, Hiroshi DOYU wrote:
> >>> To simplify the code, alloc necessary data at once.
> >>>
> >>> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> >>> ---
> >>> This patch requires:
> >>>
> >>>     [PATCH 1/2] iommu/tegra: smmu: Add device tree support for SMMU
> >>>         http://marc.info/?l=linux-tegra&m=133663641107327&w=2
> >>>
> >>> Also the above patch requires:
> >>>
> >>>     [PATCH 1/1] dt: Add general DMA window parser
> >>>         http://marc.info/?l=linux-tegra&m=133671302703840&w=2
> >>
> >> I know I've been harping on about dependencies, but you typically only
> >> need to mention them if the dependencies are not already checked into
> >> the branch you expect this patch to be checked into.
> >>
> >>> -	smmu = devm_kzalloc(dev, sizeof(*smmu), GFP_KERNEL);
> >>> +	if (of_property_read_u32(dev->of_node, "nvidia,#asids", &asids))
> >>> +		return -ENODEV;
> >>
> >> I believe you need to change the asids variable from int to u32 to avoid
> >> a warning here.
> > 
> > There's no warning but it's allowed because of "-Wno-pointer-sign". It
> 
> That's odd. I'm sure I have seen this warning recently when calling this
> API, but you're right, I'm not able to trigger that warning right now,
> so this is fine.

Then, either [PATCH v1] or [PATCH v2] would be ok, but v2 may be a bit
better because it's exacltly compatible with that function prototype,
of_property_read_u32(...u32 *).
