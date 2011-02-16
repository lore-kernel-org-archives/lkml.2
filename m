Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab1BPGfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 01:35:45 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39960 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab1BPGfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 01:35:01 -0500
From: John Stultz <johnstul@us.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Chris McDermott <lcm@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Glauber Costa <glommer@redhat.com>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>, jacob.jun.pan@intel.com,
        Jeremy Fitzhardinge <jeremy@xensource.com>,
        Matt Turner <mattst88@gmail.com>, Mike Frysinger <vapier@gentoo.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Richard Henderson <rth@twiddle.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 0/6] clocksource_register_hz/khz cleanups for 2.6.39
Date: Tue, 15 Feb 2011 22:34:46 -0800
Message-Id: <1297838092-22989-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I wanted to send out a small batch of clocksource_register_hz/khz
cleanups for possible inclusion in 2.6.39.

I've been unable to test these, but they should be pretty straight
forward.

It would be *wonderful* if arch maintainers would check these out and
add them into their queue. However, since I sent most of these out
for 2.6.37 and 2.6.38 with no takers, if they get ignored again, I
will try to push these through Thomas.

thanks
-john

CC: Chris McDermott <lcm@us.ibm.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: Dimitri Sivanich <sivanich@sgi.com>
CC: Glauber Costa <glommer@redhat.com>
CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: jacob.jun.pan@intel.com
CC: Jeremy Fitzhardinge <jeremy@xensource.com>
CC: Matt Turner <mattst88@gmail.com>
CC: Mike Frysinger <vapier@gentoo.org>
CC: Ralf Baechle <ralf@linux-mips.org>
CC: Richard Henderson <rth@twiddle.net>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Tony Luck <tony.luck@intel.com>

John Stultz (6):
  x86: Convert untested clocksources to clocksource_register_hz/khz
  ia64: convert to clocksource_register_hz/khz
  alpha: convert to clocksource_register_hz
  sparc: convert to clocksource_register_hz/khz
  mips: convert to clocksource_register_hz/khz
  blackfin: convert to clocksource_register_hz

 arch/alpha/kernel/time.c                        |    3 +-
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
 arch/x86/lguest/boot.c                          |    4 +--
 arch/x86/platform/uv/uv_time.c                  |    6 +---
 arch/x86/xen/time.c                             |    6 +---
 drivers/char/hpet.c                             |    6 +---
 drivers/clocksource/cyclone.c                   |   10 +-----
 27 files changed, 31 insertions(+), 166 deletions(-)

-- 
1.7.3.2.146.gca209

