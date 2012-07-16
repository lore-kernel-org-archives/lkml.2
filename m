Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab2GPGhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 02:37:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56048 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab2GPGhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 02:37:31 -0400
Date: Mon, 16 Jul 2012 08:37:28 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@linux.intel.com>
cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7 v2] dma: sh: use an integer slave ID to improve API
 compatibility
In-Reply-To: <1342418828.1726.37.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1207160832540.12302@axis700.grange>
References: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de> 
 <1341484183-10757-6-git-send-email-g.liakhovetski@gmx.de>
 <1342418828.1726.37.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:CntZ8i0GR/BYS64fxamCGzOQPF1Zt56MMO33TDCZW6p
 o2cS6B0sz4CzJKpslJ7pR2D0WmoJkhjk2cRrPlD2+hoPHJLI2z
 e7qsvqLByXEoSqUMzHe/bU0kmjFhqXcqSUCtVsw9ubtT8Eyvy3
 W9wSIUXF5CFFjToIJOoNIJR0W8Vp75Y0p53iSZIdKN1hNbDCTl
 Kyy+Z0b0fa03eClnAp2d3XcD3tO9KxqhixYG5yAsHF/MgwAU0/
 ATnyKx0OaZdYnv99LpOhSJbBZQaAOLwb1kn/JH3rCrDJgUzINt
 LiZ1C1+B22F+uezr5qiivuMw6PWNF1k6Bnma1sPwMhG4eB46xN
 GtVqiuGfKVdprzyEQGPbihNLxzx4+JBuJ5naJSIxx8XZPjDgMH
 CQQfIDDzYxLcA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012, Vinod Koul wrote:

> On Thu, 2012-07-05 at 12:29 +0200, Guennadi Liakhovetski wrote:
> > diff --git a/include/linux/sh_dma.h b/include/linux/sh_dma.h
> > index a79f10a..4e83f3e 100644
> > --- a/include/linux/sh_dma.h
> > +++ b/include/linux/sh_dma.h
> > @@ -27,10 +27,10 @@ struct sh_dmae_slave {
> >   * a certain peripheral
> >   */
> >  struct sh_dmae_slave_config {
> > -       unsigned int                    slave_id;
> > -       dma_addr_t                      addr;
> > -       u32                             chcr;
> > -       char                            mid_rid;
> > +       int             slave_id;
> > +       dma_addr_t      addr;
> > +       u32             chcr;
> > +       char            mid_rid;
> >  }; 
> why would you want to keep your own slave_id and addr fields when they
> are already provided in struct dma_slave_config.

Modifying the driver's API would break all its clients.

> Also while at it, what
> would be the use of last tow fields, what do they describe?

They tell the driver how the channel has to be configured to support this 
specific client. They are values of two specific registers. In fact, CHCR 
means exactly that - CHannel Control Register.

> Would it be possible to get rid of this structure completely? At least
> first two fields should go away.

Migration has to be performed gradually. If this approach and patches are 
accepted, then all client drivers can be migrated, then thr legacy API can 
be dropped.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
