Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab0FLDCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 23:02:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751982Ab0FLDCH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 23:02:07 -0400
MIME-Version: 1.0
Date: Fri, 11 Jun 2010 20:01:22 -0700
Message-ID: <AANLkTimlNGH89Qnt5XcKeawXxp-YEFuPBPARbKuugSf1@mail.gmail.com>
Subject: Linux 2.6.35-rc3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I've been hardnosed now for a week - perhaps overly so - and
hopefully that means that 2.6.35-rc3 will be better than -rc2 was. Not
only do we have a number of regressions handled, we don't have that
silly memory corruptor that bit so many people with -rc2 and confused
people with its many varied forms of bugs it seemed to take, depending
on just what random memory it happened to corrupt.

One effect of being strict is that this is likely the smallest -rc3
we've had in a long long time. The diffstat summary line for the week
looks like this:

 165 files changed, 1624 insertions(+), 859 deletions(-)

from 159 commits, and even then the biggest single change was due to
moving some functions around in iwl-agn.c, rather than a lot of actual
changed lines.

So give it a good testing.

                         Linus

---
Abhijeet Kolekar (1):
      iwl3945: fix internal scan

Alan Cox (1):
      misc: Fix allocation 'borrowed' by vhost_net

Alex Deucher (7):
      drm/radeon/kms/evergreen: set accel_enabled
      drm/radeon/kms/combios: fix typo in voltage fix
      drm/radeon/kms/pm: Misc fixes
      drm/radeon/kms/pm: add mid profile
      drm/radeon/kms: fix typo in printing the HPD info
      drm/radeon/kms/pm: Disable voltage adjust on RS780/RS880
      drm/radeon/kms/pm: track current voltage (v2)

Anfei (1):
      ARM: 6166/1: Proper prefetch abort handling on pre-ARMv6

Anton Vorontsov (1):
      gianfar: Revive the driver for eTSEC devices (disable timestamping)

Arnaldo Carvalho de Melo (1):
      perf symbols: Set the DSO long name when using symbol_conf.vmlinux_name

Arnd Bergmann (1):
      hp_sdc_rtc: fix broken ioctl conversion

Avi Kivity (1):
      KVM: MMU: Remove user access when allowing kernel access to gpte.w=0 page

Ben Skeggs (3):
      drm/nouveau: match U/DP script against SOR link
      drm/nouveau: completely fail init if we fail to map the PRAMIN BAR
      drm/nv50: fix iommu errors caused by device reading from address 0

Bjorn Helgaas (1):
      PCI: change resource collision messages from KERN_ERR to KERN_INFO

Bob Copeland (1):
      ath5k: retain promiscuous setting

Bruno Randolf (1):
      ath5k: fix NULL pointer in antenna configuration

Catalin Marinas (1):
      sata_sil24: Use memory barriers before issuing commands

Chris Wilson (1):
      drm: Propagate error from drm_fb_helper_init().

Christoph Hellwig (1):
      nfsd: nfsd_setattr needs to call commit_metadata

Colin Tuckley (1):
      sata_sil24: fix kernel panic on ARM caused by unaligned access
in sata_sil24

Dan Carpenter (15):
      drm/drm_crtc: return -EFAULT on copy_to_user errors
      drm/vmwgfx: return -EFAULT for copy_to_user errors
      nouveau: off by one in nv50_gpio_location()
      drm/nouveau: off by one in init_i2c_device_find()
      caif: fix a couple range checks
      sata_sil24: memset() overflow
      Btrfs: uninitialized data is check_path_shared()
      Btrfs: handle error returns from btrfs_lookup_dir_item()
      Btrfs: handle kzalloc() failure in open_ctree()
      Btrfs: btrfs_iget() returns ERR_PTR
      Btrfs: unwind after btrfs_start_transaction() errors
      Btrfs: btrfs_read_fs_root_no_name() returns ERR_PTRs
      Btrfs: btrfs_lookup_dir_item() can return ERR_PTR
      Btrfs: handle ERR_PTR from posix_acl_from_xattr()
      Btrfs: The file argument for fsync() is never null

Daniel Turull (1):
      pktgen: Fix accuracy of inter-packet delay.

Daniel Walker (2):
      msm: dma: add completion.h header
      mmc: msm: fix compile error on MSM7x30

