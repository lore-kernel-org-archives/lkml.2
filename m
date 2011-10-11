Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab1JKKUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 06:20:39 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:4222 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab1JKKUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 06:20:36 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz9371K1432N98dKzz1202hzz15d4R8275bhz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LSWCQ4-02-3YF-02
X-M-MSG: 
Date: Tue, 11 Oct 2011 12:19:36 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH v3 1/6] iommu/core: split mapping to page sizes as
 supported by the hardware
Message-ID: <20111011101936.GD2138@amd.com>
References: <20110927100505.GH2138@amd.com>
 <CAK=WgbahwY+7Ux-RjW2Tw9WBSwZnYuTMZ2NQASWyOXQ3zF6qFg@mail.gmail.com>
 <20110927131222.GL2138@amd.com>
 <CAK=WgbYG2tpMJ2SikZhm=R9j5kQ6Hm8CGg=q1bko3idzF53Q3Q@mail.gmail.com>
 <20110927181438.GM2138@amd.com>
 <CAK=WgbbNs5fWHDEputZ=jzU5YN0sn0tf6AETkcsoq_Jbvc2XgQ@mail.gmail.com>
 <20111010094738.GW2138@amd.com>
 <CAK=WgbZ7Wyax1yfS1jSXw9OdwMtxxidwLO8PTsNUXX9CWzmVrw@mail.gmail.com>
 <20111010153609.GB2138@amd.com>
 <CAK=WgbYR_qx53Z7s3R=q29KYo8ebYCH9H9=2OrrWXWMv6=-iOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAK=WgbYR_qx53Z7s3R=q29KYo8ebYCH9H9=2OrrWXWMv6=-iOQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On Mon, Oct 10, 2011 at 01:02:46PM -0400, Ohad Ben-Cohen wrote:
> On Mon, Oct 10, 2011 at 5:36 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> > Yes, somthing like that. Probably the iommu_ops->unmap function should
> > be turned into a unmap_page function call which only takes an iova and
> > no size parameter. The iommu-driver unmaps the page pointing to that
> > iova and returns the size of the page unmapped. This still allows the
> > simple implementation for the unmap-call.
> 
> Yes, exactly. It will take some time to migrate all drivers (today we
> have 4 drivers, each of which is implementing a slightly different
> ->unmap() semantics), but at least let's not accept any new driver
> that doesn't adhere to this, otherwise it's going to be even harder
> for the API to evolve.

Agreed. We should change the existing drivers one-by-one.

> > We don't need to really enforce the calls to be symetric. But we can
> > define that we only give the guarantee about what will be unmapped
> > when the calls are symetric.
> 
> Sounds good to me. I'll add this to the kernel doc patch (which I'll
> submit after this patch set materializes), and when/if we move to
> symmetric only, we will update it.

Great. So if no one disagrees with this direction (this means all the
other people on Cc :) ) it is the way to.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

