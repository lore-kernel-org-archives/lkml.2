Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab2C1Dbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 23:31:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:46000 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755930Ab2C1Dbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 23:31:40 -0400
Message-ID: <1332905481.2882.70.camel@pasglop>
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Wed, 28 Mar 2012 14:31:21 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's a few more things for powerpc this time around:

 - Anton's did some recent improvements to EPOW event reporting
on pSeries (power supply failures and such). The patches are self
contained enough and replace really nasty code so I felt it should
still go in

 - I did the vio driver registration change Greg requested, I
don't see the point of leaving that til the next merge window

 - The remaining EEH changes I said were still pending to get
rid of the EEH references from the generic struct device_node

 - A few more iSeries removal bits

 - A perf bug fix on 970

Cheers,
Ben.

The following changes since commit e22057c8599373e5caef0bc42bdb95d2a361ab0d:

  Merge tag 'stable/for-linus-3.4-tag-two' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen (2012-03-24 12:20:25 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

for you to fetch changes up to 1ce447b90f3e71c81ae59e0062bc305ef267668b:

  powerpc/perf: Fix instruction address sampling on 970 and Power4 (2012-03-28 11:33:24 +1100)

----------------------------------------------------------------
Anton Blanchard (6):
      powerpc: Make function that parses RTAS error logs global
      powerpc/pseries: Parse and handle EPOW interrupts
      powerpc/pseries: Use rtas_get_sensor in RAS code
      powerpc/pseries: Remove RTAS_POWERMGM_EVENTS
      powerpc/pseries: Clean up ras_error_interrupt code
      powerpc/pseries: Cut down on enthusiastic use of defines in RAS code

Benjamin Herrenschmidt (2):
      powerpc+sparc/vio: Modernize driver registration
      powerpc/perf: Fix instruction address sampling on 970 and Power4

Gavin Shan (3):
      powerpc/eeh: Remove eeh device from OF node
      powerpc/eeh: Remove eeh information from pci_dn
      powerpc/eeh: Retrieve PHB from global list

Stephen Rothwell (2):
      powerpc: Remove NO_IRQ_IGNORE
      powerpc: Random little legacy iSeries removal tidy ups

 arch/powerpc/boot/.gitignore                  |    1 -
 arch/powerpc/include/asm/iommu.h              |    1 -
 arch/powerpc/include/asm/irq.h                |    6 -
 arch/powerpc/include/asm/machdep.h            |    4 +-
 arch/powerpc/include/asm/mmu-hash64.h         |   12 --
 arch/powerpc/include/asm/pci-bridge.h         |   16 +-
 arch/powerpc/include/asm/perf_event_server.h  |    2 +
 arch/powerpc/include/asm/rtas.h               |   34 ++++-
 arch/powerpc/include/asm/smp.h                |    1 -
 arch/powerpc/include/asm/udbg.h               |    1 -
 arch/powerpc/include/asm/vio.h                |   10 +-
 arch/powerpc/kernel/irq.c                     |    8 +-
 arch/powerpc/kernel/prom_init.c               |    2 +-
 arch/powerpc/kernel/rtas.c                    |   34 +++++
 arch/powerpc/kernel/udbg.c                    |    3 -
 arch/powerpc/kernel/vdso.c                    |    4 +-
 arch/powerpc/kernel/vio.c                     |   12 +-
 arch/powerpc/perf/core-book3s.c               |   46 +++++-
 arch/powerpc/perf/power4-pmu.c                |    1 +
 arch/powerpc/perf/ppc970-pmu.c                |    1 +
 arch/powerpc/platforms/cell/beat_htab.c       |    2 -
 arch/powerpc/platforms/pseries/eeh.c          |   19 +--
 arch/powerpc/platforms/pseries/eeh_dev.c      |    2 +-
 arch/powerpc/platforms/pseries/io_event_irq.c |   68 +---------
 arch/powerpc/platforms/pseries/iommu.c        |   29 ++--
 arch/powerpc/platforms/pseries/ras.c          |  195 ++++++++++++++++---------
 arch/sparc/include/asm/vio.h                  |    9 +-
 arch/sparc/kernel/ds.c                        |    5 +-
 arch/sparc/kernel/vio.c                       |    8 +-
 drivers/block/sunvdc.c                        |    5 +-
 drivers/net/ethernet/ibm/ibmveth.c            |    7 +-
 drivers/net/ethernet/sun/sunvnet.c            |    5 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                |    7 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c              |    7 +-
 drivers/scsi/ibmvscsi/ibmvstgt.c              |    5 +-
 drivers/tty/hvc/hvc_vio.c                     |    7 +-
 drivers/tty/hvc/hvcs.c                        |    5 +-
 include/linux/of.h                            |   10 --
 38 files changed, 321 insertions(+), 273 deletions(-)


