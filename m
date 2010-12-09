Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab0LIWxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 17:53:04 -0500
Received: from kroah.org ([198.145.64.141]:45711 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293Ab0LIWv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 17:51:56 -0500
Date: Thu, 9 Dec 2010 14:50:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.27
Message-ID: <20101209225040.GC2777@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.27 kernel.

All users of the 2.6.32 kernel series must upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=summary

Note, this will be the last .32 release in the stable/ directory.  All
future ones will be in the longterm/ directory on kernel.org.  Please
adjust your scripts as necessary.

thanks,

greg k-h

------------

 MAINTAINERS                                |    6 
 Makefile                                   |    2 
 arch/arm/include/asm/assembler.h           |    2 
 arch/arm/lib/findbit.S                     |    6 
 arch/microblaze/Makefile                   |    8 -
 arch/s390/kernel/nmi.c                     |   10 -
 arch/s390/lib/delay.c                      |   14 +
 arch/sparc/kernel/signal32.c               |  161 +++++++++++++---------
 arch/sparc/kernel/signal_32.c              |   55 ++++---
 arch/sparc/kernel/signal_64.c              |   45 +++---
 arch/um/drivers/line.c                     |    5 
 arch/um/kernel/uml.lds.S                   |    2 
 arch/um/os-Linux/time.c                    |    2 
 arch/x86/include/asm/pgtable_32.h          |    1 
 arch/x86/include/asm/trampoline.h          |    5 
 arch/x86/kernel/apic/x2apic_uv_x.c         |    9 -
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    1 
 arch/x86/kernel/head_32.S                  |    8 -
 arch/x86/kernel/quirks.c                   |    9 +
 arch/x86/kernel/setup.c                    |    3 
 arch/x86/kernel/smpboot.c                  |   32 +---
 arch/x86/kernel/trampoline.c               |   17 ++
 arch/x86/kvm/vmx.c                         |   16 +-
 arch/x86/kvm/x86.c                         |    8 +
 arch/x86/xen/enlighten.c                   |    4 
 block/blk-map.c                            |    2 
 block/blk-settings.c                       |    2 
 block/scsi_ioctl.c                         |   34 +++-
 drivers/acpi/blacklist.c                   |    8 +
 drivers/ata/ahci.c                         |   10 +
 drivers/ata/ata_generic.c                  |   30 +++-
 drivers/ata/libata-scsi.c                  |    7 
 drivers/char/hpet.c                        |   17 ++
 drivers/char/tty_buffer.c                  |   14 +
 drivers/char/tty_ldisc.c                   |   58 ++++++--
 drivers/char/vt_ioctl.c                    |   11 -
 drivers/crypto/padlock-aes.c               |    2 
 drivers/firewire/core-cdev.c               |   18 +-
 drivers/firewire/core-device.c             |    1 
 drivers/firewire/ohci.c                    |   60 ++++++--
 drivers/gpu/drm/ttm/ttm_bo_util.c          |    1 
 drivers/hid/hidraw.c                       |   18 +-
 drivers/hwmon/lm85.c                       |    1 
 drivers/i2c/busses/i2c-pca-platform.c      |    2 
 drivers/input/serio/i8042-x86ia64io.h      |    7 
 drivers/md/md.c                            |    4 
 drivers/md/raid1.c                         |    1 
 drivers/media/video/ivtv/ivtvfb.c          |    2 
 drivers/media/video/uvc/uvc_driver.c       |   14 +
 drivers/misc/sgi-xp/xpc_partition.c        |   25 ++-
 drivers/misc/sgi-xp/xpc_uv.c               |   19 +-
 drivers/net/gianfar.c                      |    6 
 drivers/net/jme.c                          |   22 ++-
 drivers/pci/pci-sysfs.c                    |   22 ++-
 drivers/pci/pci.h                          |    7 
 drivers/pci/proc.c                         |    2 
 drivers/power/olpc_battery.c               |    8 -
 drivers/ssb/b43_pci_bridge.c               |    1 
 drivers/staging/asus_oled/asus_oled.c      |    8 -
 drivers/staging/frontier/tranzport.c       |    2 
 drivers/staging/line6/control.c            |  204 ++++++++++++++---------------
 drivers/staging/line6/midi.c               |    4 
 drivers/staging/line6/pod.c                |   32 ++--
 drivers/staging/line6/toneport.c           |    4 
 drivers/staging/line6/variax.c             |   12 -
 drivers/staging/rtl8187se/r8185b_init.c    |   30 +++-
 drivers/usb/atm/ueagle-atm.c               |    6 
 drivers/usb/core/devio.c                   |    7 
 drivers/usb/gadget/atmel_usba_udc.c        |    2 
 drivers/usb/host/ehci-hcd.c                |   10 -
 drivers/usb/misc/cypress_cy7c63.c          |    6 
 drivers/usb/misc/iowarrior.c               |    1 
 drivers/usb/misc/sisusbvga/sisusb.c        |    1 
 drivers/usb/misc/trancevibrator.c          |    2 
 drivers/usb/misc/usbled.c                  |    2 
 drivers/usb/misc/usbsevseg.c               |   10 -
 drivers/usb/serial/ftdi_sio.c              |    8 -
 drivers/usb/serial/ftdi_sio_ids.h          |   11 +
 drivers/usb/serial/option.c                |    2 
 drivers/usb/storage/sierra_ms.c            |    2 
 drivers/video/backlight/backlight.c        |   12 -
 drivers/video/efifb.c                      |  106 +++++++++++++--
 drivers/video/via/accel.c                  |    7 
 drivers/xen/events.c                       |    2 
 fs/bio.c                                   |   23 ++-
 fs/ecryptfs/inode.c                        |    4 
 fs/fuse/file.c                             |   10 +
 include/linux/blkdev.h                     |    4 
 include/linux/pci_ids.h                    |    2 
 include/linux/socket.h                     |    2 
 include/net/x25.h                          |    4 
 ipc/compat.c                               |    6 
 ipc/compat_mq.c                            |    5 
 ipc/sem.c                                  |    2 
 ipc/shm.c                                  |    1 
 kernel/exit.c                              |    9 +
 kernel/latencytop.c                        |   17 +-
 lib/percpu_counter.c                       |    1 
 mm/filemap.c                               |    3 
 mm/internal.h                              |    2 
 mm/memory_hotplug.c                        |    2 
 mm/mempolicy.c                             |    2 
 mm/mprotect.c                              |    2 
 mm/nommu.c                                 |    1 
 net/can/bcm.c                              |    2 
 net/compat.c                               |   10 -
 net/core/dev.c                             |    6 
 net/core/ethtool.c                         |    2 
 net/core/iovec.c                           |   20 +-
 net/decnet/af_decnet.c                     |    2 
 net/econet/af_econet.c                     |   29 +---
 net/ipv4/tcp.c                             |    4 
 net/ipv4/udp.c                             |    4 
 net/irda/iriap.c                           |    3 
 net/irda/parameters.c                      |    4 
 net/netfilter/nf_conntrack_core.c          |    3 
 net/rds/rdma.c                             |    2 
 net/sched/act_gact.c                       |   21 +-
 net/sched/act_mirred.c                     |   15 +-
 net/sched/act_nat.c                        |   35 +---
 net/sched/act_police.c                     |   21 +-
 net/sched/act_simple.c                     |   11 -
 net/sched/act_skbedit.c                    |   11 -
 net/sctp/protocol.c                        |    4 
 net/socket.c                               |    4 
 net/x25/af_x25.c                           |   47 ++++++
 net/x25/x25_facilities.c                   |   32 +++-
 net/x25/x25_in.c                           |   17 +-
 sound/pci/hda/patch_realtek.c              |    4 
 sound/pci/hda/patch_sigmatel.c             |    2 
 sound/pci/intel8x0.c                       |    6 
 131 files changed, 1189 insertions(+), 594 deletions(-)

Alan Stern (1):
      USB: EHCI: fix obscure race in ehci_endpoint_disable

Antonio Ospite (2):
      HID: hidraw, fix a NULL pointer dereference in hidraw_ioctl
      HID: hidraw, fix a NULL pointer dereference in hidraw_write

Ben Hutchings (2):
      net: NETIF_F_HW_CSUM does not imply FCoE CRC offload
      KVM: VMX: Fix host userspace gsbase corruption

Changli Gao (1):
      act_nat: use stack variable

Clemens Ladisch (3):
      hpet: fix unwanted interrupt due to stale irq status bit
      firewire: ohci: fix buffer overflow in AR split packet handling
      firewire: ohci: fix race in AR split packet handling

Dan Rosenberg (6):
      ipc: initialize structure memory to zero for compat functions
      sys_semctl: fix kernel stack leakage
      DECnet: don't leak uninitialized stack byte
      V4L/DVB: ivtvfb: prevent reading uninitialized stack memory
      x25: Prevent crashing when parsing bad X.25 facilities
      rds: Integer overflow in RDS cmsg handling

Daniel Klaffenbach (1):
      ssb: b43-pci-bridge: Add new vendor for BCM4318

Daniel T Chen (2):
      ALSA: ac97: Apply quirk for Dell Latitude D610 binding Master and Headphone controls
      ALSA: hda: Use "alienware" model quirk for another SSID

Darrick J. Wong (1):
      PCI: fix offset check for sysfs mmapped files

Dave Hansen (1):
      mm/vfs: revalidate page->mapping in do_generic_file_read()

David Henningsson (1):
      ALSA: HDA: Add an extra DAC for Realtek ALC887-VD

David S. Miller (4):
      sparc64: Fix race in signal instruction flushing.
      sparc: Don't mask signal when we can't setup signal frame.
      sparc: Prevent no-handler signal syscall restart recursion.
      net: Limit socket I/O iovec total length to INT_MAX.

Dmitry Torokhov (1):
      Input: i8042 - add Sony VAIO VPCZ122GX to nomux list

Douglas Gilbert (1):
      libata-scsi passthru: fix bug which truncated LBA48 return values

Eric Dumazet (3):
      numa: fix slab_node(MPOL_BIND)
      netfilter: nf_conntrack: allow nf_ct_alloc_hashtable() to get highmem pages
      net sched: fix some kernel memory leaks

Florian Tobias Schandinat (1):
      viafb: use proper register for colour when doing fill ops

Francisco Jerez (1):
      drm/ttm: Clear the ghost cpu_writers flag on ttm_buffer_object_transfer.

Gleb Natapov (1):
      KVM: VMX: fix vmx null pointer dereference on debug register access

Graham Gower (1):
      drivers/char/vt_ioctl.c: fix VT_OPENQRY error value

Greg Kroah-Hartman (11):
      Staging: asus_oled: fix up some sysfs attribute permissions
      Staging: asus_oled: fix up my fixup for some sysfs attribute permissions
      Staging: line6: fix up some sysfs attribute permissions
      USB: storage: sierra_ms: fix sysfs file attribute
      USB: atm: ueagle-atm: fix up some permissions on the sysfs files
      USB: misc: cypress_cy7c63: fix up some sysfs attribute permissions
      USB: misc: usbled: fix up some sysfs attribute permissions
      USB: misc: trancevibrator: fix up a sysfs attribute permission
      USB: misc: usbsevseg: fix up some sysfs attribute permissions
      Staging: frontier: fix up some sysfs attribute permissions
      Linux 2.6.32.27

Guo-Fu Tseng (1):
      jme: Fix PHY power-off error

H. Peter Anvin (1):
      x86-32: Fix dummy trampoline-related inline stubs

Heiko Carstens (1):
      nmi: fix clock comparator revalidation

Herbert Xu (1):
      crypto: padlock - Fix AES-CBC handling on odd-block-sized input

Hugh Dickins (1):
      x86, mm: Fix CONFIG_VMSPLIT_1G and 2G_OPT trampoline

Ian Campbell (1):
      xen: ensure that all event channels start off bound to VCPU 0

Jack Steiner (2):
      x86, UV: Delete unneeded boot messages
      x86, UV: Fix initialization of max_pnode

Jacques Viviers (1):
      USB: serial: ftdi_sio: Vardaan USB RS422/485 converter PID added

James Jones (1):
      ARM: 6482/2: Fix find_next_zero_bit and related assembly

Jarek Poplawski (1):
      gianfar: Fix crashes on RX path (Was Re: [Bugme-new] [Bug 19692] New: linux-2.6.36-rc5 crash with gianfar ethernet at full line rate traffic)

Jean Delvare (1):
      hwmon: (lm85) Fix ADT7468 frequency table

Jeff Mahoney (1):
      net sched: fix kernel leak in act_police

Jens Axboe (4):
      block: limit vec count in bio_kmalloc() and bio_alloc_map_data()
      block: take care not to overflow when calculating total iov length
      block: check for proper length of iov entries in blk_rq_map_user_iov()
      bio: take care not overflow page count when mapping/copying user data

Jeremy Fitzhardinge (1):
      xen: don't bother to stop other cpus on shutdown/reboot

Jiri Olsa (1):
      tty: prevent DOS in the flush_to_ldisc

Jiri Slaby (3):
      hpet: unmap unused I/O space
      TTY: restore tty_ldisc_wait_idle
      TTY: ldisc, fix open flag handling

Joerg Roedel (1):
      x86-32: Separate 1:1 pagetables from swapper_pg_dir

Johan Hovold (1):
      USB: ftdi_sio: revert "USB: ftdi_sio: fix DTR/RTS line modes"

John Hughes (1):
      x25: Patch to fix bug 15678 - x25 accesses fields beyond end of packet.

Josh Wu (1):
      USB: gadget: AT91: fix typo in atmel_usba_udc driver

Justin Maggard (1):
      md: fix return value of rdev_size_change()

KAMEZAWA Hiroyuki (2):
      mm: fix return value of scan_lru_pages in memory unplug
      mm: fix is_mem_section_removable() page_order BUG_ON check

Kees Cook (1):
      net: clear heap allocation for ETHTOOL_GRXCLSRLALL

Ken Chen (1):
      latencytop: fix per task accumulator

Ken Sumrall (1):
      fuse: fix attributes after open(O_TRUNC)

Larry Finger (1):
      staging: rtl8187se: Change panic to warn when RF switch turned off

Laurent Pinchart (1):
      V4L/DVB (13154): uvcvideo: Handle garbage at the end of streaming interface descriptors

Len Brown (1):
      ACPI: EC: add Vista incompatibility DMI entry for Toshiba Satellite L355

Linus Torvalds (1):
      net: Truncate recvfrom and sendto length to INT_MAX.

Luke Macken (1):
      efifb: support the EFI framebuffer on more Apple hardware

Martin K. Petersen (1):
      block: Ensure physical block size is unsigned int

Martin Wilck (1):
      PCI: fix size checks for mmap() on /proc/bus/pci files

Masanori ITOH (1):
      percpu: fix list_head init bug in __percpu_counter_init()

Michael Stuermer (1):
      USB: ftdi_sio: Add ID for RT Systems USB-29B radio cable

NeilBrown (1):
      md/raid1: really fix recovery looping when single good device fails.

Nelson Elhage (1):
      do_exit(): make sure that we run with get_fs() == USER_DS

Nobuhiro Iwamatsu (1):
      i2c-pca-platform: Change device name of request_irq

Oliver Hartkopp (1):
      can-bcm: fix minor heap overflow

Pekka Enberg (1):
      perf_events: Fix perf_counter_mmap() hook in mprotect()

Peter Jones (1):
      efifb: check that the base address is plausible on pci systems

Phil Blundell (2):
      econet: disallow NULL remote addr for sendmsg(), fixes CVE-2010-3849
      econet: fix CVE-2010-3850

Philippe Rétornaz (1):
      tty_ldisc: Fix BUG() on hangup

Prarit Bhargava (1):
      x86: AMD Northbridge: Verify NB's node is online

Richard A. Smith (1):
      olpc_battery: Fix endian neutral breakage for s16 values

Richard Weinberger (2):
      um: remove PAGE_SIZE alignment in linker script causing kernel segfault.
      um: fix global timer issue when using CONFIG_NO_HZ

Robin Holt (5):
      Limit sysctl_tcp_mem and sysctl_udp_mem initializers to prevent integer overflows.
      UV - XPC: pass nasid instead of nid to gru_create_message_queue
      x86: uv: XPC receive message reuse triggers invalid BUG_ON()
      X86: uv: xpc_make_first_contact hang due to not accepting ACTIVE state
      x86: uv: xpc NULL deref when mesq becomes empty

Robin@sgi.com (1):
      sgi-xpc: XPC fails to discover partitions with all nasids above 128

Samuel Ortiz (2):
      irda: Fix parameter extraction stack overflow
      irda: Fix heap memory corruption in iriap.c

Sebastien Bourdeauducq (1):
      USB: ftdi_sio: add device IDs for Milkymist One JTAG/serial

Stefan Richter (2):
      firewire: cdev: fix information leak
      firewire: core: fix an information leak

Steven J. Magnani (1):
      nommu: yield CPU while disposing VM

Tejun Heo (3):
      ahci,ata_generic: let ata_generic handle new MBP w/ MCP89
      ata_generic: implement ATA_GEN_* flags and force enable DMA on MBP 7,1
      libata: fix NULL sdev dereference race in atapi_qc_complete()

Thomas Backlund (1):
      microblaze: Fix build with make 3.82

Thomas Gerlach (1):
      drivers/video/efifb.c: support framebuffer for NVIDIA 9400M in MacBook Pro 5,1

Tyler Hicks (1):
      eCryptfs: Clear LOOKUP_OPEN flag when creating lower file

Uwe Kleine-König (1):
      backlight: grab ops_lock before testing bd->ops

Vasiliy Kulikov (5):
      ipc: shm: fix information leak to userland
      KVM: x86: fix information leak to userland
      usb: misc: sisusbvga: fix information leak to userland
      usb: misc: iowarrior: fix information leak to userland
      usb: core: fix information leak to userland

Will Deacon (1):
      ARM: 6489/1: thumb2: fix incorrect optimisation in usracc

Will Newton (1):
      uml: disable winch irq before freeing handler data

Zhang Rui (1):
      acpi-cpufreq: fix a memleak when unloading driver

andrew hendry (1):
      memory corruption in X.25 facilities parsing

ma rui (1):
      USB: option: fix when the driver is loaded incorrectly for some Huawei devices.

