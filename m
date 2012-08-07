Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab2HGDhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:37:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59599 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757215Ab2HGDhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:37:52 -0400
Message-Id: <20120807032755.803571133@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:27:55 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/70] 3.2.27-stable review
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.27 release.
There are 70 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Aug  9 10:00:00 UTC 2012.
Anything received after that time might be too late.

A combined patch relative to 3.2.26 will be posted as an additional
response to this, and the diffstat can be found below.

Ben.

-------------
 Documentation/sound/alsa/HD-Audio-Models.txt |    3 +-
 Documentation/stable_kernel_rules.txt        |   19 +-
 Makefile                                     |    4 +-
 arch/arm/include/asm/mutex.h                 |  119 +----------
 arch/arm/kernel/entry-armv.S                 |  111 +++++++----
 arch/arm/kernel/process.c                    |    2 +
 arch/arm/kernel/traps.c                      |    8 -
 arch/arm/mm/tlb-v7.S                         |   12 ++
 arch/arm/vfp/entry.S                         |   16 +-
 arch/arm/vfp/vfphw.S                         |   19 +-
 arch/arm/vfp/vfpmodule.c                     |    8 +-
 arch/ia64/include/asm/atomic.h               |    4 +-
 arch/m68k/include/asm/entry.h                |    4 +-
 arch/m68k/kernel/sys_m68k.c                  |    8 +-
 arch/s390/include/asm/mmu_context.h          |   14 +-
 arch/s390/include/asm/processor.h            |    2 +
 arch/s390/mm/fault.c                         |   13 +-
 arch/s390/mm/mmap.c                          |   12 +-
 arch/s390/mm/pgtable.c                       |    5 -
 arch/x86/kernel/alternative.c                |    2 +-
 arch/x86/xen/p2m.c                           |   36 ++++
 drivers/block/floppy.c                       |    8 +-
 drivers/block/virtio_blk.c                   |    9 +-
 drivers/char/mspec.c                         |    2 +-
 drivers/char/random.c                        |  273 +++++++++++++++++++-------
 drivers/firmware/pcdp.c                      |    4 +-
 drivers/gpu/drm/i915/intel_dp.c              |    4 +-
 drivers/input/mouse/synaptics.c              |   23 +++
 drivers/md/dm-thin.c                         |    7 +-
 drivers/md/raid1.c                           |    5 +-
 drivers/media/rc/ene_ir.c                    |    3 +-
 drivers/mfd/ab3100-core.c                    |    2 -
 drivers/mfd/wm831x-otp.c                     |    8 +
 drivers/net/wireless/rt2x00/rt2800usb.c      |    1 +
 drivers/platform/x86/asus-wmi.c              |    7 +-
 drivers/rtc/rtc-wm831x.c                     |   24 ++-
 drivers/staging/media/lirc/lirc_sir.c        |   60 +++++-
 drivers/tty/serial/pch_uart.c                |   21 +-
 drivers/usb/core/hub.c                       |    9 +
 drivers/usb/early/ehci-dbgp.c                |    2 +-
 drivers/video/smscufx.c                      |    2 +-
 fs/exofs/ore.c                               |   14 +-
 fs/nfs/file.c                                |    7 +-
 fs/nfsd/nfs4xdr.c                            |    2 +-
 fs/nilfs2/ioctl.c                            |    4 +-
 fs/nilfs2/super.c                            |    3 +
 fs/nilfs2/the_nilfs.c                        |    1 +
 fs/nilfs2/the_nilfs.h                        |    2 +
 include/linux/hugetlb.h                      |   10 +
 include/linux/init_task.h                    |   12 +-
 include/linux/random.h                       |    4 +-
 include/linux/sched.h                        |    5 +-
 kernel/futex.c                               |   17 +-
 kernel/irq/handle.c                          |    7 +-
 kernel/sched.c                               |   32 +--
 lib/vsprintf.c                               |    3 +-
 mm/hugetlb.c                                 |   28 ++-
 mm/internal.h                                |    2 +
 mm/memory.c                                  |    7 +-
 mm/mmu_notifier.c                            |   45 ++---
 mm/page_alloc.c                              |   33 ++--
 mm/sparse.c                                  |    3 +
 net/core/dev.c                               |    3 +
 net/core/drop_monitor.c                      |  113 ++++++-----
 net/core/rtnetlink.c                         |    1 +
 net/sunrpc/rpcb_clnt.c                       |    4 +-
 net/sunrpc/sched.c                           |    2 +
 net/sunrpc/xprtrdma/transport.c              |    3 +-
 net/sunrpc/xprtsock.c                        |   10 +
 net/wireless/util.c                          |    3 +
 sound/drivers/mpu401/mpu401_uart.c           |    1 +
 sound/pci/hda/patch_realtek.c                |   28 +++
 sound/pci/hda/patch_via.c                    |    7 +-
 sound/soc/codecs/wm8962.c                    |    3 +
 sound/soc/codecs/wm8994.c                    |    2 +-
 sound/usb/clock.c                            |    3 +-
 76 files changed, 863 insertions(+), 456 deletions(-)

-- 
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

