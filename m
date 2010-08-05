Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934522Ab0HEWGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:06:53 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6512 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab0HEWGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:06:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=Mzw7zNwDxzg+pC2+Cw2CJeqKMpR5oHa8k1UY7R1MbG78m0bkCtJqjDtQL2FgP6e/3
	rEa2+77sCsxcY92j2hcNA==
MIME-Version: 1.0
In-Reply-To: <AANLkTimZYveOZLoDS82z0nosAHa21ChHCK1GpophEQ1P@mail.gmail.com>
References: <AANLkTi=dcQrik=+5xfwbNo_w7WkTOKZiKAFYFhwzbS=_@mail.gmail.com>
	<1281044755.30969.8.camel@c-dwalke-linux.qualcomm.com>
	<AANLkTimZYveOZLoDS82z0nosAHa21ChHCK1GpophEQ1P@mail.gmail.com>
Date: Thu, 5 Aug 2010 15:06:47 -0700
Message-ID: <AANLkTin_De+bqV9sC4k2iDaQ3i7r1pXLWbX87_dMAtAc@mail.gmail.com>
Subject: Re: [GIT PULL] Initial Tegra ARM support
From: Erik Gilling <konkers@google.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

I rebased my for-linus tree on top of master and resolved the merge
conflict with arch/arm/Kconfig

The following changes since commit cdd854bc42b5e6c79bbbc40c6600d995ffe6e747:
  Linus Torvalds (1):
        Merge branch 'next' of git://git.kernel.org/.../benh/powerpc

are available in the git repository at:

  git://android.kernel.org/kernel/tegra.git for-linus

Cheers,
    Erik

Colin Cross (4):
      [ARM] tegra: Add clock support
      [ARM] tegra: SMP support
      [ARM] tegra: Add timer support
      [ARM] tegra: harmony: Add harmony board file

