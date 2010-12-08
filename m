Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab0LHAqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:46:40 -0500
Received: from kroah.org ([198.145.64.141]:45871 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729Ab0LHAqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:46:37 -0500
Date: Tue, 7 Dec 2010 16:44:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [000/127] 2.6.32.27-stable review
Message-ID: <20101208004456.GA23578@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.32.27 release.
There are 127 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Thursday, December 9, 2010, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.27-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 MAINTAINERS                                |    6 +
 Makefile                                   |    2 +-
 arch/arm/include/asm/assembler.h           |    2 +-
 arch/arm/lib/findbit.S                     |    6 +-
 arch/microblaze/Makefile                   |    8 +-
 arch/s390/kernel/nmi.c                     |   10 +-
 arch/s390/lib/delay.c                      |   14 ++-
 arch/sparc/kernel/signal32.c               |  161 +++++++++++++---------
 arch/sparc/kernel/signal_32.c              |   55 +++++---
 arch/sparc/kernel/signal_64.c              |   45 ++++---
 arch/um/drivers/line.c                     |    5 +-
 arch/um/kernel/uml.lds.S                   |    2 +-
 arch/um/os-Linux/time.c                    |    2 +-
 arch/x86/include/asm/pgtable_32.h          |    1 +
 arch/x86/include/asm/trampoline.h          |    5 +-
 arch/x86/kernel/apic/x2apic_uv_x.c         |    9 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    1 +
 arch/x86/kernel/head_32.S                  |    8 +-
 arch/x86/kernel/quirks.c                   |    9 +-
 arch/x86/kernel/setup.c                    |    3 +
 arch/x86/kernel/smpboot.c                  |   32 ++---
 arch/x86/kernel/trampoline.c               |   17 +++
 arch/x86/kvm/vmx.c                         |   16 ++-
 arch/x86/kvm/x86.c                         |    8 +
 arch/x86/xen/enlighten.c                   |    4 -
 block/blk-map.c                            |    2 +
 block/blk-settings.c                       |    2 +-
 block/scsi_ioctl.c                         |   34 ++++--
 drivers/acpi/blacklist.c                   |    8 +
 drivers/ata/ahci.c                         |   10 ++
 drivers/ata/ata_generic.c                  |   30 ++++-
 drivers/ata/libata-scsi.c                  |    7 +-
 drivers/char/hpet.c                        |   17 +++
 drivers/char/tty_buffer.c                  |   14 ++-
 drivers/char/tty_ldisc.c                   |   58 +++++++--
 drivers/char/vt_ioctl.c                    |   11 +-
 drivers/crypto/padlock-aes.c               |    2 +-
 drivers/firewire/core-cdev.c               |   18 ++--
 drivers/firewire/core-device.c             |    1 +
 drivers/firewire/ohci.c                    |   64 +++++++--
 drivers/gpu/drm/ttm/ttm_bo_util.c          |    1 +
 drivers/hid/hidraw.c                       |   18 ++-
 drivers/hwmon/lm85.c                       |    1 +
 drivers/i2c/busses/i2c-pca-platform.c      |    2 +-
 drivers/input/serio/i8042-x86ia64io.h      |    7 +
 drivers/md/md.c                            |    4 +-
 drivers/md/raid1.c                         |    1 +
 drivers/media/video/ivtv/ivtvfb.c          |    2 +
 drivers/media/video/uvc/uvc_driver.c       |   14 ++-
 drivers/misc/sgi-xp/xpc_partition.c        |   25 ++--
 drivers/misc/sgi-xp/xpc_uv.c               |   19 ++-
 drivers/net/gianfar.c                      |    6 +-
 drivers/net/jme.c                          |   22 +++-
 drivers/pci/pci-sysfs.c                    |   22 ++-
 drivers/pci/pci.h                          |    7 +-
 drivers/pci/proc.c                         |    2 +-
 drivers/power/olpc_battery.c               |    8 +-
 drivers/ssb/b43_pci_bridge.c               |    1 +
 drivers/staging/asus_oled/asus_oled.c      |    8 +-
 drivers/staging/frontier/tranzport.c       |    2 +-
 drivers/staging/line6/control.c            |  204 ++++++++++++++--------------
 drivers/staging/line6/midi.c               |    4 +-
 drivers/staging/line6/pod.c                |   32 ++--
 drivers/staging/line6/toneport.c           |    4 +-
 drivers/staging/line6/variax.c             |   12 +-
 drivers/staging/rtl8187se/r8185b_init.c    |   30 +++-
 drivers/usb/atm/ueagle-atm.c               |    6 +-
 drivers/usb/core/devio.c                   |    7 +-
 drivers/usb/gadget/atmel_usba_udc.c        |    2 +-
 drivers/usb/host/ehci-hcd.c                |   10 +-
 drivers/usb/misc/cypress_cy7c63.c          |    6 +-
 drivers/usb/misc/iowarrior.c               |    1 +
 drivers/usb/misc/sisusbvga/sisusb.c        |    1 +
 drivers/usb/misc/trancevibrator.c          |    2 +-
 drivers/usb/misc/usbled.c                  |    2 +-
 drivers/usb/misc/usbsevseg.c               |   10 +-
 drivers/usb/serial/ftdi_sio.c              |    8 +-
 drivers/usb/serial/ftdi_sio_ids.h          |   11 ++
 drivers/usb/serial/option.c                |    2 +-
 drivers/usb/storage/sierra_ms.c            |    2 +-
 drivers/video/backlight/backlight.c        |   12 +-
 drivers/video/efifb.c                      |  106 +++++++++++++--
 drivers/video/via/accel.c                  |    7 +-
 drivers/xen/events.c                       |    2 +-
 fs/bio.c                                   |   23 +++-
 fs/ecryptfs/inode.c                        |    4 +
 fs/fuse/file.c                             |   10 ++
 include/linux/blkdev.h                     |    4 +-
 include/linux/pci_ids.h                    |    2 +
 include/linux/socket.h                     |    2 +-
 include/net/x25.h                          |    4 +
 ipc/compat.c                               |    6 +
 ipc/compat_mq.c                            |    5 +
 ipc/sem.c                                  |    2 +
 ipc/shm.c                                  |    1 +
 kernel/exit.c                              |    9 ++
 kernel/latencytop.c                        |   17 +--
 lib/percpu_counter.c                       |    1 +
 mm/filemap.c                               |    3 +
 mm/internal.h                              |    2 +-
 mm/memory_hotplug.c                        |    2 +-
 mm/mempolicy.c                             |    2 +-
 mm/mprotect.c                              |    2 +-
 mm/nommu.c                                 |    1 +
 net/can/bcm.c                              |    2 +-
 net/compat.c                               |   10 +-
 net/core/dev.c                             |    6 +-
 net/core/ethtool.c                         |    2 +-
 net/core/iovec.c                           |   20 ++--
 net/decnet/af_decnet.c                     |    2 +
 net/econet/af_econet.c                     |   29 ++---
 net/ipv4/tcp.c                             |    4 +-
 net/ipv4/udp.c                             |    4 +-
 net/irda/iriap.c                           |    3 +-
 net/irda/parameters.c                      |    4 +-
 net/netfilter/nf_conntrack_core.c          |    3 +-
 net/rds/rdma.c                             |    2 +-
 net/sched/act_gact.c                       |   21 ++--
 net/sched/act_mirred.c                     |   15 +-
 net/sched/act_nat.c                        |   35 ++---
 net/sched/act_police.c                     |   21 ++--
 net/sched/act_simple.c                     |   11 +-
 net/sched/act_skbedit.c                    |   11 +-
 net/sctp/protocol.c                        |    4 +-
 net/socket.c                               |    4 +
 net/x25/af_x25.c                           |   47 ++++++-
 net/x25/x25_facilities.c                   |   32 ++++-
 net/x25/x25_in.c                           |   17 ++-
 sound/pci/hda/patch_realtek.c              |    4 +-
 sound/pci/hda/patch_sigmatel.c             |    2 +
 sound/pci/intel8x0.c                       |    6 +
 131 files changed, 1191 insertions(+), 596 deletions(-)
