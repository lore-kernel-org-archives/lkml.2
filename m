Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab1JJRDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 13:03:11 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47775 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab1JJRDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 13:03:09 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.27.118]
In-Reply-To: <20111010153609.GB2138@amd.com>
References: <1316195506-9777-1-git-send-email-ohad@wizery.com>
 <1316195506-9777-2-git-send-email-ohad@wizery.com> <20110927100505.GH2138@amd.com>
 <CAK=WgbahwY+7Ux-RjW2Tw9WBSwZnYuTMZ2NQASWyOXQ3zF6qFg@mail.gmail.com>
 <20110927131222.GL2138@amd.com> <CAK=WgbYG2tpMJ2SikZhm=R9j5kQ6Hm8CGg=q1bko3idzF53Q3Q@mail.gmail.com>
 <20110927181438.GM2138@amd.com> <CAK=WgbbNs5fWHDEputZ=jzU5YN0sn0tf6AETkcsoq_Jbvc2XgQ@mail.gmail.com>
 <20111010094738.GW2138@amd.com> <CAK=WgbZ7Wyax1yfS1jSXw9OdwMtxxidwLO8PTsNUXX9CWzmVrw@mail.gmail.com>
 <20111010153609.GB2138@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 10 Oct 2011 19:02:46 +0200
Message-ID: <CAK=WgbYR_qx53Z7s3R=q29KYo8ebYCH9H9=2OrrWXWMv6=-iOQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] iommu/core: split mapping to page sizes as
 supported by the hardware
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

On Mon, Oct 10, 2011 at 5:36 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> The master branch is best to base your patches on for generic work.

Oh, great. thanks.

> It can happen when there is a bug somewhere :)

Hmm, bug ? ;)

Ok, I'll add a BUG_ON :)

> Yes, somthing like that. Probably the iommu_ops->unmap function should
> be turned into a unmap_page function call which only takes an iova and
> no size parameter. The iommu-driver unmaps the page pointing to that
> iova and returns the size of the page unmapped. This still allows the
> simple implementation for the unmap-call.

Yes, exactly. It will take some time to migrate all drivers (today we
have 4 drivers, each of which is implementing a slightly different
->unmap() semantics), but at least let's not accept any new driver
that doesn't adhere to this, otherwise it's going to be even harder
for the API to evolve.

> This change is no requirement for this patch-set, but if we agree on it
> this patch-set should keep that direction in mind.

Definitely, thanks.

> We don't need to really
> enforce the calls to be symetric. But we can define that we only give
> the guarantee about what will be unmapped when the calls are symetric.

Sounds good to me. I'll add this to the kernel doc patch (which I'll
submit after this patch set materializes), and when/if we move to
symmetric only, we will update it.

> The alternative is that we implement page-splitting in the iommu_unmap
> function. But that introduces complexity I am not sure we really need.

Yeah, me neither.

> Yes, this get_order thing should be changes to size long-term.

Good. That should be a simple change, I'll do it after this patch set.

Thanks,
Ohad.
