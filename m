Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab0ELWTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 18:19:22 -0400
Received: from kroah.org ([198.145.64.141]:37253 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756492Ab0ELWTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 18:19:11 -0400
Date: Wed, 12 May 2010 15:18:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.33.4
Message-ID: <20100512221848.GC2981@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.33.4 kernel.

All users of the 2.6.33 kernel series should upgrade.

Many thanks to maximilian attems for all of his work in submitting
patches for this release, it is much appreciated.

The updated 2.6.33.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.33.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.33.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                        |    2 
 arch/arm/mach-pxa/include/mach/colibri.h        |    1 
 arch/mips/include/asm/mach-sibyte/war.h         |    6 -
 arch/mips/sibyte/sb1250/setup.c                 |   15 ++
 arch/powerpc/kernel/head_64.S                   |   11 +
 arch/powerpc/mm/fsl_booke_mmu.c                 |    5 
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |   42 ++-----
 arch/powerpc/platforms/pseries/offline_states.h |    1 
 arch/sparc/include/asm/irqflags_64.h            |   23 +++
 arch/sparc/include/asm/thread_info_64.h         |    2 
 arch/sparc/kernel/pci_common.c                  |   11 +
 arch/sparc/kernel/rtrap_64.S                    |   12 +-
 arch/sparc/kernel/traps_64.c                    |   26 ----
 arch/sparc/kernel/unaligned_64.c                |    6 -
 arch/x86/Kconfig                                |    4 
 arch/x86/kernel/apic/io_apic.c                  |    3 
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c       |    3 
 arch/x86/kernel/cpu/intel.c                     |   21 +++
 arch/x86/kernel/k8.c                            |   14 ++
 arch/x86/kernel/pci-gart_64.c                   |    2 
 arch/x86/kernel/process_64.c                    |    4 
 block/blk-timeout.c                             |   12 --
 crypto/async_tx/async_raid6_recov.c             |   21 ++-
 drivers/Makefile                                |    2 
 drivers/acpi/power_meter.c                      |    2 
 drivers/acpi/sleep.c                            |  144 ++++++++++++++++++++++++
 drivers/ata/libata-eh.c                         |    5 
 drivers/base/memory.c                           |    2 
 drivers/char/agp/Kconfig                        |    2 
 drivers/cpuidle/governors/menu.c                |    9 -
 drivers/edac/edac_mce_amd.c                     |    5 
 drivers/gpu/drm/i915/i915_debugfs.c             |    2 
 drivers/gpu/drm/i915/i915_dma.c                 |   16 +-
 drivers/gpu/drm/i915/i915_drv.h                 |   26 ++++
 drivers/gpu/drm/i915/i915_gem.c                 |    8 +
 drivers/gpu/drm/i915/i915_gem_tiling.c          |   24 +---
 drivers/gpu/drm/i915/i915_irq.c                 |   18 +--
 drivers/gpu/drm/i915/i915_reg.h                 |    2 
 drivers/gpu/drm/i915/intel_bios.c               |    3 
 drivers/gpu/drm/i915/intel_crt.c                |   14 +-
 drivers/gpu/drm/i915/intel_display.c            |   56 ++++-----
 drivers/gpu/drm/i915/intel_lvds.c               |    2 
 drivers/gpu/drm/i915/intel_overlay.c            |    2 
 drivers/i2c/i2c-core.c                          |   21 ++-
 drivers/md/md.c                                 |   10 +
 drivers/md/raid5.c                              |   54 ++++-----
 drivers/media/dvb/ttpci/budget.c                |    3 
 drivers/net/bnx2.c                              |    6 -
 drivers/net/r8169.c                             |   13 +-
 drivers/net/sfc/efx.c                           |    4 
 drivers/net/sfc/falcon.c                        |    4 
 drivers/net/sfc/falcon_boards.c                 |   13 --
 drivers/net/sfc/nic.h                           |    2 
 drivers/net/sfc/siena.c                         |   13 +-
 drivers/net/tg3.c                               |    1 
 drivers/net/tun.c                               |    4 
 drivers/net/usb/cdc_ether.c                     |    1 
 drivers/net/usb/dm9601.c                        |    2 
 drivers/net/wan/hdlc_ppp.c                      |    6 +
 drivers/net/wireless/ath/ath9k/main.c           |    2 
 drivers/net/wireless/p54/p54pci.c               |    2 
 drivers/net/wireless/p54/p54usb.c               |    1 
 drivers/net/wireless/p54/txrx.c                 |    2 
 drivers/pci/pci.c                               |    6 -
 drivers/scsi/libiscsi.c                         |    2 
 drivers/scsi/libsas/sas_ata.c                   |    4 
 drivers/scsi/libsas/sas_scsi_host.c             |    4 
 drivers/scsi/scsi_debug.c                       |    3 
 drivers/scsi/scsi_error.c                       |   15 ++
 drivers/scsi/scsi_lib.c                         |   10 +
 drivers/scsi/sd.c                               |    1 
 drivers/serial/8250_pnp.c                       |    2 
 drivers/staging/hv/Hv.c                         |    2 
 drivers/staging/hv/RndisFilter.c                |    1 
 drivers/staging/hv/netvsc_drv.c                 |    3 
 drivers/staging/usbip/usbip_event.c             |    3 
 drivers/usb/core/driver.c                       |   32 +++++
 drivers/usb/core/generic.c                      |    2 
 drivers/usb/core/inode.c                        |    4 
 drivers/usb/core/message.c                      |    2 
 drivers/usb/host/ehci-hcd.c                     |    1 
 drivers/usb/host/ehci-mem.c                     |    2 
 drivers/usb/host/ehci-sched.c                   |   38 +++++-
 drivers/usb/host/ehci.h                         |    5 
 drivers/usb/host/ohci-hub.c                     |    2 
 drivers/usb/host/xhci-mem.c                     |   65 ++++++++++
 drivers/usb/host/xhci.h                         |    4 
 drivers/usb/serial/sierra.c                     |    1 
 drivers/w1/slaves/w1_therm.c                    |    5 
 fs/ext4/extents.c                               |    9 +
 fs/jfs/resize.c                                 |    6 -
 fs/nfs/client.c                                 |    2 
 fs/nfs/dir.c                                    |    2 
 fs/nfsd/nfs4xdr.c                               |    8 -
 fs/ocfs2/buffer_head_io.c                       |    2 
 fs/ocfs2/dlm/dlmfs.c                            |    2 
 fs/ocfs2/inode.c                                |    1 
 fs/ocfs2/refcounttree.c                         |    3 
 fs/proc/base.c                                  |    2 
 fs/reiserfs/dir.c                               |    2 
 fs/reiserfs/xattr.c                             |   19 ---
 fs/xfs/linux-2.6/xfs_super.c                    |    5 
 fs/xfs/linux-2.6/xfs_sync.c                     |  107 ++++++++++++++++-
 fs/xfs/linux-2.6/xfs_sync.h                     |    7 +
 fs/xfs/quota/xfs_qm_syscalls.c                  |    3 
 fs/xfs/xfs_ag.h                                 |    1 
 fs/xfs/xfs_mount.h                              |    1 
 include/linux/ata.h                             |    4 
 include/linux/poison.h                          |    9 +
 include/net/sctp/command.h                      |    1 
 include/net/sctp/sctp.h                         |    1 
 init/initramfs.c                                |    3 
 kernel/cred.c                                   |    2 
 kernel/perf_event.c                             |    2 
 lib/flex_array.c                                |    2 
 mm/hugetlb.c                                    |    5 
 mm/memcontrol.c                                 |    4 
 net/ieee802154/af_ieee802154.c                  |    3 
 net/ipv4/tcp.c                                  |    1 
 net/ipv4/udp.c                                  |    4 
 net/ipv6/tcp_ipv6.c                             |    2 
 net/ipv6/udp.c                                  |    4 
 net/mac80211/agg-tx.c                           |    1 
 net/sctp/associola.c                            |    6 -
 net/sctp/endpointola.c                          |    1 
 net/sctp/sm_make_chunk.c                        |   32 +----
 net/sctp/sm_sideeffect.c                        |   26 ++++
 net/sctp/sm_statefuns.c                         |    8 +
 net/sctp/socket.c                               |   14 ++
 net/tipc/bearer.c                               |   37 +-----
 net/tipc/bearer.h                               |    2 
 net/tipc/net.c                                  |   25 ----
 security/inode.c                                |    4 
 security/keys/request_key.c                     |    9 +
 sound/pci/hda/hda_intel.c                       |    1 
 sound/pci/hda/patch_conexant.c                  |    7 -
 sound/pci/hda/patch_realtek.c                   |    2 
 sound/pci/hda/patch_sigmatel.c                  |    6 +
 sound/pci/maestro3.c                            |    9 +
 139 files changed, 988 insertions(+), 405 deletions(-)


Al Viro (1):
      nfs d_revalidate() is too trigger-happy with d_drop()

Alan Stern (4):
      USB: EHCI: defer reclamation of siTDs
      USB: fix remote wakeup settings during system sleep
      USB: don't choose configs with no interfaces
      USB: OHCI: don't look at the root hub to get the number of ports

Alex Chiang (1):
      ACPI: DMI init_set_sci_en_on_resume for multiple Lenovo ThinkPads

Andre Detsch (1):
      tg3: Fix INTx fallback when MSI fails

Andrea Arcangeli (1):
      memcg: fix prepare migration

Arjan van de Ven (1):
      cpuidle: Fix incorrect optimization

Ben Hutchings (3):
      sfc: Wait at most 10ms for the MC to finish reading out MAC statistics
      sfc: Always close net device at the end of a disabling reset
      sfc: Change falcon_probe_board() to fail for unsupported boards

Bill Pemberton (1):
      jfs: fix diAllocExt error in resizing filesystem

Bjørn Mork (1):
      V4L/DVB: budget: Oops: "BUG: unable to handle kernel NULL pointer dereference"

Borislav Petkov (2):
      edac, mce: Fix wrong mask and macro usage
      x86, k8 nb: Fix boot crash: enable k8_northbridges unconditionally on AMD systems

Changli Gao (1):
      flex_array: fix the panic when calling flex_array_alloc() without __GFP_ZERO

Chuck Lever (1):
      NFS: rsize and wsize settings ignored on v4 mounts

Cyrill Gorcunov (1):
      Staging: hv: Fix up memory leak on HvCleanup

Dan Carpenter (4):
      USB: fix testing the wrong variable in fs_create_by_name()
      ocfs2: potential ERR_PTR dereference on error paths
      security: testing the wrong variable in create_by_name()
      power_meter: acpi_device_class "power_meter_resource" too long

Dan Williams (1):
      raid6: fix recovery performance regression

Daniel T Chen (7):
      ALSA: hda: Use LPIB quirk for DG965OT board version AAD63733-203
      ALSA: hda: Use STAC_DELL_M6_BOTH quirk for Dell Studio XPS 1645
      ALSA: hda: Use STAC_DELL_M6_BOTH quirk for Dell Studio 1558
      ALSA: hda: Use ALC880_F1734 quirk for Fujitsu Siemens AMILO Xi 1526
      ALSA: hda: Fix 0 dB for Packard Bell models using Conexant CX20549 (Venice)
      ALSA: hda: Use olpc-xo-1_5 quirk for Toshiba Satellite Pro T130-15F
      ALSA: hda: Use olpc-xo-1_5 quirk for Toshiba Satellite P500-PSPGSC-01800T

Daniel Vetter (1):
      drm/i915: fix tiling limits for i915 class hw v2

Darren Jenkins (1):
      drivers/net/wireless/p54/txrx.c Fix off by one error

Dave Chinner (1):
      xfs: add a shrinker to background inode reclaim

David Dillow (1):
      r8169: use correct barrier between cacheable and non-cacheable memory

David Howells (2):
      keys: the request_key() syscall should link an existing key to the dest keyring
      CRED: Fix a race in creds_are_invalid() in credentials debugging

David S. Miller (6):
      sparc64: Use correct pt_regs in decode_access_size() error paths.
      sparc64: Fix PREEMPT_ACTIVE value.
      sparc64: Fix hardirq tracing in trap return path.
      sparc64: Use kstack_valid() in die_if_kernel().
      sparc64: Adjust __raw_local_irq_save() to cooperate in NMIs.
      sparc64: Fix memory leak in pci_register_iommu_region().

Douglas Gilbert (2):
      skip sense logging for some ATA PASS-THROUGH cdbs
      scsi_debug: virtual_gb ignores sector_size

Eric Anholt (1):
      drm/i915: Add initial bits for VGA modesetting bringup on Sandybridge.

Eric Lescouet (1):
      staging: usbip: Fix deadlock

Francois Romieu (1):
      r8169: fix broken register writes

Gabriele A. Trombetti (1):
      md/raid6: Fix raid-6 read-error correction in degraded state

Greg Kroah-Hartman (1):
      Linux 2.6.33.4

H. Peter Anvin (2):
      x86-64: Clear a 64-bit FS/GS base on fork if selector is nonzero
      x86: Disable large pages on CPUs with Atom erratum AAE44

Haiyang Zhang (1):
      Staging: hv: Fix a bug affecting IPv6

Hannes Reinecke (1):
      Enable retries for SYNCRONIZE_CACHE commands to fix I/O error

Hans de Goede (3):
      p54pci: fix bugs in p54p_check_tx_ring
      ALSA: snd-meastro3: Add amp_gpio quirk for Compaq EVO N600C
      ALSA: snd-meastro3: Ignore spurious HV interrupts during suspend / resume

Herbert Xu (1):
      ipv6: Fix tcp_v6_send_response transport header setting.

Ian Dall (1):
      w1: w1 temp: fix negative termperature calculation

Jakob Viketoft (1):
      pxa/colibri: fix missing #include <mach/mfp.h> in colibri.h

James Bottomley (1):
      SCSI: Retry commands with UNIT_ATTENTION sense codes to fix ext3/ext4 I/O error

Jean Delvare (1):
      i2c: Fix probing of FSC hardware monitoring chips

Jeff Garzik (1):
      libata: ensure NCQ error result taskfile is fully initialized before returning it via qc->result_tf.

Jeff Mahoney (2):
      reiserfs: fix permissions on .reiserfs_priv
      reiserfs: fix corruption during shrinking of xattrs

Jerome Marchand (1):
      procfs: fix tid fdinfo

Joel Becker (2):
      ocfs2: Compute metaecc for superblocks during online resize.
      ocfs2_dlmfs: Fix math error when reading LVB.

Johannes Berg (1):
      mac80211: remove bogus TX agg state assignment

John W. Linville (1):
      ath9k: reorder ieee80211_free_hw behind ath9k_uninit_hw to avoid oops

Jorge Boncompte [DTI2] (1):
      udp: fix for unicast RX path optimization

Kamal Mostafa (1):
      ACPI: sleep: init_set_sci_en_on_resume for Dell Studio 155x

Krzysztof Halasa (1):
      WAN: flush tx_queue in hdlc_ppp to prevent panic on rmmod hw_driver.

Kunal Gangakhedkar (1):
      ALSA: hda - Add PCI quirk for HP dv6-1110ax.

Leonard Michlmayr (1):
      ext4: correctly calculate number of blocks for fiemap

Linus Torvalds (1):
      Revert "memory-hotplug: add 0x prefix to HEX block_size_bytes"

Mark Langsdorf (1):
      powernow-k8: Fix frequency reporting

Mark Lord (1):
      libata: Fix accesses at LBA28 boundary (old bug, but nasty) (v2)

Matthew Garrett (1):
      PCI: Ensure we re-enable devices on resume

Mel Gorman (1):
      hugetlb: fix infinite loop in get_futex_key() when backed by huge pages

Michael Chan (1):
      bnx2: Fix lost MSI-X problem on 5709 NICs.

Michael S. Tsirkin (1):
      tun: orphan an skb on tx

Mike Christie (1):
      SCSI: libiscsi: regression: fix header digest errors

Neil Brown (1):
      nfsd4: bug in read_buf

Neil Horman (1):
      tipc: Fix oops on send prior to entering networked mode (v3)

NeilBrown (3):
      md/raid5: allow for more than 2^31 chunks.
      md/raid5: fix previous patch.
      md: restore ability of spare drives to spin down.

Peter Korsgaard (1):
      dm9601: fix phy/eeprom write routine

Phillip Lougher (1):
      initramfs: handle unrecognised decompressor when unpacking

Ping Cheng (1):
      serial: 8250_pnp - add Fujitsu Wacom device

Prarit Bhargava (1):
      x86: Fix NULL pointer access in irq_force_complete_move() for Xen guests

Ralf Baechle (1):
      MIPS: Sibyte: Apply M3 workaround only on affected chip types and versions.

Richard Kennedy (1):
      block: ensure jiffies wrap is handled correctly in blk_rq_timed_out_timer

Roel Kluin (1):
      USB: don't read past config->interface[] if usb_control_msg() fails in usb_reset_configuration()

Sarah Sharp (2):
      USB: xhci: properly set the "Mult" field of the endpoint context.
      USB: xhci: properly set endpoint context fields for periodic eps.

Shimada Hirofumi (1):
      p54usb: Add usbid for Corega CG-WLUSB2GT.

Stefan Schmidt (1):
      ieee802154: Fix oops during ieee802154_sock_ioctl

Stephen Hemminger (1):
      Staging: hv: name network device ethX rather than sethX

Steven J. Magnani (1):
      net: Fix oops from tcp_collapse() when using splice()

Stijn Tintel (1):
      virtio: initialize earlier

Tao Ma (1):
      ocfs2: Update VFS inode's id info after reflink.

Tejun Heo (3):
      libata: fix locking around blk_abort_request()
      perf: Fix resource leak in failure path of perf_event_open()
      SCSI: fix locking around blk_abort_request()

Torgny Johansson (1):
      cdc_ether: fix autosuspend for mbm devices

Vaidyanathan Srinivasan (3):
      powerpc: Reset kernel stack on cpu online from cede state
      powerpc: Move checks in pseries_mach_cpu_die()
      powerpc: Reduce printk from pseries_mach_cpu_die()

Vlad Yasevich (3):
      sctp: fix potential reference of a freed pointer
      sctp: per_cpu variables should be in bh_disabled section
      sctp: Fix oops when sending queued ASCONF chunks

Wei Yongjun (2):
      sctp: avoid irq lock inversion while call sk->sk_data_ready()
      sctp: fix to calc the INIT/INIT-ACK chunk length correctly is set

William Lightning (1):
      USB: Add id for HP ev2210 a.k.a Sierra MC5725 miniPCI-e Cell Modem.

Wufei (1):
      kgdb: don't needlessly skip PAGE_USER test for Fsl booke

françois romieu (1):
      r8169: more broken register writes workaround

