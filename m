Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab1G0Uhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 16:37:32 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39396 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab1G0Uh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 16:37:29 -0400
Date: Wed, 27 Jul 2011 21:37:11 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Jaswinder Singh <jaswinder.singh@linaro.org>
Cc: "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, per.friden@stericsson.com,
        wei.zhang@freescale.com, ebony.zhu@freescale.com, iws@ovro.caltech.edu,
        s.hauer@pengutronix.de, maciej.sosnowski@intel.com, saeed@marvell.com,
        shawn.guo@freescale.com, yur@emcraft.com, agust@denx.de,
        iwamatsu.nobuhiro@renesas.com, per.forlin@stericsson.com,
        jonas.aberg@stericsson.com, anemo@mba.ocn.ne.jp
Subject: Re: [PATCHv2] DMAEngine: Let dmac drivers to set chan_id
Message-ID: <20110727203710.GB5028@flint.arm.linux.org.uk>
References: <CABE8wwt8J_r9cExG+EAqqK=XVmAyLYhv+-T49Rr9hhKudD8n2g@mail.gmail.com> <CAJe_ZheVyLk-yqyF_XO80xX3j7_7mDPnv-me+n=X_hNWycSLwg@mail.gmail.com> <CABE8wwtkSnaJ5fvi=4bq7zye3W0SmErHAZeWAcHuYvLgvqy=_Q@mail.gmail.com> <CAJe_ZhfYvd6mdUMtzdAKKk4o1ythCBm7rut7ZCWRTxiWLP__Tg@mail.gmail.com> <CABE8wwv2XQ_aJ8O2TUAz1LgJorBwDbgyQQv7jeAn06Q2AcqH+Q@mail.gmail.com> <CAJe_ZhcNM7m-eWA0nDUrOrHxeAhNS00gewf=txmvOFL_uOPhrw@mail.gmail.com> <1311740499.1536.56.camel@vkoul-udesk3> <CAJe_ZhfaPfobs5P+q+t-kRSK4fAvm-v_brYgqmco8fwOOBeT8A@mail.gmail.com> <1311757347.1536.103.camel@vkoul-udesk3> <CAJe_Zhd+Z4-=xDzFrd3ARuKZkUAo6n_miQgdSADY9Uk6uhkqhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJe_Zhd+Z4-=xDzFrd3ARuKZkUAo6n_miQgdSADY9Uk6uhkqhw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 08:00:23PM +0530, Jaswinder Singh wrote:
> On 27 July 2011 14:32, Koul, Vinod <vinod.koul@intel.com> wrote:
> > You can have two different DMACs in same system. At least I have two
> > from current intel_mid_dma which are used. Both give their channel id
> > starting from 0, 1....
> > Further as we integrate video, audio, spi, emmc dmacs possibility of
> > having multiple dmacs will increase in a system
>
> Most of Samsung's S5P series have 3 DMACs - 2 for peripherals and 1 for
> mem->mem But that is not the point.
> 
> This patch in no way affects what values currently a dmac driver
> assigns to chan_id

Then *explain* how the chan_id is used to match the channel which the
peripheral requires when you have three DMA controllers, each with
channels numbered 0 to 7.

> > Sorry I didn't get you.
> > As I understand you are trying to simplify the filter function by
> > assigning unique ids to all channels,
>
> No dear. Let me put it precisely.
> 
> Even if we make no further change to the dmaengine, this patch is the right
> thing to do today.

You sound like a politician.  "the right thing to do" is a cop-out.  That
says "believe me, I know I'm right, but I can't say why I'm right, I just
am."  Basically, it means that the person saying it has no clue on the
subject they're talking about.

If you do have a clue, then don't say that infuriating phrase, but give an
actual reason.

> On a serious note, my proposal, and the reply, shows the possibility
> of having :-
> a) Client drivers that are truly platform agnostic -- no platform_data
> poking for
>       channel selection

I really doubt that's even possible.  Take this setup:

MMCI ---> DMAC

where the DMAC has 32 request signals, and 8 channels.  The MMCI is
connected to two of them.  The DMAC can supply any of its physical
channels for MMCI.

Board 1 has the MMCI connected to request signals #1 and #3.  Board 2
has the MMCI connected to request signals #8 and #22.  Board 3 has
the MMCI connected through an external FPGA mux, which can route the
MMCI requests to DMA request signals #1, #2 or #3.

Now, explain how a channel is selected for each of those two boards, and
the DMA controller is provided with the relevant request signal is found
without platform data involved, using _only_ your 'capabilities' bitfield
and the channel ID number.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
