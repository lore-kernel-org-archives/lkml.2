Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab1HYOi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 10:38:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:39379 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430Ab1HYOir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 10:38:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,281,1312182000"; 
   d="scan'208";a="45000180"
Subject: Re: [PATCH] DMA: PL330: add missing header
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan <dan.j.williams@intel.com>
Cc: Boojin Kim <boojin.kim@samsung.com>, linux-kernel@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
In-Reply-To: <1314097039.22120.160.camel@vkoul-udesk3>
References: <1314079058-24601-1-git-send-email-boojin.kim@samsung.com>
	 <1314081133.22120.19.camel@vkoul-udesk3>
	 <001101cc6164$fe07ce10$fa176a30$%kim@samsung.com>
	 <1314087342.22120.100.camel@vkoul-udesk3>
	 <20110823082319.GA19622@n2100.arm.linux.org.uk>
	 <1314088367.22120.133.camel@vkoul-udesk3>
	 <20110823093958.GC19622@n2100.arm.linux.org.uk>
	 <1314097039.22120.160.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Aug 2011 20:08:08 +0530
Message-ID: <1314283088.1606.50.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-23 at 16:27 +0530, Koul, Vinod wrote:
> On Tue, 2011-08-23 at 10:39 +0100, Russell King - ARM Linux wrote:
> > On Tue, Aug 23, 2011 at 02:02:47PM +0530, Koul, Vinod wrote:
> > > On Tue, 2011-08-23 at 09:23 +0100, Russell King - ARM Linux wrote:
> > > > On Tue, Aug 23, 2011 at 01:45:42PM +0530, Koul, Vinod wrote:
> > > > > Russell had fixed compilation of pl330 driver, and was supposed to send
> > > > > the fix to Linus as part of his fixes. If thats not done I can send it
> > > > > for next -rc
> > > > 
> > > > That was for amba-pl08x.c, not pl330.c
> > > Okay, thanks.
> > > I will send the patch for dmaengine.h to Linus for next -rc
> > 
> > If you read the original commit, you'll find that scatterlist.h was
> > explicitly removed from dmaengine.h:
> > 
> >     net: remove mm.h inclusion from netdevice.h
> > 
> >     Remove linux/mm.h inclusion from netdevice.h -- it's unused (I've checked ma
> > 
> >     To prevent mm.h inclusion via other channels also extract "enum dma_data_dir
> >     definition into separate header. This tiny piece is what gluing netdevice.h
> >     via "netdevice.h => dmaengine.h => dma-mapping.h => scatterlist.h => mm.h".
> >     Removal of mm.h from scatterlist.h was tried and was found not feasible
> >     on most archs, so the link was cutoff earlier.
> > 
> >     Hope people are OK with tiny include file.
> > 
> >     Note, that mm_types.h is still dragged in, but it is a separate story.
> > 
> >     Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> >     Signed-off-by: David S. Miller <davem@davemloft.net>
> > 
> > So adding scatterlist.h back into dmaengine.h may not be the best idea.
> Yes, looks like that maybe the case. 
> 
> It's rather unfortunate that neither Dan nor me were copied on changes
> done on dmaengine drivers and headers :(
Anyway now we have added the new API of dmaengine_prep_slave_single()
which needs scatterlist.h, any attempt to remove scatterlist wont work.
Either we have to include this in dmaengine.h or any other driver (like
netdevice.h) which includes dmaengine.h


-- 
~Vinod

