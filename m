Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab1D3PIz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 11:08:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:43987 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258Ab1D3PIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 11:08:50 -0400
Date: Sat, 30 Apr 2011 15:08:46 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Linux 2.6.27.59
Message-ID: <20110430150846.GA11600@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 30 Apr 2011 15:08:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've just released Linux 2.6.27.59.

I'll also be replying to this message with a copy of the patch between
2.6.27.58 and 2.6.27.59.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.27/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.27/patch-2.6.27.59.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.27/ChangeLog-2.6.27.59

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.27.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.27.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.27.y.git

Thanks to all reviewers,
Willy

-------

 Documentation/kernel-parameters.txt             |    1 
 MAINTAINERS                                     |    2 
 Makefile                                        |    2 
 arch/arm/kernel/signal.c                        |    4 -
 arch/ia64/sn/pci/tioca_provider.c               |    2 
 arch/parisc/kernel/firmware.c                   |   23 ------
 arch/parisc/kernel/irq.c                        |    2 
 arch/powerpc/include/asm/hvcall.h               |    1 
 arch/powerpc/kernel/cpu_setup_6xx.S             |   40 ++++++------
 arch/powerpc/kernel/crash.c                     |   42 ++++++++++++
 arch/powerpc/kernel/machine_kexec_64.c          |   25 +++++++
 arch/powerpc/kernel/rtas_flash.c                |   39 ++++++-----
 arch/powerpc/kernel/setup_64.c                  |   17 +++--
 arch/powerpc/platforms/pseries/hvCall.S         |   38 +++++++++++
 arch/powerpc/platforms/pseries/lpar.c           |   35 ++++++----
 arch/powerpc/platforms/pseries/plpar_wrappers.h |   18 +++++
 arch/powerpc/sysdev/fsl_rio.c                   |    1 
 arch/s390/include/asm/processor.h               |    5 -
 arch/s390/kernel/traps.c                        |   37 -----------
 arch/x86/kernel/e820.c                          |    3 
 arch/x86/kernel/early-quirks.c                  |    7 +-
 arch/x86/kernel/entry_64.S                      |    2 
 arch/x86/lib/semaphore_32.S                     |    2 
 arch/x86/mm/pgtable.c                           |    3 
 drivers/acpi/asus_acpi.c                        |    8 --
 drivers/ata/ahci.c                              |   15 ++++
 drivers/ata/libata-core.c                       |   24 ++++---
 drivers/block/cciss.h                           |    1 
 drivers/block/pktcdvd.c                         |    2 
 drivers/bluetooth/btusb.c                       |    3 
 drivers/char/tpm/tpm.c                          |   12 ++-
 drivers/firmware/dcdbas.c                       |    4 -
 drivers/hwmon/f71882fg.c                        |    2 
 drivers/hwmon/via686a.c                         |   14 +++-
 drivers/infiniband/core/cm.c                    |    1 
 drivers/infiniband/core/cma.c                   |   15 ++++
 drivers/input/serio/i8042-x86ia64io.h           |   21 ++++++
 drivers/input/serio/i8042.c                     |    6 +
 drivers/input/xen-kbdfront.c                    |   32 ++++++---
 drivers/isdn/hisax/config.c                     |   18 ++++-
 drivers/isdn/hisax/hisax.h                      |    1 
 drivers/isdn/i4l/isdn_tty.c                     |    6 -
 drivers/md/dm-raid1.c                           |    2 
 drivers/md/md.c                                 |    8 +-
 drivers/media/dvb/ttpci/av7110_ca.c             |    2 
 drivers/media/radio/radio-aimslab.c             |   24 ++-----
 drivers/media/video/sn9c102/sn9c102_core.c      |    6 -
 drivers/message/fusion/mptscsih.c               |    2 
 drivers/mfd/ucb1x00-ts.c                        |   12 ++-
 drivers/misc/acer-wmi.c                         |    4 -
 drivers/misc/tc1100-wmi.c                       |    2 
 drivers/net/myri10ge/myri10ge.c                 |    1 
 drivers/net/r8169.c                             |    6 +
 drivers/net/wireless/hostap/hostap_cs.c         |   10 ---
 drivers/net/wireless/rt2x00/rt73usb.c           |    1 
 drivers/pci/quirks.c                            |   61 ++++++++++++++++--
 drivers/rtc/rtc-ds1511.c                        |    2 
 drivers/s390/char/keyboard.c                    |    3 
 drivers/scsi/libsas/sas_scsi_host.c             |    1 
 drivers/scsi/sd.c                               |    9 ++
 drivers/scsi/ses.c                              |    4 -
 drivers/serial/8250.c                           |    3 
 drivers/usb/class/cdc-acm.c                     |    3 
 drivers/usb/core/hub.c                          |    5 +
 drivers/usb/gadget/printer.c                    |   14 ++--
 drivers/usb/host/ehci-hcd.c                     |   28 ++++++--
 drivers/usb/host/ehci-pci.c                     |   39 +++++++++++
 drivers/usb/host/ehci-q.c                       |   27 ++------
 drivers/usb/host/ehci-sched.c                   |   79 ++++++++++++++++++++++++
 drivers/usb/host/ehci.h                         |    1 
 drivers/usb/misc/iowarrior.c                    |    2 
 drivers/usb/misc/uss720.c                       |    7 --
 drivers/usb/musb/omap2430.c                     |    1 
 drivers/usb/serial/ch341.c                      |    1 
 drivers/usb/serial/io_edgeport.c                |    4 -
 drivers/usb/serial/pl2303.c                     |    2 
 drivers/usb/serial/pl2303.h                     |    2 
 drivers/usb/serial/ti_usb_3410_5052.c           |    2 
 drivers/usb/storage/unusual_devs.h              |   16 ++++
 drivers/video/console/tileblit.c                |    2 
 drivers/virtio/virtio_pci.c                     |    1 
 fs/aio.c                                        |    4 -
 fs/compat.c                                     |   28 ++++----
 fs/dquot.c                                      |   11 +--
 fs/ecryptfs/keystore.c                          |    1 
 fs/exec.c                                       |   30 ++++++++-
 fs/ext2/namei.c                                 |    9 --
 fs/ext3/namei.c                                 |    2 
 fs/ext3/super.c                                 |    7 ++
 fs/ext4/inode.c                                 |   11 +--
 fs/gfs2/bmap.c                                  |    2 
 fs/nfs/direct.c                                 |   34 ++++++----
 fs/nfs/file.c                                   |    2 
 fs/nfsd/lockd.c                                 |    1 
 fs/nfsd/nfs4xdr.c                               |    8 +-
 fs/nfsd/vfs.c                                   |    2 
 fs/ocfs2/aops.c                                 |    6 +
 fs/ocfs2/stack_user.c                           |    2 
 fs/partitions/ldm.c                             |    5 +
 fs/partitions/mac.c                             |   17 ++---
 fs/proc/array.c                                 |    7 --
 fs/proc/base.c                                  |    9 ++
 fs/proc/task_mmu.c                              |    4 -
 fs/ramfs/file-nommu.c                           |    3 
 fs/ubifs/commit.c                               |    2 
 fs/ubifs/file.c                                 |    3 
 fs/ubifs/lpt.c                                  |    7 --
 fs/xfs/linux-2.6/xfs_ioctl.c                    |   11 ++-
 fs/xfs/xfs_fsops.c                              |    3 
 include/asm-x86/mach-default/smpboot_hooks.h    |    2 
 include/asm-x86/mmu_context_32.h                |    5 -
 include/asm-x86/mmu_context_64.h                |    5 -
 include/asm-x86/pgtable-3level.h                |   11 ---
 include/drm/drm_pciids.h                        |    1 
 include/linux/binfmts.h                         |    5 +
 include/linux/pid.h                             |    2 
 include/net/sctp/command.h                      |    1 
 include/scsi/scsi_device.h                      |    2 
 include/sound/soc-dapm.h                        |   16 ++--
 init/calibrate.c                                |    6 -
 kernel/irq/manage.c                             |    2 
 kernel/kgdb.c                                   |    9 --
 kernel/pid.c                                    |    5 +
 kernel/ptrace.c                                 |    2 
 kernel/signal.c                                 |    8 +-
 mm/mremap.c                                     |   19 ++++-
 mm/shmem.c                                      |    1 
 net/ax25/af_ax25.c                              |    2 
 net/bluetooth/bnep/sock.c                       |    1 
 net/bluetooth/sco.c                             |    1 
 net/bridge/netfilter/ebtables.c                 |    2 
 net/can/bcm.c                                   |    4 -
 net/core/filter.c                               |   64 ++++++++++---------
 net/dccp/input.c                                |    7 --
 net/econet/af_econet.c                          |    8 +-
 net/ipv4/inet_diag.c                            |   27 ++++----
 net/ipv4/netfilter/arp_tables.c                 |    3 
 net/ipv4/netfilter/ip_tables.c                  |    3 
 net/ipv4/netfilter/ipt_CLUSTERIP.c              |    5 +
 net/ipv4/tcp.c                                  |    3 
 net/ipv6/netfilter/ip6_tables.c                 |    3 
 net/irda/af_irda.c                              |   16 ++--
 net/irda/iriap.c                                |    6 +
 net/irda/irnet/irnet_ppp.c                      |    3 
 net/mac80211/sta_info.c                         |    1 
 net/packet/af_packet.c                          |    3 
 net/rose/rose_subr.c                            |   18 ++++-
 net/sctp/auth.c                                 |    8 +-
 net/sctp/sm_make_chunk.c                        |   32 +++------
 net/sctp/sm_sideeffect.c                        |   26 +++++++
 net/sctp/sm_statefuns.c                         |    8 ++
 net/sunrpc/cache.c                              |    4 -
 net/sunrpc/sched.c                              |   14 +---
 net/tipc/socket.c                               |    1 
 net/x25/x25_link.c                              |    4 +
 sound/oss/dev_table.h                           |    2 
 sound/oss/midi_synth.c                          |   34 ++++------
 sound/oss/midi_synth.h                          |    2 
 sound/oss/opl3.c                                |   23 ++++--
 sound/oss/sequencer.c                           |    2 
 sound/pci/au88x0/au88x0_pcm.c                   |   24 ++++++-
 sound/pci/ens1370.c                             |   23 +++++-
 162 files changed, 1119 insertions(+), 536 deletions(-)

