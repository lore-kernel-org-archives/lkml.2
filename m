Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab2K2OFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 09:05:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35690 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab2K2OE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 09:04:59 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: =?UTF-8?q?=5B3=2E5=2Ey=2Ez=20extended=20stable=5D=20Linux=203=2E5=2E7=2E1?=
Date: Thu, 29 Nov 2012 12:04:51 -0200
Message-Id: <1354197892-21593-1-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 3.5.7.1 tree of stable patches.

This tree picks up the latest 3.5 stable release upstream, and add patches
on top that were later marked for stable but can't be added to 3.5, as
it is not anymore an stable series maintained upstream.

The tree is maintained by the Ubuntu Kernel Team, with the intention
to continue to provide support for the 3.5 series. Anyone is welcomed
on using it or contributing to this effort.

For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

The updated 3.5.y tree can be found at: 

  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.5.y

The diffstat and shortlog with changes since previous v3.5.7 release are
shown below.

-Herton

-- 
 .../devicetree/bindings/arm/atmel-at91.txt         |    2 +-
 .../bindings/pinctrl/nvidia,tegra20-pinmux.txt     |    2 +-
 .../bindings/pinctrl/nvidia,tegra30-pinmux.txt     |    2 +-
 Documentation/hwmon/coretemp                       |    1 +
 Makefile                                           |    2 +-
 arch/arm/include/asm/hwcap.h                       |    3 +-
 arch/arm/include/asm/vfpmacros.h                   |   12 +-
 arch/arm/kernel/smp.c                              |   14 +-
 arch/arm/mach-at91/at91rm9200_devices.c            |    2 +-
 arch/arm/mach-at91/at91sam9260_devices.c           |    2 +-
 arch/arm/mach-at91/at91sam9261_devices.c           |    2 +-
 arch/arm/mach-at91/at91sam9263_devices.c           |    2 +-
 arch/arm/mach-at91/at91sam9rl_devices.c            |    2 +-
 arch/arm/mach-at91/setup.c                         |    2 +-
 arch/arm/plat-omap/counter_32k.c                   |   21 +-
 arch/arm/vfp/vfpmodule.c                           |    9 +-
 arch/mips/ath79/clock.c                            |  109 ++-
 arch/mips/include/asm/mach-ath79/ar71xx_regs.h     |   23 +
 arch/mips/kernel/kgdb.c                            |    9 +
 arch/powerpc/platforms/pseries/eeh_driver.c        |   95 +-
 arch/s390/boot/compressed/vmlinux.lds.S            |    2 +-
 arch/s390/kernel/vmlinux.lds.S                     |    2 +-
 arch/tile/Makefile                                 |    4 +
 arch/x86/include/asm/efi.h                         |    1 +
 arch/x86/kernel/e820.c                             |    3 +
 arch/x86/kernel/entry_32.S                         |    8 +-
 arch/x86/kernel/entry_64.S                         |    2 +-
 arch/x86/kernel/setup.c                            |   30 +-
 arch/x86/mm/init.c                                 |   58 +-
 arch/x86/mm/init_64.c                              |    7 +-
 arch/x86/oprofile/nmi_int.c                        |    2 +-
 arch/x86/platform/efi/efi.c                        |   43 +-
 arch/x86/xen/enlighten.c                           |   18 +-
 block/blk-core.c                                   |   11 +-
 block/blk-sysfs.c                                  |    6 +
 drivers/acpi/ec.c                                  |   30 +-
 drivers/bcma/main.c                                |    5 +-
 drivers/cpufreq/powernow-k8.c                      |    9 +-
 drivers/dma/dmaengine.c                            |    2 +-
 drivers/dma/imx-dma.c                              |    4 +-
 drivers/dma/sirf-dma.c                             |    4 +-
 drivers/edac/amd64_edac.c                          |   11 +-
 drivers/extcon/extcon_class.c                      |    7 +
 drivers/firewire/core-cdev.c                       |    4 +-
 drivers/gpu/drm/i915/i915_gem.c                    |    1 -
 drivers/gpu/drm/i915/i915_reg.h                    |    2 +-
 drivers/gpu/drm/i915/intel_display.c               |    4 +-
 drivers/gpu/drm/i915/intel_pm.c                    |    4 +-
 drivers/gpu/drm/radeon/evergreen_cs.c              |    1 +
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c    |    6 +-
 drivers/hv/channel.c                               |   24 +-
 drivers/hwmon/coretemp.c                           |    7 +-
 drivers/iommu/tegra-smmu.c                         |    2 +-
 drivers/md/raid10.c                                |    2 +-
 drivers/mfd/88pm860x-core.c                        |   89 +-
 drivers/mmc/host/sdhci-s3c.c                       |    2 +-
 drivers/mtd/nand/nand_base.c                       |    8 +-
 drivers/net/ethernet/intel/e1000e/hw.h             |    2 +
 drivers/net/ethernet/intel/e1000e/netdev.c         |    2 +
 drivers/net/usb/cdc_ether.c                        |   41 +-
 drivers/net/usb/qmi_wwan.c                         |   14 +
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |  164 ++--
 drivers/net/wireless/ath/ath9k/beacon.c            |    2 +-
 drivers/net/wireless/ath/ath9k/main.c              |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |   53 +-
 drivers/net/wireless/b43/main.c                    |    4 +
 drivers/net/wireless/ipw2x00/ipw2200.c             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-devices.c     |   39 +-
 drivers/pcmcia/pxa2xx_sharpsl.c                    |    2 +-
 drivers/pinctrl/core.c                             |    4 +-
 drivers/pinctrl/pinconf.c                          |    4 -
 drivers/pinctrl/pinctrl-tegra.c                    |    2 +-
 drivers/pinctrl/pinctrl-tegra30.c                  |   24 +-
 drivers/rtc/rtc-imxdi.c                            |    2 +
 drivers/scsi/qla2xxx/qla_target.c                  |    2 +-
 drivers/scsi/scsi_debug.c                          |    2 +-
 drivers/scsi/storvsc_drv.c                         |    5 +
 drivers/staging/android/binder.c                   |   30 +-
 drivers/staging/comedi/drivers/amplc_pc236.c       |    2 +-
 drivers/target/iscsi/iscsi_target.c                |    2 +-
 drivers/target/iscsi/iscsi_target_core.h           |    4 +-
 drivers/target/iscsi/iscsi_target_tpg.c            |   12 +
 drivers/target/target_core_cdb.c                   |   48 +-
 drivers/target/target_core_configfs.c              |    8 +-
 drivers/target/target_core_file.c                  |   41 +-
 drivers/target/target_core_file.h                  |    1 +
 drivers/tty/vt/vt.c                                |   13 +
 drivers/usb/class/cdc-acm.c                        |   22 +-
 drivers/usb/core/driver.c                          |    4 +
 drivers/usb/core/hub.c                             |   40 +-
 drivers/usb/dwc3/gadget.c                          |    1 +
 drivers/usb/gadget/at91_udc.c                      |    2 +-
 drivers/usb/host/pci-quirks.c                      |    9 +-
 drivers/usb/host/xhci-ring.c                       |   11 +
 drivers/usb/host/xhci.c                            |    7 +-
 drivers/usb/musb/am35x.c                           |    6 +
 drivers/usb/serial/mct_u232.c                      |   14 +-
 drivers/usb/serial/metro-usb.c                     |   15 +-
 drivers/usb/serial/mos7840.c                       |   30 +-
 drivers/usb/serial/opticon.c                       |   11 +-
 drivers/usb/serial/option.c                        |   84 +-
 drivers/usb/serial/quatech2.c                      |    8 +
 drivers/usb/serial/sierra.c                        |   26 +-
 drivers/usb/serial/whiteheat.c                     |    1 +
 drivers/usb/storage/unusual_devs.h                 |    6 +
 drivers/vhost/net.c                                |    3 +-
 drivers/video/udlfb.c                              |    2 +-
 drivers/video/via/via_clock.c                      |   19 +
 fs/autofs4/root.c                                  |    6 +-
 fs/ceph/addr.c                                     |   11 +-
 fs/ceph/debugfs.c                                  |    1 +
 fs/ceph/export.c                                   |   20 +-
 fs/ceph/mds_client.c                               |   13 +-
 fs/compat_ioctl.c                                  |    2 +
 fs/ecryptfs/ecryptfs_kernel.h                      |    2 +
 fs/ecryptfs/file.c                                 |  100 +--
 fs/ecryptfs/inode.c                                |   65 +-
 fs/ecryptfs/main.c                                 |   24 +-
 fs/ecryptfs/mmap.c                                 |   39 +-
 fs/exec.c                                          |    3 +-
 fs/ext4/balloc.c                                   |    8 +-
 fs/ext4/bitmap.c                                   |    6 +-
 fs/ext4/ext4.h                                     |   11 +-
 fs/ext4/ext4_jbd2.c                                |    6 +-
 fs/ext4/extents.c                                  |   57 +-
 fs/ext4/ialloc.c                                   |    4 +-
 fs/ext4/mballoc.c                                  |   14 +-
 fs/ext4/resize.c                                   |    5 +-
 fs/ext4/super.c                                    |    7 +-
 fs/gfs2/export.c                                   |    4 +
 fs/isofs/export.c                                  |    2 +-
 fs/jbd/commit.c                                    |   45 +-
 fs/jbd/transaction.c                               |   64 +-
 fs/lockd/clntxdr.c                                 |    2 +-
 fs/lockd/mon.c                                     |    4 +-
 fs/lockd/svcproc.c                                 |    3 +-
 fs/nfs/blocklayout/blocklayout.c                   |  275 +++++-
 fs/nfs/blocklayout/blocklayout.h                   |    1 +
 fs/nfsd/nfs4idmap.c                                |    2 +-
 fs/nfsd/nfs4state.c                                |   19 +-
 fs/proc/stat.c                                     |   14 +-
 fs/reiserfs/inode.c                                |    6 +-
 fs/sysfs/dir.c                                     |   16 +-
 fs/udf/super.c                                     |    5 +-
 fs/xfs/xfs_export.c                                |    3 +
 include/drm/drm_pciids.h                           |    3 +
 include/linux/ceph/libceph.h                       |    2 +-
 include/linux/ceph/messenger.h                     |   60 +-
 include/linux/ceph/mon_client.h                    |    2 +-
 include/linux/ceph/msgpool.h                       |    3 +-
 include/linux/ceph/osd_client.h                    |    2 +-
 include/linux/ceph/osdmap.h                        |    6 +-
 include/linux/efi.h                                |    5 +
 include/linux/memblock.h                           |    1 +
 include/linux/mtd/nand.h                           |    3 -
 include/net/cfg80211.h                             |    1 +
 include/net/netfilter/nf_conntrack_ecache.h        |    1 +
 init/main.c                                        |    3 +
 kernel/cgroup.c                                    |   41 +-
 kernel/debug/kdb/kdb_io.c                          |   33 +-
 kernel/module.c                                    |    4 +
 kernel/sched/stop_task.c                           |   22 +-
 kernel/sys.c                                       |   12 +-
 kernel/time/tick-sched.c                           |    1 -
 kernel/time/timekeeping.c                          |    2 +-
 kernel/timer.c                                     |   10 +-
 kernel/trace/ring_buffer.c                         |    4 +
 lib/genalloc.c                                     |    2 +-
 mm/memblock.c                                      |   24 +
 mm/rmap.c                                          |   20 +-
 mm/shmem.c                                         |    6 +-
 net/bluetooth/smp.c                                |    6 +-
 net/ceph/ceph_common.c                             |   21 +-
 net/ceph/crypto.c                                  |    1 +
 net/ceph/crypto.h                                  |    3 +-
 net/ceph/debugfs.c                                 |    4 +
 net/ceph/messenger.c                               |  945 ++++++++++++--------
 net/ceph/mon_client.c                              |  127 ++-
 net/ceph/msgpool.c                                 |    7 +-
 net/ceph/osd_client.c                              |  100 ++-
 net/ceph/osdmap.c                                  |   38 +-
 net/core/pktgen.c                                  |    2 +-
 net/core/skbuff.c                                  |    6 +-
 net/ipv4/netfilter/nf_nat_sip.c                    |   10 +-
 net/mac80211/iface.c                               |    2 +-
 net/mac80211/mlme.c                                |    5 +-
 net/mac80211/sta_info.c                            |    4 +-
 net/mac80211/status.c                              |    4 +-
 net/mac80211/tx.c                                  |   22 +-
 net/mac80211/util.c                                |    4 +-
 net/mac80211/wpa.c                                 |    3 +-
 net/netfilter/nf_conntrack_core.c                  |   16 +-
 net/netfilter/nf_conntrack_expect.c                |   29 +-
 net/netfilter/nfnetlink_log.c                      |    2 +-
 net/netfilter/xt_limit.c                           |    8 +-
 net/sunrpc/cache.c                                 |    4 +-
 net/sunrpc/xprtsock.c                              |   62 +-
 net/wireless/mlme.c                                |   12 +-
 scripts/package/buildtar                           |    2 +-
 sound/pci/hda/hda_codec.c                          |   10 +-
 sound/pci/hda/hda_intel.c                          |   31 +-
 sound/pci/hda/patch_cirrus.c                       |    6 +-
 sound/pci/hda/patch_realtek.c                      |   39 +-
 sound/pci/hda/patch_via.c                          |    4 +
 sound/soc/codecs/wm2200.c                          |    3 +-
 sound/soc/sh/fsi.c                                 |   15 +-
 usr/gen_init_cpio.c                                |   43 +-
 207 files changed, 2832 insertions(+), 1505 deletions(-)