Dave Airlie (5):
      drm/i915: fix oops on single crtc devices.
      drm/radeon: fix PM on non-vram cards.
      drm/fb: use printk to print out the switching to text mode error.
      drm/radeon: reset i2c valid to avoid incorrect tv-out polling.
      drm/radeon: don't poll tv dac if crtc2 is in use.

Dave Chinner (3):
      writeback: pay attention to wbc->nr_to_write in write_cache_pages
      xfs: remove nr_to_write writeback windup.
      writeback: limit write_cache_pages integrity scanning to current EOF

David Howells (1):
      FRV: Reinstate null behaviour for the GDB remote protocol 'p' command

David Woodhouse (2):
      jffs2: Fix in-core inode leaks on error paths
      jffs2: Fix NFS race by using insert_inode_locked()

Denis Kirjanov (2):
      8139too: fix buffer overrun in rtl8139_init_board
      powerpc/oprofile: fix potential buffer overrun in op_model_cell.c

Dominik Brodowski (3):
      pcmcia: only keep saved I365_CSCINT flag if there is no PCI irq
      pcmcia: dev_node removal bugfix
      pcmcia: avoid validate_cis failure on CIS override

Emmanuel Grumbach (1):
      iwlwifi: move sysfs_create_group to post request firmware

Eric Dumazet (5):
      ipv6: avoid high order allocations
      ip6mr: fix a typo in ip6mr_for_each_table()
      ipmr: dont corrupt lists
      ipv6: fix ICMP6_MIB_OUTERRORS
      pkt_sched: gen_estimator: add a new lock

FUJITA Tomonori (1):
      microblaze: Fix sg_dma_len() regression

Figo.zhang (1):
      net8139: fix a race at the end of NAPI

Grazvydas Ignotas (1):
      wl1251: fix a memory leak in probe

H Hartley Sweeten (1):
      docbook: make mtd nand module init static

Heiko Carstens (1):
      [S390] appldata/extmem/kvm: add missing GFP_KERNEL flag

Hendrik Brueckner (1):
      [S390] kprobes: add parameter check to module_free()

Henry C Chang (1):
      ceph: fix d_subdirs ordering problem

Holger Schurig (1):
      mac80211: fix function pointer check

Inaky Perez-Gonzalez (1):
      wimax/i2400m: fix missing endian correction read in fw loader

J. Bruce Fields (1):
      nfsd4: shut down callback queue outside state lock

Jan Kara (1):
      jffs2: update ctime when changing the file's permission by setfacl

Jan Kiszka (1):
      KVM: Fix order passed to iommu_unmap

Jason Dravet (1):
      p54usb: Add device ID for Dell WLA3310 USB

Jean Delvare (1):
      KVM: powerpc: fix init/exit annotation

Jeff Mahoney (1):
      ceph: fix atomic64_t initialization on ia64

Jens Axboe (1):
      block: remove duplicate BUG_ON() in bd_finish_claiming()

Jesse Barnes (1):
      Revert "PCI: create function symlinks in /sys/bus/pci/slots/N/"

Jiri Slaby (1):
      PCI: hotplug/cpqphp, fix NULL dereference

Joerg Roedel (2):
      KVM: SVM: Handle MCEs early in the vmexit process
      KVM: SVM: Implement workaround for Erratum 383

Johannes Berg (3):
      mac80211: process station blockack action frames from work
      iwlwifi: add missing rcu_read_lock
      mac80211: fix deauth before assoc

John Fastabend (1):
      net: deliver skbs on inactive slaves to exact matches

John W. Linville (1):
      Revert "wireless: hostap, fix oops due to early probing interrupt"

Josef Bacik (1):
      Btrfs: fix fallocate regression

Julia Lawall (4):
      drivers/mtd: Use memdup_user
      drivers/watchdog: Eliminate a NULL pointer dereference
      [S390] arch/s390/kvm: Use GFP_ATOMIC when a lock is held
      KVM: ia64: Add missing spin_unlock in kvm_arch_hardware_enable()

Jussi Kivilinna (1):
      asix: check packet size against mtu+ETH_HLEN instead of ETH_FRAME_LEN

Justin P. Mattock (4):
      pcmcia: yenta_socket.c Remove extra #ifdef CONFIG_YENTA_TI
      ALSA: hda - Add SSID table for MacBookAir2,1
      ALSA: hda - Add SSID table for MacBookAir1,1
      ALSA: hda - Add SSID table for iMac7,1.

Khem Raj (1):
      ARM: 6164/1: Add kto and kfrom to input operands list.