Summary of changes from 2.6.27.58 to 2.6.27.59
============================================

Aaro Koskinen (1):
      procfs: fix /proc/<pid>/maps heap check

Alan Stern (6):
      USB: usb-storage: unusual_devs entry for CamSport Evo
      USB: EHCI: fix DMA deallocation bug
      USB: g_printer: fix bug in module parameter definitions
      USB: prevent buggy hubs from crashing the USB stack
      ehci-hcd: Bug fix: don't set a QH's Halt bit
      USB: EHCI: unlink unused QHs when the controller is stopped

Alex Deucher (1):
      drm/radeon: remove 0x4243 pci id

Alex Elder (1):
      xfs: zero proper structure size for geometry calls

Alex He (2):
      USB: EHCI: ASPM quirk of ISOC on AMD SB800
      USB: EHCI: ASPM quirk of ISOC on AMD Hudson

Alexander van Heukelum (1):
      x86, binutils, xen: Fix another wrong size directive

Amir Goldstein (1):
      ext3: skip orphan cleanup on rocompat fs

Andreas Herrmann (1):
      x86, quirk: Fix SB600 revision check

Anton Blanchard (3):
      powerpc/kdump: CPUs assume the context of the oopsing CPU
      powerpc/kdump: Use chip->shutdown to disable IRQs
      powerpc: Use more accurate limit for first segment memory allocations

