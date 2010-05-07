Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab0EGJdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 05:33:18 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48759 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab0EGJdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 05:33:14 -0400
Date: Fri, 7 May 2010 10:32:56 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
       linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] DMAENGINE: fixes and PrimeCells
Message-ID: <20100507093256.GB19936@n2100.arm.linux.org.uk>
References: <1272848060-28049-1-git-send-email-linus.walleij@stericsson.com> <i2t63386a3d1005070213u2ad32613w694be1ecbeb46856@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <i2t63386a3d1005070213u2ad32613w694be1ecbeb46856@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 11:13:57AM +0200, Linus Walleij wrote:
> Dan is this patch set OK?
> 
> Sorry if you're busy, just need to check...
> 
> Patches 1 thru 4 should be uncontroversial, only affects
> our ST-Ericsson platforms and have been thorougly reviewed.
> 
> As posted elsewhere this is tested on an ARM reference
> design now as well, which IMHO would make it OK to apply
> also the PL011 patch, nr 5.

I would have thought given the concerns that I stated, merely running
the drivers in PIO mode would not address those concerns.  So no, I'm
not satisfied.

As I've said, I don't want the ARM platforms to be boxed into a corner
such that they can never have DMA support because this stuff hasn't been
properly thought out.

Or let me put it another way - if people are happy for Linux to support
new ARM CPU architectures, but with very little attention given to DMA
support on those architectures, then feel free to box the ARM platforms
into a corner on DMA support - but on the understanding that _you_ will
have to deal with the DMA API breakage on those architectures yourself.
Because with ARM platforms not having DMA support, there's absolutely
no way to run any checks what so ever on DMA when the CPU architecture
support is created.

This is why people like the OMAP folk end up doing a lot of the DMA
debugging; they tend to be the first group to pick up new architectures
with fully functional platforms.
