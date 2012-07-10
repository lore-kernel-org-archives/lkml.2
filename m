Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab2GJVpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 17:45:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47140 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753307Ab2GJVpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 17:45:07 -0400
Date: Tue, 10 Jul 2012 22:44:29 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120710214429.GA4733@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <20120710101018.GE15120@arm.com>
 <20120710163358.6ae4a576@pyramind.ukuu.org.uk>
 <201207101652.18401.arnd@arndb.de>
 <20120710203527.GA16986@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120710203527.GA16986@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(just replying to a couple of points now, I'll follow up tomorrow)

On Tue, Jul 10, 2012 at 09:35:27PM +0100, Ingo Molnar wrote:
> Do you *really* think that all of the 32-bit ARM code should 
> essentially be thrown away when going to 64-bit ARM, that 
> patches can only touch arch/arm64/ + drivers/ or the highway?

Definitely not, I don't think anyone claimed this. The 32-bit ARM code
will have the same important place for a very long time, ARM Ltd isn't
withdrawing support for this (it's the main revenue generator). I expect
to see many new 32-bit platforms to appear, MP systems, big.little
configurations etc. If there is need for bigger physical address space,
LPAE support (even with its drawbacks) is still the preferred choice for
mobile systems.

But this doesn't have much to do with the aarch64 port. 32-bit SoC code
goes under arch/arm/ and drivers/, there is no change here. 64-bit SoC
goes under drivers/ and, if absolutely necessary, under arch/aarch64 (or
arm64).

> The moment someone adds 64-bit CPU support to arch/arm/ and it's 
> merged we'll have an interesting situation on hand: support for 
> the same CPU in two different architectures in the kernel tree.

Unless I misunderstand you, adding 64-bit support to arch/arm/ means
pretty much doing a significant architecture port or somehow merging the
patches that I posted. I doubt this would go unnoticed (would be obvious
only looking at the diffstat) and such pull request should be rejected
until we get to an agreement on using one or the other.

If you meant ARMv8 32-bit support, this should be rejected by the
arm-soc team as ARMv8 has a 64-bit mode already.

-- 
Catalin