Apollon Oikonomopoulos (1):
      x25: decrement netdev reference counts on unload

Artem Bityutskiy (3):
      UBIFS: do not read flash unnecessarily
      UBIFS: fix oops on error path in read_pnode
      UBIFS: fix oops when R/O file-system is fsync'ed

Benjamin Herrenschmidt (1):
      powerpc: Fix some 6xx/7xxx CPU setup functions

Bjørn Mork (1):
      USB: io_edgeport: fix the reported firmware major and minor

Bud Brown (1):
      cciss: fix lost command issue

Chuck Lever (1):
      NFS: Fix "kernel BUG at fs/aio.c:554!"

Clemens Ladisch (1):
      ALSA: ens1371: fix Creative Ectiva support

Dan Carpenter (2):
      av7110: check for negative array offset
      keyboard: integer underflow bug

Dan Rosenberg (10):
      sctp: Fix out-of-bounds reading in sctp_asoc_get_hmac()
      Fix pktcdvd ioctl dev_minor range check
      sound/oss/opl3: validate voice and channel indexes
      xfs: prevent leaking uninitialized stack memory in FSGEOMETRY_V1
      irda: validate peer name and attribute lengths
      irda: prevent heap corruption on invalid nickname
      ROSE: prevent heap corruption with bad facilities
      sound/oss: remove offset from load_patch callbacks
      irda: prevent integer underflow in IRLMP_ENUMDEVICES
      CAN: Use inode instead of kernel address for /proc file

