Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab0FDBGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 21:06:54 -0400
Received: from gate.crashing.org ([63.228.1.57]:41367 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065Ab0FDBGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 21:06:52 -0400
Subject: Re: ARM defconfig files
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Daniel Walker <dwalker@codeaurora.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
In-Reply-To: <20100603195703.GG25779@flint.arm.linux.org.uk>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
	 <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
	 <20100603181010.GA25779@flint.arm.linux.org.uk>
	 <alpine.LFD.2.00.1006031116360.8175@i5.linux-foundation.org>
	 <20100603185333.GD25779@flint.arm.linux.org.uk>
	 <alpine.LFD.2.00.1006031153420.8175@i5.linux-foundation.org>
	 <1275593742.23384.48.camel@c-dwalke-linux.qualcomm.com>
	 <20100603194559.GF25779@flint.arm.linux.org.uk>
	 <1275594598.23384.52.camel@c-dwalke-linux.qualcomm.com>
	 <20100603195703.GG25779@flint.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Jun 2010 11:06:37 +1000
Message-ID: <1275613597.1931.852.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-03 at 20:57 +0100, Russell King wrote:

> config MACH_HALIBUT
> 	bool "Halibut Board (QCT SURF7201A)"
> 	select I2C if STD_CONFIG
> 	select I2C_WHATEVER if STD_CONFIG
> 	...
> 
> That means if you enable STD_CONFIG, you'll get everything that's required
> selected.  If you then disable STD_CONFIG, I believe Kconfig leaves
> everything that was selected as still being selected.
> 
> So, what you _could_ do is start off with a blank configuration, then
> configure a kernel with STD_CONFIG enabled and you end up with everything
> that's required.  If you then want to disable something that's selected,
> turn off STD_CONFIG first, and you'll be able to turn off individual
> options.

The main problem with that approach is that you can't choose what is to
be modules and what is to be built-in.

Yes, I do -hate- modules as much as you do.

However, I have for example that little ARM based NAS box (DNS-323 from
Belkin) and the firmware on that thing won't let me boot a kernel that
is more than about 1.5M, tho I have about 6M of flash to put an
initramfs with modules in it.

Maybe we could extend select that way. IE. A way to say that a given
option should be y or m by default, for example, while the user can
still change it to be the other way around ?

Cheers,
Ben.


