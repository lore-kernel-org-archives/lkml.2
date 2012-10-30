Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934916Ab2JaH16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:27:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64131 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933730Ab2JaH1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:27:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH] ARM: zynq: move ttc timer code to drivers/clocksource
Date: Tue, 30 Oct 2012 22:36:42 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Josh Cartwright <josh.cartwright@ni.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <20121029185630.GA26149@beefymiracle.amer.corp.natinst.com> <508FBBA5.2080707@monstr.eu>
In-Reply-To: <508FBBA5.2080707@monstr.eu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210302236.43473.arnd@arndb.de>
X-Provags-ID: V02:K0:H4+geAxg0bFg0ImafBuj7Gp2ttKNxu4ACfOhQ7W9upn
 M3V8z3VbjhhP5mXUXIY/9zMXZ6hWPNETQhK+RaSbWBP0P75w/3
 b7ukMkKhlmsZV3gBLAUMZv9cionSTPqg8TFX38FZv+azaB6DtS
 kyPUBJi53Ic8FV/sdsltiHg/m6LwqhPOpLJfR/f/LFfC/3qDfR
 tcaDqK3jMEH2bnWfJZ3+1aG7FnbAJH0ymuasTeiMXSC5HKkXpu
 Vlg8IC3HjI9TBqK113Sj5leTeXWVbuX2MHQOrHiLdqHVmm5him
 e7ccWuuYJMZ/I4d3FCw4cw3yxbfuVHxCJ90/l6Jm+wIwEsxVIA
 Pb/WZaxhnhd/7GL20zvA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 October 2012, Michal Simek wrote:
> On 10/29/2012 07:56 PM, Josh Cartwright wrote:
> > Suggested cleanup by Arnd Bergmann.  Move the ttc timer.c code to
> > drivers/clocksource, and out of the mach-zynq directory.
> >
> > The common.h (which only held the timer declaration) was renamed to
> > xilinx_ttc.h and moved into include/linux.
> >
> > Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > ---
> >   arch/arm/mach-zynq/Makefile      |   2 +-
> >   arch/arm/mach-zynq/common.c      |   2 +-
> >   arch/arm/mach-zynq/common.h      |  24 ----
> >   arch/arm/mach-zynq/timer.c       | 298 ---------------------------------------
> >   drivers/clocksource/Makefile     |   1 +
> >   drivers/clocksource/xilinx_ttc.c | 297 ++++++++++++++++++++++++++++++++++++++
> >   include/linux/xilinx_ttc.h       |  24 ++++
> >   7 files changed, 324 insertions(+), 324 deletions(-)

When you submit a patch that moves files around, please use the '-M' flag to
git-format-patch so we can see the actual changes instead of a file being
removed and another one added.

> >   delete mode 100644 arch/arm/mach-zynq/common.h
> >   delete mode 100644 arch/arm/mach-zynq/timer.c
> >   create mode 100644 drivers/clocksource/xilinx_ttc.c
> >   create mode 100644 include/linux/xilinx_ttc.h
> 
> Really?
> If yes. shouldn't be there any better naming convention
> especially for headers. linux/clocksource/xilinx_ttc.h.

Moving it is certainly the right direction, but I think we need a better way to
handle those forward declarations. "struct sys_timer" is actually an ARM specific
structure, so we might just want to add all the forward declarations for the 
timers into arch/arm/include/asm/mach/time.h. It's not ideal to do it like that,
but I think it's much better than having a new globally visible header for
each timer that is used on ARM.

Eventually, we might want to do something similar to what we are discussing
for the top-level IRQ controllers at the moment, where we just autodetect them
from DT if possible, so we don't need to have any pointer to the timer from
arch code at all.

	Arnd
