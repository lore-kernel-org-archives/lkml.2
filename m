Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab2GPGxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 02:53:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:61045 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab2GPGxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 02:53:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="193257148"
Subject: Re: [PATCH 5/7 v2] dma: sh: use an integer slave ID to improve API
 compatibility
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1207160832540.12302@axis700.grange>
References: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de>
	 <1341484183-10757-6-git-send-email-g.liakhovetski@gmx.de>
	 <1342418828.1726.37.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1207160832540.12302@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jul 2012 12:23:07 +0530
Message-ID: <1342421587.1726.49.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-16 at 08:37 +0200, Guennadi Liakhovetski wrote:
> On Mon, 16 Jul 2012, Vinod Koul wrote:
> 
> > On Thu, 2012-07-05 at 12:29 +0200, Guennadi Liakhovetski wrote:
> > > diff --git a/include/linux/sh_dma.h b/include/linux/sh_dma.h
> > > index a79f10a..4e83f3e 100644
> > > --- a/include/linux/sh_dma.h
> > > +++ b/include/linux/sh_dma.h
> > > @@ -27,10 +27,10 @@ struct sh_dmae_slave {
> > >   * a certain peripheral
> > >   */
> > >  struct sh_dmae_slave_config {
> > > -       unsigned int                    slave_id;
> > > -       dma_addr_t                      addr;
> > > -       u32                             chcr;
> > > -       char                            mid_rid;
> > > +       int             slave_id;
> > > +       dma_addr_t      addr;
> > > +       u32             chcr;
> > > +       char            mid_rid;
> > >  }; 
> > why would you want to keep your own slave_id and addr fields when they
> > are already provided in struct dma_slave_config.
> 
> Modifying the driver's API would break all its clients.
rightly so, they need to be moved too.

> 
> > Also while at it, what
> > would be the use of last tow fields, what do they describe?
> 
> They tell the driver how the channel has to be configured to support this 
> specific client. They are values of two specific registers. In fact, CHCR 
> means exactly that - CHannel Control Register.
what exactly does the channel control register do in shdma? Should shdma
driver deduce this value rather than client giving it?
Same question for mid_rid?


-- 
~Vinod

