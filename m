Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab2A0NDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 08:03:42 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:47058
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754744Ab2A0NDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 08:03:41 -0500
X-SpamScore: -20
X-BigFish: VPS-20(zz9371I1432N98dKzz1202hzz15d4R8275bhz2dhc1bhc31hc1ah668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LYGK9V-01-8OF-02
X-M-MSG: 
Date: Fri, 27 Jan 2012 14:03:29 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stuart Yoder <b08248@gmail.com>, Scott Wood <scottwood@freescale.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH 2/6] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
Message-ID: <20120127130329.GM19255@amd.com>
References: <1327603257-17028-1-git-send-email-joerg.roedel@amd.com>
 <1327603257-17028-3-git-send-email-joerg.roedel@amd.com>
 <CAK=WgbbZB0hGRr84JV4a7c0KvW7VbVzsnCx1PGg=wjoB0OSrYw@mail.gmail.com>
 <20120127102608.GK19255@amd.com>
 <CAK=WgbZQB+76FuJXK82x09CieDmF23zLQ8KbHbEtjnQsc_4axg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAK=WgbZQB+76FuJXK82x09CieDmF23zLQ8KbHbEtjnQsc_4axg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 01:00:02PM +0200, Ohad Ben-Cohen wrote:
> On Fri, Jan 27, 2012 at 12:26 PM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> > But probably we can replace the 'void *data' with a 'union
> > domain_attr'? This will give us some type-safety.
> 
> I was thinking that since the geometry concept is actually handled by
> the core itself, it could probably have its own dedicated function.

Note that only the read-side is handled by the core. An IOMMU driver may
decide to implement a write-side for the geometry which would be not in
the core then. Having a dedicated function for the write-side does not
make sense because (for now) there is only one upcoming driver requiring
this. So we either end up with an asymetric interface for read and write
or with an api function implemented by only one driver.

I think dedicated functions also make the API harder to use because a
developer first needs to find out if a property is read/written by a
dedicated function or the set/get-attr interface.

The next attribute I have in mind btw. is the default-domain attribute
which can be used set by the core to tell the iommu driver that dma-api
specific optimizations can be applied to this domain.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

