Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622Ab1BRAUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 19:20:08 -0500
Received: from kroah.org ([198.145.64.141]:48719 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757010Ab1BRASu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 19:18:50 -0500
Date: Thu, 17 Feb 2011 16:18:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.37.1
Message-ID: <20110218001819.GE9342@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.37.1 kernel.

All users of the 2.6.37 kernel series must upgrade.

The updated 2.6.37.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.37.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.37.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt            |    1 
 Makefile                                       |    2 
 arch/arm/kernel/head.S                         |   41 +++---
 arch/arm/mach-s5pv310/cpu.c                    |    2 
 arch/arm/mm/init.c                             |    6 
 arch/arm/oprofile/common.c                     |   12 -
 arch/avr32/include/asm/syscalls.h              |    9 -
 arch/parisc/kernel/firmware.c                  |   13 --
 arch/powerpc/boot/dts/p1022ds.dts              |    4 
 arch/powerpc/kernel/cpu_setup_6xx.S            |   40 +++---
 arch/powerpc/mm/numa.c                         |    2 
 arch/powerpc/platforms/pseries/lpar.c          |   37 +++++
 arch/powerpc/sysdev/fsl_rio.c                  |    1 
 arch/sh/include/asm/io.h                       |   10 +
 arch/sh/include/asm/pgtable_32.h               |    7 -
 arch/x86/Kconfig                               |    1 
 arch/x86/include/asm/mmu_context.h             |    5 
 arch/x86/include/asm/uv/uv_bau.h               |    9 -
 arch/x86/kernel/cpu/mtrr/main.c                |   10 +
 arch/x86/kernel/irq.c                          |    3 
 arch/x86/kernel/process.c                      |   22 ++-
 arch/x86/platform/uv/tlb_uv.c                  |   22 ++-
 block/blk-core.c                               |   26 +++-
 block/blk-merge.c                              |    3 
 block/cfq-iosched.c                            |    4 
 block/genhd.c                                  |    1 
 drivers/ata/libata-scsi.c                      |   24 ++-
 drivers/ata/pata_mpc52xx.c                     |    2 
 drivers/base/power/runtime.c                   |    9 -
 drivers/block/nbd.c                            |    3 
 drivers/char/agp/intel-agp.c                   |   27 ++--
 drivers/char/ipmi/ipmi_si_intf.c               |   12 -
 drivers/char/tpm/tpm.c                         |   28 +++-
 drivers/char/tpm/tpm.h                         |    2 
 drivers/char/tpm/tpm_tis.c                     |   10 -
 drivers/char/virtio_console.c                  |   15 ++
 drivers/cpuidle/cpuidle.c                      |   82 ++++++-------
 drivers/firewire/core-card.c                   |   11 +
 drivers/firmware/dmi_scan.c                    |   11 +
 drivers/gpu/drm/Kconfig                        |    3 
 drivers/gpu/drm/drm_crtc_helper.c              |   17 +-
 drivers/gpu/drm/i915/i915_dma.c                |   10 +
 drivers/gpu/drm/i915/i915_drv.c                |   10 +
 drivers/gpu/drm/i915/i915_drv.h                |    1 
 drivers/gpu/drm/i915/i915_reg.h                |    9 -
 drivers/gpu/drm/i915/intel_crt.c               |   30 ++++
 drivers/gpu/drm/i915/intel_display.c           |    4 
 drivers/gpu/drm/i915/intel_dp.c                |   23 ++-
 drivers/gpu/drm/i915/intel_drv.h               |    3 
 drivers/gpu/drm/i915/intel_lvds.c              |   18 +-
 drivers/gpu/drm/i915/intel_panel.c             |   31 +++++
 drivers/gpu/drm/i915/intel_sdvo.c              |   33 +----
 drivers/gpu/drm/radeon/atombios_crtc.c         |   18 ++
 drivers/gpu/drm/radeon/atombios_dp.c           |    4 
 drivers/gpu/drm/radeon/evergreen.c             |    7 -
 drivers/gpu/drm/radeon/evergreen_blit_kms.c    |   39 +++++-
 drivers/gpu/drm/radeon/radeon_atombios.c       |   47 +++----
 drivers/gpu/drm/radeon/radeon_display.c        |  132 ++++++++++++++++++++-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c    |    6 
 drivers/gpu/drm/radeon/radeon_mode.h           |   23 ++-
 drivers/gpu/vga/vgaarb.c                       |    2 
 drivers/hwmon/applesmc.c                       |   48 ++-----
 drivers/hwmon/lm63.c                           |   59 +++++++--
 drivers/hwmon/via686a.c                        |   14 +-
 drivers/i2c/i2c-core.c                         |   14 ++
 drivers/idle/intel_idle.c                      |   43 ++++++
 drivers/infiniband/hw/cxgb4/cm.c               |    2 
 drivers/infiniband/hw/cxgb4/qp.c               |    6 
 drivers/input/input.c                          |   37 +----
 drivers/input/mouse/bcm5974.c                  |   40 ++++++
 drivers/input/serio/i8042-x86ia64io.h          |   21 +++
 drivers/input/serio/i8042.c                    |    6 
 drivers/md/dm-mpath.c                          |   12 -
 drivers/md/dm.c                                |    5 
 drivers/md/md.c                                |   27 +++-
 drivers/md/md.h                                |    3 
 drivers/media/IR/ir-keytable.c                 |   28 ++--
 drivers/media/dvb/frontends/ix2505v.c          |    2 
 drivers/media/radio/radio-aimslab.c            |   23 ---
 drivers/media/video/em28xx/em28xx-cards.c      |    4 
 drivers/mmc/host/bfin_sdh.c                    |    2 
 drivers/mtd/nand/pxa3xx_nand.c                 |    2 
 drivers/net/e1000/e1000_main.c                 |   10 -
 drivers/net/fec.c                              |    4 
 drivers/net/ixgbe/ixgbe_main.c                 |   11 +
 drivers/net/virtio_net.c                       |   27 ++--
 drivers/net/wireless/ath/ath9k/ar9002_calib.c  |   10 -
 drivers/net/wireless/ath/ath9k/ar9002_hw.c     |    3 
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   14 +-
 drivers/net/wireless/ath/ath9k/ath9k.h         |    4 
 drivers/net/wireless/ath/ath9k/hif_usb.c       |   40 +++++-
 drivers/net/wireless/ath/ath9k/hif_usb.h       |    1 
 drivers/net/wireless/ath/ath9k/hw.c            |    6 
 drivers/net/wireless/ath/ath9k/hw.h            |    1 
 drivers/net/wireless/ath/ath9k/main.c          |    8 -
 drivers/net/wireless/ath/ath9k/pci.c           |    4 
 drivers/net/wireless/ath/carl9170/rx.c         |    2 
 drivers/net/wireless/ath/key.c                 |    2 
 drivers/net/wireless/hostap/hostap_cs.c        |   15 --
 drivers/net/wireless/iwlwifi/iwl-agn.c         |   15 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h     |    6 
 drivers/net/wireless/p54/txrx.c                |    2 
 drivers/net/wireless/rt2x00/rt73usb.c          |    1 
 drivers/pci/pci-stub.c                         |    3 
 drivers/power/ds2760_battery.c                 |    2 
 drivers/power/jz4740-battery.c                 |    7 +
 drivers/rtc/rtc-cmos.c                         |   16 +-
 drivers/s390/cio/qdio.h                        |    6 
 drivers/s390/cio/qdio_main.c                   |   43 ++++--
 drivers/s390/crypto/ap_bus.c                   |    2 
 drivers/scsi/libsas/sas_scsi_host.c            |    1 
 drivers/scsi/mpt2sas/mpt2sas_base.c            |   24 +++
 drivers/scsi/mpt2sas/mpt2sas_scsih.c           |   64 ++++++++--
 drivers/scsi/sd.c                              |    9 +
 drivers/serial/68360serial.c                   |    1 
 drivers/serial/8250.c                          |    3 
 drivers/ssb/pcmcia.c                           |    2 
 drivers/staging/bcm/InterfaceInit.c            |    1 
 drivers/staging/bcm/InterfaceInit.h            |    1 
 drivers/staging/brcm80211/sys/wl_mac80211.c    |   45 +++----
 drivers/staging/comedi/drivers/jr3_pci.c       |    7 +
 drivers/staging/comedi/drivers/ni_labpc.c      |    3 
 drivers/staging/hv/blkvsc_drv.c                |    1 
 drivers/staging/hv/netvsc.c                    |    2 
 drivers/staging/hv/netvsc_drv.c                |    2 
 drivers/staging/iio/adc/ad7476_core.c          |    2 
 drivers/staging/iio/adc/ad799x_core.c          |    2 
 drivers/staging/rt2860/chips/rt3090.c          |    3 
 drivers/staging/rt2860/chips/rt30xx.c          |    4 
 drivers/staging/rt2860/rt_main_dev.c           |    2 
 drivers/staging/rt2860/usb_main_dev.c          |    1 
 drivers/staging/rtl8712/usb_intf.c             |  145 ++++++++++++++++++-----
 drivers/staging/speakup/kobjects.c             |    2 
 drivers/staging/usbip/vhci_hcd.c               |   14 --
 drivers/staging/zram/zram_drv.c                |    4 
 drivers/tty/n_gsm.c                            |    1 
 drivers/tty/sysrq.c                            |   19 ++-
 drivers/usb/class/cdc-acm.c                    |    1 
 drivers/usb/core/hcd-pci.c                     |    7 -
 drivers/usb/core/hcd.c                         |    2 
 drivers/usb/core/hub.c                         |   26 ++++
 drivers/usb/gadget/printer.c                   |   19 +--
 drivers/usb/host/ehci-au1xxx.c                 |    2 
 drivers/usb/host/ehci-hcd.c                    |   27 +++-
 drivers/usb/host/ehci-hub.c                    |    7 +
 drivers/usb/host/ehci-pci.c                    |   41 ++++++
 drivers/usb/host/ehci-sched.c                  |   79 ++++++++++++
 drivers/usb/host/ehci.h                        |    1 
 drivers/usb/host/xhci-ring.c                   |    2 
 drivers/usb/host/xhci.c                        |   60 ++++-----
 drivers/usb/serial/ch341.c                     |   10 +
 drivers/usb/serial/cp210x.c                    |   16 --
 drivers/usb/serial/digi_acceleport.c           |   10 -
 drivers/usb/serial/ftdi_sio.c                  |   39 ++++++
 drivers/usb/serial/ftdi_sio_ids.h              |   32 ++++-
 drivers/usb/serial/generic.c                   |   20 +++
 drivers/usb/serial/io_edgeport.c               |    4 
 drivers/usb/serial/io_tables.h                 |    1 
 drivers/usb/serial/iuu_phoenix.c               |    1 
 drivers/usb/serial/keyspan.h                   |    4 
 drivers/usb/serial/keyspan_pda.c               |   17 --
 drivers/usb/serial/moto_modem.c                |    1 
 drivers/usb/serial/option.c                    |   23 +++
 drivers/usb/serial/oti6858.c                   |    1 
 drivers/usb/serial/pl2303.c                    |   12 +
 drivers/usb/serial/pl2303.h                    |    1 
 drivers/usb/serial/qcaux.c                     |    3 
 drivers/usb/serial/siemens_mpi.c               |    1 
 drivers/usb/serial/spcp8x5.c                   |    7 -
 drivers/usb/serial/ti_usb_3410_5052.c          |    2 
 drivers/usb/serial/usb-serial.c                |    8 -
 drivers/usb/serial/usb_debug.c                 |    1 
 drivers/usb/storage/unusual_cypress.h          |    5 
 drivers/usb/storage/unusual_devs.h             |   32 +++++
 drivers/video/aty/atyfb_base.c                 |   27 ----
 drivers/video/backlight/88pm860x_bl.c          |    4 
 drivers/virtio/virtio_pci.c                    |   20 ---
 drivers/xen/platform-pci.c                     |   21 +--
 fs/cifs/cifsproto.h                            |    2 
 fs/cifs/cifssmb.c                              |    4 
 fs/cifs/connect.c                              |    4 
 fs/cifs/file.c                                 |   21 +--
 fs/cifs/misc.c                                 |    2 
 fs/direct-io.c                                 |   10 +
 fs/eventpoll.c                                 |   16 ++
 fs/exofs/inode.c                               |    2 
 fs/ext4/inode.c                                |    1 
 fs/ext4/mballoc.c                              |  102 +++++++++-------
 fs/ext4/page-io.c                              |   11 -
 fs/ext4/super.c                                |   41 ++++--
 fs/fs-writeback.c                              |   98 ++++++++++++---
 fs/nfs/delegation.c                            |    6 
 fs/nfs/dir.c                                   |   50 ++++----
 fs/nfs/direct.c                                |   34 +++--
 fs/nfs/nfs2xdr.c                               |    6 
 fs/nfs/nfs3xdr.c                               |    6 
 fs/nfs/nfs4xdr.c                               |    6 
 fs/nfsd/nfs4idmap.c                            |    4 
 fs/nfsd/nfsd.h                                 |    1 
 fs/nfsd/nfsproc.c                              |    2 
 fs/nilfs2/super.c                              |    3 
 fs/partitions/check.c                          |   10 +
 fs/proc/kcore.c                                |    2 
 include/drm/drm_pciids.h                       |    1 
 include/linux/blkdev.h                         |    1 
 include/linux/completion.h                     |    8 -
 include/linux/dynamic_debug.h                  |   18 --
 include/linux/genhd.h                          |    2 
 include/linux/ieee80211.h                      |    2 
 include/linux/klist.h                          |    2 
 include/linux/kref.h                           |    1 
 include/linux/lockdep.h                        |    3 
 include/linux/memory_hotplug.h                 |    6 
 include/linux/mmzone.h                         |   10 -
 include/linux/nl80211.h                        |    6 
 include/linux/oprofile.h                       |   13 +-
 include/linux/radix-tree.h                     |   16 ++
 include/linux/security.h                       |   15 +-
 include/linux/sunrpc/xdr.h                     |    4 
 include/linux/sysrq.h                          |    3 
 include/linux/usb/hcd.h                        |    1 
 include/linux/usb/serial.h                     |    3 
 include/linux/vmstat.h                         |    5 
 include/net/cfg80211.h                         |   15 +-
 include/scsi/scsi.h                            |    1 
 init/calibrate.c                               |    6 
 kernel/irq/migration.c                         |   14 +-
 kernel/perf_event.c                            |   15 +-
 kernel/ptrace.c                                |    2 
 kernel/sched.c                                 |   22 +++
 kernel/sched_rt.c                              |    2 
 kernel/smp.c                                   |   30 ++++
 kernel/sys.c                                   |    3 
 kernel/sysctl.c                                |    3 
 kernel/trace/trace.c                           |    6 
 kernel/watchdog.c                              |   41 ++----
 kernel/workqueue.c                             |   14 +-
 lib/dynamic_debug.c                            |    9 -
 lib/kref.c                                     |   12 +
 mm/memcontrol.c                                |    7 -
 mm/memory_hotplug.c                            |    4 
 mm/migrate.c                                   |   75 ++++--------
 mm/mmzone.c                                    |   21 ---
 mm/page_alloc.c                                |   35 ++++-
 mm/slub.c                                      |    4 
 mm/vmscan.c                                    |   23 ++-
 mm/vmstat.c                                    |   68 ++++++++++
 net/ax25/af_ax25.c                             |    2 
 net/core/ethtool.c                             |    2 
 net/core/rtnetlink.c                           |    3 
 net/core/sock.c                                |    2 
 net/ipv4/ip_fragment.c                         |   34 +++++
 net/ipv6/ip6_output.c                          |    3 
 net/mac80211/agg-rx.c                          |   11 -
 net/mac80211/key.c                             |    6 
 net/mac80211/rx.c                              |    4 
 net/mac80211/tx.c                              |    6 
 net/sched/sch_fifo.c                           |    2 
 net/sunrpc/xdr.c                               |  155 ++++++++++++++++++++-----
 net/unix/af_unix.c                             |    2 
 net/wireless/reg.c                             |   33 ++++-
 security/capability.c                          |    2 
 security/security.c                            |    3 
 security/selinux/hooks.c                       |   15 +-
 security/selinux/nlmsgtab.c                    |    2 
 security/smack/smack_lsm.c                     |   14 +-
 sound/atmel/ac97c.c                            |    5 
 sound/core/hrtimer.c                           |    5 
 sound/pci/au88x0/au88x0_pcm.c                  |   24 +++
 sound/pci/hda/hda_codec.c                      |    3 
 sound/pci/hda/hda_eld.c                        |    2 
 sound/pci/hda/patch_conexant.c                 |    9 +
 sound/pci/hda/patch_hdmi.c                     |   51 ++++++++
 sound/pci/hda/patch_realtek.c                  |    2 
 sound/pci/hda/patch_sigmatel.c                 |    2 
 sound/soc/blackfin/bf5xx-ac97.c                |    4 
 sound/soc/blackfin/bf5xx-tdm.c                 |    2 
 sound/soc/codecs/wm8990.c                      |   10 -
 sound/soc/codecs/wm8994.c                      |   17 +-
 sound/soc/codecs/wm_hubs.c                     |   15 +-
 sound/soc/davinci/davinci-evm.c                |    2 
 sound/soc/pxa/corgi.c                          |    4 
 sound/soc/pxa/poodle.c                         |    2 
 sound/soc/pxa/spitz.c                          |    4 
 sound/soc/soc-core.c                           |    2 
 sound/usb/midi.c                               |   11 +
 sound/usb/usx2y/us122l.c                       |   41 +++---
 287 files changed, 2858 insertions(+), 1280 deletions(-)

Alan Stern (9):
      USB: usb-storage: unusual_devs entry for CamSport Evo
      USB: usb-storage: unusual_devs entry for Coby MP3 player
      USB serial: add missing .usb_driver field in serial drivers
      USB: EHCI: fix DMA deallocation bug
      USB: g_printer: fix bug in unregistration
      USB: g_printer: fix bug in module parameter definitions
      USB: prevent buggy hubs from crashing the USB stack
      USB: fix race between root-hub resume and wakeup requests
      PM / Runtime: Don't enable interrupts while running in_interrupt

Alex Deucher (11):
      drm/radeon/kms: add quirk for Mac Radeon HD 2600 card
      drm/radeon/kms: adjust quirk for acer laptop
      drm/radeon/kms: make the mac rv630 quirk generic
      drm/radeon/kms: re-emit full context state for evergreen blits
      drm/radeon/kms: switch back to min->max pll post divider iteration
      drm/radeon/kms: add pll debugging output
      drm/radeon/kms: add new pll algo for avivo asics
      drm/radeon/kms: Enable new pll calculation for avivo+ asics
      drm/radeon: remove 0x4243 pci id
      drm/radeon/kms/evergreen: always set certain VGT regs at CP init
      drm/radeon/kms: fix s/r issues with bios scratch regs

Alex He (2):
      USB: EHCI: ASPM quirk of ISOC on AMD SB800
      USB: EHCI: ASPM quirk of ISOC on AMD Hudson

Alexey Kuznetsov (1):
      inet6: prevent network storms caused by linux IPv6 routers

Amit Shah (1):
      virtio: console: Wake up outvq on host notifications

Amitkumar Karwar (1):
      ieee80211: correct IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK macro

Andiry Xu (1):
      xHCI: synchronize irq in xhci_suspend()

Andrew Morton (1):
      ext4: fix uninitialized variable in ext4_register_li_request

Andy Whitcroft (1):
      Input: sysrq - ensure sysrq_enabled and __sysrq_enabled are consistent

Anton Blanchard (3):
      powerpc: Fix hcall tracepoint recursion
      powerpc/numa: Fix bug in unmap_cpu_from_node
      kernel/smp.c: fix smp_call_function_many() SMP race

Arend van Spriel (1):
      staging: brcm80211: fix suspend/resume issue in brcmsmac

Ari Kauppi (2):
      oprofile: Fix usage of CONFIG_HW_PERF_EVENTS for oprofile_perf_init and friends
      ARM: oprofile: Fix backtraces in timer mode

Arvid Ephraim Picciani (1):
      USB: cdc-acm: Adding second ACM channel support for Nokia N8

Axel Köllhofer (1):
      staging: r8712u: Add new device IDs

Ben Hutchings (1):
      68360serial: Plumb in rs_360_get_icount()

Benjamin Herrenschmidt (1):
      powerpc: Fix some 6xx/7xxx CPU setup functions

Bjørn Mork (1):
      USB: io_edgeport: fix the reported firmware major and minor

Boaz Harrosh (1):
      Revert "exofs: Set i_mapping->backing_dev_info anyway"

Bruce Rogers (1):
      virtio_net: Add schedule check to napi_enable call

Changhwan Youn (1):
      ARM: S5PV310: Set bit 22 in the PL310 (cache controller) AuxCtlr register

Chien-Chia Chen (2):
      Staging: rt3090: Fix RT3090 scan AP function
      Staging: rt2860: fix previous patch error

Chris Mason (1):
      md_make_request: don't touch the bio after calling make_request

Chris Wilson (6):
      drm: Restore the old_fb upon modeset failure
      drm/i915/sdvo: Defer detection of output capabilities until probing
      drm/i915/panel: Only record the backlight level when it is enabled
      drm/i915: Add dependency on CONFIG_TMPFS
      drm/i915: Recognise non-VGA display devices
      drm/i915: Only bind to function 0 of the PCI device

Christian Lamparter (2):
      p54: fix sequence no. accounting off-by-one error
      carl9170: fix typo in PS code

Christoph Lameter (1):
      slub: Avoid use of slub_lock in show_slab_objects()

Chuck Lever (1):
      NFS: Fix "kernel BUG at fs/aio.c:554!"

Clemens Ladisch (1):
      ALSA: hrtimer: handle delayed timer interrupts

Cliff Wickman (1):
      x86, UV, BAU: Extend for more than 16 cpus per socket

Corey Minyard (1):
      char/ipmi: fix OOPS caused by pnp_unregister_driver on unregistered driver

Craig Shelley (2):
      USB: CP210x Add two device IDs
      USB: CP210x Removed incorrect device ID

Curt Wohlgemuth (1):
      ext4: Fix data corruption with multi-block writepages support

Dan Carpenter (2):
      Staging: Beceem: add USB id for BCSM250 Mobile WiMAX
      mtd: pxa3xx_nand: NULL dereference in pxa3xx_nand_probe

Dan Williams (1):
      USB: qcaux: add Pantech UML290 device ID

Daniel T Chen (1):
      ALSA: hda: Use vostro model quirk for Dell Vostro 1014

Dario Lombardo (1):
      drivers: update to pl2303 usb-serial to support Motorola cables

Dave Anderson (1):
      /proc/kcore: fix seeking

David Dillow (2):
      fix incorrect value of SCSI_MAX_SG_CHAIN_SEGMENTS due to include file ordering
      fs/direct-io.c: don't try to allocate more than BIO_MAX_PAGES in a bio

David Henningsson (2):
      ALSA: HDA: Fix dmesg output of HDMI supported bits
      ALSA: HDA: Add subwoofer quirk for Acer Aspire 8942G

David Miller (1):
      klist: Fix object alignment on 64-bit.

David Müller (1):
      drm/i915/crt: Check for a analog monitor in case of DVI-I

David S. Miller (2):
      atyfb: Fix bootup hangs on sparc64.
      af_unix: Avoid socket->sk NULL OOPS in stream connect security hooks.

Dean Nelson (1):
      e1000: fix return value not set on error

Denis Kirjanov (1):
      staging: rt2860: Fix incorrect netif_stop_queue usage warning

Dimitris Papastamos (1):
      ASoC: WM8990: msleep() takes milliseconds not jiffies

Dirk Eibach (1):
      hwmon: (lm63) Consider LM64 temperature offset

Dmitry Eremin-Solenikov (1):
      ASoC: correct link specifications for corgi, poodle and spitz

Dmitry Torokhov (3):
      Input: rc-keymap - return KEY_RESERVED for unknown mappings
      Input: sysrq - rework re-inject logic
      Revert "Input: do not pass injected events back to the originating handler"

Don Fry (1):
      iwlagn: Re-enable RF_KILL interrupt when down

Don Skidmore (1):
      ixgbe: fix for 82599 erratum on Header Splitting

Edgar (gimli) Hucek (1):
      input: bcm5974: Add support for MacBookAir3

Edgar Hucek (1):
      hwmon: (applesmc) Add MacBookAir3,1(3,2) support

Eric Dumazet (5):
      net: add POLLPRI to sock_def_readable()
      ipv4: IP defragmentation must be ECN aware
      net_sched: pfifo_head_drop problem
      epoll: epoll_wait() should not use timespec_add_ns()
      perf: Fix alloc_callchain_buffers()

Eric Paris (2):
      SELinux: define permissions for DCB netlink messages
      SELinux: do not compute transition labels on mountpoint labeled filesystems

Eric Sandeen (2):
      ext4: fix panic on module unload when stopping lazyinit thread
      ext4: make grpinfo slab cache names static

Eric W. Biederman (1):
      net: Fix ip link add netns oops

Eugene Teo (1):
      net: clear heap allocation for ethtool_get_regs()

Felix Beck (1):
      zcrypt: Fix check to look for facility bits 2 & 65

Felix Fietkau (2):
      mac80211: fix a crash in ieee80211_beacon_get_tim on change_interface
      mac80211: fix initialization of skb->cb in ieee80211_subif_start_xmit

Greg Kroah-Hartman (2):
      rt2x00: add device id for windy31 usb device
      Linux 2.6.37.1

Guy Martin (1):
      parisc : Remove broken line wrapping handling pdc_iodc_print()

H. Peter Anvin (1):
      x86, olpc: Add missing Kconfig dependencies

Haiyang Zhang (1):
      staging: hv: Enable sending GARP packet after live migration

Hank Janssen (1):
      staging: hv: Removed unneeded call to netif_stop_queue() in hv_netvsc

Hans-Christian Egtvedt (2):
      ALSA: fix invalid hardware.h include in ac97c for AVR32 architecture
      avr32: use syscall prototypes from asm-generic instead of arch

Henrik Rydberg (1):
      hwmon: (applesmc) Relax the severity of device init failure

Hugh Dickins (2):
      mm: fix migration hangs on anon_vma lock
      mm: fix hugepage migration

Ian Abbott (1):
      staging: comedi: ni_labpc: Use shared IRQ for PCMCIA card

Ian Campbell (1):
      xen-platform: use PCI interfaces to request IO and MEM resources.

Indan Zupancic (1):
      drm/i915/panel: The backlight is enabled if the current value is non-zero

Ionut Nicu (1):
      USB: ti_usb: fix module removal

J. Bruce Fields (1):
      nfsd4: name->id mapping should fail with BADOWNER not BADNAME

James Bottomley (2):
      fix medium error problems with some arrays which can cause data corruption
      libsas: fix runaway error handler problem

Jan Glauber (1):
      qdio: use proper QEBSM operand for SIGA-R and SIGA-S

Jan Kara (4):
      writeback: integrated background writeback work
      writeback: stop background/kupdate works from livelocking other works
      writeback: avoid livelocking WB_SYNC_ALL writeback
      ext4: fix trimming of a single group

Jason Baron (1):
      dynamic debug: Fix build issue with older gcc

Jean Delvare (2):
      hwmon: (via686a) Initialize fan_div values
      i2c: Unregister dummy devices last on adapter removal

Jean-Christophe PLAGNIOL-VILLARD (1):
      USB: ftdi_sio: add ST Micro Connect Lite uart support

Jerome Glisse (1):
      radeon/kms: fix dp displayport mode validation

Jerome Marchand (2):
      kref: add kref_test_and_get
      block: fix accounting bug on cross partition merges

Jesse Barnes (1):
      drm/i915: check eDP encoder correctly when setting modes

Jiri Kosina (1):
      Input: i8042 - introduce 'notimeout' blacklist for Dell Vostro V13

Johannes Berg (1):
      mac80211: add missing synchronize_rcu

Justin TerAvest (1):
      cfq-iosched: Don't wait if queue already has requests.

KAMEZAWA Hiroyuki (2):
      memcg: fix account leak at failure of memsw acconting
      memory hotplug: one more lock on memory hotplug

Kacper Kornet (1):
      Fix prlimit64 for suid/sgid processes

Karsten Wiese (2):
      ALSA: snd-usb-us122l: Fix MIDI output
      ALSA: snd-usb-us122l: Fix missing NULL checks

Kashyap, Desai (7):
      mpt2sas: fix Integrated Raid unsynced on shutdown problem
      mpt2sas: Fix device removal handshake for zoned devices
      mpt2sas: fix internal device reset for older firmware prior to MPI Rev K
      mpt2sas: Fix the race between broadcast asyn event and scsi command completion
      mpt2sas: Correct resizing calculation for max_queue_depth
      mpt2sas: add missing initialization of scsih_cmds
      mpt2sas: Kernel Panic during Large Topology discovery

Kees Cook (1):
      net: ax25: fix information leak to userland harder

Keith Packard (1):
      drm: Only set DPMS ON when actually configuring a mode

Ken Mills (1):
      n_gsm: copy mtu over when configuring via ioctl interface

Knut Petersen (1):
      drm/i915/lvds: Add AOpen i915GMm-HFS to the list of false-positive LVDS

Ky Srinivasan (1):
      Staging: hv: fix sysfs symlink on hv block device

Larry Finger (1):
      staging: rt2870sta: Add ID for Linksys WUSB100v2

Lars-Peter Clausen (1):
      jz4740-battery: Protect against concurrent battery readings

Li Zefan (1):
      tracing: Fix preempt count leak

Libor Pechacek (1):
      USB: serial: handle Data Carrier Detect changes

Luciano Coelho (1):
      mac80211: use maximum number of AMPDU frames as default in BA RX

Luis R. Rodriguez (6):
      ath9k: fix assumptions for idle calls on suspend/resume
      ath9k: fix aphy / wiphy idle mismatch
      ath9k_hw: disabled PAPRD for AR9003
      cfg80211: pass the reg hint initiator to helpers
      cfg80211: fix allowing country IEs for WIPHY_FLAG_STRICT_REGULATORY
      cfg80211: fix disabling channels based on hints

Lukas Czerner (1):
      ext4: unregister features interface on module unload

Marcin Slusarz (3):
      watchdog: Fix sysctl consistency
      watchdog: Don't change watchdog state on read of sysctl
      watchdog: Fix broken nowatchdog logic

Mark Brown (4):
      ASoC: When disabling WM8994 FLL force a source selection
      ASoC: Fix AC'97 registration unwind
      ASoC: Handle low measured DC offsets for wm_hubs devices
      ASoC: Create an AIF1ADCDAT signal widget to match AIF2

Matthias Schwarzott (1):
      IX2505V: i2c transfer error code ignored

Mauro Carvalho Chehab (2):
      radio-aimslab.c: Fix gcc 4.5+ bug
      em28xx: Fix audio input for Terratec Grabby

Mel Gorman (2):
      mm: migration: use rcu_dereference_protected when dereferencing the radix tree slot during file page migration
      mm: page allocator: adjust the per-cpu counter threshold when memory is low

Michael Buesch (1):
      ssb-pcmcia: Fix parsing of invariants tuples

Michael Williamson (1):
      USB: ftdi_sio: Add VID=0x0647, PID=0x0100 for Acton Research spectrograph

Michal Hocko (1):
      memsw: handle swapaccount kernel parameter correctly

Mike Frysinger (2):
      ASoC: Blackfin AC97: fix build error after multi-component update
      ASoC: Blackfin TDM: fix missed snd_soc_dai_get_drvdata update

Mike Snitzer (2):
      dm: dont take i_mutex to change device size
      dm mpath: disable blk_abort_queue

Milton Miller (2):
      mac80211: fix mesh forwarding when ratelimited too
      virtio: remove virtio-pci root device

Márton Németh (1):
      staging: usbip: remove double giveback of URB

Naga Chumbalkar (1):
      x86, dmi, debug: Log board name (when present) in dmesg/oops output

NeilBrown (5):
      sched: Change wait_for_completion_*_timeout() to return a signed long
      md: fix regression with re-adding devices to arrays with no metadata
      md: fix regression resulting in delays in clearing bits in a bitmap
      md: Ensure no IO request to get md device before it is properly initialised.
      md: Fix removal of extra drives when converting RAID6 to RAID5

Nick Holloway (1):
      USB: Storage: Add unusual_devs entry for VTech Kidizoom

Nicolaus Colberg (1):
      USB: adding USB support for Cinterion's HC2x, EU3 and PH8 products

Nitin Daga (1):
      ALSA: hda: Disable 4/6 channels on some NVIDIA GPUs.

Nitin Gupta (1):
      staging: zram: fix data corruption issue

Oleg Nesterov (2):
      perf: Find_get_context: fix the per-cpu-counter check
      perf: Validate cpu early in perf_event_alloc()

Olof Johansson (1):
      tpm: fix panic caused by "tpm: Autodetect itpm devices"

Paul Fox (1):
      rtc-cmos: fix suspend/resume

Paul Mundt (1):
      sh: Fix up legacy PTEA space attribute mapping.

Pavel Machek (1):
      serial: unbreak billionton CF card

Pavel Shilovsky (1):
      CIFS: Fix oplock break handling (try #2)

Peter Zijlstra (2):
      sched, cgroup: Use exit hook to avoid use-after-free crash
      sched: Fix update_curr_rt()

Pieter Maes (1):
      USB: serial: Updated support for ICOM devices

Qiao Zhou (1):
      ASoC: WM8994: fix wrong value in tristate function

Rafael J. Wysocki (1):
      cpuidle: Make cpuidle_enable_device() call poll_idle_init()

Rajiv Andrade (1):
      TPM: Long default timeout fix

Rajkumar Manoharan (4):
      ath9k: fix beacon restart on channel change
      ath9k_hw: do PA offset calibration only on longcal interval
      ath9k_hw: Fix system hang when resuming from S3/S4
      ath: Missed to clear key4 of micentry

Randy Dunlap (1):
      backlight: fix 88pm860x_bl macro collision

Raymond Yau (1):
      ALSA : au88x0 - Limit number of channels to fix Oops via OSS emu

Richard Schütz (2):
      USB: usb-storage: unusual_devs update for Cypress ATACB
      USB: usb-storage: unusual_devs update for TrekStor DataStation maxi g.u external hard drive enclosure

Roland Stigge (1):
      iio: Fixpoint formatted output bugfix

Ruben Smits (1):
      staging: comedi: add support for newer jr3 1-channel pci board

Russell King (3):
      ARM: initrd: disable initrd if passed address overlaps reserved region
      ARM: SMP: use more sane register allocation for __fixup_smp_on_up
      ARM: smp_on_up: allow non-ARM SMP processors

Ryusuke Konishi (1):
      nilfs2: fix crash after one superblock became unavailable

Sarah Sharp (3):
      xhci: Resume bus on any port status change.
      usb: Realloc xHCI structures after a hub is verified.
      xhci: Use GFP_NOIO during device reset.

Shaohua Li (2):
      intel_idle: open broadcast clock event
      fix a shutdown regression in intel_idle

Shawn Guo (1):
      net/fec: fix MMFR_OP type in fec_enet_mdio_write

Shirish Pargaonkar (1):
      cifs: Fix regression during share-level security mounts (Repost)

Sonic Zhang (1):
      mmc: bfin_sdh: fix alloc size for private data

Soren Hansen (1):
      nbd: remove module-level ioctl mutex

Stanislaw Gruszka (2):
      iwlagn: enable only rfkill interrupt when device is down
      hostap_cs: fix sleeping function called from invalid context

Stefan Berger (1):
      tpm_tis: Use timeouts returned from TPM

Stefan Richter (1):
      firewire: core: fix unstable I/O with Canon camcorder

Stephen Kitt (1):
      agp: ensure GART has an address before enabling it

Steve Wise (3):
      RDMA/cxgb4: Don't re-init wait object in init/fini paths
      RDMA/cxgb4: Set the correct device physical function for iWARP connections
      RDMA/cxgb4: Limit MAXBURST EQ context field to 256B

Sudhakar Rajashekhara (1):
      ASoC: da8xx/omap-l1xx: match codec_name with i2c ids

Sujith Manoharan (1):
      ath9k_htc: Handle pending URBs properly

Suresh Siddha (2):
      x86, mtrr: Avoid MTRR reprogramming on BP during boot on UP platforms
      x86, mm: avoid possible bogus tlb entries by clearing prev mm_cpumask after switching mm

Sven Neumann (1):
      ds2760_battery: Fix calculation of time_to_empty_now

Takashi Iwai (7):
      ALSA: hda - Add missing NID 0x19 fixup for Sony VAIO
      ALSA: hda - Don't refer ELD when unplugged
      ALSA: hda - Fix NULL-derefence with a single mic in STAC auto-mic detection
      ALSA: hda - Fix multi-headphone handling for Realtek codecs
      ALSA: hda - Add static_hdmi_pcm option to HDMI codec parser
      ALSA: hda - Fix memory leaks in conexant jack arrays
      ALSA: hda - Fix missing CA initialization for HDMI/DP

Tejun Heo (5):
      libata: set queue DMA alignment to sector size for ATAPI too
      PCI: pci-stub: ignore zero-length id parameters
      ptrace: use safer wake up on ptrace_detach()
      workqueue: relax lockdep annotation on flush_work()
      pata_mpc52xx: inherit from ata_bmdma_port_ops

Theodore Ts'o (1):
      ext4: fix memory leak in ext4_free_branches

Thomas Gleixner (2):
      genirq: Prevent irq storm on migration
      x86: Readd missing irq_to_desc() in fixup_irq()

Thomas Taranowski (1):
      rapidio: fix hang on RapidIO doorbell queue full condition

Tim Deegan (1):
      fix jiffy calculations in calibrate_delay_direct to handle overflow

Timo Teräs (1):
      staging: hv: fix netvsc sleeping while atomic

Timur Tabi (1):
      powerpc/85xx: fix compatible properties of the P1022DS DMA nodes used for audio

Trond Myklebust (3):
      NFS: Don't use vm_map_ram() in readdir
      NFS: Fix NFSv3 exclusive open semantics
      NFS: Fix an NFS client lockdep issue

Vasanthakumar Thiagarajan (2):
      ath9k_hw: Fix XPABIAS level configuration for AR9003
      ath9k: Fix bug in delimiter padding computation

Yin Kangkai (1):
      USB: EHCI: fix scheduling while atomic during suspend

Yuanhan Liu (1):
      drm/i915: fix calculation of eDP signal levels on Sandybridge

Zhang Rui (1):
      xhci: Do not run xhci_cleanup_msix with irq disabled

roel kluin (1):
      Staging: speakup: &&/|| confusion in silent_store()

