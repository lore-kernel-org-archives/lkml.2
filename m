Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934482Ab1KJNIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 08:08:19 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:37875
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934318Ab1KJNIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 08:08:13 -0500
X-SpamScore: -24
X-BigFish: VPS-24(zzbb2dK9371K1432N98dKzz1202hzz15d4R8275bh8275dhz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LUG4HE-01-BJ5-02
X-M-MSG: 
Date: Thu, 10 Nov 2011 14:08:01 +0100
From: Joerg Roedel <Joerg.Roedel@amd.com>
To: cody <mail.kai.huang@gmail.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, <iommu@lists.linux-foundation.org>,
        <linux-omap@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Woodhouse <dwmw2@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        KyongHo Cho <pullip.cho@samsung.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 2/7] iommu/core: split mapping to page sizes as
 supported by the hardware
Message-ID: <20111110130801.GC13213@amd.com>
References: <1318850846-16066-1-git-send-email-ohad@wizery.com>
 <1318850846-16066-3-git-send-email-ohad@wizery.com>
 <CANqQZNH1YRSgYRVxceicQ3szD=t7zeJjhJKEQ30PeKsxtj5V+A@mail.gmail.com>
 <CAK=WgbZbfCRJqA-wwHN=iLH6rYyoKjJCaL0zMfY93Tg6Jw2uvA@mail.gmail.com>
 <4EBBC090.4070109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4EBBC090.4070109@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 08:16:16PM +0800, cody wrote:
> On 11/10/2011 03:31 PM, Ohad Ben-Cohen wrote:
> >On Thu, Nov 10, 2011 at 8:17 AM, Kai Huang<mail.kai.huang@gmail.com>  wrote:
> >>Seems the unmap function don't take phys as parameter, does this mean
> >>domain->ops->unmap will walk through the page table to find out the
> >>actual page size?
> >The short answer is yes, and furthermore, we also consider to remove
> >the size param from domain->ops->unmap entirely at some point.
> >
> >We had a long discussion about it, please see:
> >
> >https://lkml.org/lkml/2011/10/10/234
> Yes I've seen your discussion, I followed this thread from beginning:)
> 
> How about the IOTLB flush? As I said I think we need to consider
> that IOMMU (even does not exist now) may have some limitation on
> IOTLB flush, and hiding page size from IOTLB flush code may hurt
> performance, or even worse, trigger undefined behaviors.

We can only care about IOMMUs that exist today or ones that will exist
and we already know of.
In general for the hardware I know of a page-size is not required for
implementing unmap operations. Requiring this would imply that any user
of the IOMMU-API needs to keeps track of the page-sizes used to map a
given area.
This would be a huge burden which is not really necessary because the
IOMMU driver already has this information and can return it to the user.
So if you want to change that you need a very good reason for it.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

