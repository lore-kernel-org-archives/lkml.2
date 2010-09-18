Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab0IRTBs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:01:48 -0400
Received: from kroah.org ([198.145.64.141]:51090 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165Ab0IRTBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:11 -0400
Date: Sat, 18 Sep 2010 12:00:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [000/123] 2.6.32.22-stable review
Message-ID: <20100918190024.GA14388@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Note, I do still have patches that people have sent me for inclusion in
the .32-stable tree in my queue, but I figured this series was already
big enough that it should go out now.  If you notice, I _did_ apply all
patches that went through Linus's tree with a stable@kernel.org marking
on it, so people might consider using that method instead...]

This is the start of the stable review cycle for the 2.6.32.22 release.
There are 123 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by September 20, 2010 19:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.22-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                                |    2 +-
 arch/arm/kernel/entry-common.S          |    2 +
 arch/ia64/include/asm/compat.h          |    2 +-
 arch/ia64/kernel/msi_ia64.c             |    2 +-
 arch/ia64/sn/kernel/msi_sn.c            |    2 +-
 arch/mips/include/asm/compat.h          |    2 +-
 arch/parisc/include/asm/compat.h        |    2 +-
 arch/powerpc/include/asm/compat.h       |    2 +-
 arch/s390/include/asm/compat.h          |    2 +-
 arch/sparc/include/asm/compat.h         |    2 +-
 arch/x86/ia32/ia32entry.S               |   22 +-
 arch/x86/include/asm/compat.h           |    2 +-
 arch/x86/include/asm/tsc.h              |    2 +
 arch/x86/kernel/apic/io_apic.c          |    2 +-
 arch/x86/kernel/tsc.c                   |   38 +++
 arch/x86/oprofile/nmi_int.c             |   22 +-
 arch/x86/power/cpu.c                    |    2 +
 drivers/ata/libata-core.c               |   14 +-
 drivers/ata/libata-eh.c                 |    4 +
 drivers/ata/sata_mv.c                   |   44 +++-
 drivers/gpu/drm/drm_crtc_helper.c       |    4 +-
 drivers/gpu/drm/i915/i915_dma.c         |   12 +-
 drivers/gpu/drm/i915/i915_gem.c         |    1 +
 drivers/gpu/drm/i915/intel_display.c    |    5 +-
 drivers/hid/usbhid/hid-core.c           |   18 +-
 drivers/hwmon/f75375s.c                 |    6 +-
 drivers/hwmon/k8temp.c                  |   35 ++-
 drivers/input/serio/i8042.c             |    2 +-
 drivers/mmc/host/tmio_mmc.c             |    7 +-
 drivers/mmc/host/tmio_mmc.h             |   13 +-
 drivers/net/tun.c                       |    3 +-
 drivers/net/wireless/ath/ath5k/base.c   |    4 +
 drivers/net/wireless/ath/ath9k/eeprom.h |    2 +-
 drivers/net/wireless/ath/regd.h         |    1 -
 drivers/net/wireless/p54/txrx.c         |    2 +-
 drivers/oprofile/buffer_sync.c          |   27 +-
 drivers/oprofile/cpu_buffer.c           |    2 -
 drivers/pci/msi.c                       |   27 ++-
 drivers/power/apm_power.c               |    1 +
 drivers/staging/hv/RingBuffer.c         |    2 +-
 drivers/staging/hv/StorVscApi.h         |    4 +-
 drivers/staging/hv/netvsc_drv.c         |    3 +
 drivers/staging/hv/storvsc_drv.c        |    9 +-
 drivers/usb/class/cdc-acm.c             |   85 ++++++-
 drivers/usb/gadget/rndis.c              |   10 +-
 drivers/usb/host/ehci-ppc-of.c          |   12 +-
 drivers/usb/serial/cp210x.c             |   10 +-
 drivers/usb/serial/ftdi_sio.c           |    8 +
 drivers/usb/serial/ftdi_sio_ids.h       |   12 +
 drivers/usb/serial/mos7840.c            |   55 +++-
 drivers/xen/events.c                    |   21 +-
 fs/binfmt_misc.c                        |    2 +-
 fs/fuse/dev.c                           |   16 +-
 fs/nfs/client.c                         |    2 +-
 fs/ocfs2/inode.c                        |    6 +-
 fs/sysfs/file.c                         |    2 +-
 include/linux/compat.h                  |    2 +
 include/linux/cpuset.h                  |   16 +-
 include/linux/libata.h                  |    1 +
 include/linux/msi.h                     |    2 +
 include/linux/sched.h                   |   20 +-
 include/linux/topology.h                |    2 +-
 kernel/compat.c                         |   22 ++
 kernel/cpu.c                            |   44 +---
 kernel/cpuset.c                         |   67 +++--
 kernel/fork.c                           |   15 -
 kernel/gcov/fs.c                        |  244 ++++++++++++----
 kernel/groups.c                         |    5 +-
 kernel/sched.c                          |  485 ++++++++++++++++++-------------
 kernel/sched_debug.c                    |    2 -
 kernel/sched_fair.c                     |  210 +++++++++-----
 kernel/sched_idletask.c                 |    5 +-
 kernel/sched_rt.c                       |   33 ++-
 kernel/trace/ftrace.c                   |   19 +-
 mm/bounce.c                             |    2 +-
 mm/memory_hotplug.c                     |   16 +-
 net/irda/irlan/irlan_common.c           |    2 +-
 net/sunrpc/auth_gss/auth_gss.c          |    9 +-
 net/sunrpc/rpc_pipe.c                   |    6 +-
 net/wireless/wext-compat.c              |    3 +
 net/wireless/wext.c                     |   16 +
 sound/core/seq/oss/seq_oss_init.c       |    9 +-
 sound/pci/hda/patch_realtek.c           |    9 +-
 tools/perf/util/callchain.h             |    1 +
 84 files changed, 1252 insertions(+), 618 deletions(-)
