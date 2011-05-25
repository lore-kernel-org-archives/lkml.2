Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab1EYKIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 06:08:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:52136 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab1EYKIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 06:08:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,266,1304319600"; 
   d="scan'208";a="1272813"
Subject: Re: [PATCH] dmaengine: Add API documentation for slave dma usage
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Per Forlin <per.forlin@linaro.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <BANLkTikn3BBeNyuUeZ9BhG5QLj-dmcGjTg@mail.gmail.com>
References: <1306238657-30089-1-git-send-email-vinod.koul@intel.com>
	 <BANLkTikDPeEFWdsVQ=Ak8jXEXsC-+uoOaw@mail.gmail.com>
	 <1306253171.30236.9.camel@vkoul-udesk3>
	 <BANLkTikjxECNAK5eS5hSu2bbEKpZX341Dw@mail.gmail.com>
	 <BANLkTikAm=D_YNFt0Regeas6AX8116L0-A@mail.gmail.com>
	 <1306312009.30236.110.camel@vkoul-udesk3>
	 <BANLkTikn3BBeNyuUeZ9BhG5QLj-dmcGjTg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 15:04:42 +0530
Message-ID: <1306316082.30236.137.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 11:47 +0200, Per Forlin wrote:
> On 25 May 2011 10:26, Koul, Vinod <vinod.koul@intel.com> wrote:
> > I am okay with making this same for the slave devices as well.
> >
> > That would also require to change few drivers which start the txn in
> > submit()
> Yes,
> The trivial part is to move enable from submit to issue_pending. I had
> a quick look and it looks like the following drivers need to be
> changed.
> mpc512x_dma.c
> imx-dma.c
> imx-sdma.c
> mxs-dma.c
> 
> The other part is more complex. To make submit only add descs to a
> queue that will be pushed down to the DMA only after issue_pending. It
> is not as trivial to identify which of the drivers support this or
> not.
> I still think it make sense to fix the documentation first and then
> fix the drivers. Keep a list inside the dmaengine.txt of drivers that
> need to be fixed in order to comply with the API. Over time drivers
> will be fixed and removed from the list. When we have agreed upon the
> API (we may not be there yet) I am willingly to make a draft of such a
> list.
Yes this sounds right, I will send updated version and now drivers would
need to call issue_pending.

I know dw_dmac, intel_mid_dma and ste_dma40 would need changes as well.

Was thinking to add TODO in drivers/dma with these and any other changes
we feel are required moving forward.
We need dw_dmac to be moved to new slave interface and remove old slave
pointer mechanism when all are moved. 

-- 
~Vinod