Linus Torvalds (3):
      Revert "tty: fix a little bug in scrup, vt.c"
      Revert "drm/i915: Don't enable pipe/plane/VCO early (wait for DPMS on)."
      Linux 2.6.35-rc3

Linus Walleij (3):
      ARM: 6144/1: TCM memory bug freeing bug
      ARM: 6145/1: ux500 MTU clockrate correction
      ARM: 6152/1: ux500 make it possible to disable localtimers

Marcelo Tosatti (2):
      KVM: MMU: invalidate and flush on spte small->large page size change
      KVM: read apic->irr with ioapic lock held

Marek Vasut (1):
      [ARM] pxa/spitz: Correctly register WM8750

Marek Vašut (1):
      ARM: 6146/1: sa1111: Prevent deadlock in resume path

Martin Schwidefsky (1):
      [S390] Update default configuration.

Maxim Levitsky (4):
      mtd/r852: register IRQ as last step
      mtd/r852: Fixes in case of DMA timeout
      mtd/r852: update card detect early.
      mtd: Fix NAND submenu

Miao Xie (2):
      Btrfs: fix loop device on top of btrfs
      Btrfs: fix remap_file_pages error

Michal Marek (2):
      kbuild: Generate modules.builtin in make modules
      kbuild: Create output directory in Makefile.modbuiltin

Michal Simek (1):
      microblaze: Define ARCH_SLAB_MINALIGN to fix slab crash

Miklos Szeredi (2):
      pipe: fix pipe buffer resizing
      pipe: fix check in "set size" fcntl

Nick Piggin (2):
      block: bd_start_claiming fix module refcount
      block: bd_start_claiming cleanup

Nicolas Pitre (1):
      ARM: 6165/1: trap overflows on highmem pages from kmap_atomic
when debugging

Oleg Nesterov (1):
      tracing: Fix null pointer deref with SEND_SIG_FORCED

Ondrej Zary (1):
      PM / x86: Save/restore MISC_ENABLE register

Peter Zijlstra (1):
      perf: Fix signed comparison in perf_adjust_period()

Rafał Miłecki (3):
      drm/radeon/kms/r600+: use voltage from requested clock mode (v3)
      drm/radeon/kms: add trivial debugging for voltage
      drm/radeon/kms/pm: resurrect printing power states

Reinette Chatre (1):
      iwl3945: enable stuck queue detection on 3945
Richard Cochran (1):
      phylib: Add support for the LXT973 phy.

Russell King (1):
      ARM: VFP: Fix vfp_put_double() for d16-d31

Sage Weil (6):
      ceph: fix f_namelen reported by statfs
      ceph: fix lease revocation when seq doesn't match
      ceph: fix misleading/incorrect debug message
      ceph: release cap on import if we don't have the inode
      ceph: try to send partial cap release on cap message on missing inode
      Btrfs: avoid BUG when dropping root and reference in same transaction

Shi Weihua (2):
      Btrfs: should add a permission check for setfacl
      Btrfs: prohibit a operation of changing acl's mask when noacl
mount option used

Stefan Richter (1):
      firewire: core: check for 1394a compliant IRM, fix
inaccessibility of Sony camcorder

Tejun Heo (3):
      sata_via: explain the magic fix
      ahci: add pci quirk for JMB362
      ahci: redo stopping DMA engines on empty ports

Tim Gardner (1):
      net: Print num_rx_queues imbalance warning only when there are
allocated queues

Timo Teräs (2):
      r8169: fix random mdio_write failures
      r8169: fix mdio_read and update mdio_write according to hw specs

Tobias Doerffel (1):
      ath5k: depend on CONFIG_PM_SLEEP for suspend/resume functions

Tobias Klauser (1):
      [ARM] pxa/palmtc: storage class should be before const qualifier

Wan ZongShun (1):
      ALSA: sound/spi: patch for the unuseful variable removal

Wey-Yi Guy (1):
      iwlwifi: add name to Maintainers list

Yan, Zheng (2):
      Btrfs: Fix null dereference in relocation.c
      Btrfs: Fix BUG_ON for fs converted from extN

Yegor Yefremov (1):
      ALSA: atmel: set "channel A event" output to debug

Yehuda Sadeh (1):
      ceph: fix memory leak in statfs

Yinghai Lu (1):
      PCI: clear bridge resource range if BIOS assigned bad one

Zhu Yi (1):
      wireless: remove my name from the maintainer list
