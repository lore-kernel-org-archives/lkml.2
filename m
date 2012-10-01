Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab2JANzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:55:46 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:49419 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab2JANzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:55:44 -0400
Date: Mon, 1 Oct 2012 09:56:03 -0400
From: Matt Porter <mporter@ti.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Paul Walmsley <paul@pwsan.com>, Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 4/7] ARM: davinci: Add support for an L3RAM gen_pool
Message-ID: <20121001135603.GM5641@beef>
References: <1348861072-14507-1-git-send-email-mporter@ti.com>
 <1348861072-14507-5-git-send-email-mporter@ti.com>
 <506986B2.1030000@ti.com>
 <20121001123242.GJ5641@beef>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001123242.GJ5641@beef>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 08:32:42AM -0400, Matt Porter wrote:
> On Mon, Oct 01, 2012 at 05:34:02PM +0530, Sekhar Nori wrote:
> > Hi Matt,
> > 
> > On 9/29/2012 1:07 AM, Matt Porter wrote:
> > > L3RAM (shared SRAM) is needed for use by several drivers.
> > > This creates a genalloc pool and a hook for the platform code
> > > to provide the struct gen_pool * in platform data.
> > > 
> > > Signed-off-by: Matt Porter <mporter@ti.com>
> > 
> > I am not sure if any of the DaVinci devices have a need to allocate from
> > *both* ARM RAM and shared RAM. Shared RAM is not present on all DaVinci
> > devices AFAIR, and on DA850, there is just 8KB ARM RAM so I am not sure
> > if there is much point in trying to allocate from there.
> > 
> > Can you instead see if Ben's earlier patch[1] to use shared RAM for SRAM
> > allocation on DA850 makes sense for your case? If yes, can you repost
> > with Ben's patch included in your series instead of this patch? I would
> > prefer that over creating a new pool for shared RAM.
> 
> Hrm, I did look at Ben's earlier patch. The reason I added a separate
> pool mostly was so I didn't have to touch the PM code at all. That can
> continue using the private SRAM API with the ARM RAM as it is now. The
> idea here was to allow that to be separate since no other bus masters
> can access the ARM RAM anyway and do something that didn't require
> regression testing PM. Also, I figured there's really no reason to use
> even a tiny bit of the shared SRAM on PM if we have that ARM RAM there
> and working fine for that use case.
> 
> The other thing is that Ben's patch needs to be rewritten to at least
> have the hook I added so we can provide the gen_pool in platform data.
> If you prefer this path still, I can add the needed hook on top of his
> original patch. Ultimately, I only *need* genalloc support for the
> shared sram so I can remove the private SRAM API from uio_pruss...so I'm
> happy with any way to get at it.
> 
> Oh, and to be honest...it's not just for uio_pruss, but also to cleanly
> remove the private SRAM API usage from the davinci ASoC driver too.

[and replying to myself :)]

Looking at the older parts (DM355/365/DM64xx) in more detail now, I see
that to get rid of SRAM API in davinci ASoC, we'll have a similar hook
to get the local ARM RAM gen_pool pointer necessary to support ping-pong
to that pool since that's able to be accessed from EDMA on those parts.
Ultimately, the approach is the same, it's just a matter of if we want
to fully leverage both SRAM pools on DA850 and friends.

-Matt
