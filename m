Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab2JDNJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 09:09:59 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50392 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab2JDNJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 09:09:58 -0400
Date: Thu, 4 Oct 2012 09:10:27 -0400
From: Matt Porter <mporter@ti.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Philipp Zabel <pza@pengutronix.de>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/6] uio_pruss cleanup and platform support
Message-ID: <20121004131027.GH11149@beef>
References: <1349276133-26408-1-git-send-email-mporter@ti.com>
 <20121004091145.GA3317@pengutronix.de>
 <20121004124253.GC11149@beef>
 <506D8720.8040004@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506D8720.8040004@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 06:24:56PM +0530, Sekhar Nori wrote:
> On 10/4/2012 6:12 PM, Matt Porter wrote:
> > On Thu, Oct 04, 2012 at 11:11:45AM +0200, Philipp Zabel wrote:
> >> Hi Matt,
> >>
> >> On 10/3/12, Matt Porter <mporter@ti.com> wrote:
> >>> This series enables uio_pruss on DA850 and removes use of the
> >>> private SRAM API by the driver. The driver previously was not
> >>> enabled by any platform and the private SRAM API was accessing
> >>> an invalid SRAM bank.
> >>
> >> have you seen my SRAM patch series at https://lkml.org/lkml/2012/9/7/281
> >> "Add device tree support for on-chip SRAM" ?
> > 
> > Yes.
> > 
> >> I think the generic SRAM/genalloc driver (https://lkml.org/lkml/2012/9/7/282)
> >> could be useful to map the L3RAM on Davinci.
> >> With the gen_pool lookup patch (https://lkml.org/lkml/2012/9/7/284) the
> >> uio_pruss driver could then use the gen_pool_find_by_phys() (or
> >> of_get_named_gen_pool() for initialization from device tree) to
> >> retrieve the struct gen_pool*.
> >>
> >> This way you could avoid handing it over via platform data and you could
> >> get rid of arch/arm/mach-davinci/{sram.c,include/mach/sram.h} completely.
> > 
> > I did miss the gen_pool_find_by_phys() call in that series. That does
> > look useful. I actually mentioned your series in an earlier posting
> > since I like it, but since the initialization of the driver was inherently
> > tied to DT it's not usable for DaVinci that's just starting to convert
> > to DT and needs !DT support as well.
> > 
> > I do see it moving to your driver exclusively, but I wanted to make this
> > series focused on only getting rid of the private SRAM API using the
> > existing pdata framework that's already there. I think once
> > gen_pool_find_by_phys() goes upstream we can switch to that and get the
> > address from a resource in the !DT case. I guess we should see if Sekhar
> > would like to see this happen in two steps or just have us depend on
> > the gen_pool_find_by_phys() patch now.
> 
> I prefer going with this series now and switching to the SRAM driver
> once it is available mainline.

Ok, thanks. In that case, I'll also plan to keep the davinci-pcm series
using the same approach for now too.

-Matt
