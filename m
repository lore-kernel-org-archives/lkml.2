Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab0ELWTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 18:19:14 -0400
Received: from kroah.org ([198.145.64.141]:37244 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637Ab0ELWTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 18:19:09 -0400
Date: Wed, 12 May 2010 15:18:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.13
Message-ID: <20100512221809.GA2981@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.13 kernel.

All users of the 2.6.32 kernel series should upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt       |    5 
 Makefile                                  |    2 
 arch/arm/mach-pxa/include/mach/colibri.h  |    1 
 arch/mips/include/asm/mach-sibyte/war.h   |    6 -
 arch/mips/sibyte/sb1250/setup.c           |   15 ++
 arch/parisc/kernel/pci.c                  |    7 -
 arch/powerpc/mm/fsl_booke_mmu.c           |    5 
 arch/x86/Kconfig                          |    9 +
 arch/x86/kernel/acpi/sleep.c              |    2 
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    3 
 arch/x86/kernel/cpu/intel.c               |   21 +++
 arch/x86/kernel/cpu/intel_cacheinfo.c     |   13 +-
 arch/x86/kernel/k8.c                      |   14 ++
 arch/x86/kernel/pci-gart_64.c             |    2 
 arch/x86/kernel/process_64.c              |    5 
 arch/x86/kvm/x86.c                        |   12 --
 block/blk-timeout.c                       |   12 --
 crypto/async_tx/async_raid6_recov.c       |   21 ++-
 drivers/Makefile                          |    2 
 drivers/acpi/power_meter.c                |    2 
 drivers/acpi/sleep.c                      |  173 +++++++++++++++++++++++++++---
 drivers/ata/libata-eh.c                   |    5 
 drivers/char/agp/Kconfig                  |    2 
 drivers/cpuidle/governors/menu.c          |    9 -
 drivers/edac/edac_mce_amd.c               |    5 
 drivers/gpu/drm/i915/i915_gem.c           |    6 +
 drivers/gpu/drm/i915/i915_gem_tiling.c    |   22 +--
 drivers/gpu/drm/i915/i915_reg.h           |    2 
 drivers/i2c/i2c-core.c                    |   26 +++-
 drivers/md/md.c                           |   10 +
 drivers/md/raid5.c                        |   54 ++++-----
 drivers/media/dvb/ttpci/budget.c          |    3 
 drivers/net/bnx2.c                        |    6 -
 drivers/net/r8169.c                       |   13 +-
 drivers/net/tg3.c                         |    1 
 drivers/net/usb/dm9601.c                  |    2 
 drivers/net/wireless/p54/p54pci.c         |   10 +
 drivers/net/wireless/p54/p54usb.c         |    1 
 drivers/net/wireless/p54/txrx.c           |    2 
 drivers/pci/pci.c                         |    6 -
 drivers/scsi/libiscsi.c                   |    2 
 drivers/scsi/libsas/sas_ata.c             |    4 
 drivers/scsi/libsas/sas_scsi_host.c       |    4 
 drivers/scsi/qla2xxx/qla_isr.c            |  120 +++++++++-----------
 drivers/scsi/scsi_debug.c                 |    3 
 drivers/scsi/scsi_error.c                 |   15 ++
 drivers/scsi/scsi_lib.c                   |   10 +
 drivers/scsi/sd.c                         |    1 
 drivers/serial/8250_pnp.c                 |    2 
 drivers/staging/hv/Hv.c                   |    2 
 drivers/staging/hv/RndisFilter.c          |    1 
 drivers/staging/hv/netvsc_drv.c           |    3 
 drivers/staging/usbip/usbip_event.c       |    3 
 drivers/usb/core/driver.c                 |   32 +++++
 drivers/usb/core/generic.c                |    2 
 drivers/usb/core/inode.c                  |    4 
 drivers/usb/host/ehci-hcd.c               |    1 
 drivers/usb/host/ehci-mem.c               |    2 
 drivers/usb/host/ehci-sched.c             |   38 +++++-
 drivers/usb/host/ehci.h                   |    5 
 drivers/usb/host/ohci-hub.c               |    2 
 drivers/usb/host/xhci-mem.c               |   65 +++++++++++
 drivers/usb/host/xhci.h                   |    4 
 drivers/usb/serial/sierra.c               |    1 
 drivers/w1/slaves/w1_therm.c              |    5 
 fs/ext4/extents.c                         |    9 +
 fs/jfs/resize.c                           |    6 -
 fs/nfs/client.c                           |    2 
 fs/nfs/dir.c                              |    2 
 fs/nfsd/nfs4xdr.c                         |    8 -
 fs/ocfs2/buffer_head_io.c                 |    2 
 fs/ocfs2/dlm/dlmfs.c                      |    2 
 fs/ocfs2/inode.c                          |    1 
 fs/ocfs2/refcounttree.c                   |    3 
 fs/proc/base.c                            |    2 
 fs/reiserfs/dir.c                         |    2 
 fs/reiserfs/xattr.c                       |   19 ---
 fs/xfs/linux-2.6/xfs_super.c              |    5 
 fs/xfs/linux-2.6/xfs_sync.c               |  107 +++++++++++++++++-
 fs/xfs/linux-2.6/xfs_sync.h               |    7 +
 fs/xfs/quota/xfs_qm_syscalls.c            |    3 
 fs/xfs/xfs_ag.h                           |    1 
 fs/xfs/xfs_mount.h                        |    1 
 include/linux/acpi.h                      |    1 
 include/linux/ata.h                       |    4 
 include/linux/poison.h                    |   25 +++-
 include/linux/syscalls.h                  |    6 -
 include/trace/ftrace.h                    |    3 
 init/initramfs.c                          |    3 
 kernel/cred.c                             |    2 
 kernel/perf_event.c                       |    2 
 kernel/trace/trace.h                      |    3 
 lib/flex_array.c                          |    2 
 mm/hugetlb.c                              |    5 
 mm/memcontrol.c                           |    4 
 net/dccp/probe.c                          |    3 
 net/mac80211/agg-tx.c                     |    1 
 security/inode.c                          |    4 
 security/keys/request_key.c               |    9 +
 sound/pci/hda/hda_intel.c                 |    1 
 sound/pci/hda/patch_conexant.c            |   10 +
 sound/pci/hda/patch_realtek.c             |    2 
 sound/pci/hda/patch_sigmatel.c            |    6 +
 sound/pci/maestro3.c                      |    9 +
 104 files changed, 843 insertions(+), 292 deletions(-)


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

Avi Kivity (1):
      core, x86: make LIST_POISON less deadly

Bill Pemberton (1):
      jfs: fix diAllocExt error in resizing filesystem

Bjørn Mork (1):
      V4L/DVB: budget: Oops: "BUG: unable to handle kernel NULL pointer dereference"

Borislav Petkov (2):
      edac, mce: Fix wrong mask and macro usage
      x86, k8 nb: Fix boot crash: enable k8_northbridges unconditionally on AMD systems

Carlos O'Donell (1):
      parisc: Set PCI CLS early in boot.

Changli Gao (1):
      flex_array: fix the panic when calling flex_array_alloc() without __GFP_ZERO

Christian Lamparter (1):
      p54pci: rx frame length check

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

Daniel T Chen (8):
      ALSA: hda: Use LPIB quirk for DG965OT board version AAD63733-203
      ALSA: hda: Use STAC_DELL_M6_BOTH quirk for Dell Studio XPS 1645
      ALSA: hda: Use STAC_DELL_M6_BOTH quirk for Dell Studio 1558
      ALSA: hda: Use ALC880_F1734 quirk for Fujitsu Siemens AMILO Xi 1526
      ALSA: hda: Fix max PCM level to 0 dB for Fujitsu-Siemens laptops using CX20549 (Venice)
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

Douglas Gilbert (2):
      skip sense logging for some ATA PASS-THROUGH cdbs
      scsi_debug: virtual_gb ignores sector_size

Eric Lescouet (1):
      staging: usbip: Fix deadlock

Francois Romieu (1):
      r8169: fix broken register writes

Gabriele A. Trombetti (1):
      md/raid6: Fix raid-6 read-error correction in degraded state

Greg Kroah-Hartman (1):
      Linux 2.6.32.13

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

Jeff Mahoney (3):
      reiserfs: fix permissions on .reiserfs_priv
      reiserfs: fix corruption during shrinking of xattrs
      tracing: Fix ftrace_event_call alignment for use with gcc 4.5

Jerome Marchand (1):
      procfs: fix tid fdinfo

Joel Becker (2):
      ocfs2: Compute metaecc for superblocks during online resize.
      ocfs2_dlmfs: Fix math error when reading LVB.

Johannes Berg (1):
      mac80211: remove bogus TX agg state assignment

Kamal Mostafa (1):
      ACPI: sleep: init_set_sci_en_on_resume for Dell Studio 155x

Kunal Gangakhedkar (1):
      ALSA: hda - Add PCI quirk for HP dv6-1110ax.

Lalit Chandivade (1):
      qla2xxx: Properly handle UNDERRUN completion statuses.

Leonard Michlmayr (1):
      ext4: correctly calculate number of blocks for fiemap

Marcelo Tosatti (1):
      KVM: remove unused load_segment_descriptor_to_kvm_desct

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

Mike Christie (1):
      SCSI: libiscsi: regression: fix header digest errors

Neil Brown (1):
      nfsd4: bug in read_buf

Neil Horman (1):
      dccp_probe: Fix module load dependencies between dccp and dccp_probe

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
      x86, AMD: Fix stale cpuid4_info shared_map data in shared_cpu_map cpumasks

Ralf Baechle (1):
      MIPS: Sibyte: Apply M3 workaround only on affected chip types and versions.

Richard Kennedy (1):
      block: ensure jiffies wrap is handled correctly in blk_rq_timed_out_timer

Sarah Sharp (2):
      USB: xhci: properly set the "Mult" field of the endpoint context.
      USB: xhci: properly set endpoint context fields for periodic eps.

Shimada Hirofumi (1):
      p54usb: Add usbid for Corega CG-WLUSB2GT.

Stephen Hemminger (1):
      Staging: hv: name network device ethX rather than sethX

Stijn Tintel (1):
      virtio: initialize earlier

Tao Ma (1):
      ocfs2: Update VFS inode's id info after reflink.

Tejun Heo (3):
      libata: fix locking around blk_abort_request()
      perf: Fix resource leak in failure path of perf_event_open()
      SCSI: fix locking around blk_abort_request()

William Lightning (1):
      USB: Add id for HP ev2210 a.k.a Sierra MC5725 miniPCI-e Cell Modem.

Wufei (1):
      kgdb: don't needlessly skip PAGE_USER test for Fsl booke

Zhang Rui (1):
      ACPI: introduce kernel parameter acpi_sleep=sci_force_enable

françois romieu (1):
      r8169: more broken register writes workaround

