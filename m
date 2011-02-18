Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab1BRATK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 19:19:10 -0500
Received: from kroah.org ([198.145.64.141]:48711 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757402Ab1BRASo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 19:18:44 -0500
Date: Thu, 17 Feb 2011 16:17:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.36.4
Message-ID: <20110218001725.GC9342@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.36.4 kernel.

All users of the 2.6.36 kernel series must upgrade.

No, scratch that, you should move to the .37 kernel series as this is
the last .36 kernel to be released.  It's now "end of life", "dead",
"buried", "pining for the fjords", or whatever term you and your
company uses for things that are no more.

The updated 2.6.36.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.36.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.36.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt            |    1 
 Makefile                                       |    2 
 arch/arm/mm/init.c                             |    6 +
 arch/avr32/include/asm/syscalls.h              |    9 --
 arch/parisc/kernel/firmware.c                  |   13 ---
 arch/powerpc/boot/dts/p1022ds.dts              |    4 -
 arch/powerpc/kernel/cpu_setup_6xx.S            |   40 ++++++------
 arch/powerpc/mm/numa.c                         |    2 
 arch/powerpc/platforms/pseries/lpar.c          |   37 +++++++++++
 arch/powerpc/sysdev/fsl_rio.c                  |    1 
 arch/sh/include/asm/io.h                       |   10 ++-
 arch/sh/include/asm/pgtable_32.h               |    7 +-
 arch/x86/include/asm/mmu_context.h             |    5 -
 arch/x86/kernel/cpu/mtrr/main.c                |   10 ++-
 arch/x86/kvm/i8259.c                           |    2 
 arch/x86/kvm/mmu.c                             |   10 ++-
 block/cfq-iosched.c                            |    4 +
 drivers/ata/pata_mpc52xx.c                     |    2 
 drivers/char/agp/intel-agp.c                   |   27 ++++----
 drivers/char/ipmi/ipmi_si_intf.c               |   12 ---
 drivers/char/tpm/tpm.c                         |   28 ++++++--
 drivers/char/tpm/tpm.h                         |    2 
 drivers/char/tpm/tpm_tis.c                     |   28 ++++++++
 drivers/char/virtio_console.c                  |   15 +++-
 drivers/cpuidle/cpuidle.c                      |   82 ++++++++++++-------------
 drivers/firewire/core-card.c                   |   11 ++-
 drivers/gpu/drm/Kconfig                        |    3 
 drivers/gpu/drm/drm_crtc_helper.c              |    5 +
 drivers/gpu/drm/i915/i915_dma.c                |   10 ++-
 drivers/gpu/drm/i915/i915_drv.c                |   10 ++-
 drivers/gpu/drm/i915/i915_reg.h                |    9 +-
 drivers/gpu/drm/i915/intel_dp.c                |   23 ++++---
 drivers/gpu/drm/i915/intel_lvds.c              |    8 ++
 drivers/gpu/drm/radeon/atombios_dp.c           |    4 -
 drivers/gpu/drm/radeon/radeon_atombios.c       |   37 +++++++----
 drivers/gpu/drm/radeon/radeon_display.c        |    4 +
 drivers/gpu/vga/vgaarb.c                       |    2 
 drivers/hwmon/applesmc.c                       |   48 +++++---------
 drivers/hwmon/lm63.c                           |   59 ++++++++++++++---
 drivers/hwmon/via686a.c                        |   14 +++-
 drivers/i2c/i2c-core.c                         |   14 +++-
 drivers/infiniband/hw/cxgb4/cm.c               |    2 
 drivers/input/mouse/bcm5974.c                  |   40 ++++++++++++
 drivers/input/serio/i8042-x86ia64io.h          |   21 ++++++
 drivers/input/serio/i8042.c                    |    6 +
 drivers/md/dm-mpath.c                          |   12 ---
 drivers/md/dm.c                                |    5 -
 drivers/md/md.c                                |   27 +++++---
 drivers/md/md.h                                |    3 
 drivers/media/radio/radio-aimslab.c            |   23 +------
 drivers/media/video/em28xx/em28xx-cards.c      |    4 -
 drivers/mmc/host/bfin_sdh.c                    |    2 
 drivers/net/atlx/atl1.c                        |   10 +++
 drivers/net/fec.c                              |    4 -
 drivers/net/ixgbe/ixgbe_main.c                 |   11 ++-
 drivers/net/virtio_net.c                       |   27 ++++----
 drivers/net/wireless/ath/ath9k/ar9002_calib.c  |   10 +--
 drivers/net/wireless/ath/ath9k/ar9002_hw.c     |    3 
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   14 ++--
 drivers/net/wireless/ath/ath9k/ath9k.h         |    7 --
 drivers/net/wireless/ath/ath9k/hif_usb.c       |   40 ++++++++++--
 drivers/net/wireless/ath/ath9k/hif_usb.h       |    1 
 drivers/net/wireless/ath/ath9k/hw.c            |    6 +
 drivers/net/wireless/ath/ath9k/hw.h            |    1 
 drivers/net/wireless/ath/ath9k/init.c          |    1 
 drivers/net/wireless/ath/ath9k/main.c          |   64 ++++++++-----------
 drivers/net/wireless/ath/ath9k/pci.c           |    4 +
 drivers/net/wireless/ath/ath9k/recv.c          |    2 
 drivers/net/wireless/ath/ath9k/xmit.c          |    4 -
 drivers/net/wireless/iwlwifi/iwl-agn.c         |   15 +++-
 drivers/net/wireless/iwlwifi/iwl-helpers.h     |    6 +
 drivers/net/wireless/p54/txrx.c                |    2 
 drivers/net/wireless/rt2x00/rt73usb.c          |    1 
 drivers/pci/pci-stub.c                         |    3 
 drivers/power/ds2760_battery.c                 |    2 
 drivers/power/jz4740-battery.c                 |    7 ++
 drivers/rtc/rtc-cmos.c                         |   16 ++--
 drivers/s390/cio/qdio.h                        |    6 +
 drivers/s390/cio/qdio_main.c                   |   43 ++++++++-----
 drivers/scsi/libsas/sas_scsi_host.c            |    1 
 drivers/scsi/mpt2sas/mpt2sas_base.c            |   24 +++++--
 drivers/scsi/mpt2sas/mpt2sas_scsih.c           |   64 +++++++++++++++----
 drivers/scsi/sd.c                              |    9 ++
 drivers/serial/8250.c                          |    3 
 drivers/ssb/pcmcia.c                           |    2 
 drivers/staging/comedi/drivers/jr3_pci.c       |    7 ++
 drivers/staging/comedi/drivers/ni_labpc.c      |    3 
 drivers/staging/hv/blkvsc_drv.c                |    1 
 drivers/staging/hv/netvsc.c                    |    2 
 drivers/staging/hv/netvsc_drv.c                |    1 
 drivers/staging/rt2860/chips/rt3090.c          |    3 
 drivers/staging/rt2860/chips/rt30xx.c          |    4 -
 drivers/staging/rt2860/rt_main_dev.c           |    2 
 drivers/staging/rt2860/usb_main_dev.c          |    1 
 drivers/staging/usbip/vhci_hcd.c               |   14 ----
 drivers/staging/zram/zram_drv.c                |    4 +
 drivers/usb/class/cdc-acm.c                    |    1 
 drivers/usb/core/hcd.c                         |    2 
 drivers/usb/core/hub.c                         |   26 +++++++
 drivers/usb/gadget/printer.c                   |   19 ++---
 drivers/usb/host/ehci-au1xxx.c                 |    2 
 drivers/usb/host/ehci-hcd.c                    |   27 ++++++--
 drivers/usb/host/ehci-hub.c                    |    7 ++
 drivers/usb/host/ehci-pci.c                    |   41 ++++++++++++
 drivers/usb/host/ehci-sched.c                  |   79 ++++++++++++++++++++++++
 drivers/usb/host/ehci.h                        |    1 
 drivers/usb/host/xhci.c                        |   14 +++-
 drivers/usb/serial/ch341.c                     |   10 +++
 drivers/usb/serial/cp210x.c                    |   16 ----
 drivers/usb/serial/digi_acceleport.c           |   10 ---
 drivers/usb/serial/ftdi_sio.c                  |   39 +++++++++++
 drivers/usb/serial/ftdi_sio_ids.h              |   32 ++++++++-
 drivers/usb/serial/generic.c                   |   20 ++++++
 drivers/usb/serial/io_edgeport.c               |    4 -
 drivers/usb/serial/io_tables.h                 |    1 
 drivers/usb/serial/iuu_phoenix.c               |    1 
 drivers/usb/serial/keyspan.h                   |    4 +
 drivers/usb/serial/keyspan_pda.c               |   17 -----
 drivers/usb/serial/moto_modem.c                |    1 
 drivers/usb/serial/option.c                    |   23 ++++++-
 drivers/usb/serial/oti6858.c                   |    1 
 drivers/usb/serial/pl2303.c                    |   12 +++
 drivers/usb/serial/pl2303.h                    |    1 
 drivers/usb/serial/qcaux.c                     |    3 
 drivers/usb/serial/siemens_mpi.c               |    1 
 drivers/usb/serial/spcp8x5.c                   |    7 +-
 drivers/usb/serial/ti_usb_3410_5052.c          |    2 
 drivers/usb/serial/usb-serial.c                |    8 +-
 drivers/usb/serial/usb_debug.c                 |    1 
 drivers/usb/storage/unusual_cypress.h          |    5 +
 drivers/usb/storage/unusual_devs.h             |   32 +++++++++
 drivers/video/backlight/88pm860x_bl.c          |    4 -
 drivers/virtio/virtio_pci.c                    |   20 ------
 fs/direct-io.c                                 |   10 ++-
 fs/ext4/inode.c                                |    1 
 fs/nfs/delegation.c                            |    6 +
 fs/nfs/direct.c                                |   34 ++++++----
 fs/nilfs2/super.c                              |    3 
 fs/proc/kcore.c                                |    2 
 include/drm/drm_pciids.h                       |    1 
 include/linux/ieee80211.h                      |    2 
 include/linux/klist.h                          |    2 
 include/linux/mmzone.h                         |   10 ---
 include/linux/usb/serial.h                     |    3 
 include/linux/vmstat.h                         |    5 +
 include/net/cfg80211.h                         |   15 ++--
 include/scsi/scsi.h                            |    1 
 init/calibrate.c                               |    6 -
 kernel/ptrace.c                                |    2 
 kernel/smp.c                                   |   30 +++++++++
 kernel/sys.c                                   |    3 
 kernel/watchdog.c                              |   23 +++----
 mm/memcontrol.c                                |    1 
 mm/migrate.c                                   |   48 +++++---------
 mm/mmzone.c                                    |   21 ------
 mm/page_alloc.c                                |   35 ++++++++--
 mm/vmscan.c                                    |   23 +++----
 mm/vmstat.c                                    |   68 ++++++++++++++++++++
 net/core/rtnetlink.c                           |    3 
 net/mac80211/agg-rx.c                          |   11 ---
 net/mac80211/key.c                             |    6 +
 net/mac80211/rx.c                              |    4 -
 net/mac80211/tx.c                              |    6 +
 net/wireless/reg.c                             |   13 ++-
 security/keys/request_key.c                    |    1 
 security/selinux/hooks.c                       |    5 +
 security/selinux/nlmsgtab.c                    |    2 
 sound/atmel/ac97c.c                            |    5 +
 sound/core/hrtimer.c                           |    5 -
 sound/pci/au88x0/au88x0_pcm.c                  |   24 ++++++-
 sound/pci/hda/hda_eld.c                        |    2 
 sound/pci/hda/patch_conexant.c                 |    8 ++
 sound/pci/hda/patch_realtek.c                  |    1 
 sound/soc/blackfin/bf5xx-ac97.c                |    4 -
 sound/soc/blackfin/bf5xx-tdm.c                 |    2 
 sound/soc/codecs/wm8990.c                      |   10 +--
 sound/soc/codecs/wm8994.c                      |   17 +++--
 sound/soc/codecs/wm_hubs.c                     |   15 ++--
 sound/usb/midi.c                               |   11 ++-
 sound/usb/usx2y/us122l.c                       |   41 ++++++------
 180 files changed, 1578 insertions(+), 687 deletions(-)


Alan Stern (8):
      USB: usb-storage: unusual_devs entry for CamSport Evo
      USB: usb-storage: unusual_devs entry for Coby MP3 player
      USB serial: add missing .usb_driver field in serial drivers
      USB: EHCI: fix DMA deallocation bug
      USB: g_printer: fix bug in unregistration
      USB: g_printer: fix bug in module parameter definitions
      USB: prevent buggy hubs from crashing the USB stack
      USB: fix race between root-hub resume and wakeup requests

Alex Deucher (6):
      drm/radeon/kms: add quirk for Mac Radeon HD 2600 card
      drm/radeon/kms: adjust quirk for acer laptop
      drm/radeon/kms: make the mac rv630 quirk generic
      drm/radeon/kms: add pll debugging output
      drm/radeon: remove 0x4243 pci id
      drm/radeon/kms: fix s/r issues with bios scratch regs

Alex He (2):
      USB: EHCI: ASPM quirk of ISOC on AMD SB800
      USB: EHCI: ASPM quirk of ISOC on AMD Hudson

Amit Shah (1):
      virtio: console: Wake up outvq on host notifications

Amitkumar Karwar (1):
      ieee80211: correct IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK macro

Anton Blanchard (3):
      powerpc: Fix hcall tracepoint recursion
      powerpc/numa: Fix bug in unmap_cpu_from_node
      kernel/smp.c: fix smp_call_function_many() SMP race

Arvid Ephraim Picciani (1):
      USB: cdc-acm: Adding second ACM channel support for Nokia N8

Avi Kivity (2):
      KVM: i8259: initialize isr_ack
      KVM: MMU: Fix incorrect direct gfn for unpaged mode shadow

Benjamin Herrenschmidt (1):
      powerpc: Fix some 6xx/7xxx CPU setup functions

Bjørn Mork (1):
      USB: io_edgeport: fix the reported firmware major and minor

Bruce Rogers (1):
      virtio_net: Add schedule check to napi_enable call

Chien-Chia Chen (2):
      Staging: rt3090: Fix RT3090 scan AP function
      Staging: rt2860: fix previous patch error

Chris Mason (1):
      md_make_request: don't touch the bio after calling make_request

Chris Wilson (4):
      drm: Restore the old_fb upon modeset failure
      drm/i915: Add dependency on CONFIG_TMPFS
      drm/i915: Recognise non-VGA display devices
      drm/i915: Only bind to function 0 of the PCI device

Christian Lamparter (1):
      p54: fix sequence no. accounting off-by-one error

Chuck Lever (1):
      NFS: Fix "kernel BUG at fs/aio.c:554!"

Clemens Ladisch (1):
      ALSA: hrtimer: handle delayed timer interrupts

Corey Minyard (1):
      char/ipmi: fix OOPS caused by pnp_unregister_driver on unregistered driver

Craig Shelley (2):
      USB: CP210x Add two device IDs
      USB: CP210x Removed incorrect device ID

Dan Williams (1):
      USB: qcaux: add Pantech UML290 device ID

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

David Howells (1):
      KEYS: Don't call up_write() if __key_link_begin() returns an error

David Miller (1):
      klist: Fix object alignment on 64-bit.

Denis Kirjanov (1):
      staging: rt2860: Fix incorrect netif_stop_queue usage warning

Dimitris Papastamos (1):
      ASoC: WM8990: msleep() takes milliseconds not jiffies

Dirk Eibach (1):
      hwmon: (lm63) Consider LM64 temperature offset

Don Fry (1):
      iwlagn: Re-enable RF_KILL interrupt when down

Don Skidmore (1):
      ixgbe: fix for 82599 erratum on Header Splitting

Edgar (gimli) Hucek (1):
      input: bcm5974: Add support for MacBookAir3

Edgar Hucek (1):
      hwmon: (applesmc) Add MacBookAir3,1(3,2) support

Eric Paris (2):
      SELinux: define permissions for DCB netlink messages
      SELinux: do not compute transition labels on mountpoint labeled filesystems

Eric W. Biederman (1):
      net: Fix ip link add netns oops

Felix Fietkau (2):
      mac80211: fix a crash in ieee80211_beacon_get_tim on change_interface
      mac80211: fix initialization of skb->cb in ieee80211_subif_start_xmit

Greg Kroah-Hartman (2):
      rt2x00: add device id for windy31 usb device
      Linux 2.6.36.4

Guy Martin (1):
      parisc : Remove broken line wrapping handling pdc_iodc_print()

Haiyang Zhang (1):
      staging: hv: Enable sending GARP packet after live migration

Hans-Christian Egtvedt (2):
      ALSA: fix invalid hardware.h include in ac97c for AVR32 architecture
      avr32: use syscall prototypes from asm-generic instead of arch

Henrik Rydberg (1):
      hwmon: (applesmc) Relax the severity of device init failure

Hugh Dickins (1):
      mm: fix migration hangs on anon_vma lock

Ian Abbott (1):
      staging: comedi: ni_labpc: Use shared IRQ for PCMCIA card

Ionut Nicu (1):
      USB: ti_usb: fix module removal

J. K. Cliburn (1):
      atl1: fix oops when changing tx/rx ring params

James Bottomley (2):
      fix medium error problems with some arrays which can cause data corruption
      libsas: fix runaway error handler problem

Jan Glauber (1):
      qdio: use proper QEBSM operand for SIGA-R and SIGA-S

Jean Delvare (2):
      hwmon: (via686a) Initialize fan_div values
      i2c: Unregister dummy devices last on adapter removal

Jean-Christophe PLAGNIOL-VILLARD (1):
      USB: ftdi_sio: add ST Micro Connect Lite uart support

Jerome Glisse (1):
      radeon/kms: fix dp displayport mode validation

Jiri Kosina (1):
      Input: i8042 - introduce 'notimeout' blacklist for Dell Vostro V13

Joerg Roedel (1):
      KVM: MMU: Fix 32 bit legacy paging with NPT

Johannes Berg (1):
      mac80211: add missing synchronize_rcu

Justin TerAvest (1):
      cfq-iosched: Don't wait if queue already has requests.

KAMEZAWA Hiroyuki (1):
      memcg: fix account leak at failure of memsw acconting

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
      mpt2sas: Kernel Panic during Large Topology discovery
      mpt2sas: add missing initialization of scsih_cmds

Knut Petersen (1):
      drm/i915/lvds: Add AOpen i915GMm-HFS to the list of false-positive LVDS

Ky Srinivasan (1):
      Staging: hv: fix sysfs symlink on hv block device

Larry Finger (1):
      staging: rt2870sta: Add ID for Linksys WUSB100v2

Lars-Peter Clausen (1):
      jz4740-battery: Protect against concurrent battery readings

Libor Pechacek (1):
      USB: serial: handle Data Carrier Detect changes

Luciano Coelho (1):
      mac80211: use maximum number of AMPDU frames as default in BA RX

Luis R. Rodriguez (7):
      ath9k: simplify hw reset locking
      ath9k: move the PCU lock to the sc structure
      ath9k: fix assumptions for idle calls on suspend/resume
      ath9k: fix aphy / wiphy idle mismatch
      ath9k_hw: disabled PAPRD for AR9003
      cfg80211: pass the reg hint initiator to helpers
      cfg80211: fix allowing country IEs for WIPHY_FLAG_STRICT_REGULATORY

Marcin Slusarz (2):
      watchdog: Fix sysctl consistency
      watchdog: Don't change watchdog state on read of sysctl

Mark Brown (3):
      ASoC: When disabling WM8994 FLL force a source selection
      ASoC: Handle low measured DC offsets for wm_hubs devices
      ASoC: Create an AIF1ADCDAT signal widget to match AIF2

Matthew Garrett (1):
      tpm: Autodetect itpm devices

Mauro Carvalho Chehab (2):
      radio-aimslab.c: Fix gcc 4.5+ bug
      em28xx: Fix audio input for Terratec Grabby

Mel Gorman (1):
      mm: page allocator: adjust the per-cpu counter threshold when memory is low

Michael Buesch (1):
      ssb-pcmcia: Fix parsing of invariants tuples

Michael Williamson (1):
      USB: ftdi_sio: Add VID=0x0647, PID=0x0100 for Acton Research spectrograph

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

NeilBrown (4):
      md: fix regression with re-adding devices to arrays with no metadata
      md: fix regression resulting in delays in clearing bits in a bitmap
      md: Ensure no IO request to get md device before it is properly initialised.
      md: Fix removal of extra drives when converting RAID6 to RAID5

Nick Holloway (1):
      USB: Storage: Add unusual_devs entry for VTech Kidizoom

Nicolaus Colberg (1):
      USB: adding USB support for Cinterion's HC2x, EU3 and PH8 products

Nitin Gupta (1):
      staging: zram: fix data corruption issue

Paul Fox (1):
      rtc-cmos: fix suspend/resume

Paul Mundt (1):
      sh: Fix up legacy PTEA space attribute mapping.

Pavel Machek (1):
      serial: unbreak billionton CF card

Pieter Maes (1):
      USB: serial: Updated support for ICOM devices

Qiao Zhou (1):
      ASoC: WM8994: fix wrong value in tristate function

Rafael J. Wysocki (1):
      cpuidle: Make cpuidle_enable_device() call poll_idle_init()

Rajiv Andrade (1):
      TPM: Long default timeout fix

Rajkumar Manoharan (3):
      ath9k: fix beacon restart on channel change
      ath9k_hw: do PA offset calibration only on longcal interval
      ath9k_hw: Fix system hang when resuming from S3/S4

Randy Dunlap (1):
      backlight: fix 88pm860x_bl macro collision

Raymond Yau (1):
      ALSA : au88x0 - Limit number of channels to fix Oops via OSS emu

Richard Schütz (2):
      USB: usb-storage: unusual_devs update for Cypress ATACB
      USB: usb-storage: unusual_devs update for TrekStor DataStation maxi g.u external hard drive enclosure

Ruben Smits (1):
      staging: comedi: add support for newer jr3 1-channel pci board

Russell King (1):
      ARM: initrd: disable initrd if passed address overlaps reserved region

Ryusuke Konishi (1):
      nilfs2: fix crash after one superblock became unavailable

Sarah Sharp (2):
      usb: Realloc xHCI structures after a hub is verified.
      xhci: Use GFP_NOIO during device reset.

Shawn Guo (1):
      net/fec: fix MMFR_OP type in fec_enet_mdio_write

Sonic Zhang (1):
      mmc: bfin_sdh: fix alloc size for private data

Stanislaw Gruszka (1):
      iwlagn: enable only rfkill interrupt when device is down

Stefan Berger (1):
      tpm_tis: Use timeouts returned from TPM

Stefan Richter (1):
      firewire: core: fix unstable I/O with Canon camcorder

Stephen Kitt (1):
      agp: ensure GART has an address before enabling it

Steve Wise (1):
      RDMA/cxgb4: Set the correct device physical function for iWARP connections

Sujith Manoharan (1):
      ath9k_htc: Handle pending URBs properly

Suresh Siddha (2):
      x86, mtrr: Avoid MTRR reprogramming on BP during boot on UP platforms
      x86, mm: avoid possible bogus tlb entries by clearing prev mm_cpumask after switching mm

Sven Neumann (1):
      ds2760_battery: Fix calculation of time_to_empty_now

Takashi Iwai (1):
      ALSA: hda - Fix memory leaks in conexant jack arrays

Tejun Heo (3):
      PCI: pci-stub: ignore zero-length id parameters
      ptrace: use safer wake up on ptrace_detach()
      pata_mpc52xx: inherit from ata_bmdma_port_ops

Theodore Ts'o (1):
      ext4: fix memory leak in ext4_free_branches

Thomas Taranowski (1):
      rapidio: fix hang on RapidIO doorbell queue full condition

Tim Deegan (1):
      fix jiffy calculations in calibrate_delay_direct to handle overflow

Timo Teräs (1):
      staging: hv: fix netvsc sleeping while atomic

Timur Tabi (1):
      powerpc/85xx: fix compatible properties of the P1022DS DMA nodes used for audio

Trond Myklebust (1):
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

