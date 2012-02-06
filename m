Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab2BFP2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 10:28:44 -0500
Received: from mga03.intel.com ([143.182.124.21]:47747 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861Ab2BFP2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 10:28:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="63766575"
Subject: RE: [PATCH 01/11] dmaengine: add context parameter toprep_slave_sg
 and prep_dma_cyclic
From: Vinod Koul <vinod.koul@intel.com>
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
Cc: Russell King <rmk@arm.linux.org.uk>, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E552028729F9@CORPEXCH1.na.ads.idt.com>
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com>
	 <1328218341-31436-2-git-send-email-alexandre.bounine@idt.com>
	 <20120202214350.GB4432@flint.arm.linux.org.uk>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E55202872683@CORPEXCH1.na.ads.idt.com>
	 <1328529182.26182.92.camel@vkoul-udesk3>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E552028729F9@CORPEXCH1.na.ads.idt.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Feb 2012 20:58:54 +0530
Message-ID: <1328542134.26182.111.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-06 at 07:04 -0800, Bounine, Alexandre wrote:
> I was thinking about keeping the original scatterlist for dmac unchanged,
> but allocating another scatterlist in rio_dma_prep_slave_sg() and chaining
> two lists together. After it passed to device specific function, it parses
> first section of the chain for additional transfer parameters and use
> following scatterlist as intended for dmac.
hmmm, but that wouldn't make it generic for other systems like proposed
MSM box mode..., right?
> 
> But Russell's idea (See https://lkml.org/lkml/2012/2/3/269 ) seems to be
> a better way without added complexity and I am ready to take that path and
> make new patches if you and Dan agree with it. 
but it still doesn't fix his concerns for the using void pointer.

If we agree that this is the way, then I was thinking to add arch specif
calls which cast the context pointer to void for passing to dmac. The
arch specific struct gets defined in dmaengine_arch.h <or something
similar>. That way clients cant define their own stuff and we continue
to be generic as well as cater to arch specific requirements.

-- 
~Vinod

