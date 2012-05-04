Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab2EDT5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 15:57:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62162 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab2EDT5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 15:57:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 00/02] mach-shmobile: Emma Mobile EV2 - first shot
Date: Fri, 4 May 2012 19:57:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, horms@verge.net.au,
        linux@arm.linux.org.uk, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl, lethal@linux-sh.org,
        olof@lixom.net
References: <20120503144645.6390.62303.sendpatchset@w520>
In-Reply-To: <20120503144645.6390.62303.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205041957.14205.arnd@arndb.de>
X-Provags-ID: V02:K0:ZcLtY+6Piuh9lIfFXPMKpk9fhcZUphjlsvvI8b9WNTS
 /uYaxiZLBM7qGUNauKLWKC7/njS0f5BxrkdaaKgw/h3BoCSSPF
 HESZBuq0I4lmPM/o3Y+BOTHTznxrk7yyJwmt+ZqwddUHKMNakP
 IJtJjHkrjfW3isk/m3tcQ4jENRYKn82XKG9KsiW70k9e4pjdBb
 3uBb0gFiWX/3k22sifQCFQ2MIswgSkoVDVbakpJbddMS4QxeT0
 1QDrWn0rjddb54XjTfuwit2lq9zksykEMIL+Bg8qMvgRwHYyEh
 aKZDQ8I8PDIGEDdPcMAiUCBImEiz5S+Lv7tS9tf7bF/gB0UYvf
 RFOau1ohl81QxhBTO79k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 May 2012, Magnus Damm wrote:
> mach-shmobile: Emma Mobile EV2 - first shot
> 
> [PATCH 01/02] mach-shmobile: Emma Mobile EV2 SoC base support
> [PATCH 02/02] mach-shmobile: KZM9D board prototype support
> 
> This series adds experimental Emma Mobile EV2 support to
> mach-shmobile. Yet another dual core Cortex-A9 SoC.
> 
> At this point only serial and timer is supported. Future work
> includes GPIO, network device, SMP and DT support. If possible
> it would be nice to use the common clocks on this platform.
> 
> To boot this on actual hardware you also need the following:
> "[PATCH] serial8250-em: Emma Mobile UART driver V2"
> "[PATCH] clocksource: em_sti: Emma Mobile STI driver"
> 
> Any reason to not put this in mach-shmobile?

Well, from all I can tell it shares basically zero code with the
rest of mach-shmobile, so I would be more comfortable with creating
a new mach-emma directory for this.

Clearly you have an interest in building it into the same kernel
as the shmobile/rmobile platforms, but there seems to be little
technical reason to keep them together. Since we are still missing
a bit of infrastructure to actually build multiple platform
directories together, how about doing this similar to some of
the mach-s3c24* directories:?

You can have a single Kconfig entry for shmobile and emma, but
leave the code in separate directories, and just refer to the
arch/arm/mach-shmobile/include/mach/ directory for the global
headers (they are obviously identical right now). The additions
to mach/common.h can easily become a local header file instead
of getting listed in mach/*.h. I believe you don't actually need
the other headers you currently include (mach/hardware.h, mach/irqs.h),
so it would be completely standalone aside from the header files
that are required for building, and it can still be built
together with shmobile.

	Arnd
