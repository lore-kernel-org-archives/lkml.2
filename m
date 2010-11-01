Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab0KAUNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 16:13:18 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43827 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361Ab0KAUNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 16:13:15 -0400
From: John Stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Chris McDermott <lcm@us.ibm.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Chris Zankel <chris@zankel.net>,
        "David S. Miller" <davem@davemloft.net>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Glauber Costa <glommer@redhat.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        jacob.jun.pan@intel.com, Jeremy Fitzhardinge <jeremy@xensource.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Kyle McMartin <kyle@mcmartin.ca>, Michal Simek <monstr@monstr.eu>,
        Mikael Starvik <starvik@axis.com>, Mike Frysinger <vapier@gentoo.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 00/10] clocksource_register_khz/hz cleanups (for 2.6.38)
Date: Mon,  1 Nov 2010 13:12:20 -0700
Message-Id: <1288642350-1599-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clocksource_register_hz/khz() properly calculates a 
clocksource mult and shift value for a clocksource,
removing much of the copy/pasted or arch-specific helper 
functions that do so.

The common x86 clocksources have been converted to use
clocksource_register_hz/clocksource_register_khz and I've
seen no related bug reports, so I think the infrastructure
is fairly sound. So I wanted to start consolidating the
other arches to also use the clocksource_register_hz/khz
method.

I was a bit too late sending some of these patches out for
the 2.6.37 cycle, so I wanted to send these out early for 
2.6.38.

While all of these patches are untested, they are pretty
straight forward, so please consider including these into
your 2.6.38 queue for testing.

thanks
-john


CC: Chris McDermott <lcm@us.ibm.com>
CC: Chris Metcalf <cmetcalf@tilera.com>
CC: Chris Zankel <chris@zankel.net>
CC: "David S. Miller" <davem@davemloft.net>
CC: Dimitri Sivanich <sivanich@sgi.com>
CC: Glauber Costa <glommer@redhat.com>
CC: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
CC: jacob.jun.pan@intel.com
CC: Jeremy Fitzhardinge <jeremy@xensource.com>
CC: Jesper Nilsson <jesper.nilsson@axis.com>
CC: Kyle McMartin <kyle@mcmartin.ca>
CC: Michal Simek <monstr@monstr.eu>
CC: Mikael Starvik <starvik@axis.com>
CC: Mike Frysinger <vapier@gentoo.org>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Tony Luck <tony.luck@intel.com>

John Stultz (10):
  x86: Convert untested clocksources to clocksource_register_hz/khz
  ia64: convert to clocksource_register_hz/khz
  cris: convert to clocksource_register_khz
  tile: convert to use clocksource_register_hz
  parisc: convert to clocksource_register_hz/khz
  microblaze: convert to clocksource_register_hz/khz
  avr32: Convert to clocksource_register_hz
  blackfin: convert to clocksource_register_hz
  xtensa: convert to clocksource_register_hz/khz
  sparc: convert to clocksource_register_hz/khz

 arch/avr32/kernel/time.c         |    5 +----
 arch/blackfin/kernel/time-ts.c   |   35 ++---------------------------------
 arch/cris/arch-v32/kernel/time.c |    4 +---
 arch/ia64/kernel/cyclone.c       |    6 +-----
 arch/ia64/kernel/time.c          |    9 ++-------
 arch/ia64/sn/kernel/sn2/timer.c  |    6 +-----
 arch/microblaze/kernel/timer.c   |    6 +-----
 arch/parisc/kernel/time.c        |    6 +-----
 arch/sparc/kernel/time_64.c      |    4 +---
 arch/tile/kernel/time.c          |    5 +----
 arch/x86/kernel/apb_timer.c      |   10 +---------
 arch/x86/kernel/i8253.c          |    6 +-----
 arch/x86/kernel/kvmclock.c       |    6 +-----
 arch/x86/lguest/boot.c           |    4 +---
 arch/x86/platform/uv/uv_time.c   |    6 +-----
 arch/x86/xen/time.c              |    6 +-----
 arch/xtensa/kernel/time.c        |   13 +------------
 drivers/char/hpet.c              |    6 +-----
 drivers/clocksource/cyclone.c    |   10 ++--------
 19 files changed, 22 insertions(+), 131 deletions(-)

-- 
1.7.3.2.146.gca209

