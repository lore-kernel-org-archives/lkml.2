Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965237Ab2LGSyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 13:54:10 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:49082 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2LGSyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 13:54:08 -0500
Date: Fri, 7 Dec 2012 13:54:05 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Gerlando Falauto <gerlando.falauto@keymile.com>
cc: Sergei Trofimovich <slyich@gmail.com>, Ian Campbell <ijc@hellion.org.uk>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: arm: CONFIG_ARM_PATCH_PHYS_VIRT=y is broken on kirkwood
In-Reply-To: <50C212E6.9010200@keymile.com>
Message-ID: <alpine.LFD.2.02.1212071343090.6589@xanadu.home>
References: <20120408115920.4d7d2197@sf.home> <1334006908.12209.150.camel@dagon.hellion.org.uk> <20120410211210.310b65ea@sf.home> <50C212E6.9010200@keymile.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Dec 2012, Gerlando Falauto wrote:

> Hi everyone,
> 
> On 04/10/2012 08:12 PM, Sergei Trofimovich wrote:
> > On Mon, 09 Apr 2012 22:28:28 +0100
> > Ian Campbell<ijc@hellion.org.uk>  wrote:
> > 
> > > On Sun, 2012-04-08 at 11:59 +0300, Sergei Trofimovich wrote:
> > > > In order to make the box boot I had to set:
> > > >      CONFIG_EMBEDDED=y
> > > >      # CONFIG_ARM_PATCH_PHYS_VIRT is not set
> > > >     CONFIG_PHYS_OFFSET=0x0
> > > > 
> > > > Do you have an idea why it does not boot anymore by default?
> > > 
> > > There is a u-boot commit which fixes this issue:
> > > 
> > > commit 679530278d5a79d34e356ad2d452f4400953bfc2
> > > Author: Michael Walle<[michael@walle.cc]>
> > > Date:   Mon Feb 6 22:42:10 2012 +0530
> > > 
> > >      arm, arm-kirkwood: disable l2c before linux boot
> > > 
> > >      The decompressor expects the L2 cache to be disabled. This fixes
> > > booting
> > >      some kernels, which have CONFIG_ARM_PATCH_PHYS_VIRT enabled.
> > > 
> > >      Signed-off-by: Michael Walle<michael@walle.cc>
> > >      Acked-by: Prafulla Wadaskar<prafulla@marvell.com>
> > >      Cc: Albert ARIBAUD<albert.u.boot@aribaud.net>
> > >      Cc: Prafulla Wadaskar<prafulla@marvell.com>
> > >      Cc: Wolfgang Denk<wd@denx.de>
> > 
> > Thank you, Ian. Updating u-boot helped!
> > 
> > Sorry for the noise.
> 
> I guess if updating u-boot is not an option, there's no other way around it
> than disabling CONFIG_ARM_PATCH_PHYS_VIRT altogether.
> 
> Could someone (Russell?) simply state what the consequences are of disabling
> such option? (Or, conversely, what its advantages are?)
> Only reference I found is the original commit, but I couldn't really
> understand what it does (or to what purpose), see at the bottom.

Disabling this option will not do you any harm.  It will prevent your 
kernel binary from being usable on another platform as the physical RAM 
address will then be hardcoded in the compiled kernel, but there are 
still other things that prevents such sharing in this case anyway.

One thing that this option allowed is to remove all the physical RAM 
offset information for most platform out of the source tree.  So to not 
have this option might mean that you might be prompted to provide it at 
kernel configuration time.

Nicolas
