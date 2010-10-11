Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab0JKFLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 01:11:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:43532 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773Ab0JKFLn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 01:11:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,311,1283756400"; 
   d="scan'208";a="845791696"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "K V, Ramesh B" <ramesh.b.k.v@intel.com>,
        "yong.y.wang@linux.intel.com" <yong.y.wang@linux.intel.com>
Date: Mon, 11 Oct 2010 10:41:25 +0530
Subject: RE: [PATCH 6/6] intel_mid_dma: change the slave interface
Thread-Topic: [PATCH 6/6] intel_mid_dma: change the slave interface
Thread-Index: ActnDibybvlSV25pQqGMnzDg5GR4swB6mLmw
Message-ID: <438BB0150E931F4B9CE701519A44630104BE486B2A@bgsmsx502.gar.corp.intel.com>
References: <1286188723-6341-1-git-send-email-vinod.koul@intel.com>
 <AANLkTi=8dV1EaAsT-Gkjkb-UY9R10r8LFQxMK3xQOwDw@mail.gmail.com>
In-Reply-To: <AANLkTi=8dV1EaAsT-Gkjkb-UY9R10r8LFQxMK3xQOwDw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, Oct 8, 2010 at 10:58 PM, dan.j.williams@gmail.com wrote:
> On Mon, Oct 4, 2010 at 3:38 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> > In 2.6.36 kernel, dma slave control command was introduced,
> > this patch changes the intel-mid-dma driver to this
> > new kernel slave interface
> >
> > Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> > ---
> [..]
> > +static int dma_slave_control(struct dma_chan *chan, unsigned long arg)
> > +{
> > +       struct intel_mid_dma_chan       *midc = to_intel_mid_dma_chan(chan);
> > +       struct dma_slave_config  *slave = (struct dma_slave_config *)arg;
> > +       struct intel_mid_dma_slave *mid_slave;
> > +
> > +       BUG_ON(!midc);
> > +       BUG_ON(!slave);
> > +       pr_debug("MDMA: slave control called\n");
> > +
> > +       mid_slave = to_intel_mid_dma_slave(slave);
> 
> I know this was the initial recommendation to support custom
> extensions to dma_slave_config, but this isn't safe.  How does this
> routine know that that 'slave' is embedded in an intel_mid_dma_slave
> structure.  I applied it as is, but I think we need a better approach.
> 
> Maybe a per device alloc_dma_slave_config() such that ->dma_control()
> can assume the driver allocated the dma_slave_config.  As it stands
> nothing in the calling convention guarantees type safety.


Dan,
Thanks for applying the patches.

I had thought thru this earlier, yes I agree that it is not fully safe to 
*assume* that intel_mid_dma_slave embeds the dma_slave_config structure.

But we can also argue that since this is DMA_SLAVE device and device needs to 
always pass controller specific arguments and hence knows about this controller,
so will have such a thing in place.
Yes but this can be easily abused.

Another alternative is to maintain the channel->private pointer for these sort 
of details as we were doing previously...

Thoughts...?

~Vinod



