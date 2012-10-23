Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab2JXCYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 22:24:46 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:42525 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785Ab2JXCYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 22:24:44 -0400
Date: Tue, 23 Oct 2012 16:27:03 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Josh Cartwright <josh.cartwright@ni.com>
Cc: Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        John Linn <john.linn@xilinx.com>
Subject: Re: [PATCH v2 2/4] zynq: move static peripheral mappings
Message-ID: <20121023202703.GA16912@elliptictech.com>
References: <20121022211219.GC31538@beefymiracle.amer.corp.natinst.com>
 <201210231450.11540.arnd@arndb.de>
 <20121023162641.GG20593@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023162641.GG20593@beefymiracle.amer.corp.natinst.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-23 11:26 -0500, Josh Cartwright wrote:
> On Tue, Oct 23, 2012 at 02:50:11PM +0000, Arnd Bergmann wrote:
> > On Monday 22 October 2012, Josh Cartwright wrote:
> > > Shifting them up into the vmalloc region prevents the following warning,
> > > when booting a zynq qemu target with more than 512mb of RAM:
> > > 
> > >   BUG: mapping for 0xe0000000 at 0xe0000000 out of vmalloc space
> > > 
> > > In addition, it allows for reuse of these mappings when the proper
> > > drivers issue requests via ioremap().
> > > 
> > > Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> > 
> > This looks like a bug fix that should be backported to older kernels,
> > so it would be good to add 'Cc: stable@vger.kernel.org' below your
> > Signed-off-by.
> 
> Will-do, thanks.

Just FYI, I sent a patch to fix the same bug a while back

  https://patchwork.kernel.org/patch/1156361/

together with other patches to fix early printk on the ZC702 serial
console.  Admittedly, I dropped the ball on these as other issues
came up so I was away from the Zynq for a while.

However, I'm now getting back on the Zynq and have a bunch of patches to
make it all work on the ZC702 board.  I've respun the ZC702 early boot
fixes against newer git but they're obviously going to conflict with
this series.  Should I resend them anyway?

> > > -#define TTC0_PHYS			0xF8001000
> > > -#define TTC0_VIRT			TTC0_PHYS
> > > +#define TTC0_PHYS		0xF8001000
> > > +#define TTC0_SIZE		SZ_4K
> > > +#define TTC0_VIRT		(UART0_VIRT - TTC0_SIZE)
> > 
> > It's quite likely that this does not have to be a fixed mapping
> > any more. Just have a look at how drivers/clocksource/dw_apb_timer_of.c
> > calls of_iomap() to get the address.
> 
> Yes, this is already on my list of plans.  The in-tree TTC driver
> unfortunately doesn't yet support device tree bindings.  Are you
> comfortable waiting on the DT-ification of the TTC in a follow-up
> patchset?

I also have a DT binding for the TTC driver, I can send that.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
