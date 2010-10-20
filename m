Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab0JTXpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 19:45:23 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48123 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab0JTXoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 19:44:21 -0400
From: John Stultz <johnstul@us.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, jacob.jun.pan@intel.com,
        Glauber Costa <glommer@redhat.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Alok N Kataria <akataria@vmware.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jeremy Fitzhardinge <jeremy@xensource.com>,
        Chris McDermott <lcm@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        Tony Luck <tony.luck@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Haavard Skinnemoen <hskinnemoen@atmel.com>,
        Ralf Baechle <ralf@linux-mips.org>, Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 0/7] clocksource_register_khz/hz cleanups(for 2.6.37?)
Date: Wed, 20 Oct 2010 16:44:06 -0700
Message-Id: <1287618253-13258-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So the common x86 clocksources have switched over to using 
clocksource_register_khz/hz() and so far I've seen no bug
reports, so I wanted to post the conversion for a few more
architectures so they can be queued up for 2.6.37 (or later
if the maintainer feels more testing would be good).

These changes greatly simplify clocksource registration,
removing much of the copy/paste voodoo surrounding how
to calculate good mult and shift values for clocksources.

While the patch set is numbered here, the patches are not
dependent on each other. So each maintainer can make an 
independent call on merging for 2.6.37.

The conversion is fairly straight forward. However, I have 
not been able to test these, so I'd appreciate any testing 
or feedback. Any assistance from the maintainers in getting
these into their trees would also be greatly appreciated.

thanks
-john


CC: jacob.jun.pan@intel.com
CC: Glauber Costa <glommer@redhat.com>
CC: Dimitri Sivanich <sivanich@sgi.com>
CC: Alok N Kataria <akataria@vmware.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Jeremy Fitzhardinge <jeremy@xensource.com>
CC: Chris McDermott <lcm@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Magnus Damm <magnus.damm@gmail.com>
CC: Paul Mundt <lethal@linux-sh.org>
CC: Tony Luck <tony.luck@intel.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: Ralf Baechle <ralf@linux-mips.org>
CC: Mike Frysinger <vapier@gentoo.org>


John Stultz (7):
  x86: Convert remaining clocksources to clocksource_register_hz/khz
  sh: convert to clocksource_register_hz
  ia64: convert to clocksource_register_hz/khz
  sparc: convert to clocksource_register_hz/khz
  avr32: Convert to clocksource_register_hz
  mips: convert to clocksource_register_hz/khz
  blackfin: convert to clocksource_register_hz

 arch/avr32/kernel/time.c                        |    5 +--
 arch/blackfin/kernel/time-ts.c                  |   35 +---------------------
 arch/ia64/kernel/cyclone.c                      |    6 +---
 arch/ia64/kernel/time.c                         |    9 +----
 arch/ia64/sn/kernel/sn2/timer.c                 |    6 +---
 arch/mips/alchemy/common/time.c                 |    3 +-
 arch/mips/cavium-octeon/csrc-octeon.c           |    3 +-
 arch/mips/include/asm/time.h                    |    6 ----
 arch/mips/jz4740/time.c                         |    3 +-
 arch/mips/kernel/cevt-txx9.c                    |    3 +-
 arch/mips/kernel/csrc-bcm1480.c                 |    3 +-
 arch/mips/kernel/csrc-ioasic.c                  |    4 +--
 arch/mips/kernel/csrc-powertv.c                 |   35 ++---------------------
 arch/mips/kernel/csrc-r4k.c                     |    4 +--
 arch/mips/kernel/csrc-sb1250.c                  |    3 +-
 arch/mips/kernel/i8253.c                        |    5 +--
 arch/mips/loongson/common/cs5536/cs5536_mfgpt.c |    5 +--
 arch/mips/sgi-ip27/ip27-timer.c                 |    3 +-
 arch/sparc/kernel/time_64.c                     |    4 +--
 arch/x86/kernel/apb_timer.c                     |   10 +------
 arch/x86/kernel/i8253.c                         |    6 +---
 arch/x86/kernel/kvmclock.c                      |    6 +---
 arch/x86/kernel/uv_time.c                       |    6 +---
 arch/x86/kernel/vmiclock_32.c                   |    9 +-----
 arch/x86/lguest/boot.c                          |    4 +--
 arch/x86/xen/time.c                             |    6 +---
 drivers/char/hpet.c                             |    6 +---
 drivers/clocksource/cyclone.c                   |   10 +-----
 drivers/clocksource/sh_cmt.c                    |   14 ++++----
 drivers/clocksource/sh_tmu.c                    |   12 ++++----
 30 files changed, 45 insertions(+), 189 deletions(-)

