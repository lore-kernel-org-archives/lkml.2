Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab0C3XGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:06:12 -0400
Received: from kroah.org ([198.145.64.141]:51718 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab0C3XGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:06:10 -0400
Date: Tue, 30 Mar 2010 16:05:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/89] 2.6.31.13-stable review
Message-ID: <20100330230520.GA28779@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100330230338.GA28642@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for the 2.6.31.13 release.
There are 89 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by April 1, 2010, 22:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.31.13-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

 Documentation/filesystems/tmpfs.txt       |    6 +-
 Makefile                                  |    2 +-
 arch/powerpc/include/asm/elf.h            |    8 +-
 arch/powerpc/include/asm/thread_info.h    |    2 -
 arch/powerpc/kernel/process.c             |   12 --
 arch/sh/kernel/process_64.c               |    2 +-
 arch/sparc/include/asm/elf_64.h           |   13 +--
 arch/sparc/include/asm/thread_info_64.h   |    4 +-
 arch/sparc/kernel/process_64.c            |    8 -
 arch/x86/ia32/ia32_aout.c                 |   12 +-
 arch/x86/include/asm/elf.h                |   10 +-
 arch/x86/include/asm/fixmap.h             |    6 +-
 arch/x86/include/asm/io_apic.h            |    1 +
 arch/x86/include/asm/kvm_x86_emulate.h    |    2 +-
 arch/x86/include/asm/thread_info.h        |    2 -
 arch/x86/kernel/acpi/boot.c               |    9 +-
 arch/x86/kernel/apic/apic_flat_64.c       |    5 +
 arch/x86/kernel/apic/io_apic.c            |   50 ++++++
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    3 +-
 arch/x86/kernel/microcode_core.c          |    4 +-
 arch/x86/kernel/process.c                 |   12 --
 arch/x86/kernel/process_64.c              |   11 ++
 arch/x86/kvm/x86_emulate.c                |    5 +-
 arch/x86/pci/i386.c                       |    9 +
 drivers/acpi/processor_idle.c             |   28 ++--
 drivers/base/class.c                      |    2 +
 drivers/block/cciss.c                     |    3 +
 drivers/char/agp/backend.c                |    4 +-
 drivers/char/nozomi.c                     |    2 +-
 drivers/char/tty_io.c                     |    2 +
 drivers/connector/connector.c             |  175 --------------------
 drivers/edac/i5000_edac.c                 |    8 +-
 drivers/gpu/drm/r128/r128_cce.c           |   18 ++-
 drivers/gpu/drm/r128/r128_drv.h           |    8 +
 drivers/gpu/drm/r128/r128_state.c         |   36 +++--
 drivers/hid/hid-apple.c                   |    7 +
 drivers/hid/hid-core.c                    |    3 +
 drivers/hid/hid-ids.h                     |    3 +
 drivers/hwmon/adt7462.c                   |    2 +-
 drivers/hwmon/coretemp.c                  |    2 +-
 drivers/hwmon/fschmd.c                    |    7 +-
 drivers/hwmon/lm78.c                      |   25 ++--
 drivers/hwmon/w83781d.c                   |   26 ++--
 drivers/i2c/busses/i2c-pca-isa.c          |    4 +-
 drivers/i2c/busses/i2c-pca-platform.c     |    4 +-
 drivers/i2c/busses/i2c-tiny-usb.c         |   12 +-
 drivers/i2c/i2c-core.c                    |    5 +-
 drivers/input/mouse/alps.c                |  252 ++++++++++++++++++++++++++---
 drivers/input/mouse/alps.h                |    1 +
 drivers/media/dvb/dvb-usb/af9015.c        |    4 +-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h   |    1 +
 drivers/media/video/em28xx/em28xx-dvb.c   |    1 +
 drivers/media/video/pwc/pwc-ctrl.c        |    2 +-
 drivers/media/video/uvc/uvc_driver.c      |    3 +
 drivers/media/video/uvc/uvc_video.c       |    4 +-
 drivers/media/video/uvc/uvcvideo.h        |    3 +-
 drivers/misc/enclosure.c                  |    1 +
 drivers/mtd/ubi/cdev.c                    |    1 -
 drivers/net/sfc/tx.c                      |    4 +-
 drivers/net/wireless/airo.c               |   34 ++--
 drivers/net/wireless/ath/ath5k/eeprom.c   |   32 ++++-
 drivers/net/wireless/ath/ath5k/eeprom.h   |    8 +
 drivers/net/wireless/b43/b43.h            |    1 +
 drivers/net/wireless/b43/main.c           |   13 ++-
 drivers/parisc/ccio-dma.c                 |    4 +-
 drivers/parisc/sba_iommu.c                |    4 +-
 drivers/rtc/rtc-fm3130.c                  |    6 +-
 drivers/scsi/megaraid/megaraid_sas.c      |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c      |   17 ++
 drivers/serial/8250.c                     |    7 +-
 drivers/serial/8250_pnp.c                 |   10 +-
 drivers/usb/core/devices.c                |    2 +-
 drivers/usb/core/devio.c                  |   61 +++++---
 drivers/usb/core/hub.c                    |    3 +
 drivers/usb/core/message.c                |    8 +-
 drivers/usb/core/sysfs.c                  |    6 +
 drivers/usb/host/ehci-hcd.c               |    5 +-
 drivers/usb/host/ehci-hub.c               |   20 +++-
 drivers/usb/host/ehci-q.c                 |   11 +-
 drivers/usb/host/uhci-hcd.c               |   15 ++-
 drivers/usb/host/uhci-hub.c               |    2 +-
 drivers/usb/serial/generic.c              |    2 +
 drivers/usb/storage/unusual_devs.h        |    7 -
 drivers/usb/storage/usb.c                 |    3 +-
 drivers/xen/balloon.c                     |    4 -
 fs/binfmt_aout.c                          |    1 +
 fs/binfmt_elf.c                           |   27 +---
 fs/binfmt_elf_fdpic.c                     |    3 +
 fs/binfmt_flat.c                          |    1 +
 fs/binfmt_som.c                           |    1 +
 fs/cifs/readdir.c                         |    1 +
 fs/ecryptfs/crypto.c                      |    4 +-
 fs/ecryptfs/file.c                        |   14 +-
 fs/exec.c                                 |   39 +++--
 fs/namei.c                                |   14 ++-
 fs/nfs/fscache.c                          |   21 ++--
 fs/notify/dnotify/dnotify.c               |    3 +-
 fs/notify/inotify/inotify_fsnotify.c      |    2 +-
 fs/notify/inotify/inotify_user.c          |    4 +-
 fs/notify/notification.c                  |    2 +-
 fs/ntfs/malloc.h                          |    2 +-
 fs/partitions/efi.c                       |   30 +++--
 fs/partitions/efi.h                       |    8 +-
 fs/reiserfs/inode.c                       |   17 ++-
 include/linux/binfmts.h                   |    1 +
 include/linux/connector.h                 |   32 ----
 include/linux/enclosure.h                 |    2 +
 include/linux/mm.h                        |    1 +
 include/linux/sched.h                     |   24 +++-
 init/main.c                               |    4 +-
 ipc/msg.c                                 |    1 +
 ipc/sem.c                                 |    1 +
 ipc/shm.c                                 |    1 +
 kernel/futex.c                            |   30 +++-
 kernel/time/clockevents.c                 |    5 +-
 mm/mempolicy.c                            |   40 +++--
 mm/migrate.c                              |    3 +
 mm/page_alloc.c                           |    2 +-
 mm/slab.c                                 |    2 +-
 mm/swap.c                                 |    2 +-
 mm/vmalloc.c                              |    8 +-
 net/core/sock.c                           |    4 +-
 net/dccp/proto.c                          |    6 +-
 net/decnet/dn_route.c                     |    2 +-
 net/ipv4/route.c                          |    2 +-
 net/ipv4/tcp.c                            |    4 +-
 net/netfilter/nf_conntrack_core.c         |    4 +-
 net/netfilter/x_tables.c                  |    2 +-
 net/netfilter/xt_hashlimit.c              |    8 +-
 net/netlink/af_netlink.c                  |    6 +-
 net/sctp/protocol.c                       |    6 +-
 security/selinux/hooks.c                  |    2 +-
 sound/pci/hda/hda_intel.c                 |    6 +
 sound/usb/usbaudio.c                      |    2 +-
 134 files changed, 931 insertions(+), 624 deletions(-)
