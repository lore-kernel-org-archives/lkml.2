Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab0IXQxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:53:22 -0400
Received: from kroah.org ([198.145.64.141]:38368 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932684Ab0IXQ23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:29 -0400
Date: Fri, 24 Sep 2010 09:27:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/80] 2.6.35.6 stable review
Message-ID: <20100924162706.GA7381@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.35.6 release.
There are 80 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Sunday September 26, 17:00:00 UTC
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.35.6-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                                 |    2 +-
 arch/alpha/kernel/err_marvel.c           |    6 +-
 arch/alpha/kernel/proto.h                |    3 -
 arch/alpha/kernel/sys_cabriolet.c        |   19 ++-
 arch/alpha/kernel/sys_takara.c           |   11 +-
 arch/arm/mach-at91/at91sam9g45_devices.c |    2 +-
 arch/ia64/kernel/fsys.S                  |   30 ++-
 arch/sparc/include/asm/oplib_64.h        |   27 +---
 arch/sparc/prom/cif.S                    |   16 +-
 arch/sparc/prom/console_64.c             |   48 ++++-
 arch/sparc/prom/devops_64.c              |   36 +++-
 arch/sparc/prom/misc_64.c                |  314 +++++++++++++++++++++---------
 arch/sparc/prom/p1275.c                  |  102 +----------
 arch/sparc/prom/tree_64.c                |  210 +++++++++++++++------
 arch/x86/kvm/emulate.c                   |    4 +-
 arch/x86/kvm/mmu.c                       |    8 +-
 arch/x86/kvm/paging_tmpl.h               |   28 +++-
 arch/x86/kvm/vmx.c                       |    4 +
 arch/x86/kvm/x86.c                       |    7 +-
 arch/x86/lib/atomic64_386_32.S           |   38 ++--
 arch/x86/oprofile/nmi_int.c              |    4 +-
 drivers/base/power/main.c                |    1 +
 drivers/char/agp/intel-agp.c             |   44 +++--
 drivers/char/agp/intel-agp.h             |   19 ++-
 drivers/char/agp/intel-gtt.c             |   47 +++++-
 drivers/char/mem.c                       |    3 +-
 drivers/char/virtio_console.c            |    6 +-
 drivers/gpu/drm/i915/i915_drv.c          |    6 +
 drivers/gpu/drm/i915/intel_display.c     |    8 +
 drivers/gpu/drm/nouveau/nv50_instmem.c   |    2 +
 drivers/message/fusion/mptscsih.c        |    2 +
 drivers/net/bonding/bond_3ad.c           |    3 +
 drivers/net/bonding/bond_alb.c           |    3 +
 drivers/net/cxgb3/cxgb3_main.c           |    2 +
 drivers/net/eql.c                        |    2 +
 drivers/net/usb/hso.c                    |    2 +
 drivers/pci/intel-iommu.c                |   90 ++++-----
 drivers/platform/x86/dell-wmi.c          |    2 +-
 drivers/platform/x86/hp-wmi.c            |   51 +++--
 drivers/rtc/rtc-s3c.c                    |   13 +-
 drivers/staging/vt6655/wpactl.c          |   11 +-
 drivers/usb/musb/musb_debugfs.c          |    5 +-
 drivers/usb/serial/mos7720.c             |    3 +
 drivers/usb/serial/mos7840.c             |    3 +
 drivers/video/sis/sis_main.c             |    3 +
 drivers/video/via/ioctl.c                |    2 +
 fs/aio.c                                 |   13 ++-
 fs/char_dev.c                            |    4 +-
 fs/compat.c                              |    2 +-
 fs/fs-writeback.c                        |   23 ++-
 fs/gfs2/log.c                            |    2 +-
 fs/notify/inotify/inotify_user.c         |    7 +-
 fs/proc/vmcore.c                         |    2 +-
 fs/xfs/linux-2.6/xfs_ioctl.c             |    2 +
 include/linux/ksm.h                      |   20 +-
 include/linux/kvm_host.h                 |    1 +
 include/linux/mm.h                       |    8 +-
 include/linux/mmzone.h                   |   13 ++
 include/linux/vmstat.h                   |   22 ++
 include/net/sock.h                       |    1 +
 include/net/tcp.h                        |   36 +++-
 include/net/udp.h                        |    1 +
 kernel/exit.c                            |    5 +-
 kernel/hw_breakpoint.c                   |    3 +-
 kernel/power/snapshot.c                  |   85 ++++++--
 kernel/sched.c                           |    8 +-
 kernel/sys.c                             |    2 +
 mm/backing-dev.c                         |    2 +
 mm/ksm.c                                 |    3 -
 mm/memory.c                              |   56 +++++-
 mm/mmap.c                                |    4 +-
 mm/mmzone.c                              |   21 ++
 mm/page_alloc.c                          |   33 +++-
 mm/percpu.c                              |    2 +-
 mm/vmscan.c                              |   43 ++++-
 mm/vmstat.c                              |   15 ++-
 net/Kconfig                              |    2 +-
 net/bridge/br_netfilter.c                |    6 +-
 net/core/skbuff.c                        |    6 +-
 net/ipv4/datagram.c                      |    5 +-
 net/ipv4/route.c                         |    7 +-
 net/ipv4/tcp.c                           |   32 +--
 net/ipv4/tcp_timer.c                     |    8 +-
 net/ipv4/udp.c                           |   44 ++++
 net/ipv6/datagram.c                      |    7 +-
 net/ipv6/udp.c                           |   10 +
 net/irda/af_irda.c                       |    4 +-
 net/l2tp/l2tp_eth.c                      |    2 +-
 net/llc/af_llc.c                         |    3 +-
 net/rds/recv.c                           |    2 +-
 net/sctp/output.c                        |    1 -
 net/unix/af_unix.c                       |   15 ++-
 security/keys/keyctl.c                   |    6 +-
 sound/pci/hda/patch_sigmatel.c           |   12 +-
 virt/kvm/kvm_main.c                      |    1 +
 95 files changed, 1285 insertions(+), 579 deletions(-)