Dario Lombardo (1):
      drivers: update to pl2303 usb-serial to support Motorola cables

David Milburn (1):
      ahci: add device IDs for Ibex Peak ahci controllers

David S. Miller (5):
      filter: make sure filters dont read uninitialized memory
      tcp: Increase TCP_MAXSEG socket option minimum.
      tcp: Make TCP_MAXSEG minimum more correct.
      x25: Do not reference freed memory.
      econet: Fix crash in aun_incoming().

Don Zickus (1):
      x86: Use u32 instead of long to set reset vector back to 0

Enrik Berkhan (1):
      nommu: ramfs: pages allocated to an inode's pagecache may get wrongly discarded

Eric Sandeen (1):
      ext3: Always set dx_node's fake_dirent explicitly.

Felix Fietkau (1):
      mac80211: initialize sta->last_rx in sta_info_alloc

Geert Uytterhoeven (1):
      radio-aimslab.c needs #include <linux/delay.h>

Gerrit Renker (1):
      dccp: fix oops on Reset after close

Goldwyn Rodrigues (1):
      Treat writes as new when holes span across page boundaries

Greg Kroah-Hartman (1):
      rt2x00: add device id for windy31 usb device

Guy Martin (1):
      parisc : Remove broken line wrapping handling pdc_iodc_print()

Hans de Goede (1):
      hwmon/f71882fg: Set platform drvdata to NULL later

Henry Nestler (1):
      fbcon: Bugfix soft cursor detection in Tile Blitting

Hugh Dickins (2):
      mm: fix possible cause of a page_mapped BUG
      shmem: let shared anonymous be nonlinear again

Ionut Nicu (1):
      USB: ti_usb: fix module removal

J. Bruce Fields (1):
      nfsd: fix auth_domain reference leak on nlm operations

J. R. Okajima (1):
      NFS: fix the return value of nfs_file_fsync()

James Bottomley (2):
      fix medium error problems with some arrays which can cause data corruption
      libsas: fix runaway error handler problem

Jan Beulich (1):
      x86: Fix a bogus unwind annotation in lib/semaphore_32.S

Jan Kara (1):
      quota: Don't write quota info in dquot_commit()

Jason Wessel (1):
      repair gdbstub to match the gdbserial protocol specification

Jean Delvare (1):
      hwmon: (via686a) Initialize fan_div values

Jeff Mahoney (1):
      tioca: Fix assignment from incompatible pointer warnings

Jiri Kosina (1):
      Input: i8042 - introduce 'notimeout' blacklist for Dell Vostro V13

Jiri Slaby (2):
      PCI: add more checking to ICH region quirks
      PCI: do not create quirk I/O regions below PCIBIOS_MIN_IO for ICH

