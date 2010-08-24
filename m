Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab0HXWq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:46:58 -0400
Received: from kroah.org ([198.145.64.141]:59760 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755705Ab0HXWqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:46:47 -0400
Date: Tue, 24 Aug 2010 15:46:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/59] 2.6.32.21-stable review
Message-ID: <20100824224625.GA5449@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.32.21 release.
There are 59 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Thursday, August 26, 2010 22:00:00 UTC
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.21-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                                    |    2 +-
 arch/arm/include/asm/ptrace.h               |   17 +++-
 arch/powerpc/Makefile                       |    2 +-
 arch/powerpc/kernel/head_64.S               |    6 +-
 arch/sparc/include/asm/atomic_64.h          |   10 +-
 arch/sparc/include/asm/parport.h            |    4 +
 arch/sparc/include/asm/rwsem-const.h        |    2 +-
 arch/x86/Kconfig                            |    5 +
 arch/x86/kernel/apic/apic.c                 |   41 ++++++++--
 arch/x86/kernel/apic/io_apic.c              |    2 +
 arch/x86/kernel/smpboot.c                   |   19 +++++
 arch/x86/oprofile/nmi_int.c                 |   17 ++++-
 drivers/gpu/drm/drm_drv.c                   |    4 +-
 drivers/gpu/drm/i915/i915_gem.c             |    3 +-
 drivers/gpu/drm/i915/intel_display.c        |    1 +
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |    2 +-
 drivers/hwmon/pc87360.c                     |   31 ++++---
 drivers/isdn/sc/ioctl.c                     |   10 +-
 drivers/md/dm-ioctl.c                       |   44 ++++++-----
 drivers/md/dm-mpath.c                       |    1 +
 drivers/memstick/core/mspro_block.c         |    5 +-
 drivers/mtd/nand/pxa3xx_nand.c              |    2 +-
 drivers/net/wireless/ath/ath5k/base.c       |   21 +++++
 drivers/pcmcia/pcmcia_resource.c            |    5 +-
 drivers/usb/host/xhci-ring.c                |    2 +-
 drivers/usb/serial/cp210x.c                 |    4 +-
 drivers/usb/serial/ftdi_sio.c               |    5 +-
 drivers/usb/serial/ftdi_sio_ids.h           |    9 ++
 drivers/usb/serial/io_ti.c                  |    2 +-
 drivers/usb/serial/navman.c                 |    1 +
 drivers/usb/serial/option.c                 |    7 +-
 drivers/usb/serial/pl2303.c                 |    1 +
 drivers/usb/serial/pl2303.h                 |    4 +
 drivers/video/sunxvr500.c                   |   24 ++++--
 firmware/Makefile                           |    2 +-
 fs/ext4/balloc.c                            |    3 -
 fs/ext4/ext4.h                              |    2 +
 fs/ext4/extents.c                           |    4 +-
 fs/ext4/mballoc.h                           |    2 -
 fs/nfs/super.c                              |    7 ++
 fs/ocfs2/acl.c                              |   33 +++++++-
 fs/ocfs2/dlm/dlmmaster.c                    |    9 +--
 fs/ocfs2/dlm/dlmrecovery.c                  |   22 +++---
 fs/ocfs2/dlm/dlmthread.c                    |  114 +++++++++++++--------------
 fs/ocfs2/refcounttree.c                     |   20 ++++-
 include/linux/mm_types.h                    |    2 +-
 include/sound/emu10k1.h                     |    1 +
 kernel/fork.c                               |    7 +-
 mm/memory.c                                 |   15 +++-
 mm/mlock.c                                  |   21 ++++-
 mm/mmap.c                                   |   21 ++++-
 mm/nommu.c                                  |    7 +-
 mm/slab.c                                   |    4 +-
 mm/vmscan.c                                 |   53 +++++++++++--
 net/can/bcm.c                               |   41 ++++++---
 net/core/dev.c                              |    2 +-
 net/netlink/af_netlink.c                    |   46 ++++-------
 net/sched/act_nat.c                         |    2 +-
 scripts/mkmakefile                          |    4 +-
 sound/core/pcm_native.c                     |    4 +
 sound/pci/emu10k1/emu10k1.c                 |    4 +
 sound/pci/emu10k1/emupcm.c                  |   30 ++++++-
 sound/pci/emu10k1/memory.c                  |    4 +-
 sound/pci/hda/patch_realtek.c               |    1 +
 sound/pci/intel8x0.c                        |    6 ++
 sound/pci/riptide/riptide.c                 |   11 +--
 sound/soc/codecs/wm8580.c                   |    6 +-
 sound/soc/codecs/wm8776.c                   |    7 --
 68 files changed, 556 insertions(+), 276 deletions(-)
