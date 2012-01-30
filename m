Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab2A3OtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 09:49:22 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:33063
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753082Ab2A3OtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 09:49:19 -0500
X-SpamScore: -20
X-BigFish: VPS-20(zz9371I1432N98dKzz1202hzz15d4R8275bhz2dhc1bhc31hc1ah668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LYM95Y-02-1KM-02
X-M-MSG: 
Date: Mon, 30 Jan 2012 15:49:09 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stuart Yoder <b08248@gmail.com>, Scott Wood <scottwood@freescale.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH 2/6] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
Message-ID: <20120130144909.GT19255@amd.com>
References: <1327603257-17028-1-git-send-email-joerg.roedel@amd.com>
 <1327603257-17028-3-git-send-email-joerg.roedel@amd.com>
 <CAK=WgbbZB0hGRr84JV4a7c0KvW7VbVzsnCx1PGg=wjoB0OSrYw@mail.gmail.com>
 <20120127102608.GK19255@amd.com>
 <CAK=WgbZQB+76FuJXK82x09CieDmF23zLQ8KbHbEtjnQsc_4axg@mail.gmail.com>
 <20120127130329.GM19255@amd.com>
 <CAK=WgbY+aBwTno4YxGLaxS7Y-R=CS1604+c5j-6EMQSfJeGvTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAK=WgbY+aBwTno4YxGLaxS7Y-R=CS1604+c5j-6EMQSfJeGvTA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 28, 2012 at 10:44:22PM +0200, Ohad Ben-Cohen wrote:
> On Fri, Jan 27, 2012 at 3:03 PM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> > Note that only the read-side is handled by the core. An IOMMU driver may
> > decide to implement a write-side for the geometry which would be not in
> > the core then. Having a dedicated function for the write-side does not
> > make sense because (for now) there is only one upcoming driver requiring
> > this.
> 
> I'd still go with a type-safe interface here, but maybe it's only me.

Well, the idea still stands to replace 'void *data' with something like
'union domain_attr *data'. This isn't as type-safe as dedicated
functions, but still better than void*.

> I'm not so sure how would drivers use these "hardware-specific api
> attr extensions" in general.

Depends on the attribute. For the geometry attribute drivers that
allocate a domain should read out the geometry and only use the range
returned for map/unmap (or fail initialization when the domain geometry
is unexpected).

> Is the intention that only hardware-specific drivers will use them ? I
> guess that generic drivers won't be able to use them, because their
> behavior will not be well-defined across all hardware implementations.

Hardware specific attributes are intended, but not limited to hardware
specific drivers. A generic driver that _may_ run on a given hardware
can use a hardware specific attribute too. If it doesn't run on this
hardware it will just get -EINVAL back.

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

