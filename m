Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab1KPGsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 01:48:37 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57295 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab1KPGsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 01:48:36 -0500
Date: Wed, 16 Nov 2011 08:48:22 +0200
From: Mika Westerberg <mika.westerberg@iki.fi>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Rafal Prylowski <prylowski@metasoft.pl>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rmallon@gmail.com" <rmallon@gmail.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "lrg@ti.com" <lrg@ti.com>
Subject: Re: [PATCH v2 1/5] dmaengine: add ep93xx DMA support
Message-ID: <20111116064822.GA2703@mwesterb-mobl.ger.corp.intel.com>
References: <cover.1306662317.git.mika.westerberg@iki.fi>
 <3ea8d56034f25cbe3fd8a4c31d7d0d1540b6ac7e.1306662317.git.mika.westerberg@iki.fi>
 <4EC27EED.4030108@metasoft.pl>
 <ADE657CA350FB648AAC2C43247A983F001F3E93FDC22@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F3E93FDC22@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 11:59:50AM -0600, H Hartley Sweeten wrote:
> >
> > Index: linux-2.6/drivers/dma/ep93xx_dma.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/dma/ep93xx_dma.c
> > +++ linux-2.6/drivers/dma/ep93xx_dma.c
> > @@ -246,6 +246,7 @@ static void ep93xx_dma_set_active(struct
> >  static struct ep93xx_dma_desc *
> >  ep93xx_dma_get_active(struct ep93xx_dma_chan *edmac)
> >  {
> > +	BUG_ON(list_empty(&edmac->active));
> 
> BUG_ON is evil...
> 
> I'm not sure this is the right way to handle this.
> 
> If your doing dma the list should never be empty.  If it is I think it should
> have been caught way before this.  Mika, do you have any comments?

I agree - the list should never be empty when this is called. The actual bug
is somewhere else.
