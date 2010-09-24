Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313Ab0IXQsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:48:39 -0400
Received: from kroah.org ([198.145.64.141]:37048 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932918Ab0IXQe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:34:56 -0400
Date: Fri, 24 Sep 2010 09:33:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/68] 2.6.32.23 stable review
Message-ID: <20100924163357.GA15741@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.32.23 release.
There are 68 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Sunday September 26, 17:00:00 UTC
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.23-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                                 |    2 +-
 arch/alpha/kernel/err_marvel.c           |    6 +-
 arch/arm/mach-at91/at91sam9g45_devices.c |    2 +-
 arch/ia64/kernel/fsys.S                  |   30 ++-
 arch/mips/include/asm/atomic.h           |   24 ++--
 arch/mips/mm/tlbex.c                     |   22 ++-
 arch/mips/mm/uasm.c                      |    4 +-
 arch/mips/mm/uasm.h                      |    1 +
 arch/mips/mti-malta/malta-pci.c          |    2 +
 arch/mips/nxp/pnx8550/common/pci.c       |    1 +
 arch/mips/nxp/pnx8550/common/setup.c     |    2 +-
 arch/mips/pci/ops-pmcmsp.c               |    1 +
 arch/mips/pci/pci-yosemite.c             |    1 +
 arch/sparc/include/asm/io_32.h           |    4 +
 arch/sparc/include/asm/io_64.h           |    4 +
 arch/sparc/include/asm/oplib_64.h        |   27 +---
 arch/sparc/prom/cif.S                    |   16 +-
 arch/sparc/prom/console_64.c             |   48 ++++-
 arch/sparc/prom/devops_64.c              |   36 +++-
 arch/sparc/prom/misc_64.c                |  314 +++++++++++++++++++++---------
 arch/sparc/prom/p1275.c                  |  102 +----------
 arch/sparc/prom/tree_64.c                |  210 +++++++++++++++------
 arch/x86/include/asm/cmpxchg_32.h        |   65 ++-----
 arch/x86/include/asm/cmpxchg_64.h        |    4 +-
 arch/x86/oprofile/nmi_int.c              |    4 +-
 drivers/acpi/blacklist.c                 |   14 ++
 drivers/ata/pata_pdc202xx_old.c          |   15 ++-
 drivers/char/agp/sis-agp.c               |    8 -
 drivers/char/mem.c                       |    3 +-
 drivers/clocksource/sh_tmu.c             |   20 +-
 drivers/input/input.c                    |   86 +++++++--
 drivers/message/fusion/mptscsih.c        |    2 +
 drivers/net/3c503.c                      |   41 +++-
 drivers/net/bnx2.c                       |   20 ++-
 drivers/net/bonding/bond_3ad.c           |    3 +
 drivers/net/bonding/bond_alb.c           |    3 +
 drivers/net/cxgb3/cxgb3_main.c           |    3 +
 drivers/net/eql.c                        |    2 +
 drivers/net/r8169.c                      |   11 +
 drivers/net/usb/asix.c                   |   30 +++-
 drivers/net/usb/hso.c                    |    2 +
 drivers/net/wireless/hostap/hostap_pci.c |    1 +
 drivers/pci/intel-iommu.c                |   90 ++++-----
 drivers/staging/vt6655/wpactl.c          |   11 +-
 drivers/usb/serial/mos7720.c             |    3 +
 drivers/usb/serial/mos7840.c             |    3 +
 drivers/video/sis/sis_main.c             |    3 +
 drivers/video/via/ioctl.c                |    2 +
 fs/aio.c                                 |    3 +
 fs/char_dev.c                            |    4 +-
 fs/ext4/inode.c                          |   40 +++--
 fs/notify/inotify/inotify_fsnotify.c     |    3 +
 fs/notify/inotify/inotify_user.c         |    7 +-
 fs/partitions/ibm.c                      |   13 ++-
 fs/xfs/linux-2.6/xfs_ioctl.c             |    2 +
 include/linux/mm.h                       |    8 +-
 include/linux/mmzone.h                   |   13 ++
 include/linux/vmstat.h                   |   22 ++
 include/net/tcp.h                        |   36 +++-
 kernel/exit.c                            |    5 +-
 kernel/sched.c                           |    4 +-
 kernel/sys.c                             |    2 +
 mm/memory.c                              |   15 +-
 mm/mmap.c                                |    3 -
 mm/mmzone.c                              |   21 ++
 mm/page_alloc.c                          |   33 +++-
 mm/percpu.c                              |    2 +-
 mm/vmstat.c                              |   15 ++-
 net/bridge/br_netfilter.c                |    9 +-
 net/core/skbuff.c                        |    7 +-
 net/ipv4/tcp.c                           |   33 +--
 net/ipv4/tcp_timer.c                     |    8 +-
 net/irda/af_irda.c                       |    4 +-
 net/llc/af_llc.c                         |    3 +-
 net/rds/recv.c                           |    2 +-
 net/sctp/output.c                        |    1 -
 net/unix/af_unix.c                       |   15 ++-
 security/keys/keyctl.c                   |    6 +-
 78 files changed, 1076 insertions(+), 571 deletions(-)
