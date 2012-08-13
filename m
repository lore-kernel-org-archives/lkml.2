Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649Ab2HMKxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 06:53:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:32891 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab2HMKxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 06:53:03 -0400
Date: Mon, 13 Aug 2012 11:52:45 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] ARM: rpc: Fix building RiscPC
Message-ID: <20120813105245.GE18957@n2100.arm.linux.org.uk>
References: <1344461278-28245-1-git-send-email-arnd@arndb.de> <1344461278-28245-10-git-send-email-arnd@arndb.de> <20120809074754.GP18957@n2100.arm.linux.org.uk> <201208101103.58808.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208101103.58808.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 11:03:58AM +0000, Arnd Bergmann wrote:
> On Thursday 09 August 2012, Russell King - ARM Linux wrote:
> > On Wed, Aug 08, 2012 at 11:27:57PM +0200, Arnd Bergmann wrote:
> > > ARMv3 support was removed in 357c9c1f07 "ARM: Remove support for ARMv3
> > > ARM610 and ARM710 CPUs", which explicitly left parts of the CPU32v3
> > > support in place for building RiscPC. However, this does not actually
> > > build in my test setup.
> > > 
> > > This is probably not the right solution, but maybe someone has a better
> > > idea for how to deal with this.
> > 
> > This isn't the right solution.  The RiscPC bus does not support half-word
> > load/stores, so we must continue to build that target for the 32v3
> > architecture (which is why I carefully left that stuff behind.)
> > 
> > The mistake is in what I did with arch/arm/lib - the armv3 code in there
> > needs to be resurected instead.
> 
> Ok, I'll drop my patch from the series then and wait for you to
> fix this properly.

I've just reverted the arch/arm/lib part of
357c9c1f07d4546bc3fbc0fd1044d96b114d14ed (ARM: Remove support for ARMv3
ARM610 and ARM710 CPUs) so when I push my fixes branch this should resolve
your build error.