Erik Gilling (5):
      [ARM] tegra: initial tegra support
      [ARM] tegra: Add IRQ support
      [ARM] tegra: add GPIO support
      [ARM] tegra: add pinmux support
      [ARM] tegra: add MAINTAINERS entry

 MAINTAINERS                                    |    9 +
 arch/arm/Kconfig                               |   24 +-
 arch/arm/Makefile                              |    1 +
 arch/arm/mach-tegra/Kconfig                    |   50 +
 arch/arm/mach-tegra/Makefile                   |   14 +
 arch/arm/mach-tegra/Makefile.boot              |    3 +
 arch/arm/mach-tegra/board-harmony-pinmux.c     |  144 +++
 arch/arm/mach-tegra/board-harmony.c            |  127 +++
 arch/arm/mach-tegra/board-harmony.h            |   22 +
 arch/arm/mach-tegra/board.h                    |   32 +
 arch/arm/mach-tegra/clock.c                    |  488 +++++++++
 arch/arm/mach-tegra/clock.h                    |  147 +++
 arch/arm/mach-tegra/common.c                   |   61 ++
 arch/arm/mach-tegra/gpio-names.h               |  247 +++++
 arch/arm/mach-tegra/gpio.c                     |  348 ++++++
 arch/arm/mach-tegra/headsmp.S                  |   61 ++
 arch/arm/mach-tegra/hotplug.c                  |  140 +++
 arch/arm/mach-tegra/include/mach/barriers.h    |   30 +
 arch/arm/mach-tegra/include/mach/clk.h         |   26 +
 arch/arm/mach-tegra/include/mach/clkdev.h      |   32 +
 arch/arm/mach-tegra/include/mach/debug-macro.S |   46 +
 arch/arm/mach-tegra/include/mach/entry-macro.S |  118 ++
 arch/arm/mach-tegra/include/mach/gpio.h        |   53 +
 arch/arm/mach-tegra/include/mach/hardware.h    |   24 +
 arch/arm/mach-tegra/include/mach/io.h          |   79 ++
 arch/arm/mach-tegra/include/mach/iomap.h       |  203 ++++
 arch/arm/mach-tegra/include/mach/irqs.h        |  173 +++
 arch/arm/mach-tegra/include/mach/memory.h      |   28 +
 arch/arm/mach-tegra/include/mach/pinmux.h      |  348 ++++++
 arch/arm/mach-tegra/include/mach/smp.h         |   30 +
 arch/arm/mach-tegra/include/mach/system.h      |   39 +
 arch/arm/mach-tegra/include/mach/timex.h       |   26 +
 arch/arm/mach-tegra/include/mach/uncompress.h  |   78 ++
 arch/arm/mach-tegra/include/mach/vmalloc.h     |   28 +
 arch/arm/mach-tegra/io.c                       |   78 ++
 arch/arm/mach-tegra/irq.c                      |   34 +
 arch/arm/mach-tegra/localtimer.c               |   25 +
 arch/arm/mach-tegra/pinmux.c                   |  945 ++++++++++++++++
 arch/arm/mach-tegra/platsmp.c                  |  156 +++
 arch/arm/mach-tegra/tegra2_clocks.c            | 1359 ++++++++++++++++++++++++
 arch/arm/mach-tegra/timer.c                    |  187 ++++
 arch/arm/mm/Kconfig                            |    3 +-
 42 files changed, 6061 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm/mach-tegra/Kconfig
 create mode 100644 arch/arm/mach-tegra/Makefile
 create mode 100644 arch/arm/mach-tegra/Makefile.boot
 create mode 100644 arch/arm/mach-tegra/board-harmony-pinmux.c
 create mode 100644 arch/arm/mach-tegra/board-harmony.c
 create mode 100644 arch/arm/mach-tegra/board-harmony.h
 create mode 100644 arch/arm/mach-tegra/board.h
 create mode 100644 arch/arm/mach-tegra/clock.c
 create mode 100644 arch/arm/mach-tegra/clock.h
 create mode 100644 arch/arm/mach-tegra/common.c
 create mode 100644 arch/arm/mach-tegra/gpio-names.h
 create mode 100644 arch/arm/mach-tegra/gpio.c
 create mode 100644 arch/arm/mach-tegra/headsmp.S
 create mode 100644 arch/arm/mach-tegra/hotplug.c
 create mode 100644 arch/arm/mach-tegra/include/mach/barriers.h
 create mode 100644 arch/arm/mach-tegra/include/mach/clk.h
 create mode 100644 arch/arm/mach-tegra/include/mach/clkdev.h
 create mode 100644 arch/arm/mach-tegra/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-tegra/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-tegra/include/mach/gpio.h
 create mode 100644 arch/arm/mach-tegra/include/mach/hardware.h
 create mode 100644 arch/arm/mach-tegra/include/mach/io.h
 create mode 100644 arch/arm/mach-tegra/include/mach/iomap.h
 create mode 100644 arch/arm/mach-tegra/include/mach/irqs.h
 create mode 100644 arch/arm/mach-tegra/include/mach/memory.h
 create mode 100644 arch/arm/mach-tegra/include/mach/pinmux.h
 create mode 100644 arch/arm/mach-tegra/include/mach/smp.h
 create mode 100644 arch/arm/mach-tegra/include/mach/system.h
 create mode 100644 arch/arm/mach-tegra/include/mach/timex.h
 create mode 100644 arch/arm/mach-tegra/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-tegra/include/mach/vmalloc.h
 create mode 100644 arch/arm/mach-tegra/io.c
 create mode 100644 arch/arm/mach-tegra/irq.c
 create mode 100644 arch/arm/mach-tegra/localtimer.c
 create mode 100644 arch/arm/mach-tegra/pinmux.c
 create mode 100644 arch/arm/mach-tegra/platsmp.c
 create mode 100644 arch/arm/mach-tegra/tegra2_clocks.c
 create mode 100644 arch/arm/mach-tegra/timer.c
