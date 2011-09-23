Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab1IWPUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 11:20:43 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:17022
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752996Ab1IWPUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 11:20:42 -0400
X-SpamScore: -25
X-BigFish: VPS-25(zz146fK1432N98dK4015Lzz1202hzz15d4R8275bhz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LRZEKL-02-03U-02
X-M-MSG: 
Date: Fri, 23 Sep 2011 17:19:36 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Greg KH <gregkh@suse.de>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] Driver core: Add iommu_ops to bus_type
Message-ID: <20110923151936.GA2138@amd.com>
References: <1316708102-16250-1-git-send-email-joerg.roedel@amd.com>
 <1316708102-16250-3-git-send-email-joerg.roedel@amd.com>
 <20110922201155.GA12788@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110922201155.GA12788@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 04:11:55PM -0400, Greg KH wrote:
> On Thu, Sep 22, 2011 at 06:14:54PM +0200, Joerg Roedel wrote:
> > This is the starting point to make the iommu_ops used for
> > the iommu-api a per-bus-type structure. It is required to
> > easily implement bus-specific setup in the iommu-layer.
> > The first user will be the iommu-group attribute in sysfs.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  drivers/base/bus.c     |   29 +++++++++++++++++++++++++++++
> >  drivers/iommu/iommu.c  |    4 ++++
> >  include/linux/device.h |   10 ++++++++++
> >  include/linux/iommu.h  |    2 ++
> >  4 files changed, 45 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> > index 000e7b2..b3014fe 100644
> > --- a/drivers/base/bus.c
> > +++ b/drivers/base/bus.c
> > @@ -1028,6 +1028,35 @@ void bus_sort_breadthfirst(struct bus_type *bus,
> >  }
> >  EXPORT_SYMBOL_GPL(bus_sort_breadthfirst);
> >  
> > +#ifdef CONFIG_IOMMU_API
> > +/**
> 
> This ifdef really isn't needed, is it?  I think you can remove it.

Actually, iommu_bus_init is only defined with CONFIG_IOMMU_API=y. But
you are right, the ifdef is not very nice here. I solved this situation
by moving the function into drivers/iommu/iommu.c which is only compiled
with CONFIG_IOMMU_API=y anyway, so no ifdef is required anymore.

> Other than that, looks much better, thanks.

Great, I sent a new round if these patches. Moving this function to
another file caused some changes in the following patches too during the
rebase.

Thanks,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