Alex Deucher (2):
      drm/radeon: add some new SI PCI ids
      drm/radeon: add error output if VM CS fails on cayman

Alex Elder (38):
      libceph: eliminate connection state "DEAD"
      libceph: kill bad_proto ceph connection op
      libceph: rename socket callbacks
      libceph: rename kvec_reset and kvec_add functions
      libceph: embed ceph messenger structure in ceph_client
      libceph: start separating connection flags from state
      libceph: start tracking connection socket state
      libceph: provide osd number when creating osd
      libceph: set CLOSED state bit in con_init
      libceph: embed ceph connection structure in mon_client
      libceph: init monitor connection when opening
      libceph: fully initialize connection in con_init()
      libceph: tweak ceph_alloc_msg()
      libceph: have messages point to their connection
      libceph: have messages take a connection reference
      libceph: make ceph_con_revoke() a msg operation
      libceph: make ceph_con_revoke_message() a msg op
      libceph: encapsulate out message data setup
      libceph: encapsulate advancing msg page
      libceph: don't mark footer complete before it is
      libceph: move init_bio_*() functions up
      libceph: move init of bio_iter
      libceph: don't use bio_iter as a flag
      libceph: SOCK_CLOSED is a flag, not a state
      libceph: don't change socket state on sock event
      libceph: just set SOCK_CLOSED when state changes
      libceph: don't touch con state in con_close_socket()
      libceph: clear CONNECTING in ceph_con_close()
      libceph: clear NEGOTIATING when done
      libceph: define and use an explicit CONNECTED state
      libceph: separate banner and connect writes
      libceph: distinguish two phases of connect sequence
      libceph: small changes to messenger.c
      libceph: add some fine ASCII art
      libceph: only kunmap kmapped pages
      rbd: reset BACKOFF if unable to re-queue
      ceph: avoid 32-bit page index overflow
      libceph: drop declaration of ceph_con_get()

