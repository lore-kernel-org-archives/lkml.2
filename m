Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095Ab0JVSz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:55:26 -0400
Received: from kroah.org ([198.145.64.141]:45581 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755608Ab0JVSiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:38:16 -0400
Date: Fri, 22 Oct 2010 11:37:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/66] 2.6.32.25-stable review
Message-ID: <20101022183711.GA23214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.32.25 release.
There are 66 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Monday, October 25, 2010 16:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.25-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                                    |    2 +-
 arch/powerpc/kernel/head_64.S               |   18 +++++--
 arch/um/drivers/ubd_kern.c                  |    9 ++--
 arch/x86/include/asm/amd_iommu_types.h      |   18 +++++++
 arch/x86/kernel/Makefile                    |    2 +
 arch/x86/kernel/amd_iommu.c                 |    4 +-
 arch/x86/kernel/amd_iommu_init.c            |   67 ++++++++++++++++++---------
 arch/x86/kernel/apic/io_apic.c              |   11 +++-
 arch/x86/kernel/cpu/common.c                |    4 +-
 arch/x86/kernel/cpu/cpu.h                   |    1 +
 arch/x86/kernel/cpu/intel.c                 |    1 +
 arch/x86/kernel/cpu/mcheck/mce_amd.c        |    9 +--
 arch/x86/kernel/hpet.c                      |    2 +-
 arch/x86/oprofile/nmi_int.c                 |    1 +
 block/bsg.c                                 |    2 +-
 drivers/acpi/acpica/aclocal.h               |    1 +
 drivers/acpi/blacklist.c                    |   16 ++++++
 drivers/acpi/processor_core.c               |    6 --
 drivers/dma/mv_xor.c                        |    2 +-
 drivers/hwmon/coretemp.c                    |   32 +++++--------
 drivers/i2c/busses/i2c-pca-isa.c            |   12 +++--
 drivers/i2c/busses/i2c-pca-platform.c       |   11 +++--
 drivers/infiniband/hw/cxgb3/iwch_cm.c       |    6 ++-
 drivers/input/joydev.c                      |    3 +
 drivers/media/video/cx231xx/cx231xx-cards.c |   14 +++--
 drivers/media/video/saa7134/saa7134-core.c  |   13 -----
 drivers/media/video/saa7134/saa7134-ts.c    |   13 +++++
 drivers/media/video/v4l2-compat-ioctl32.c   |   32 ++++++++----
 drivers/mmc/host/sdhci-s3c.c                |    6 ++-
 drivers/net/atlx/atl1.c                     |    5 +-
 drivers/net/b44.c                           |    4 +-
 drivers/net/netxen/netxen_nic_init.c        |    3 -
 drivers/net/r6040.c                         |   12 ++---
 drivers/net/r8169.c                         |   12 ++--
 drivers/net/skge.c                          |   18 +++++++-
 drivers/pci/quirks.c                        |   20 ++++++++
 drivers/usb/core/file.c                     |   35 ++++++--------
 drivers/usb/core/message.c                  |    1 +
 drivers/usb/musb/musb_gadget.c              |   22 +++++++--
 drivers/usb/musb/musb_gadget.h              |    2 +
 drivers/usb/musb/musb_gadget_ep0.c          |    9 ++++
 fs/exec.c                                   |   14 ++++++
 fs/ocfs2/symlink.c                          |    2 +-
 fs/proc/task_mmu.c                          |    3 +-
 include/drm/drm_pciids.h                    |    2 +-
 include/linux/mm.h                          |    6 ++
 include/linux/pci_ids.h                     |    3 +
 include/linux/socket.h                      |    2 +-
 kernel/hrtimer.c                            |   13 ++++-
 kernel/sched.c                              |    7 +--
 kernel/trace/ring_buffer.c                  |    2 +-
 mm/mlock.c                                  |    6 --
 net/core/ethtool.c                          |    2 +-
 net/core/iovec.c                            |    5 +-
 net/core/stream.c                           |    8 ++--
 net/ipv4/ip_output.c                        |   19 +++++--
 net/ipv4/route.c                            |    7 ++-
 net/ipv4/tcp.c                              |    9 ++-
 net/ipv4/tcp_input.c                        |    2 +
 net/ipv4/xfrm4_policy.c                     |    4 +-
 net/ipv6/ip6_output.c                       |   18 +++++--
 net/ipv6/route.c                            |   28 ++++++++++--
 net/phonet/af_phonet.c                      |    4 ++
 net/phonet/pep.c                            |    3 +-
 net/phonet/pn_dev.c                         |   12 ++++-
 net/phonet/pn_netlink.c                     |    9 +++-
 net/rds/page.c                              |   27 +++--------
 net/rose/af_rose.c                          |    4 +-
 net/wireless/wext.c                         |    2 +-
 sound/core/control.c                        |    5 ++
 sound/core/rawmidi.c                        |    4 +-
 sound/pci/hda/patch_analog.c                |    1 +
 sound/pci/oxygen/oxygen.c                   |    4 ++
 sound/pci/rme9652/hdsp.c                    |    1 +
 sound/pci/rme9652/hdspm.c                   |    1 +
 75 files changed, 465 insertions(+), 235 deletions(-)
