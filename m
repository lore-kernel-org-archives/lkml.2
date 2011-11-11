Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821Ab1KKNZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 08:25:30 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:37690
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751948Ab1KKNZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 08:25:28 -0500
X-SpamScore: -12
X-BigFish: VPS-12(zz98dKzz1202hzz15d4Rz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LUHZY7-01-35V-02
X-M-MSG: 
Date: Fri, 11 Nov 2011 14:24:11 +0100
From: Joerg Roedel <Joerg.Roedel@amd.com>
To: Stepan Moskovchenko <stepanm@codeaurora.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        Kai Huang <mail.kai.huang@gmail.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        <iommu@lists.linux-foundation.org>, <linux-omap@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Hiroshi Doyu <hdoyu@nvidia.com>,
        KyongHo Cho <pullip.cho@samsung.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 2/7] iommu/core: split mapping to page sizes as
 supported by the hardware
Message-ID: <20111111132411.GH13213@amd.com>
References: <1318850846-16066-1-git-send-email-ohad@wizery.com>
 <1318850846-16066-3-git-send-email-ohad@wizery.com>
 <CANqQZNH1YRSgYRVxceicQ3szD=t7zeJjhJKEQ30PeKsxtj5V+A@mail.gmail.com>
 <1320938930.22195.17.camel@i7.infradead.org>
 <20111110170918.GE13213@amd.com>
 <4EBC3E20.20301@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4EBC3E20.20301@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 01:12:00PM -0800, Stepan Moskovchenko wrote:
> I have been experimenting with an iommu_map_range call, which maps a
> given scatterlist of discontiguous physical pages into a contiguous
> virtual region at a given IOVA. This has some performance advantages
> over just calling iommu_map iteratively. First, it reduces the
> amount of table walking / calculation needed for mapping each page,
> given how you know that all the pages will be mapped into a single
> virtually-contiguous region (so in most cases, the first-level table
> calculation can be reused). Second, it allows one to defer the TLB
> (and sometimes cache) maintenance operations until the entire
> scatterlist has been mapped, rather than doing a TLB invalidate
> after mapping each page, as would have been the case if iommu_map
> were just being called from within a loop. Granted, just using
> iommu_map many times may be acceptable on the slow path, but I have
> seen significant performance gains when using this approach on the
> fast path.

Yes, from a performance point-of-view that makes sense, as an addition
to the existing iommu_map interface. Are the pages in the list allowed
to have different page-sizes?


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

