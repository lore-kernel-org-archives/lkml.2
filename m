Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab1IFKQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 06:16:26 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:13873
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753316Ab1IFKQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 06:16:19 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432N98dKzz1202hzz15d4Rz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LR3J5Y-02-0RG-02
X-M-MSG: 
Date: Tue, 6 Sep 2011 12:15:35 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC 0/7] iommu: fixes & extensions
Message-ID: <20110906101535.GT16691@amd.com>
References: <1314984756-4400-1-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1314984756-4400-1-git-send-email-ohad@wizery.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 01:32:29PM -0400, Ohad Ben-Cohen wrote:
> 5 first patches are relatively small iommu fixes/cleanups.
> 
> 2 last patches are proposals for core iommu extensions:
> - Add fault report mechanism, needed for recovery of remote processors
>   trying to access unmapped addresses.
> - Add splitting of memory regions to pages in the iommu core itself
>   (according to hardware capabilities as advertised by the iommu drivers).
>   This is needed to prevent duplication of this logic by
>   the iommu users/drivers themselves.
> 
> The patches are based on Joerg's arm/omap branch.
> 
> Tested with OMAP3 (omap3isp) + OMAP4 (rpmsg/remoteproc).
> 
> Laurent Pinchart (1):
>   iommu/omap-iovmm: support non page-aligned buffers in iommu_vmap
> 
> Ohad Ben-Cohen (6):
>   iommu/omap: cleanup: remove a redundant 'return' statement
>   iommu/core: use the existing IS_ALIGNED macro
>   iommu/omap: ->unmap() should return order of unmapped page
>   iommu/msm: ->unmap() should return order of unmapped page
>   iommu/core: add fault reporting
>   iommu/core: split mapping to page sizes as supported by the hardware

Ok, I applied 1-5 to their respective branches. Patch 6 needs some more
discussion to make sure the interface is generally usable. Patch 7 seems
to be a starting point for now. This definitly requires conversion of
the other IOMMU drivers too.
Please make individual patch-sets from patch 6 and 7 respectivly.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

