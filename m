Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab1EYT4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 15:56:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55970 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab1EYT4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 15:56:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JZL6sdBwuTCchzIRGcZ4eqVH5I7Xqi/7JkIE8SN85R9WCs9N6pIHQIwDCVHvPoSK6q
         +db7NJRvxYeAKySeByeBP/peCA+1apZlLV1QYnPXA9OjJPbCgO0dDEVV+X4ag177Z32E
         g7LFLQHXztBmIlwvkyMlBabt8ybMv9stvhWV0=
Date: Wed, 25 May 2011 22:54:13 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, hsweeten@visionengravers.com,
        ryan@bluewatersys.com, Dan Williams <dan.j.williams@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/5] dmaengine: add ep93xx DMA support
Message-ID: <20110525195413.GC2996@acer>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
 <e6777eb9f7228ee1dadec1f0c9f16c3afc44c307.1306082097.git.mika.westerberg@iki.fi>
 <BANLkTi=3z3kO5VEe2up8Mfm+bNXkY3baUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=3z3kO5VEe2up8Mfm+bNXkY3baUw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 10:39:52AM +0200, Linus Walleij wrote:
> 
> No so much a review comment as an observation: I opposed the merge of the
> EP93xx SPI driver in drivers/spi/ep93xx_spi.c on the grounds that it was close
> enough to amba-pl022.c that it could use that driver instead.

I re-checked the specs and indeed, as discussed previously, it is clear that
Cirrus (or ARM) copied the interface from other. Even the wording in the
document is identical in many places. However, in ep93xx User's Guide, there
is no mention about SSP being AMBA PrimeCell peripheral. For UARTs it is
mentioned... go figure.

There are differences also, some of the bits in control registers are in
different places. Interrupt registers are completely different and there is no
DMA control register at all. The same things we discussed before.

> One of the arguments against was that you were going to do custom DMA
> and stuff. Now you're using the DMAengine, so can you please reconsider
> refactoring amba-pl022.c to suit your needs and you'll get DMA support for
> free mor or less.

Back then, it wasn't known how the M2M DMA interface (the one used by SSP and
IDE) was going to be implemented. Now that the dmaengine has become de facto
API, it is clear that any "new" DMA implementations should implement that
instead of some home grown API. Initially my M2M DMA experiments were just
like their M2P counterparts but Ryan suggested dmaengine approach.

IMHO it is better to have ep93xx implementation on its own driver since it is
not a real AMBA PL022 peripheral but some weird hack made by Cirrus (although
my opinions are bit biased).

Thanks,
MW