Jochen Friedrich (1):
      mfd: Fix NULL pointer due to non-initialized ucb1x00-ts absinfo

Johan Hovold (2):
      usb: musb: omap2430: fix kernel panic on reboot
      USB: cdc-acm: fix potential null-pointer dereference on disconnect

John Hughes (1):
      ses: show devices for enclosures with no page 7

Josh Hunt (1):
      ext2: Fix link count corruption under heavy link+rename load

Julien Tinnes (1):
      Prevent rt_sigqueueinfo and rt_tgsigqueueinfo from spoofing the signal code

Kamal Mostafa (1):
      x86: Fix panic when handling "mem={invalid}" param

Kamalesh Babulal (2):
      powerpc/kexec: Add ifdef CONFIG_PPC_STD_MMU_64 to PPC64 code
      powerpc: Fix default_machine_crash_shutdown #ifdef botch

Kees Cook (3):
      usb: iowarrior: don't trust report_size for buffer size
      proc: protect mm start_code/end_code in /proc/pid/stat
      net: ax25: fix information leak to userland harder

Konstantin Khorenko (1):
      NFSD: memory corruption due to writing beyond the stat array

Krishnasamy, Somasundaram (1):
      ses: Avoid kernel panic when lun 0 is not mapped

Kulikov Vasiliy (2):
      sound: oss: midi_synth: check get_user() return value
      net: tipc: fix information leak to userland

Kyle McMartin (1):
      parisc: pass through '\t' to early (iodc) console

Li Zefan (1):
      sunrpc/cache: fix module refcnt leak in a failure path

Linus Torvalds (3):
      mm: avoid wrapping vm_pgoff in mremap()
      next_pidmap: fix overflow condition
      proc: do proper range check on readdir offset

Marc-Antoine Perennou (1):
      Bluetooth: add support for Apple MacBook Pro 8,2

Mark Brown (1):
      ASoC: Explicitly say registerless widgets have no register

Martin Schwidefsky (1):
      s390: remove task_show_regs

Matt Evans (1):
      powerpc/kexec: Fix orphaned offline CPUs across kexec

Mauro Carvalho Chehab (1):
      radio-aimslab.c: Fix gcc 4.5+ bug

Maxim Uvarov (1):
      powerpc/crashdump: Do not fail on NULL pointer dereferencing

Michael Neuling (3):
      powerpc/pseries: Add hcall to read 4 ptes at a time in real mode
      powerpc/kexec: Speedup kexec hash PTE tear down
      powerpc/kdump: Fix race in kdump shutdown

Michael S. Tsirkin (1):
      virtio: set pci bus master enable bit

Mikulas Patocka (1):
      dm raid1: fail writes if errors are not handled and log fails

Milton Miller (1):
      powerpc: rtas_flash needs to use rtas_data_buf

NeilBrown (3):
      md: fix regression with re-adding devices to arrays with no metadata
      nfsd: correctly handle return value from nfsd_map_name_to_*
      md: correctly handle probe of an 'mdp' device.

Nelson Elhage (1):
      inet_diag: Make sure we actually run the same bytecode we audited.

Nick Holloway (1):
      USB: Storage: Add unusual_devs entry for VTech Kidizoom

Olaf Hering (1):
      Input: xen-kbdfront - advertise either absolute or relative coordinates

Oleg Nesterov (2):
      exec: make argv/envp memory visible to oom-killer
      exec: copy-and-paste the fixes into compat_do_execve() paths

Pavel Machek (1):
      serial: unbreak billionton CF card

Peter Holik (1):
      USB: uss720 fixup refcount position

Peter Huewe (1):
      char/tpm: Fix unitialized usage of data buffer

Rajiv Andrade (1):
      TPM: Long default timeout fix

Randy Dunlap (1):
      MAINTAINERS: update STABLE BRANCH info

Raymond Yau (1):
      ALSA : au88x0 - Limit number of channels to fix Oops via OSS emu

