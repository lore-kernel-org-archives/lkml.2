Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab2CZHZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 03:25:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:45423 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab2CZHZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 03:25:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="125080411"
Subject: Re: [PATCH v5 2/2] DMAEngine: Add DMAEngine driver based on old
 MSM ADM DMA APIs
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Ravi Kumar V <kumarrav@codeaurora.org>, tsoni@codeaurora.org,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.or,
        linux-kernel@vger.kernel.org, Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <CACRpkdbk=Hu6CzXSkkTgNsXGN0tPjfzLYfUpL8D5sxz2=efFxQ@mail.gmail.com>
References: <1332426216-25273-1-git-send-email-kumarrav@codeaurora.org>
	 <CACRpkdbk=Hu6CzXSkkTgNsXGN0tPjfzLYfUpL8D5sxz2=efFxQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Mar 2012 12:58:38 +0530
Message-ID: <1332746918.19804.84.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 09:17 +0200, Linus Walleij wrote:
> On Thu, Mar 22, 2012 at 3:23 PM, Ravi Kumar V <kumarrav@codeaurora.org> wrote:
> 
> This stuff:
> 
> > +enum adm_flush_type {
> > +       ADM_FORCED_FLUSH,
> > +       ADM_GRACEFUL_FLUSH,
> > +};
> 
> > +/*
> > + *  Controlling the hardware channel like stopping, flushing.
> > + */
> > +static int msm_dma_chan_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> > +                                                       unsigned long arg)
> > +{
> > +       enum adm_flush_type cmd_type = arg;
> > +
> > +       if (cmd == DMA_TERMINATE_ALL) {
> > +               switch (cmd_type) {
> > +               case ADM_GRACEFUL_FLUSH:
> > +                               msm_dmov_stop_cmd(chan->chan_id, NULL, 1);
> > +                       break;
> > +               case ADM_FORCED_FLUSH:
> > +                       /*
> > +                        * We treate default as forced flush
> > +                        * so we fall through
> > +                        */
> > +               default:
> > +                               msm_dmov_stop_cmd(chan->chan_id, NULL, 0);
> > +                       break;
> > +               }
> > +       }
> > +       return 0;
> > +}
> 
> This is an interesting way of using the opaque arg. Can you describe
> the different semantics of graceful vs forced flush so we understand
> the usecases for them?
> 
> DMA_TERMINATE_ALL is usually not very graceful.
> 
> DMA_PAUSE might be the semantic you're looking for as the
> graceful path, and then you can do away with this strange
> enum altogether.
I am not a big fan of opaque objects. Btw client should use
dmaengine_terminate_all() only


-- 
~Vinod

