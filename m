Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab0HBRNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 13:13:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35186 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab0HBRNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 13:13:13 -0400
Date: Mon, 2 Aug 2010 10:10:50 -0700
From: Greg KH <gregkh@suse.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sascha Hauer <s.hauer@pengutronix.de>,
        Daniel Mack <daniel@caiaq.de>
Subject: Re: [098/140] USB: ehci-mxc: bail out on transceiver problems
Message-ID: <20100802171050.GB7915@suse.de>
References: <20100730173205.GA22581@kroah.com>
 <20100730173111.572059486@clark.site>
 <20100802124514.GD6193@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802124514.GD6193@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 02:45:14PM +0200, Wolfram Sang wrote:
> On Fri, Jul 30, 2010 at 10:31:03AM -0700, Greg KH wrote:
> > 2.6.33-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Wolfram Sang <w.sang@pengutronix.de>
> > 
> > commit 4c9715de52b9b6256bf1e9510917111a47b0c176 upstream.
> > 
> > The old code registered the hcd even if there were no transceivers
> > detected, leading to oopses like this if we try to probe a non-existant
> > ULPI:
> > 
> > [    2.730000] mxc-ehci mxc-ehci.0: unable to init transceiver
> > [    2.740000] timeout polling for ULPI device
> > [    2.740000] timeout polling for ULPI device
> > [    2.750000] mxc-ehci mxc-ehci.0: unable to enable vbus on transceiver
> > [    2.750000] mxc-ehci mxc-ehci.0: Freescale On-Chip EHCI Host Controller
> > [    2.760000] mxc-ehci mxc-ehci.0: new USB bus registered, assigned bus number 2
> > [    2.770000] Unhandled fault: external abort on non-linefetch (0x808) at 0xc4876184
> > [    2.770000] Internal error: : 808 [#1] PREEMPT
> > [    2.770000] last sysfs file:
> > [    2.770000] Modules linked in:
> > [    2.770000] CPU: 0    Not tainted  (2.6.33.5 #5)
> > [    2.770000] PC is at ehci_hub_control+0x4d4/0x8f8
> > [    2.770000] LR is at ehci_mxc_setup+0xbc/0xdc
> > [    2.770000] pc : [<c0196dfc>]    lr : [<c019bc8c>]    psr: 00000093
> > [    2.770000] sp : c3815e40  ip : 00000001  fp : 60000013
> > [    2.770000] r10: c4876184  r9 : 00000000  r8 : c3814000
> > [    2.770000] r7 : c391d2cc  r6 : 00000001  r5 : 00000001  r4 : 00000000
> > [    2.770000] r3 : 80000000  r2 : 00000007  r1 : 80000000  r0 : c4876184
> > [    2.770000] Flags: nzcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM Segment kernel
> > [    2.770000] Control: 0005317f  Table: a0004000  DAC: 00000017
> > [    2.770000] Process swapper (pid: 1, stack limit = 0xc3814270)
> > ...
> > 
> > Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> > Cc: Sascha Hauer <s.hauer@pengutronix.de>
> > Acked-by: Daniel Mack <daniel@caiaq.de>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Daniel mentioned that this patch could cause a "regression" with boards
> which have hardware problems in form of a floating chip select
> (originating from the reference design!). For such boards, the probing
> might now fail, leaving the boards without USB, while it worked before
> (although it only worked because of ignoring the actual problem).
> 
> I can't make my mind if it is better to fix the potential OOPS or to
> keep those boards working for older kernels. I just wanted to mention
> it, so this is issue won't be overlooked.

Odd.  Well, I'd rather match what the newer kernels do here, so I'll
keep it for now unless someone objects.

thanks,

greg k-h