Alexander Holler (1):
      video/udlfb: fix line counting in fb_write

Alexis R. Cortes (1):
      usb: host: xhci: New system added for Compliance Mode Patch on SN65LVPE502CP

Amerigo Wang (1):
      pktgen: fix crash when generating IPv6 packets

Andreas Herrmann (1):
      cpufreq / powernow-k8: Remove usage of smp_processor_id() in preemptible code

Andrew Morton (1):
      amd64_edac:__amd64_set_scrub_rate(): avoid overindexing scrubrates[]

Anisse Astier (2):
      ehci: fix Lucid nohandoff pci quirk to be more generic with BIOS versions
      ehci: Add yet-another Lucid nohandoff pci quirk

Arnd Bergmann (1):
      pcmcia: sharpsl: don't discard sharpsl_pcmcia_ops

Arve Hjønnevåg (2):
      Staging: android: binder: Fix memory leak on thread/process exit
      Staging: android: binder: Allow using highmem for binder buffers

Barry Song (2):
      dmaengine: sirf: fix a typo in dma_prep_interleaved
      dmaengine: sirf: fix a typo in moving running dma_desc to active queue

Bjørn Mork (2):
      USB: option: blacklist net interface on ZTE devices
      USB: option: add more ZTE devices

Bo Shen (1):
      ARM: at91/i2c: change id to let i2c-gpio work

