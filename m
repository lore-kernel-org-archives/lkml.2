Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933376Ab1JNREE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 13:04:04 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62797 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab1JNREB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 13:04:01 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.27.118]
In-Reply-To: <20111014133510.GC2198@amd.com>
References: <20110927131222.GL2138@amd.com> <CAK=WgbYG2tpMJ2SikZhm=R9j5kQ6Hm8CGg=q1bko3idzF53Q3Q@mail.gmail.com>
 <20110927181438.GM2138@amd.com> <CAK=WgbbNs5fWHDEputZ=jzU5YN0sn0tf6AETkcsoq_Jbvc2XgQ@mail.gmail.com>
 <20111010094738.GW2138@amd.com> <CAK=WgbZ7Wyax1yfS1jSXw9OdwMtxxidwLO8PTsNUXX9CWzmVrw@mail.gmail.com>
 <20111010153609.GB2138@amd.com> <CAK=WgbbnuO67X46sqS87q2vw2TWq3Ekvw5p1PmXvXinQXMyowg@mail.gmail.com>
 <20111011103820.GF2138@amd.com> <CAK=WgbYOUZNX0OmRwZNO1mMG+3DZXwff+S60ESWixf04HOcbtw@mail.gmail.com>
 <20111014133510.GC2198@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 14 Oct 2011 19:03:39 +0200
Message-ID: <CAK=Wgbar+z_Nm1cDM4bJgrP5yWbjCsVBW=orfYwsZsT7uET8ng@mail.gmail.com>
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

On Fri, Oct 14, 2011 at 3:35 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> This patch looks good. Please include it in the page-size patch-set.

will do.

> Hmm, I'd like to constify the iommu_ops structures in the future. This
> wouldn't work then anymore. How about renaming it to io_page_size
> (because it is the base page-size of the iommu) and let the driver set
> it?

Sure, that'd work. Though asking the driver to provide this feels a
bit redundant, as it already provided this info in the supported page
sizes.

I guess a cleaner solution might be allocating a 'struct iommu' in
which drivers will set a 'const struct iommu_ops *' member. That new
struct would then contain the base page-size and any other state the
iommu core would ever need.

This whole thing is quite marginal though and also very easy to change
later, so we can start with the "driver-provided io_page_size"
approach for now.

> This needs to be (left > 0). The drivers are allowed to unmap more then
> requested, so this value may turn negative.

Good point. 'left' is size_t though, so i'll fix this a bit differently.

> Btw, how have you tested this code?

Of course. Every patch I send is always tested on both OMAP3 (with
omap3isp) and OMAP4 (with rpmsg/remoteproc). In addition, everyone who
uses my wip rpmsg tree (there are several developers who do) is always
testing this without even knowing, as I'm always rebasing that tree on
the latest iommu patches (my wip branches are not linear).

Thanks,
Ohad.