Roberto Sassu (1):
      eCryptfs: ecryptfs_keyring_auth_tok_for_sig() bug fix

Roland Dreier (2):
      aio: wake all waiters when destroying ctx
      Relax si_code check in rt_sigqueueinfo and rt_tgsigqueueinfo

Russell King (1):
      ARM: Ensure predictable endian state on signal handler entry

Ryan Kuester (1):
      mptsas: fix hangs caused by ATA pass-through

Sean Hefty (2):
      RDMA/cma: Fix crash in request handlers
      IB/cm: Bump reference count on cm_id before invoking callback

Seth Heasley (4):
      ahci: AHCI and RAID mode SATA patch for Intel Cougar Point DeviceIDs
      ahci: AHCI and RAID mode SATA patch for Intel Patsburg DeviceIDs
      ahci: AHCI mode SATA patch for Intel DH89xxCC DeviceIDs
      ahci: AHCI mode SATA patch for Intel Patsburg SATA RAID controller

Shaohua Li (1):
      x86: Flush TLB if PGD entry is changed in i386 PAE mode

Simone Contini (1):
      USB: serial: pl2303: Hybrid reader Uniform HCR331

Stanislaw Gruszka (3):
      hostap_cs: fix sleeping function called from invalid context
      r8169: disable ASPM
      myri10ge: fix rmmod crash

Steven J. Magnani (1):
      net: Fix oops from tcp_collapse() when using splice()

Steven Whitehouse (1):
      GFS2: Fix bmap allocation corner-case bug

Stuart Hayes (1):
      dcdbas: force SMI to happen when expected

Suresh Siddha (1):
      x86, mm: avoid possible bogus tlb entries by clearing prev mm_cpumask after switching mm

Tejun Heo (2):
      ptrace: use safer wake up on ptrace_detach()
      libata: no special completion processing for EH commands

Thomas Gleixner (3):
      isdn: hisax: Replace the bogus access to irq stats
      genirq: Disable the SHIRQ_DEBUG call in request_threaded_irq for now
      fix per-cpu flag problem in the cpu affinity checkers

Thomas Taranowski (1):
      rapidio: fix hang on RapidIO doorbell queue full condition

Tilman Schmidt (1):
      isdn: avoid calling tty_ldisc_flush() in atomic context

Tim Deegan (1):
      fix jiffy calculations in calibrate_delay_direct to handle overflow

Timo Warns (2):
      fs/partitions: Validate map_count in Mac partition tables
      ldm: corrupted partition table can cause kernel oops

Trond Myklebust (1):
      SUNRPC: Ensure we always run the tk_callback before tk_action

Vasiliy Kulikov (15):
      platform: x86: asus_acpi: world-writable procfs files
      platform: x86: acer-wmi: world-writable sysfs threeg file
      platform: x86: tc1100-wmi: world-writable sysfs wireless and jogdial files
      Bluetooth: sco: fix information leak to userspace
      bridge: netfilter: fix information leak
      Bluetooth: bnep: fix buffer overflow
      netfilter: ip_tables: fix infoleak to userspace
      netfilter: arp_tables: fix infoleak to userspace
      netfilter: ipt_CLUSTERIP: fix buffer overflow
      ipv6: netfilter: ip6_tables: fix infoleak to userspace
      drivers/rtc/rtc-ds1511.c: world-writable sysfs nvram file
      econet: 4 byte infoleak to the network
      net: ax25: fix information leak to userland
      net: packet: fix information leak to userland
      video: sn9c102: world-wirtable sysfs files

Vlad Yasevich (1):
      sctp: Fix oops when sending queued ASCONF chunks

Wei Yongjun (1):
      sctp: fix to calc the INIT/INIT-ACK chunk length correctly is set

Willy Tarreau (1):
      Linux 2.6.27.59

Yongqiang Yang (1):
      ext4: fix credits computing for indirect mapped files

dann frazier (1):
      ocfs2_connection_find() returns pointer to bad structure

wangyanqing (1):
      USB: serial: ch341: add new id