Brian Norris (1):
      mtd: nand: allow NAND_NO_SUBPAGE_WRITE to be set from driver

Bruce Allan (1):
      e1000e: add device IDs for i218

Chris Metcalf (1):
      arch/tile: avoid generating .eh_frame information in modules

Christoph Hellwig (1):
      iscsit: remove incorrect unlock in iscsit_build_sendtargets_resp

Colin Cross (1):
      ARM: OMAP: counter: add locking to read_persistent_clock

Daisuke Nishimura (1):
      cgroup: notify_on_release may not be triggered in some cases

Dan Carpenter (4):
      timekeeping: Cast raw_interval to u64 to avoid shift overflow
      md/raid10: use correct limit variable
      libceph: fix NULL dereference in reset_connection()
      oprofile, x86: Fix wrapping bug in op_x86_get_ctrl()

Dan Williams (1):
      qmi_wwan/cdc_ether: move Novatel 551 and E362 to qmi_wwan

Daniel Drake (1):
      viafb: don't touch clock state on OLPC XO-1.5

Dave Young (1):
      Revert "x86/mm: Fix the size calculation of mapping tables"

David Henningsson (2):
      ALSA: hda - do not detect jack on internal speakers for Realtek
      ALSA: hda - Always check array bounds in alc_get_line_out_pfx

