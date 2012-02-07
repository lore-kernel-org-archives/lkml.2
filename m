Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab2BGDh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 22:37:57 -0500
Received: from mga03.intel.com ([143.182.124.21]:19377 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755996Ab2BGDh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 22:37:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="63955630"
Subject: RE: [PATCH 01/11] dmaengine: add context parameter
 toprep_slave_sgand prep_dma_cyclic
From: Vinod Koul <vinod.koul@intel.com>
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
Cc: Russell King <rmk@arm.linux.org.uk>, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E55202872B3D@CORPEXCH1.na.ads.idt.com>
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com>
	 <1328218341-31436-2-git-send-email-alexandre.bounine@idt.com>
	 <20120202214350.GB4432@flint.arm.linux.org.uk>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E55202872683@CORPEXCH1.na.ads.idt.com>
	 <1328529182.26182.92.camel@vkoul-udesk3>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E552028729F9@CORPEXCH1.na.ads.idt.com>
	 <1328542134.26182.111.camel@vkoul-udesk3>
	 <20120206155318.GA20852@flint.arm.linux.org.uk>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E55202872AB1@CORPEXCH1.na.ads.idt.com>
	 <1328551625.26182.139.camel@vkoul-udesk3>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E55202872B3D@CORPEXCH1.na.ads.idt.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Feb 2012 09:09:53 +0530
Message-ID: <1328585993.26182.143.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-06 at 10:45 -0800, Bounine, Alexandre wrote:
> On Mon, Feb 06, 2012 at 1:07 PM, Vinod Koul wrote:
> > 
> > On Mon, 2012-02-06 at 09:02 -0800, Bounine, Alexandre wrote:
> > >
> > > What if we introduce another dma_transaction_type like DMA_SLAVE_EXT
> > > (extended?).
> > > In this case all devices that adhere to the generic SLAVE interface
> > > still be
> > > registered as DMA_SLAVE and those that do not follow generic route
> > use
> > > DMA_SLAVE_EXT.
> > that way it would be channel specific not transaction specific as you
> > had asked for...?
> > 
> > Again, how does this solve problem of passing parameters while
> > preventing abuse...
> 
> This gives a channel-specific treatment to the parameter. Channels registered
> as DMA_SLAVE never expect an extra parameter (BUG_ON if the pointer is not NULL).
> In the generic use scenario described by Russell clients are safe to request
> any such channel without an additional HW knowledge (as it is now).
> 
> Channels registered as DMA_SLAVE_EXT will accept a pointer to parameter structure.
> This, combined with configuration specific wrappers as you described
> in earlier e-mail with #ifdef CONFIG_RAPIDIO, should ensure that there is no
> unexpected treatment of (void *) parameter. Also for channels registered
> as DMA_SLAVE_EXT a corresponding filter routine must be provided. 
Okay this sounds better :)
Sorry I didnt quite get the last line about filter routine?

-- 
~Vinod

