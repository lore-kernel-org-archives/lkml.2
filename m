Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab1BCArR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 19:47:17 -0500
Received: from www.tglx.de ([62.245.132.106]:37622 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755953Ab1BCArQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 19:47:16 -0500
Message-Id: <20110203003745.371989282@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 Feb 2011 00:46:39 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>, Tony Luck <tony.luck@intel.com>,
        David Howells <dhowells@redhat.com>, Michal Simek <monstr@monstr.eu>
Subject: [patch 0/8] genirq: Remove the last __do_IRQ() leftovers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are still a few irq chips which implement the .end function,
which is not relevant anymore since __do_IRQ() is gone. This series
removes the leftovers.

I'd like to push this through the irq tree if there are no objections
from the affected maintainers.

Thanks,

	tglx

 arch/frv/kernel/irq-mb93093.c                |    1 -
 arch/frv/kernel/irq.c                        |    6 ------
 arch/ia64/hp/sim/hpsim_irq.c                 |    1 -
 arch/ia64/kernel/iosapic.c                   |    2 --
 arch/ia64/kernel/irq_lsapic.c                |    1 -
 arch/ia64/sn/kernel/irq.c                    |   23 -----------------------
 arch/microblaze/kernel/intc.c                |   13 -------------
 arch/mips/dec/ioasic-irq.c                   |    8 --------
 arch/mips/kernel/irq-msc01.c                 |   11 -----------
 arch/mips/pnx833x/common/interrupts.c        |   11 -----------
 arch/mips/sgi-ip32/ip32-irq.c                |   22 ----------------------
 arch/mips/sibyte/bcm1480/irq.c               |   12 ------------
 arch/mips/sibyte/sb1250/irq.c                |   12 ------------
 arch/mips/sni/a20r.c                         |    9 ---------
 arch/mips/sni/pcimt.c                        |    7 -------
 arch/mips/sni/pcit.c                         |    7 -------
 arch/mips/sni/rm200.c                        |    7 -------
 arch/mn10300/kernel/mn10300-serial.c         |    5 -----
 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c |    1 -
 arch/powerpc/sysdev/tsi108_pci.c             |   13 -------------
 arch/um/kernel/irq.c                         |    2 --
 include/linux/irq.h                          |    2 --
 kernel/irq/chip.c                            |    3 ---
 kernel/irq/dummychip.c                       |    9 ---------
 kernel/irq/internals.h                       |   10 ----------
 kernel/irq/spurious.c                        |    6 ------
 26 files changed, 204 deletions(-)

