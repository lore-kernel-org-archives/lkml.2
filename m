Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab1KWKvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:51:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:43485 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab1KWKvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:51:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="79143527"
Subject: Re: [PATCH v2 1/5] dmaengine: add ep93xx DMA support
From: Vinod Koul <vinod.koul@intel.com>
To: Mika Westerberg <mika.westerberg@iki.fi>
Cc: Rafal Prylowski <prylowski@metasoft.pl>, rmallon@gmail.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, hsweeten@visionengravers.com,
        dan.j.williams@intel.com, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20111122055925.GA15889@mwesterb-mobl.ger.corp.intel.com>
References: <cover.1306662317.git.mika.westerberg@iki.fi>
	 <3ea8d56034f25cbe3fd8a4c31d7d0d1540b6ac7e.1306662317.git.mika.westerberg@iki.fi>
	 <4EC27EED.4030108@metasoft.pl>
	 <20111116065512.GB2703@mwesterb-mobl.ger.corp.intel.com>
	 <4EC374F0.8000400@metasoft.pl>
	 <20111119123837.GA2711@mwesterb-mobl.ger.corp.intel.com>
	 <4ECA0147.4020806@metasoft.pl>
	 <20111121080158.GA2713@mwesterb-mobl.ger.corp.intel.com>
	 <1321864326.1516.211.camel@vkoul-udesk3>
	 <20111122055925.GA15889@mwesterb-mobl.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Nov 2011 16:17:49 +0530
Message-ID: <1322045269.1516.247.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 07:59 +0200, Mika Westerberg wrote:
> On Mon, Nov 21, 2011 at 02:02:06PM +0530, Vinod Koul wrote:
> > On Mon, 2011-11-21 at 10:01 +0200, Mika Westerberg wrote:
> > > On Mon, Nov 21, 2011 at 08:44:07AM +0100, Rafal Prylowski wrote:
> > > > 
> > > > I'm calling dma_terminate_all from interrupt. It seems that tasklet_kill is not
> > > > allowed to be called from this context.
> > > 
> > > Ah, right.
> > > 
> > > One more try - this time we set a flag which prevents the tasktlet from
> > > referencing an empty list.
> 
> > Rather than this why not actually check for list_empty and process only
> > when it is not empty?
> 
> I was thinking that it should be an error if the active list is empty when the
> tasklet is run.
well where would you return the error from tasklet?

> 
> > Also you should check the return of the ep93xx_dma_get_active() which
> > should return NULL if it didn't find anything in active list
> 
> Right - if the list is allowed to be empty.
> 
> I'll re-check the patch from Rafal. Maybe it's better to adapt with the fact
> that dma_terminate_all() can be called in any context any time and modify the
> driver accordingly (e.g like you say, return NULL if the list is empty handle
> it correctly).
Yes dma_terminate_all() is allowed to be called by the driver in any
context. It may wish to terminate at any point and this can potentially
lead to race condition when you do actual hardware right to terminate
just when hardware sent the interrupt. And your tasklet is scheduled
after the list becomes empty.
So its better approach to check for list in tasklet and return of
ep93xx_dma_get_active() for a valid descriptor


-- 
~Vinod