David Vrabel (1):
      xen/x86: don't corrupt %eip when returning from a signal handler

David Zafman (1):
      ceph: fix dentry reference leak in encode_fh()

Dmitry Monakhov (1):
      ext4: race-condition protection for ext4_convert_unwritten_extents_endio

Dylan Reid (1):
      ALSA: hda - Fix hang caused by race during suspend.

Egbert Eich (1):
      drm/radeon: Don't destroy I2C Bus Rec in radeon_ext_tmds_enc_destroy().

Eric Dumazet (1):
      net: fix secpath kmemleak

Fabio Estevam (1):
      drivers/dma/dmaengine.c: lower the priority of 'failed to get' dma channel message

Fabio Porcedda (1):
      usb: gadget: at91_udc: fix dt support

Felipe Balbi (1):
      usb: dwc3: gadget: fix 'endpoint always busy' bug

Felix Fietkau (4):
      ath9k: use ieee80211_free_txskb
      mac80211: use ieee80211_free_txskb to fix possible skb leaks
      mac80211: use ieee80211_free_txskb in a few more places
      Revert "ath9k_hw: Updated AR9003 tx gain table for 5GHz"

Feng Tang (2):
      ACPI: EC: Make the GPE storm threshold a module parameter
      ACPI: EC: Add a quirk for CLEVO M720T/M730T laptop

Gabor Juhos (1):
      MIPS: ath79: Fix CPU/DDR frequency calculation for SRIF PLLs

Gavin Shan (1):
      powerpc/eeh: Lock module while handling EEH event

Geert Uytterhoeven (1):
      sysfs: sysfs_pathname/sysfs_add_one: Use strlcat() instead of strcat()

Guanjun He (1):
      libceph: prevent the race of incoming work during teardown

Guennadi Liakhovetski (1):
      ASoC: fsi: don't reschedule DMA from an atomic context

Guenter Roeck (1):
      hwmon: (coretemp) Add support for Atom CE4110/4150/4170

Haojian Zhuang (1):
      pinctrl: remove mutex lock in groups show

Heiko Carstens (1):
      s390: fix linker script for 31 bit builds

Herton Ronaldo Krzesinski (2):
      Revert "sched: Add missing call to calc_load_exit_idle()"
      Linux 3.5.7.1

Hildner, Christian (1):
      timers: Fix endless looping between cascade() and internal_add_timer()

Hiro Sugawara (1):
      iommu/tegra: smmu: Fix deadly typo

Hugh Dickins (1):
      tmpfs,ceph,gfs2,isofs,reiserfs,xfs: fix fh_len checking

Ian Abbott (1):
      staging: comedi: amplc_pc236: fix invalid register access during detach

Ian Kent (1):
      autofs4 - fix reset pending flag on mount fail

Ivan Shugov (1):
      ARM: at91: at91sam9g10: fix SOC type detection

