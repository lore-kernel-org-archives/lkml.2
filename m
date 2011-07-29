Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab1G2MhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 08:37:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:44813 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754263Ab1G2MhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 08:37:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,287,1309762800"; 
   d="scan'208";a="2316184"
Subject: Re: [PATCHv2] DMAEngine: Let dmac drivers to set chan_id
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jaswinder Singh <jaswinder.singh@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        per.friden@stericsson.com, wei.zhang@freescale.com,
        ebony.zhu@freescale.com, iws@ovro.caltech.edu, s.hauer@pengutronix.de,
        maciej.sosnowski@intel.com, saeed@marvell.com, shawn.guo@freescale.com,
        yur@emcraft.com, agust@denx.de, iwamatsu.nobuhiro@renesas.com,
        per.forlin@stericsson.com, jonas.aberg@stericsson.com,
        anemo@mba.ocn.ne.jp
In-Reply-To: <CACRpkdbauudu_GXfsaB23sSepf=_rzt577Hb7pA9rRRrEFYj-w@mail.gmail.com>
References: <CAJe_ZhfYvd6mdUMtzdAKKk4o1ythCBm7rut7ZCWRTxiWLP__Tg@mail.gmail.com>
	 <CABE8wwv2XQ_aJ8O2TUAz1LgJorBwDbgyQQv7jeAn06Q2AcqH+Q@mail.gmail.com>
	 <CAJe_ZhcNM7m-eWA0nDUrOrHxeAhNS00gewf=txmvOFL_uOPhrw@mail.gmail.com>
	 <1311740499.1536.56.camel@vkoul-udesk3>
	 <CAJe_ZhfaPfobs5P+q+t-kRSK4fAvm-v_brYgqmco8fwOOBeT8A@mail.gmail.com>
	 <1311757347.1536.103.camel@vkoul-udesk3> <20110727095909.GB16623@intel.com>
	 <CAJe_ZhdkPpVSyCyiUsFhOUUms8=JSQOiC33ztFzriW8jQHaa_w@mail.gmail.com>
	 <CABE8wwuAFMYHH67sjEuy7whiZD+QBmU6bvzUUzEqJQFaYpkgdQ@mail.gmail.com>
	 <CAJe_Zhfm5k9gNPaTfpZdQ__cp9fKLZoiSvG0GPciVFbkkU=QCw@mail.gmail.com>
	 <20110727202859.GA5028@flint.arm.linux.org.uk>
	 <CAJe_ZheB0uKn=Rk-i2y1rn5ZHJUJJy7D_3Pb6d4ggjNDhh+6VA@mail.gmail.com>
	 <CACRpkdbauudu_GXfsaB23sSepf=_rzt577Hb7pA9rRRrEFYj-w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 17:24:09 +0530
Message-ID: <1311940449.1536.520.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 00:27 +0200, Linus Walleij wrote:
> On Thu, Jul 28, 2011 at 12:44 PM, Jaswinder Singh
> <jaswinder.singh@linaro.org> wrote:
> 
> > {
> > So far, I haven't assumed the capability of a DMAC to switch, say,
> > the RequestSignal_7 from MMC to UART at _runtime_
> > If you think such dmacs and platforms exist, please let me know.
> > I will update the proposal.
> > }
> 
> Such DMACs exist, in the ARM Versatile and RealView boards...
> Check drivers/dma/amba-pl08x.c, notice callback functions named
> int (*get_signal)(struct pl08x_dma_chan *);
> void (*put_signal)(struct pl08x_dma_chan *);
> from <linux/amba/pl08x.h>
> 
> These implement optional runtime muxing of the request signals,
> and it is through these two callbacks because there is a mux
> which is external to the pl08x itself that is used, and the muxing
> is machine-specific and implemented in the platform. I have been
> working on patches using it like the below (still being worked on).
> 
Yes, even in intel_mid_dmac we have such a mux so that DMAC channels can
transfer to any of the h/w interfaces. This configuration can be passed
by client (which instance) and dmac configures it :)
So all channels for a controller can do transfers to any of the
peripherals...

-- 
~Vinod

