Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab0DAXTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 19:19:13 -0400
Received: from kroah.org ([198.145.64.141]:35356 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758120Ab0DAXSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 19:18:42 -0400
Date: Thu, 1 Apr 2010 16:14:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.31.13
Message-ID: <20100401231447.GC11167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.31.13 kernel.

For anyone somehow still running a .31 kernel, you really should move to
.33 or at the least .32, but if not, here's a kernel for you to use to
help resolve some of the known issues with it.

The updated 2.6.31.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.31.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.31.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/tmpfs.txt       |    6 
 Makefile                                  |    2 
 arch/powerpc/include/asm/elf.h            |    8 
 arch/powerpc/include/asm/thread_info.h    |    2 
 arch/powerpc/kernel/process.c             |   12 -
 arch/sh/kernel/process_64.c               |    2 
 arch/sparc/include/asm/elf_64.h           |   13 -
 arch/sparc/include/asm/thread_info_64.h   |    4 
 arch/sparc/kernel/process_64.c            |    8 
 arch/x86/ia32/ia32_aout.c                 |   12 -
 arch/x86/include/asm/elf.h                |   10 -
 arch/x86/include/asm/fixmap.h             |    6 
 arch/x86/include/asm/io_apic.h            |    1 
 arch/x86/include/asm/kvm_x86_emulate.h    |    2 
 arch/x86/include/asm/thread_info.h        |    2 
 arch/x86/kernel/acpi/boot.c               |    9 -
 arch/x86/kernel/apic/apic_flat_64.c       |    5 
 arch/x86/kernel/apic/io_apic.c            |   50 +++++
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    3 
 arch/x86/kernel/microcode_core.c          |    4 
 arch/x86/kernel/process.c                 |   12 -
 arch/x86/kernel/process_64.c              |   11 +
 arch/x86/kvm/x86_emulate.c                |    5 
 arch/x86/pci/i386.c                       |    9 +
 drivers/acpi/processor_idle.c             |   28 +--
 drivers/base/class.c                      |    2 
 drivers/block/cciss.c                     |    3 
 drivers/char/agp/backend.c                |    4 
 drivers/char/nozomi.c                     |    2 
 drivers/char/tty_io.c                     |    2 
 drivers/connector/connector.c             |  175 --------------------
 drivers/edac/i5000_edac.c                 |    8 
 drivers/gpu/drm/r128/r128_cce.c           |   18 +-
 drivers/gpu/drm/r128/r128_drv.h           |    8 
 drivers/gpu/drm/r128/r128_state.c         |   36 ++--
 drivers/hid/hid-apple.c                   |    7 
 drivers/hid/hid-core.c                    |    3 
 drivers/hid/hid-ids.h                     |    3 
 drivers/hwmon/adt7462.c                   |    2 
 drivers/hwmon/coretemp.c                  |    2 
 drivers/hwmon/fschmd.c                    |    7 
 drivers/hwmon/lm78.c                      |   25 +-
 drivers/hwmon/w83781d.c                   |   26 +--
 drivers/i2c/busses/i2c-pca-isa.c          |    4 
 drivers/i2c/busses/i2c-pca-platform.c     |    4 
 drivers/i2c/busses/i2c-tiny-usb.c         |   12 -
 drivers/i2c/i2c-core.c                    |    5 
 drivers/input/mouse/alps.c                |  252 +++++++++++++++++++++++++++---
 drivers/input/mouse/alps.h                |    1 
 drivers/media/dvb/dvb-usb/af9015.c        |    4 
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h   |    1 
 drivers/media/video/em28xx/em28xx-dvb.c   |    1 
 drivers/media/video/pwc/pwc-ctrl.c        |    2 
 drivers/media/video/uvc/uvc_driver.c      |    3 
 drivers/media/video/uvc/uvc_video.c       |    4 
 drivers/media/video/uvc/uvcvideo.h        |    3 
 drivers/misc/enclosure.c                  |    1 
 drivers/mtd/ubi/cdev.c                    |    1 
 drivers/net/sfc/tx.c                      |    4 
 drivers/net/wireless/airo.c               |   34 ++--
 drivers/net/wireless/ath/ath5k/eeprom.c   |   32 +++
 drivers/net/wireless/ath/ath5k/eeprom.h   |    8 
 drivers/net/wireless/b43/b43.h            |    1 
 drivers/net/wireless/b43/main.c           |   13 +
 drivers/parisc/ccio-dma.c                 |    4 
 drivers/parisc/sba_iommu.c                |    4 
 drivers/rtc/rtc-fm3130.c                  |    6 
 drivers/scsi/megaraid/megaraid_sas.c      |    2 
 drivers/scsi/mpt2sas/mpt2sas_scsih.c      |   17 ++
 drivers/serial/8250.c                     |    7 
 drivers/serial/8250_pnp.c                 |   10 -
 drivers/usb/core/devices.c                |    2 
 drivers/usb/core/devio.c                  |   61 +++++--
 drivers/usb/core/hub.c                    |    3 
 drivers/usb/core/message.c                |    8 
 drivers/usb/core/sysfs.c                  |    6 
 drivers/usb/host/ehci-hcd.c               |    5 
 drivers/usb/host/ehci-hub.c               |   20 ++
 drivers/usb/host/ehci-q.c                 |   11 -
 drivers/usb/host/uhci-hcd.c               |   15 +
 drivers/usb/host/uhci-hub.c               |    2 
 drivers/usb/serial/generic.c              |    2 
 drivers/usb/storage/unusual_devs.h        |    7 
 drivers/usb/storage/usb.c                 |    3 
 drivers/xen/balloon.c                     |    4 
 fs/binfmt_aout.c                          |    1 
 fs/binfmt_elf.c                           |   27 ---
 fs/binfmt_elf_fdpic.c                     |    3 
 fs/binfmt_flat.c                          |    1 
 fs/binfmt_som.c                           |    1 
 fs/cifs/readdir.c                         |    1 
 fs/ecryptfs/crypto.c                      |    4 
 fs/ecryptfs/file.c                        |   14 -
 fs/exec.c                                 |   39 ++--
 fs/namei.c                                |   14 +
 fs/nfs/fscache.c                          |   21 +-
 fs/notify/dnotify/dnotify.c               |    3 
 fs/notify/inotify/inotify_fsnotify.c      |    2 
 fs/notify/inotify/inotify_user.c          |    4 
 fs/notify/notification.c                  |    2 
 fs/ntfs/malloc.h                          |    2 
 fs/partitions/efi.c                       |   30 ++-
 fs/partitions/efi.h                       |    8 
 fs/reiserfs/inode.c                       |   17 +-
 include/linux/binfmts.h                   |    1 
 include/linux/connector.h                 |   32 ---
 include/linux/enclosure.h                 |    2 
 include/linux/mm.h                        |    1 
 include/linux/sched.h                     |   24 ++
 init/main.c                               |    4 
 ipc/msg.c                                 |    1 
 ipc/sem.c                                 |    1 
 ipc/shm.c                                 |    1 
 kernel/futex.c                            |   30 +++
 kernel/time/clockevents.c                 |    5 
 mm/mempolicy.c                            |   40 ++--
 mm/migrate.c                              |    3 
 mm/page_alloc.c                           |    2 
 mm/slab.c                                 |    2 
 mm/swap.c                                 |    2 
 mm/vmalloc.c                              |    8 
 net/core/sock.c                           |    4 
 net/dccp/proto.c                          |    6 
 net/decnet/dn_route.c                     |    2 
 net/ipv4/route.c                          |    2 
 net/ipv4/tcp.c                            |    4 
 net/netfilter/nf_conntrack_core.c         |    4 
 net/netfilter/x_tables.c                  |    2 
 net/netfilter/xt_hashlimit.c              |    8 
 net/netlink/af_netlink.c                  |    6 
 net/sctp/protocol.c                       |    6 
 security/selinux/hooks.c                  |    2 
 sound/pci/hda/hda_intel.c                 |    6 
 sound/usb/usbaudio.c                      |    2 
 134 files changed, 931 insertions(+), 624 deletions(-)

Al Viro (1):
      fix LOOKUP_FOLLOW on automount "symlinks"

Alan Cox (1):
      nozomi: quick fix for the close/close bug

Alan Stern (5):
      USB: add missing delay during remote wakeup
      USB: EHCI: fix handling of unusual interrupt intervals
      USB: EHCI & UHCI: fix race between root-hub suspend and port resume
      USB: fix bitmask merge error
      USB: fix usbfs regression

Andreas Gruenbacher (1):
      dnotify: ignore FS_EVENT_ON_CHILD

Andreas Schwab (1):
      powerpc: TIF_ABI_PENDING bit removal

Avi Kivity (1):
      KVM: x86 emulator: limit instructions to 15 bytes

Ben Hutchings (1):
      drm/r128: Add test for initialisation to all ioctls that require it

Bryn M. Reeves (1):
      megaraid_sas: remove sysfs poll_mode_io world writeable permissions

Christian Schuerer-Waldheim (1):
      HID: add device IDs for new model of Apple Wireless Keyboard

Dan Carpenter (1):
      ecryptfs: use after free

David Miller (1):
      sparc: TIF_ABI_PENDING bit removal

Dean Nelson (1):
      hwmon: (coretemp) Add missing newline to dev_warn() message

Dick Hollenbeck (1):
      serial: 8250: add serial transmitter fully empty test

Erez Zadok (1):
      ecryptfs: initialize private persistent file before dereferencing pointer

Eric Paris (2):
      inotify: do not reuse watch descriptors
      inotify: only warn once for inotify problems

Evgeniy Polyakov (1):
      connector: Delete buggy notification code.

Francesco Lavra (1):
      V4L/DVB (13961): em28xx-dvb: fix memleak in dvb_fini()

Greg Kroah-Hartman (5):
      tty: fix race in tty_fasync
      USB: add speed values for USB 3.0 and wireless controllers
      fnctl: f_modown should call write_lock_irqsave/restore
      USB: usbfs: only copy the actual data received
      Linux 2.6.31.13

H. Peter Anvin (1):
      x86: get rid of the insane TIF_ABI_PENDING bit

Hans de Goede (1):
      hwmon: (fschmd) Fix a memleak on multiple opens of /dev/watchdog

James Bottomley (1):
      SCSI: enclosure: fix oops while iterating enclosure_status array

Jan Beulich (2):
      mm: replace various uses of num_physpages by totalram_pages
      x86: Fix placement of FIX_OHCI1394_BASE

Jan Kara (1):
      reiserfs: truncate blocks not used by a write

Jean Delvare (3):
      i2c-tiny-usb: Fix on big-endian systems
      hwmon: (lm78) Request I/O ports individually for probing
      hwmon: (w83781d) Request I/O ports individually for probing

Jeff Layton (1):
      cifs: fix length calculation for converted unicode readdir names

Jiri Slaby (3):
      SECURITY: selinux, fix update_rlimit_cpu parameter
      resource: add helpers for fetching rlimits
      x86, ia32_aout: do not kill argument mapping

Jody Bruchon (1):
      ALSA: hda-intel: Avoid divide by zero crash

Johan Hovold (1):
      usb: serial: fix memory leak in generic driver

KOSAKI Motohiro (5):
      page allocator: update NR_FREE_PAGES only when necessary
      tmpfs: mpol=bind:0 don't cause mount error.
      tmpfs: handle MPOL_LOCAL mount option properly
      tmpfs: cleanup mpol_parse_str()
      doc: add the documentation for mpol=local

Karel Zak (2):
      partitions: read whole sector with EFI GPT header
      partitions: use sector size for EFI GPT

Kashyap, Desai (1):
      mpt2sas: Delete volume before HBA detach.

Larry Finger (1):
      b43: Fix throughput regression

Laurent Pinchart (2):
      V4L/DVB (13155): uvcvideo: Add a module parameter to set the streaming control timeout
      class: Free the class private data in class_release

Linus Torvalds (5):
      Fix potential crash with sys_move_pages
      Fix race in tty_fasync() properly
      USB: usbfs: properly clean up the as structure on error paths
      Split 'flush_old_exec' into two functions
      Fix 'flush_old_exec()/setup_new_exec()' split

Luis R. Rodriguez (1):
      ath5k: Fix eeprom checksum check for custom sized eeproms

Mart Raudsepp (1):
      V4L/DVB: af9015: add new USB ID for KWorld PlusTV Dual DVB-T Stick (DVB-T 399U)

Martin Fuzzey (1):
      V4L/DVB: Video : pwc : Fix regression in pwc_set_shutter_speed caused by bad constant => sizeof conversion.

Matthew Garrett (1):
      serial: 8250_pnp: use wildcard for serial Wacom tablets

Mika Westerberg (1):
      UBI: fix volume creation input checking

Mikael Pettersson (1):
      futex_lock_pi() key refcnt fix

Neil Horman (1):
      coredump: suppress uid comparison test if core output files are pipes

Neil Turton (1):
      sfc: Fix DMA mapping cleanup in case of an error in TSO

Oliver Neukum (1):
      USB: Don't use GFP_KERNEL while we cannot reset a storage device

Pallipadi, Venkatesh (1):
      ACPI: Be in TS_POLLING state during mwait based C-state entry

Ravikiran G Thirumalai (1):
      tmpfs: fix oops on mounts with mpol=default

Ray Copeland (1):
      hwmon: (adt7462) Wrong ADT7462_VOLT_COUNT

Ryan May (1):
      USB: fix usbstorage for 2770:915d delivers no FAT

Sebastian Kapfer (1):
      Input: ALPS - add interleaved protocol support (Dell E6x00 series)

Serge E. Hallyn (1):
      ipc ns: fix memory leak (idr)

Sergey Matyukevich (1):
      rtc-fm3130: add missing braces

Stanislaw Gruszka (1):
      airo: fix setting zero length WEP key

Stephen M. Cameron (1):
      cciss: Make cciss_seq_show handle holes in the h->drv[] array

Suresh Siddha (2):
      x86, apic: use physical mode for IBM summit platforms
      x86/PCI/PAT: return EINVAL for pci mmap WC request for !pat_enabled

Takashi Iwai (1):
      ALSA: usb-audio - Avoid Oops after disconnect

Tamas Vincze (1):
      edac: i5000_edac critical fix panic out of bounds

Thadeu Lima de Souza Cascardo (1):
      i2c: Do not use device name after device_unregister

Thomas Gleixner (2):
      futex: Handle futex value corruption gracefully
      futex: Handle user space corruption gracefully

Thomas Renninger (1):
      CPUFREQ: Fix use after free of struct powernow_k8_data

Trond Myklebust (1):
      NFS: Fix a bug in nfs_fscache_release_page()

Wei Yongjun (1):
      inotify: fix coalesce duplicate events into a single event in special case

Wolfram Sang (1):
      i2c/pca: Don't use *_interruptible

Xiaotian Feng (1):
      clockevent: Don't remove broadcast device when cpu is dead

Yinghai Lu (1):
      x86: Fix SCI on IOAPIC != 0

Yongseok Koh (1):
      vmalloc: remove BUG_ON due to racy counting of VM_LAZY_FREE

