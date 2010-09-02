Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab0IBOGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 10:06:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38258 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab0IBOGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:06:49 -0400
Date: Thu, 2 Sep 2010 15:06:30 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] dmaengine: Add Freescale i.MX SDMA support
Message-ID: <20100902140630.GM26319@n2100.arm.linux.org.uk>
References: <1281956870-12463-1-git-send-email-s.hauer@pengutronix.de> <1281956870-12463-4-git-send-email-s.hauer@pengutronix.de> <AANLkTi=pO-ZJ33FrL=4bVRYa2o9HA0_h5tBYG7wdMuwz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=pO-ZJ33FrL=4bVRYa2o9HA0_h5tBYG7wdMuwz@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 02:21:06PM +0200, Linus Walleij wrote:
> > +/*
> > + * Buffer descriptor
> > + */
> > +struct sdma_buffer_descriptor {
> > +       struct sdma_mode_count  mode;
> > +       u32 buffer_addr;    /* address of the buffer described */
> > +       u32 ext_buffer_addr; /* extended buffer address */
> 
> Shouldn't these be dma_addr_t? OK that's probably u32
> anyway but just to make a marker...

If this is describing hardware, then it makes sense to use uNN rather
than dma_addr_t.  dma_addr_t may be subject to change in the future.
