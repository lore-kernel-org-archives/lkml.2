Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933607Ab2HXUxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 16:53:07 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45193 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933522Ab2HXUxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 16:53:05 -0400
Date: Fri, 24 Aug 2012 21:52:56 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] [RFC] ARM: treewide: manually change more
	mach-*/*.h includes
Message-ID: <20120824205256.GF18957@n2100.arm.linux.org.uk>
References: <201208221253.07278.arnd@arndb.de> <201208221301.19439.arnd@arndb.de> <20120822214323.GA12255@n2100.arm.linux.org.uk> <201208231135.11688.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208231135.11688.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 11:35:11AM +0000, Arnd Bergmann wrote:
> About two third of the platform header files included in device drivers
> are not related to platform_data according to what I found. Most of them
> are also wrong (hardcoding interrupt numbers or addresses, headers
> included by accident but not actually used, driver specific definitions
> that don't belong in the platform, platform specific abstraction layers,
> ...), but they tend to be harder to clean up.
> 
> I hope we can get there eventually, but I think the intermediate step
> of enforcing a mach-${MACH}/foo.h is a step in the right direction on
> that way.

I think the opposite: if a platform wishes to be part of the multiplatform
kernel, it must clean up its header files first to become part of that,
otherwise it will not be configured into such a kernel.

Otherwise there's no incentive for platform maintainers to do anything
other than sit around waiting for someone else to do it for them.
There's also no incentive to avoid introducing new dependencies between
drivers and mach/ include files in the future either.

Yes, some platforms are going to need a lot more work than others to get
them ready (such as the Samsung suite) but that doesn't mean that we
should work around that, especially when the end-goal is to get rid of
these platform dependencies between drivers and mach includes.
