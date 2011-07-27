Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab1G0U3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 16:29:31 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33052 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab1G0U33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 16:29:29 -0400
Date: Wed, 27 Jul 2011 21:28:59 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Jaswinder Singh <jaswinder.singh@linaro.org>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, per.friden@stericsson.com,
        wei.zhang@freescale.com, ebony.zhu@freescale.com, iws@ovro.caltech.edu,
        s.hauer@pengutronix.de, maciej.sosnowski@intel.com, saeed@marvell.com,
        shawn.guo@freescale.com, yur@emcraft.com, agust@denx.de,
        iwamatsu.nobuhiro@renesas.com, per.forlin@stericsson.com,
        jonas.aberg@stericsson.com, anemo@mba.ocn.ne.jp
Subject: Re: [PATCHv2] DMAEngine: Let dmac drivers to set chan_id
Message-ID: <20110727202859.GA5028@flint.arm.linux.org.uk>
References: <CAJe_ZhfYvd6mdUMtzdAKKk4o1ythCBm7rut7ZCWRTxiWLP__Tg@mail.gmail.com> <CABE8wwv2XQ_aJ8O2TUAz1LgJorBwDbgyQQv7jeAn06Q2AcqH+Q@mail.gmail.com> <CAJe_ZhcNM7m-eWA0nDUrOrHxeAhNS00gewf=txmvOFL_uOPhrw@mail.gmail.com> <1311740499.1536.56.camel@vkoul-udesk3> <CAJe_ZhfaPfobs5P+q+t-kRSK4fAvm-v_brYgqmco8fwOOBeT8A@mail.gmail.com> <1311757347.1536.103.camel@vkoul-udesk3> <20110727095909.GB16623@intel.com> <CAJe_ZhdkPpVSyCyiUsFhOUUms8=JSQOiC33ztFzriW8jQHaa_w@mail.gmail.com> <CABE8wwuAFMYHH67sjEuy7whiZD+QBmU6bvzUUzEqJQFaYpkgdQ@mail.gmail.com> <CAJe_Zhfm5k9gNPaTfpZdQ__cp9fKLZoiSvG0GPciVFbkkU=QCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJe_Zhfm5k9gNPaTfpZdQ__cp9fKLZoiSvG0GPciVFbkkU=QCw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 10:44:53PM +0530, Jaswinder Singh wrote:
> 1) What I propose
>        http://lists.infradead.org/pipermail/linux-arm-kernel/2011-July/059212.html
> 
> 2) Why RMK thinks I am the biggest idiot on earth
>        http://lists.infradead.org/pipermail/linux-arm-kernel/2011-July/059217.html
> 
> 3) How I ask for better proof of that
>       http://lists.infradead.org/pipermail/linux-arm-kernel/2011-July/059223.html

Look, your idea is completely mad and insane - you just can't represent
the matching stuff as capabilities.

How do you deal with a peripheral being linked to a _specific_ DMA
engine on a _specific_ DMA request signal?  What if your system has
two DMA engines, each with 32 request signals?  Are you going to have
something like a 128-bit capability mask?

Peripheral drivers don't know what DMA signal the SoC designer may have
chosen.  Peripheral drivers don't know what DMA engine they're connected
to.  Yet again, I say, the only place which knows that is data associated
with the _platform_.  The platform has to be involved with binding the
DMA engine plus DMA channel with the peripheral.  You can't get away from
that.  Not with capabilities.  Not with stuff from the peripheral driver
saying "I want a M2P channel" in a capability field, etc

So I think your idea is totally unworkable, and it doesn't come close to
fitting with any DMA setup I've seen.

If that means you think I'm calling you an idiot, then so be it.  I just
think you're wrong on a purely technical level.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
