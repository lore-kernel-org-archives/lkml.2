Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343Ab2CJCyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 21:54:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50154 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759233Ab2CJCyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 21:54:41 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/4] spi-topcliff-pch: Modify pci-bus number dynamically to get DMA device info
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Wolfram Sang <w.sang@pengutronix.de>
In-Reply-To: <CANKRQniO55ZO+15Wt63Jtj4_MJk3b04_KXZT4bcrOaJjBedzyQ@mail.gmail.com>
References: <1323403905-3432-1-git-send-email-tomoya.rohm@gmail.com> <CANKRQniO55ZO+15Wt63Jtj4_MJk3b04_KXZT4bcrOaJjBedzyQ@mail.gmail.com>
Date: Fri, 09 Mar 2012 16:50:35 -0700
Message-Id: <20120309235036.05D933E0950@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jan 2012 11:34:43 +0900, Tomoya MORINAGA <tomoya.rohm@gmail.com> wrote:
> Hi Grant.
> 
> More than a month has been passed since I posted the following patches.
> However still not reviewed yet.
> 
> [PATCH 1/4] spi-topcliff-pch: Modify pci-bus number dynamically to get
> DMA device info
> [PATCH 2/4] spi-topcliff-pch: Fix issue for transmitting over 4KByte
> [PATCH 3/4][RESEND] spi-topcliff-pch: supports a spi mode setup and
> bit order setup by IO control
> [PATCH 4/4] spi-topcliff-pch: add recovery processing in case wait-event timeout
> 
> Could you review these ?

I'm working through my backlog now.  A big part of the problem is my
method of dealing with pending patches really sucked.  I've switched
to using notmuch-vim, which seems to be a much better system for tracking
email that I need to pay attention to.

g.

> 
> thanks,
> tomoya
> 
> 2011/12/9 Tomoya MORINAGA <tomoya.rohm@gmail.com>:
> > Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
> > ---
> >  drivers/spi/spi-topcliff-pch.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
> > index 99ec279..fcd9462 100644
> > --- a/drivers/spi/spi-topcliff-pch.c
> > +++ b/drivers/spi/spi-topcliff-pch.c
> > @@ -920,7 +920,8 @@ static void pch_spi_request_dma(struct pch_spi_data *data, int bpw)
> >        dma_cap_set(DMA_SLAVE, mask);
> >
> >        /* Get DMA's dev information */
> > -       dma_dev = pci_get_bus_and_slot(2, PCI_DEVFN(12, 0));
> > +       dma_dev = pci_get_bus_and_slot(data->board_dat->pdev->bus->number,
> > +                                      PCI_DEVFN(12, 0));
> >
> >        /* Set Tx DMA */
> >        param = &dma->param_tx;
> > --
> > 1.7.4.4
> >

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
