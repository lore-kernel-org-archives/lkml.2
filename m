Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab1HWJkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 05:40:25 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45948 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab1HWJkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 05:40:23 -0400
Date: Tue, 23 Aug 2011 10:39:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Koul, Vinod" <vinod.koul@intel.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: Boojin Kim <boojin.kim@samsung.com>, linux-kernel@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
Subject: Re: [PATCH] DMA: PL330: add missing header
Message-ID: <20110823093958.GC19622@n2100.arm.linux.org.uk>
References: <1314079058-24601-1-git-send-email-boojin.kim@samsung.com> <1314081133.22120.19.camel@vkoul-udesk3> <001101cc6164$fe07ce10$fa176a30$%kim@samsung.com> <1314087342.22120.100.camel@vkoul-udesk3> <20110823082319.GA19622@n2100.arm.linux.org.uk> <1314088367.22120.133.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314088367.22120.133.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 02:02:47PM +0530, Koul, Vinod wrote:
> On Tue, 2011-08-23 at 09:23 +0100, Russell King - ARM Linux wrote:
> > On Tue, Aug 23, 2011 at 01:45:42PM +0530, Koul, Vinod wrote:
> > > Russell had fixed compilation of pl330 driver, and was supposed to send
> > > the fix to Linus as part of his fixes. If thats not done I can send it
> > > for next -rc
> > 
> > That was for amba-pl08x.c, not pl330.c
> Okay, thanks.
> I will send the patch for dmaengine.h to Linus for next -rc

If you read the original commit, you'll find that scatterlist.h was
explicitly removed from dmaengine.h:

    net: remove mm.h inclusion from netdevice.h

    Remove linux/mm.h inclusion from netdevice.h -- it's unused (I've checked ma

    To prevent mm.h inclusion via other channels also extract "enum dma_data_dir
    definition into separate header. This tiny piece is what gluing netdevice.h
    via "netdevice.h => dmaengine.h => dma-mapping.h => scatterlist.h => mm.h".
    Removal of mm.h from scatterlist.h was tried and was found not feasible
    on most archs, so the link was cutoff earlier.

    Hope people are OK with tiny include file.

    Note, that mm_types.h is still dragged in, but it is a separate story.

    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

So adding scatterlist.h back into dmaengine.h may not be the best idea.