J. Bruce Fields (2):
      nfsd4: fix nfs4 stateid leak
      nfsd4: don't pin clientids to pseudoflavors

Jacob Shin (2):
      x86: Exclude E820_RESERVED regions and memory holes above 4 GB from direct mapping.
      x86, mm: Find_early_table_space based on ranges that are actually being mapped

Jaehoon Chung (2):
      block: remove the duplicated setting for congestion_threshold
      mmc: sdhci-s3c: fix the wrong number of max bus clocks

Jan Beulich (1):
      x86-64: Fix page table accounting

Jan Engelhardt (1):
      netfilter: xt_limit: have r->cost != 0 case work

Jan Kara (2):
      jbd: Fix assertion failure in commit code due to lacking transaction credits
      mm: fix XFS oops due to dirty pages without buffers on s390

Jan Luebbe (1):
      drivers/rtc/rtc-imxdi.c: add missing spin lock initialization

Jani Nikula (1):
      drm/i915: use adjusted_mode instead of mode for checking the 6bpc force flag

Jason Wessel (2):
      mips,kgdb: fix recursive page fault with CONFIG_KPROBES
      kdb,vt_console: Fix missed data due to pager overruns

Jim Schutt (1):
      libceph: avoid truncation due to racing banners

Johan Hedberg (1):
      Bluetooth: SMP: Fix setting unknown auth_req bits

Johan Hovold (13):
      USB: metro-usb: fix io after disconnect
      USB: whiteheat: fix memory leak in error path
      USB: quatech2: fix memory leak in error path
      USB: quatech2: fix io after disconnect
      USB: opticon: fix DMA from stack
      USB: opticon: fix memory leak in error path
      USB: mct_u232: fix broken close
      USB: sierra: fix memory leak in attach error path
      USB: sierra: fix memory leak in probe error path
      USB: mos7840: fix urb leak at release
      USB: mos7840: fix port-device leak in error path
      USB: mos7840: remove NULL-urb submission
      USB: mos7840: remove invalid disconnect handling

Johannes Berg (1):
      iwlwifi: fix 6000 series channel switch command

Josh Triplett (1):
      efi: Defer freeing boot services memory until after ACPI init

Josh Wu (1):
      ARM: at91/tc: fix typo in the DT document

K. Y. Srinivasan (2):
      storvsc: Account for in-transit packets in the RESET path
      Drivers: hv: Cleanup error handling in vmbus_open()

Kees Cook (4):
      kernel/sys.c: fix stack memory content leak via UNAME26
      use clamp_t in UNAME26 fix
      gen_init_cpio: avoid stack overflow when expanding
      fs/compat_ioctl.c: VIDEO_SET_SPU_PALETTE missing error check

Kenneth Graunke (1):
      drm/i915: Set guardband clipping workaround bit in the right register.

Konrad Rzeszutek Wilk (2):
      xen/bootup: allow read_tscp call for Xen PV guests.
      xen/bootup: allow {read|write}_cr8 pvops call.

Larry Finger (1):
      b43: Fix oops on unload when firmware not found

Lennart Sorensen (1):
      USB: serial: Fix memory leak in sierra_release()

Lukas Czerner (2):
      scsi_debug: Fix off-by-one bug when unmapping region
      ext4: Avoid underflow in ext4_trim_fs()

Malahal Naineni (1):
      NFSD: pass null terminated buf to kstrtouint()

Mark Brown (3):
      mfd: 88pm860x: Move _IO resources out of ioport_ioresource
      ASoC: wm2200: Use rev A register patches on rev B
      ASoC: wm2200: Fix non-inverted OUT2 mute control

Matthew Garrett (1):
      module: taint kernel when lve module is loaded

Michael S. Tsirkin (1):
      vhost: fix mergeable bufs on BE hosts

Michael Shigorin (1):
      usb-storage: add unusual_devs entry for Casio EX-N1 digital camera

Michal Hocko (1):
      nohz: Fix idle ticks in cpu summary line of /proc/stat

Michal Marek (1):
      kbuild: Do not package /boot and /lib in make tar-pkg

Mike Galbraith (1):
      sched: Fix migration thread runtime bogosity

Ming Lei (1):
      USB: cdc-acm: fix pipe type of write endpoint

