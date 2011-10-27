Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab1J0Q74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 12:59:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:4697 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab1J0Q7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 12:59:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,413,1315206000"; 
   d="scan'208";a="83157540"
Subject: Re: [PATCH 02/10] dmaengine: move drivers to dma_transfer_direction
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        jaswinder.singh@linaro.org, 21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Viresh Kumar <viresh.kumar@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Li Yang <leoli@freescale.com>, Zhang Wei <zw@zh-kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>, Yong Wang <yong.y.wang@intel.com>,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Boojin Kim <boojin.kim@samsung.com>, Barry Song <Baohua.Song@csr.com>
In-Reply-To: <Pine.LNX.4.64.1110171023070.18438@axis700.grange>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
	 <1318570705-17595-3-git-send-email-vinod.koul@intel.com>
	 <Pine.LNX.4.64.1110171023070.18438@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Oct 2011 22:26:59 +0530
Message-ID: <1319734619.20054.220.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 14:52 +0200, Guennadi Liakhovetski wrote:

Sorry for replying late...
> > diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
> > index 81809c2..cab7d3e 100644
> > --- a/drivers/dma/shdma.c
> > +++ b/drivers/dma/shdma.c
> > @@ -23,7 +23,6 @@
> >  #include <linux/interrupt.h>
> >  #include <linux/dmaengine.h>
> >  #include <linux/delay.h>
> > -#include <linux/dma-mapping.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/pm_runtime.h>
> >  #include <linux/sh_dma.h>
> > @@ -479,19 +478,19 @@ static void sh_dmae_free_chan_resources(struct
> dma_chan *chan)
> >   * @sh_chan: DMA channel
> >   * @flags:   DMA transfer flags
> >   * @dest:    destination DMA address, incremented when direction
> equals
> > - *           DMA_FROM_DEVICE or DMA_BIDIRECTIONAL
> > + *           DEV_TO_MEM
> >   * @src:     source DMA address, incremented when direction equals
> > - *           DMA_TO_DEVICE or DMA_BIDIRECTIONAL
> > + *           MEM_TO_DEV
> 
> Why have you changed the above two comments? Doesn't seem correct to
> me. 
No this is the right comment.

After the direction flag changes, the sh_dmae_add_desc will take new
flags for direction. The valid flags would be DEV_TO_MEM and
DEV_TO_DEVICE only.

-- 
~Vinod

