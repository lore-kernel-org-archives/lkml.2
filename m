Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab0G1NnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 09:43:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:54079 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab0G1NnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 09:43:19 -0400
Message-ID: <4C5033D9.7030800@kernel.org>
Date: Wed, 28 Jul 2010 15:42:49 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>
CC: Jeff Garzik <jeff@garzik.org>, Greg KH <gregkh@suse.de>
Subject: [GIT PULL tip/genirq] Please pull from lost-spurious-irq
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 28 Jul 2010 13:42:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Thomas.

With Jeff's acks added, patches to make libata use irq-expect are
commited.  Please pull from the following branch to receive patches[1]
to improve lost/spurious irq handling.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git lost-spurious-irq

Thanks.

Tejun Heo (14):
      irq: cleanup irqfixup
      irq: make spurious poll timer per desc
      irq: use desc->poll_timer for irqpoll
      irq: kill IRQF_IRQPOLL
      irq: misc preparations for further changes
      irq: implement irq_schedule_poll()
      irq: improve spurious IRQ handling
      irq: implement IRQ watching
      irq: implement IRQ expecting
      irq: add comment about overall design of lost/spurious IRQ handling
      usb: use IRQ watching
      sata_fsl,mv,nv: prepare for NCQ command completion update
      libata: always use ata_qc_complete_multiple() for NCQ command completion
      libata: use IRQ expecting

 arch/arm/mach-aaec2000/core.c            |    2 +-
 arch/arm/mach-at91/at91rm9200_time.c     |    2 +-
 arch/arm/mach-at91/at91sam926x_time.c    |    2 +-
 arch/arm/mach-bcmring/core.c             |    2 +-
 arch/arm/mach-clps711x/time.c            |    2 +-
 arch/arm/mach-cns3xxx/core.c             |    2 +-
 arch/arm/mach-ebsa110/core.c             |    2 +-
 arch/arm/mach-ep93xx/core.c              |    2 +-
 arch/arm/mach-footbridge/dc21285-timer.c |    2 +-
 arch/arm/mach-footbridge/isa-timer.c     |    2 +-
 arch/arm/mach-h720x/cpu-h7201.c          |    2 +-
 arch/arm/mach-h720x/cpu-h7202.c          |    2 +-
 arch/arm/mach-integrator/integrator_ap.c |    2 +-
 arch/arm/mach-ixp2000/core.c             |    2 +-
 arch/arm/mach-ixp23xx/core.c             |    2 +-
 arch/arm/mach-ixp4xx/common.c            |    2 +-
 arch/arm/mach-lh7a40x/time.c             |    2 +-
 arch/arm/mach-mmp/time.c                 |    2 +-
 arch/arm/mach-netx/time.c                |    2 +-
 arch/arm/mach-ns9xxx/irq.c               |    3 -
 arch/arm/mach-ns9xxx/time-ns9360.c       |    2 +-
 arch/arm/mach-nuc93x/time.c              |    2 +-
 arch/arm/mach-omap1/time.c               |    2 +-
 arch/arm/mach-omap1/timer32k.c           |    2 +-
 arch/arm/mach-omap2/timer-gp.c           |    2 +-
 arch/arm/mach-pnx4008/time.c             |    2 +-
 arch/arm/mach-pxa/time.c                 |    2 +-
 arch/arm/mach-sa1100/time.c              |    2 +-
 arch/arm/mach-shark/core.c               |    2 +-
 arch/arm/mach-u300/timer.c               |    2 +-
 arch/arm/mach-w90x900/time.c             |    2 +-
 arch/arm/plat-iop/time.c                 |    2 +-
 arch/arm/plat-mxc/time.c                 |    2 +-
 arch/arm/plat-samsung/time.c             |    2 +-
 arch/arm/plat-versatile/timer-sp.c       |    2 +-
 arch/blackfin/kernel/time-ts.c           |    6 +-
 arch/ia64/kernel/time.c                  |    2 +-
 arch/parisc/kernel/irq.c                 |    2 +-
 arch/powerpc/platforms/cell/interrupt.c  |    5 +-
 arch/x86/kernel/time.c                   |    2 +-
 drivers/ata/libata-core.c                |   54 ++-
 drivers/ata/libata-eh.c                  |    4 +-
 drivers/ata/libata-sff.c                 |   37 +-
 drivers/ata/sata_fsl.c                   |   26 +-
 drivers/ata/sata_mv.c                    |   58 +-
 drivers/ata/sata_nv.c                    |   87 +--
 drivers/clocksource/sh_cmt.c             |    3 +-
 drivers/clocksource/sh_mtu2.c            |    3 +-
 drivers/clocksource/sh_tmu.c             |    3 +-
 drivers/usb/core/hcd.c                   |    1 +
 include/linux/interrupt.h                |   43 +-
 include/linux/irq.h                      |   40 +-
 include/linux/libata.h                   |    2 +
 kernel/irq/chip.c                        |   20 +-
 kernel/irq/handle.c                      |    7 +-
 kernel/irq/internals.h                   |   10 +-
 kernel/irq/manage.c                      |   18 +-
 kernel/irq/proc.c                        |    5 +-
 kernel/irq/spurious.c                    |  978 +++++++++++++++++++++++++-----
 59 files changed, 1101 insertions(+), 386 deletions(-)

-- 
tejun

[1] http://thread.gmane.org/gmane.linux.ide/46448