Nicholas Bellinger (5):
      iscsi-target: Correctly set 0xffffffff field within ISCSI_OP_REJECT PDU
      target/file: Re-enable optional fd_buffered_io=1 operation
      iscsi-target: Add explicit set of cache_dynamic_acls=1 for TPG demo-mode
      iscsi-target: Bump defaults for nopin_timeout + nopin_response_timeout values
      target: Re-add explict zeroing of INQUIRY bounce buffer memory

Nicolas Boullis (1):
      usb: acm: fix the computation of the number of data bits

Nikola Pajkovsky (1):
      udf: fix retun value on error path in udf_load_logicalvol

Octavian Purdila (1):
      usb hub: send clear_tt_buffer_complete events when canceling TT clear work

Oleg Nesterov (1):
      freezer: exec should clear PF_NOFREEZE along with PF_KTHREAD

Oliver Neukum (2):
      xhci: endianness xhci_calculate_intel_u2_timeout
      xhci: fix integer overflow

Olof Johansson (1):
      x86: efi: Turn off efi_enabled after setup on mixed fw/kernel

Pablo Neira Ayuso (3):
      netfilter: nf_nat_sip: fix incorrect handling of EBUSY for RTCP expectation
      netfilter: nf_ct_expect: fix possible access to uninitialized timer
      netfilter: nf_conntrack: fix racy timer handling with reliable events

Paolo Bonzini (2):
      target: support zero allocation length in INQUIRY
      target: fix truncation of mode data, support zero allocation length

Patrick McHardy (2):
      netfilter: nf_nat_sip: fix via header translation with multiple parameters
      netfilter: nfnetlink_log: fix NLA_PUT macro removal bug

Paul Walmsley (1):
      ARM: 7566/1: vfp: fix save and restore when running on pre-VFPv3 and CONFIG_VFPv3 set

Peng Tao (3):
      pnfsblock: fix partial page buffer wirte
      pnfsblock: fix non-aligned DIO read
      pnfsblock: fix non-aligned DIO write

Peter Huewe (2):
      extcon: Unregister compat class at module unload to fix oops
      extcon: unregister compat link on cleanup

Peter Senna Tschudin (1):
      target: fix return code in target_core_init_configfs error path

Piotr Haber (1):
      bcma: fix unregistration of cores

Pritesh Raithatha (3):
      dt: Document: correct tegra20/30 pinctrl slew-rate name
      pinctrl: tegra: set low power mode bank width to 2
      pinctrl: tegra: correct bank for pingroup and drv pingroup

Roland Dreier (1):
      qla2xxx: Fix endianness of task management response code

Russell King (1):
      ARM: vfp: fix saving d16-d31 vfp registers on v6+ kernels

Sage Weil (32):
      libceph: drop connection refcounting for mon_client
      libceph: transition socket state prior to actual connect
      libceph: use con get/put methods
      libceph: drop ceph_con_get/put helpers and nref member
      libceph: set peer name on con_open, not init
      libceph: initialize mon_client con only once
      libceph: allow sock transition from CONNECTING to CLOSED
      libceph: initialize msgpool message types
      libceph: report socket read/write error message
      libceph: fix mutex coverage for ceph_con_close
      libceph: resubmit linger ops when pg mapping changes
      libceph: (re)initialize bio_iter on start of message receive
      libceph: protect ceph_con_open() with mutex
      libceph: reset connection retry on successfully negotiation
      libceph: fix fault locking; close socket on lossy fault
      libceph: move msgr clear_standby under con mutex protection
      libceph: move ceph_con_send() closed check under the con mutex
      libceph: drop gratuitous socket close calls in con_work
      libceph: close socket directly from ceph_con_close()
      libceph: drop unnecessary CLOSED check in socket state change callback
      libceph: replace connection state bits with states
      libceph: clean up con flags
      libceph: clear all flags on con_close
      libceph: fix handling of immediate socket connect failure
      libceph: revoke mon_client messages on session restart
      libceph: verify state after retaking con lock after dispatch
      libceph: avoid dropping con mutex before fault
      libceph: change ceph_con_in_msg_alloc convention to be less weird
      libceph: recheck con state after allocating incoming message
      libceph: delay debugfs initialization until we learn global_id
      libceph: avoid NULL kref_put when osd reset races with alloc_msg
      libceph: check for invalid mapping

