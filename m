Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab1ASVwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:52:32 -0500
Received: from www.tglx.de ([62.245.132.106]:40778 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab1ASVuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:50:17 -0500
Message-Id: <20110119205258.462759212@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 21:47:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Chen Liqin <liqin.chen@sunplusct.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Ungerer <gerg@uclinux.org>,
        Hirokazu Takata <takata@linux-m32r.org>, Jeff Dike <jdike@addtoit.com>,
        Kyle McMartin <kyle@mcmartin.ca>, Michal Simek <monstr@monstr.eu>,
        Mikael Starvik <starvik@axis.com>, Mike Frysinger <vapier@gentoo.org>,
        Paul Mundt <lethal@linux-sh.org>, Richard Henderson <rth@twiddle.net>,
        Tony Luck <tony.luck@intel.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [patch 00/37] genirq: Remove __do_IRQ() and cleanup irq related
 Kconfigs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that rc1 is out, I got reliable information about the remaining
users of __do_IRQ(), which block the removal:

  arch/cris, arch/h8300, arch/m32r

The following series converts these architectures to proper flow
handlers and removes __do_IRQ(). Aside of that if cleans up the irq
related Kconfigs in the architectures and switches them to the generic
Kconfig in kernel/irq/

The __do_IRQ() removal is only compile tested, but

 - the CRIS maintainer said some time ago he is fine with breakage
   and will deal with the fallout

 - h8300 and m32r are basically unmaintained. The last updates from
   the maintainer side have been more than a year ago.

The conversion of all 3 architectures is straight forward and with low risc,
though it's only compile tested with all available defconfigs as far as it
goes. Some of them do not build in vanilla either, but the converted files
build fine.

The last chunk of this patch series is a straight forward conversion
of architectures to use the generic irq Kconfig file. Compile tested
and boot tested on a few.

That said, if there are no objections and Linus does not go berserk on
me, I'd like to get over with this right now.

Thanks,

	tglx
---
 Documentation/feature-removal-schedule.txt |    8 -
 arch/alpha/Kconfig                         |   19 --
 arch/blackfin/Kconfig                      |   17 --
 arch/cris/Kconfig                          |    6 
 arch/cris/arch-v10/kernel/irq.c            |   41 +----
 arch/cris/arch-v32/kernel/irq.c            |   50 +-----
 arch/cris/kernel/irq.c                     |    6 
 arch/frv/Kconfig                           |    9 -
 arch/h8300/Kconfig                         |    6 
 arch/h8300/kernel/irq.c                    |   50 ++----
 arch/ia64/Kconfig                          |   26 ---
 arch/m32r/Kconfig                          |   11 -
 arch/m32r/kernel/irq.c                     |   10 -
 arch/m32r/platforms/m32104ut/setup.c       |   58 ++-----
 arch/m32r/platforms/m32700ut/setup.c       |  214 +++++++++-------------------
 arch/m32r/platforms/mappi/setup.c          |   78 +++-------
 arch/m32r/platforms/mappi2/setup.c         |   89 +++--------
 arch/m32r/platforms/mappi3/setup.c         |   92 ++++--------
 arch/m32r/platforms/oaks32r/setup.c        |   65 ++------
 arch/m32r/platforms/opsput/setup.c         |  220 +++++++++--------------------
 arch/m32r/platforms/usrv/setup.c           |  115 +++++----------
 arch/m68knommu/Kconfig                     |    9 -
 arch/microblaze/Kconfig                    |   11 -
 arch/mips/Kconfig                          |    3 
 arch/mn10300/Kconfig                       |    8 -
 arch/parisc/Kconfig                        |   18 --
 arch/powerpc/Kconfig                       |   28 ---
 arch/score/Kconfig                         |   10 -
 arch/sparc/Kconfig                         |    9 -
 arch/tile/Kconfig                          |   19 --
 arch/um/Kconfig.common                     |    6 
 arch/um/Kconfig.um                         |    3 
 include/linux/irqdesc.h                    |   14 -
 kernel/irq/Kconfig                         |    3 
 kernel/irq/handle.c                        |  111 --------------
 35 files changed, 413 insertions(+), 1029 deletions(-)

