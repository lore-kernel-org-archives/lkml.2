Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab2BFRCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 12:02:39 -0500
Received: from mxout1.idt.com ([157.165.5.25]:58261 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810Ab2BFRCi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 12:02:38 -0500
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 01/11] dmaengine: add context parameter toprep_slave_sgand prep_dma_cyclic
Date: Mon, 6 Feb 2012 09:02:15 -0800
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E55202872AB1@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <20120206155318.GA20852@flint.arm.linux.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 01/11] dmaengine: add context parameter toprep_slave_sgand prep_dma_cyclic
Thread-Index: Aczk54Ry290eMbcnTtamBgF6/FiHAgACE10Q
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com> <1328218341-31436-2-git-send-email-alexandre.bounine@idt.com> <20120202214350.GB4432@flint.arm.linux.org.uk> <0CE8B6BE3C4AD74AB97D9D29BD24E55202872683@CORPEXCH1.na.ads.idt.com> <1328529182.26182.92.camel@vkoul-udesk3> <0CE8B6BE3C4AD74AB97D9D29BD24E552028729F9@CORPEXCH1.na.ads.idt.com> <1328542134.26182.111.camel@vkoul-udesk3> <20120206155318.GA20852@flint.arm.linux.org.uk>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Russell King <rmk@arm.linux.org.uk>, Vinod Koul <vinod.koul@intel.com>
CC: <dan.j.williams@intel.com>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, Jassi Brar <jaswinder.singh@linaro.org>,
        "Kumar Gala" <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 10:53 AM, Russell King wrote:
> 
> On Mon, Feb 06, 2012 at 08:58:54PM +0530, Vinod Koul wrote:
> > On Mon, 2012-02-06 at 07:04 -0800, Bounine, Alexandre wrote:
> > > I was thinking about keeping the original scatterlist for dmac
> unchanged,
> > > but allocating another scatterlist in rio_dma_prep_slave_sg() and
> chaining
> > > two lists together. After it passed to device specific function,
it
> parses
> > > first section of the chain for additional transfer parameters and
> use
> > > following scatterlist as intended for dmac.
> > hmmm, but that wouldn't make it generic for other systems like
> proposed
> > MSM box mode..., right?
> > >
> > > But Russell's idea (See https://lkml.org/lkml/2012/2/3/269 ) seems
> to be
> > > a better way without added complexity and I am ready to take that
> path and
> > > make new patches if you and Dan agree with it.
> > but it still doesn't fix his concerns for the using void pointer.
> 
> It helps because it makes it easier to find those drivers who are not
> using the generic interface (and so would be tied to their particular
> DMA engine.)
> 

What if we introduce another dma_transaction_type like DMA_SLAVE_EXT
(extended?).
In this case all devices that adhere to the generic SLAVE interface
still be
registered as DMA_SLAVE and those that do not follow generic route use
DMA_SLAVE_EXT.

