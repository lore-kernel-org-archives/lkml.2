Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab1DSUVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:21:01 -0400
Received: from kroah.org ([198.145.64.141]:35792 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746Ab1DSUU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:20:59 -0400
Date: Tue, 19 Apr 2011 13:15:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/70] 2.6.38.4-rc1-stable review
Message-ID: <20110419201501.GA8865@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.38.4 release.
There are 70 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Thursday, April 21, 2011, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.38.4-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 MAINTAINERS                                        |    1 -
 Makefile                                           |    2 +-
 arch/arm/kernel/hw_breakpoint.c                    |    7 +
 arch/ia64/kernel/mca.c                             |    3 +-
 arch/ia64/sn/pci/tioca_provider.c                  |    2 +-
 arch/powerpc/kernel/perf_event.c                   |   37 +-
 arch/powerpc/kernel/time.c                         |    3 +
 arch/sparc/kernel/entry.S                          |    2 +-
 arch/sparc/kernel/iommu.c                          |    3 -
 arch/sparc/kernel/ldc.c                            |   28 +-
 arch/sparc/kernel/pci.c                            |    1 +
 arch/sparc/kernel/pci_common.c                     |   11 +-
 arch/sparc/kernel/pci_fire.c                       |    2 -
 arch/sparc/kernel/pci_schizo.c                     |    4 +-
 arch/sparc/kernel/pci_sun4v.c                      |    3 +-
 arch/sparc/kernel/pcr.c                            |    2 +-
 arch/sparc/kernel/ptrace_64.c                      |    3 +-
 arch/sparc/kernel/smp_64.c                         |   11 +-
 arch/sparc/kernel/traps_64.c                       |    3 +-
 arch/sparc/kernel/una_asm_64.S                     |    2 +-
 arch/sparc/mm/fault_32.c                           |    3 +-
 arch/x86/include/asm/msr-index.h                   |    4 +
 arch/x86/kernel/cpu/amd.c                          |   23 +
 arch/x86/lib/semaphore_32.S                        |    2 +-
 drivers/gpu/drm/radeon/atom.c                      |    6 +-
 drivers/gpu/drm/radeon/atombios_crtc.c             |    6 +
 drivers/gpu/drm/radeon/radeon_fence.c              |    2 +-
 drivers/gpu/drm/radeon/radeon_ring.c               |    2 +-
 drivers/i2c/algos/i2c-algo-bit.c                   |   22 +-
 drivers/media/video/sn9c102/sn9c102_core.c         |    6 +-
 drivers/net/gianfar.c                              |   16 +-
 drivers/net/gianfar.h                              |    1 +
 drivers/net/pppoe.c                                |    2 +-
 drivers/net/usb/cdc-phonet.c                       |    9 +-
 drivers/rtc/rtc-bfin.c                             |    2 +
 drivers/usb/core/devices.c                         |   10 +-
 drivers/usb/core/hcd.c                             |    2 +-
 drivers/usb/host/ehci-q.c                          |   15 +-
 drivers/usb/host/xhci-mem.c                        |   90 ++-
 drivers/usb/host/xhci.c                            |   16 +-
 drivers/usb/host/xhci.h                            |    6 +-
 drivers/usb/musb/Kconfig                           |    6 +-
 drivers/usb/serial/ftdi_sio.c                      |    5 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   12 +
 drivers/usb/serial/option.c                        |    5 +
 drivers/usb/serial/qcserial.c                      |   31 +-
 drivers/video/via/viafbdev.h                       |    3 -
 fs/binfmt_elf.c                                    |    6 +-
 fs/cifs/cifsencrypt.c                              |   15 +-
 fs/cifs/cifsfs.c                                   |    1 +
 fs/cifs/connect.c                                  |    2 +-
 fs/cifs/file.c                                     |    6 +-
 fs/namei.c                                         |    1 +
 fs/proc/base.c                                     |    9 +-
 fs/ramfs/file-nommu.c                              |    1 +
 fs/ubifs/debug.c                                   |    6 +-
 fs/ubifs/file.c                                    |    3 +
 fs/ubifs/super.c                                   |    3 +-
 include/linux/kernel.h                             |   70 ++-
 include/linux/perf_event.h                         |    2 +-
 include/linux/pid.h                                |    2 +-
 include/linux/sched.h                              |    3 +
 include/net/bluetooth/hci.h                        |    2 +
 kernel/futex.c                                     |    2 +-
 kernel/pid.c                                       |    5 +-
 kernel/sched_fair.c                                |   11 +-
 lib/Kconfig.debug                                  |    3 +
 lib/Makefile                                       |    2 +
 lib/kstrtox.c                                      |  227 ++++++
 lib/test-kstrtox.c                                 |  739 ++++++++++++++++++++
 lib/vsprintf.c                                     |  141 ----
 mm/huge_memory.c                                   |   24 +-
 mm/memory.c                                        |   26 +-
 mm/mlock.c                                         |   13 -
 mm/mmap.c                                          |   15 +-
 mm/oom_kill.c                                      |   27 -
 mm/vmscan.c                                        |   24 +-
 net/8021q/vlan_dev.c                               |    1 +
 net/bluetooth/hci_core.c                           |    5 +-
 net/bluetooth/hci_event.c                          |    4 +-
 net/bridge/br_multicast.c                          |    2 +-
 net/bridge/br_netfilter.c                          |    3 +
 net/ipv4/fib_frontend.c                            |    2 +
 net/ipv4/route.c                                   |    2 +-
 net/ipv4/tcp_input.c                               |   12 +-
 net/ipv6/sysctl_net_ipv6.c                         |   18 +-
 net/l2tp/l2tp_eth.c                                |    2 +-
 net/sctp/protocol.c                                |    4 +-
 net/xfrm/xfrm_policy.c                             |    2 +
 scripts/checkpatch.pl                              |    4 +-
 sound/pci/hda/patch_realtek.c                      |   21 +-
 tools/perf/bench/sched-pipe.c                      |    2 +-
 tools/perf/builtin-sched.c                         |   12 +-
 tools/perf/builtin-top.c                           |    5 +-
 tools/perf/util/header.c                           |    2 +-
 tools/perf/util/hist.c                             |    3 -
 .../util/scripting-engines/trace-event-python.c    |    3 +-
 tools/perf/util/symbol.c                           |    4 +-
 tools/perf/util/trace-event-parse.c                |    2 +-
 tools/perf/util/ui/browsers/map.c                  |    2 +-
 100 files changed, 1522 insertions(+), 423 deletions(-)
