Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab1CaGm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:42:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65241 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab1CaGm1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 02:42:27 -0400
MIME-Version: 1.0
X-Originating-IP: [172.22.72.244]
In-Reply-To: <AANLkTi=fSUizM38SkBhPAzSbArgoNQxbV8JrC51x_RDf@mail.gmail.com>
References: <20110317183048.GW7258@atomide.com>
	<AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
	<20110318101512.GA15375@n2100.arm.linux.org.uk>
	<201103301906.42429.arnd@arndb.de>
	<AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
	<20110331001502.GB6680@n2100.arm.linux.org.uk>
	<AANLkTinE7EDbV8hrYZWBxgvwOxdPMLoS0Y57PSm04rvM@mail.gmail.com>
	<AANLkTik-BFTzyPLuYVdhCJPocc0wPY0rKvO7BQS4Fg1S@mail.gmail.com>
	<AANLkTikd_JRxmB_OWZqq178=K3bnxhdDqcNbgFNRtTyU@mail.gmail.com>
	<AANLkTimS_8BnBz9MSdxYJVL6oreEpH=W61BsyuX2G+Xz@mail.gmail.com>
	<AANLkTimtO7vR2AQvJj1hHMqHCDqtoiJX_eENE9o3dPpV@mail.gmail.com>
	<AANLkTimPJCiaUyTfcR1NSPivJ2YjSwazhiWRC-CPLy6J@mail.gmail.com>
	<AANLkTi=fSUizM38SkBhPAzSbArgoNQxbV8JrC51x_RDf@mail.gmail.com>
Date: Wed, 30 Mar 2011 23:42:26 -0700
Message-ID: <AANLkTi=dSm7j2Kxa5PbyKvQ=73cjVNkA6GZ3NvyZua5p@mail.gmail.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bill Gatliff <bgat@billgatliff.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 8:24 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> Check out the device tree files (*.dts) and do that same
>
>   git ls-files arch/arm/ | grep gpio
>
> except do it on powerpc.
>
> See the difference?
>
> The powerpc people even wrote documentation about the thing, which is
> just above and beyond reasonable.

Powerpc does has the benefit of only having about three (active)
silicon vendors, out of which two are doing most of the arch
infrastructure work. There are more chefs in the kitchen in the ARM
world. But yeah, the arch/powerpc/platforms/* directories are tiny
compared to the ARM equivalents.

That being said: arch/ppc used to be messy too. A lot of cleanups were
done when the ppc+ppc64 -> powerpc merge happened.

Starting over on a new base would avoid some of the problems of
dealing with new incoming platforms while things are being cleaned up.
It would
decouple need to start reviewing _everything_ at the same time as as
the cleanup is underway, and would give a chance to set good examples
for how things should be handled as new platforms are brought over.

Then, when the time comes, start refusing new boards/SoCs/features on
the old subtree and have new clean stuff go directly into the new one.

Of course, main drawback is that this would duplicate the actual arch
code (the parts Russell are handling), and he is already stretched
thin as it is. That code isn't what needs the cleanup most though, so
maybe it can just be shared to start with to avoid that overhead.


-Olof