Sarah Sharp (4):
      USB: Enable LPM after a failed probe.
      usb: Don't enable LPM if the exit latency is zero.
      usb: Send Set SEL before enabling parent U1/U2 timeout.
      xhci: Fix potential NULL ptr deref in command cancellation.

Sasha Levin (1):
      SUNRPC: Prevent kernel stack corruption on long values of flush

Stanislav Kinsbursky (1):
      lockd: use rpc client's cl_nodename for id encoding

Stanislav Yakovlev (1):
      net/wireless: ipw2200: Fix panic occurring in ipw_handle_promiscuous_tx()

Stanislaw Gruszka (2):
      cfg80211/mac80211: avoid state mishmash on deauth
      mac80211: check if key has TKIP type before updating IV

Stefan Richter (1):
      firewire: cdev: fix user memory corruption (i386 userland on amd64 kernel)

Stefano Babic (1):
      usb: musb: am35xx: drop spurious unplugging a device

Stefán Freyr (1):
      ALSA: hda - add dock support for Thinkpad T430

Sylvain Munaut (1):
      libceph: fix crypto key null deref, memory leak

Takashi Iwai (4):
      ALSA: hda - Add missing hda_gen_spec to struct via_spec
      ALSA: hda - Fix memory leaks at error path in patch_cirrus.c
      ALSA: hda - Fix registration race of VGA switcheroo
      ALSA: hda - Fix silent headphone output from Toshiba P200

Tao Ma (2):
      ext4: remove erroneous ext4_superblock_csum_set() in update_backups()
      ext4: Checksum the block bitmap properly with bigalloc enabled

Tejun Heo (4):
      block: lift the initial queue bypass mode on blk_register_queue() instead of blk_init_allocated_queue()
      block: fix request_queue->flags initialization
      Revert "cgroup: Drop task_lock(parent) on cgroup_fork()"
      Revert "cgroup: Remove task_lock() from cgroup_post_fork()"

Thadeu Lima de Souza Cascardo (1):
      genalloc: stop crashing the system when destroying a pool

Theodore Ts'o (1):
      ext4: fix metadata checksum calculation for the superblock

Tim Sally (1):
      eCryptfs: check for eCryptfs cipher support at mount

Trond Myklebust (6):
      SUNRPC: Ensure that the TCP socket is closed when in CLOSE_WAIT
      NLM: nlm_lookup_file() may return NLMv4-specific error codes
      SUNRPC: Clear the connect flag when socket state is TCP_CLOSE_WAIT
      Revert "SUNRPC: Ensure we close the socket on EPIPE errors too..."
      SUNRPC: Prevent races in xs_abort_connection()
      SUNRPC: Get rid of the xs_error_report socket callback

Tyler Hicks (6):
      eCryptfs: Copy up POSIX ACL and read-only flags from lower mount
      eCryptfs: Revert to a writethrough cache model
      eCryptfs: Initialize empty lower files when opening them
      eCryptfs: Unlink lower inode when ecryptfs_create() fails
      eCryptfs: Write out all dirty pages just before releasing the lower file
      eCryptfs: Call lower ->flush() from ecryptfs_flush()

Vaibhav Nagarnaik (1):
      ring-buffer: Check for uninitialized cpu buffer before resizing

Wei Yongjun (2):
      pinctrl: fix missing unlock on error in pinctrl_groups_show()
      dmaengine: imx-dma: fix missing unlock on error in imxdma_xfer_desc()

Will Deacon (1):
      ARM: 7559/1: smp: switch away from the idmap before updating init_mm.mm_count

Willy Tarreau (1):
      drm/i915: remove useless BUG_ON which caused a regression in 3.5.

Xi Wang (3):
      libceph: fix overflow in __decode_pool_names()
      libceph: fix overflow in osdmap_decode()
      libceph: fix overflow in osdmap_apply_incremental()

Yan, Zheng (1):
      ceph: Fix oops when handling mdsmap that decreases max_mds

Yinghai Lu (3):
      x86, mm: Trim memory in memblock to be page aligned
      x86, mm: Use memblock memory loop instead of e820_RAM
      x86, mm: Undo incorrect revert in arch/x86/mm/init.c

