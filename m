Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab0LIWwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 17:52:33 -0500
Received: from kroah.org ([198.145.64.141]:45717 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133Ab0LIWwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 17:52:00 -0500
Date: Thu, 9 Dec 2010 14:51:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.36.2
Message-ID: <20101209225131.GE2777@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.36.2 kernel.

All users of the 2.6.36 kernel series must upgrade.

The updated 2.6.36.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.36.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.36.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                             |    2 
 arch/arm/include/asm/assembler.h                     |    2 
 arch/arm/lib/findbit.S                               |    6 
 arch/arm/mach-cns3xxx/pcie.c                         |    2 
 arch/arm/mm/fault-armv.c                             |   28 ++
 arch/arm/plat-omap/dma.c                             |   50 ++++
 arch/arm/plat-omap/include/plat/dma.h                |    4 
 arch/microblaze/Makefile                             |    8 
 arch/powerpc/mm/hash_utils_64.c                      |    2 
 arch/s390/kernel/nmi.c                               |   10 
 arch/s390/kernel/vtime.c                             |   19 +
 arch/s390/lib/delay.c                                |   14 -
 arch/sh/include/asm/syscalls_32.h                    |    7 
 arch/um/drivers/line.c                               |    5 
 arch/um/kernel/uml.lds.S                             |    2 
 arch/um/os-Linux/time.c                              |    2 
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c           |    1 
 arch/x86/kernel/hw_breakpoint.c                      |    4 
 arch/x86/kvm/svm.c                                   |    2 
 arch/x86/kvm/vmx.c                                   |   19 -
 arch/x86/kvm/x86.c                                   |   14 -
 arch/x86/xen/enlighten.c                             |    4 
 block/blk-map.c                                      |    2 
 block/blk-settings.c                                 |    2 
 block/genhd.c                                        |    6 
 block/scsi_ioctl.c                                   |   34 ++-
 drivers/acpi/battery.c                               |   38 +++
 drivers/acpi/bus.c                                   |    7 
 drivers/acpi/debugfs.c                               |    2 
 drivers/ata/libata-scsi.c                            |    5 
 drivers/ata/sata_via.c                               |    9 
 drivers/char/agp/intel-agp.c                         |    1 
 drivers/char/agp/intel-gtt.c                         |   63 ++---
 drivers/char/hpet.c                                  |   17 +
 drivers/char/ipmi/ipmi_si_intf.c                     |   30 +-
 drivers/char/tty_buffer.c                            |   14 +
 drivers/char/tty_io.c                                |   13 +
 drivers/char/tty_ldisc.c                             |   51 ++++
 drivers/char/vt_ioctl.c                              |   11 -
 drivers/crypto/padlock-aes.c                         |    2 
 drivers/firewire/ohci.c                              |   60 ++++-
 drivers/gpio/cs5535-gpio.c                           |   16 +
 drivers/gpu/drm/i915/i915_dma.c                      |    3 
 drivers/gpu/drm/i915/i915_irq.c                      |   21 +
 drivers/gpu/drm/i915/i915_reg.h                      |    7 
 drivers/gpu/drm/i915/i915_suspend.c                  |    4 
 drivers/gpu/drm/i915/intel_crt.c                     |    3 
 drivers/gpu/drm/i915/intel_display.c                 |    7 
 drivers/gpu/drm/i915/intel_drv.h                     |    1 
 drivers/gpu/drm/i915/intel_overlay.c                 |    8 
 drivers/gpu/drm/i915/intel_sdvo.c                    |    8 
 drivers/gpu/drm/radeon/atom.c                        |    1 
 drivers/gpu/drm/radeon/r100.c                        |    6 
 drivers/gpu/drm/radeon/r100_track.h                  |    1 
 drivers/gpu/drm/radeon/r200.c                        |    2 
 drivers/gpu/drm/radeon/r600.c                        |   15 -
 drivers/gpu/drm/radeon/r600_blit_kms.c               |    8 
 drivers/gpu/drm/radeon/r600_cs.c                     |    4 
 drivers/gpu/drm/radeon/r600_reg.h                    |    1 
 drivers/gpu/drm/radeon/radeon_atombios.c             |   16 +
 drivers/gpu/drm/radeon/radeon_bios.c                 |   13 -
 drivers/gpu/drm/radeon/radeon_combios.c              |   15 +
 drivers/gpu/drm/radeon/radeon_connectors.c           |   34 +++
 drivers/gpu/drm/radeon/radeon_encoders.c             |   36 +++
 drivers/gpu/drm/radeon/radeon_i2c.c                  |    1 
 drivers/gpu/drm/radeon/radeon_object.c               |    4 
 drivers/gpu/drm/radeon/radeon_reg.h                  |    1 
 drivers/gpu/drm/radeon/rv770.c                       |    9 
 drivers/hid/hid-egalax.c                             |   16 +
 drivers/hid/usbhid/hid-quirks.c                      |    1 
 drivers/hwmon/lm85.c                                 |    1 
 drivers/i2c/busses/i2c-pca-platform.c                |    2 
 drivers/input/serio/i8042-x86ia64io.h                |    7 
 drivers/isdn/gigaset/bas-gigaset.c                   |   89 +++-----
 drivers/isdn/gigaset/isocdata.c                      |    8 
 drivers/leds/leds-ss4200.c                           |    1 
 drivers/md/md.c                                      |    6 
 drivers/md/raid1.c                                   |    1 
 drivers/media/video/cx23885/cx23885-core.c           |    1 
 drivers/media/video/gspca/gspca.c                    |    4 
 drivers/media/video/gspca/sonixj.c                   |    3 
 drivers/media/video/hdpvr/hdpvr-video.c              |    1 
 drivers/media/video/msp3400-driver.c                 |    7 
 drivers/media/video/saa7134/saa7134-cards.c          |   24 +-
 drivers/misc/ad525x_dpot-spi.c                       |    4 
 drivers/misc/sgi-xp/xpc_partition.c                  |   25 +-
 drivers/mmc/core/core.c                              |    2 
 drivers/net/e1000/e1000_main.c                       |   12 -
 drivers/net/jme.c                                    |   22 +-
 drivers/net/pcmcia/pcnet_cs.c                        |    1 
 drivers/net/phy/marvell.c                            |   31 +-
 drivers/net/r6040.c                                  |   22 +-
 drivers/net/r8169.c                                  |   19 +
 drivers/net/usb/usbnet.c                             |   11 +
 drivers/net/wireless/ath/ath.h                       |    1 
 drivers/net/wireless/ath/ath9k/ar9002_hw.c           |    3 
 drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h |  191 ++++++++++++-----
 drivers/net/wireless/ath/ath9k/ar9003_mac.c          |    3 
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c        |   14 -
 drivers/net/wireless/ath/ath9k/ath9k.h               |    7 
 drivers/net/wireless/ath/ath9k/beacon.c              |    2 
 drivers/net/wireless/ath/ath9k/common.c              |   11 +
 drivers/net/wireless/ath/ath9k/eeprom_9287.c         |    2 
 drivers/net/wireless/ath/ath9k/hif_usb.c             |   20 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c        |    2 
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c        |    2 
 drivers/net/wireless/ath/ath9k/hw.c                  |    1 
 drivers/net/wireless/ath/ath9k/init.c                |   40 +++
 drivers/net/wireless/ath/ath9k/mac.c                 |    5 
 drivers/net/wireless/ath/ath9k/main.c                |   61 ++++-
 drivers/net/wireless/ath/ath9k/rc.c                  |    8 
 drivers/net/wireless/ath/ath9k/recv.c                |   45 ++--
 drivers/net/wireless/ath/ath9k/reg.h                 |    9 
 drivers/net/wireless/ath/ath9k/xmit.c                |  112 +++++-----
 drivers/net/wireless/b43/sdio.c                      |    3 
 drivers/oprofile/timer_int.c                         |   13 +
 drivers/pci/pci-sysfs.c                              |   22 +-
 drivers/pci/pci.h                                    |    7 
 drivers/pci/proc.c                                   |    2 
 drivers/pcmcia/soc_common.c                          |    1 
 drivers/platform/x86/wmi.c                           |    2 
 drivers/pnp/pnpacpi/core.c                           |   29 ++
 drivers/power/olpc_battery.c                         |    8 
 drivers/scsi/qla2xxx/qla_gbl.h                       |    1 
 drivers/scsi/qla2xxx/qla_init.c                      |    5 
 drivers/scsi/qla2xxx/qla_os.c                        |    5 
 drivers/serial/mfd.c                                 |   18 -
 drivers/ssb/b43_pci_bridge.c                         |    1 
 drivers/staging/asus_oled/asus_oled.c                |    8 
 drivers/staging/batman-adv/soft-interface.c          |    4 
 drivers/staging/frontier/tranzport.c                 |    2 
 drivers/staging/iio/accel/adis16220_core.c           |    2 
 drivers/staging/line6/control.c                      |  204 +++++++++----------
 drivers/staging/line6/midi.c                         |    4 
 drivers/staging/line6/pod.c                          |   32 +-
 drivers/staging/line6/toneport.c                     |    4 
 drivers/staging/line6/variax.c                       |   12 -
 drivers/staging/rt2860/usb_main_dev.c                |    2 
 drivers/staging/rtl8187se/r8185b_init.c              |   30 ++
 drivers/staging/samsung-laptop/samsung-laptop.c      |    2 
 drivers/staging/udlfb/udlfb.c                        |    2 
 drivers/usb/atm/ueagle-atm.c                         |    7 
 drivers/usb/core/devio.c                             |    7 
 drivers/usb/gadget/atmel_usba_udc.c                  |    2 
 drivers/usb/host/ehci-dbg.c                          |    2 
 drivers/usb/host/ehci-hcd.c                          |   10 
 drivers/usb/host/ehci-pci.c                          |   12 +
 drivers/usb/host/ohci-jz4740.c                       |    2 
 drivers/usb/host/xhci-hub.c                          |    7 
 drivers/usb/host/xhci-mem.c                          |  168 +++++++++++++++
 drivers/usb/host/xhci-ring.c                         |    1 
 drivers/usb/host/xhci.c                              |   18 +
 drivers/usb/host/xhci.h                              |   32 ++
 drivers/usb/misc/cypress_cy7c63.c                    |    6 
 drivers/usb/misc/iowarrior.c                         |    1 
 drivers/usb/misc/sisusbvga/sisusb.c                  |    1 
 drivers/usb/misc/trancevibrator.c                    |    2 
 drivers/usb/misc/usbled.c                            |    2 
 drivers/usb/misc/usbsevseg.c                         |   10 
 drivers/usb/musb/musb_core.c                         |    1 
 drivers/usb/serial/ftdi_sio.c                        |    4 
 drivers/usb/serial/ftdi_sio_ids.h                    |   11 +
 drivers/usb/serial/option.c                          |    2 
 drivers/usb/serial/usb-serial.c                      |    3 
 drivers/usb/storage/sierra_ms.c                      |    2 
 drivers/video/backlight/backlight.c                  |   12 -
 drivers/video/via/accel.c                            |    7 
 drivers/video/via/via_i2c.c                          |   27 ++
 drivers/xen/events.c                                 |    2 
 fs/bio.c                                             |   23 +-
 fs/cifs/dns_resolve.c                                |    2 
 fs/cifs/inode.c                                      |   12 -
 fs/compat.c                                          |   28 +-
 fs/ecryptfs/inode.c                                  |   11 -
 fs/exec.c                                            |   36 ++-
 fs/ext4/super.c                                      |    1 
 fs/fuse/file.c                                       |   10 
 fs/hostfs/hostfs.h                                   |    3 
 fs/hostfs/hostfs_kern.c                              |    2 
 fs/hostfs/hostfs_user.c                              |    9 
 fs/nfs/file.c                                        |   17 -
 fs/nfs/nfs4proc.c                                    |    9 
 fs/nfs/nfs4state.c                                   |   16 +
 fs/nfs/pagelist.c                                    |    8 
 fs/pipe.c                                            |   14 +
 fs/proc/base.c                                       |    2 
 fs/reiserfs/ioctl.c                                  |    7 
 fs/reiserfs/xattr_acl.c                              |    6 
 fs/splice.c                                          |   24 --
 include/linux/binfmts.h                              |    5 
 include/linux/blkdev.h                               |    4 
 include/linux/gfp.h                                  |    4 
 include/linux/kfifo.h                                |    7 
 include/linux/netfilter.h                            |    2 
 include/linux/pci_ids.h                              |    1 
 include/linux/perf_event.h                           |    1 
 include/linux/pipe_fs_i.h                            |    1 
 include/linux/radix-tree.h                           |   36 +--
 include/linux/socket.h                               |    2 
 include/linux/tty.h                                  |    1 
 include/net/mac80211.h                               |   16 +
 ipc/compat.c                                         |    6 
 ipc/compat_mq.c                                      |    5 
 ipc/shm.c                                            |    1 
 kernel/exit.c                                        |    9 
 kernel/irq/proc.c                                    |    2 
 kernel/latencytop.c                                  |   17 -
 kernel/perf_event.c                                  |   22 +-
 kernel/pm_qos_params.c                               |    4 
 kernel/power/hibernate.c                             |   22 +-
 kernel/power/suspend.c                               |    5 
 kernel/power/user.c                                  |    2 
 kernel/sched.c                                       |   12 +
 lib/percpu_counter.c                                 |    1 
 lib/radix-tree.c                                     |   83 +++++--
 mm/filemap.c                                         |   29 +-
 mm/hugetlb.c                                         |    8 
 mm/internal.h                                        |    2 
 mm/memcontrol.c                                      |   43 ++--
 mm/memory_hotplug.c                                  |    2 
 mm/mempolicy.c                                       |    2 
 mm/mprotect.c                                        |    2 
 mm/nommu.c                                           |    1 
 mm/page_alloc.c                                      |   21 +
 net/8021q/vlan_core.c                                |    3 
 net/can/bcm.c                                        |    2 
 net/compat.c                                         |   10 
 net/core/dev.c                                       |   16 +
 net/core/filter.c                                    |   64 +++--
 net/core/iovec.c                                     |   20 -
 net/decnet/af_decnet.c                               |    2 
 net/econet/af_econet.c                               |   91 +++-----
 net/irda/iriap.c                                     |    3 
 net/irda/parameters.c                                |    4 
 net/mac80211/cfg.c                                   |    5 
 net/mac80211/ibss.c                                  |    1 
 net/mac80211/ieee80211_i.h                           |    2 
 net/mac80211/main.c                                  |    3 
 net/mac80211/mesh_plink.c                            |   17 +
 net/mac80211/mlme.c                                  |   48 +++-
 net/mac80211/offchannel.c                            |    7 
 net/mac80211/rate.c                                  |    3 
 net/mac80211/rc80211_minstrel_ht.c                   |    7 
 net/mac80211/status.c                                |    1 
 net/netfilter/nf_conntrack_core.c                    |    3 
 net/rds/rdma.c                                       |    2 
 net/socket.c                                         |    4 
 net/sunrpc/clnt.c                                    |    2 
 net/wireless/chan.c                                  |   51 ++++
 net/wireless/nl80211.c                               |   11 -
 net/wireless/reg.c                                   |    2 
 net/wireless/scan.c                                  |   12 -
 net/x25/x25_facilities.c                             |   20 +
 net/x25/x25_in.c                                     |    2 
 scripts/kconfig/conf.c                               |    2 
 sound/core/oss/mixer_oss.c                           |   12 -
 sound/core/oss/pcm_oss.c                             |   19 +
 sound/pci/hda/hda_codec.c                            |    8 
 sound/pci/hda/hda_codec.h                            |    1 
 sound/pci/hda/hda_intel.c                            |   25 +-
 sound/pci/hda/patch_analog.c                         |    7 
 sound/pci/hda/patch_ca0110.c                         |    2 
 sound/pci/hda/patch_conexant.c                       |    1 
 sound/pci/hda/patch_realtek.c                        |   51 ++++
 sound/pci/hda/patch_sigmatel.c                       |   16 +
 sound/pci/intel8x0.c                                 |    6 
 sound/soc/codecs/wm8900.c                            |    6 
 sound/soc/codecs/wm8961.c                            |    4 
 268 files changed, 2554 insertions(+), 1110 deletions(-)


Alan Stern (2):
      USB: EHCI: fix obscure race in ehci_endpoint_disable
      USB: fix autosuspend bug in usb-serial

Alex Deucher (15):
      drm/radeon/kms: don't disable shared encoders on pre-DCE3 display blocks
      drm/radeon/kms: fix 2D tile height alignment in the r600 CS checker
      drm/radeon/kms: register an i2c adapter name for the dp aux bus
      drm/radeon/kms: MC vram map needs to be >= pci aperture size
      drm/radeon/kms: properly compute group_size on 6xx/7xx
      drm/radeon/kms: make sure blit addr masks are 64 bit
      drm/radeon/kms: fix handling of tex lookup disable in cs checker on r2xx
      drm/radeon/kms/atom: set sane defaults in atombios_get_encoder_mode()
      drm/radeon/kms: fix typos in disabled vbios code
      drm/radeon/kms: add workaround for dce3 ddc line vbios bug
      drm/radeon/kms: fix thermal sensor reporting on rv6xx
      drm/radeon/kms: fix i2c pad masks on rs4xx
      drm/radeon/kms: fix resume regression for some r5xx laptops
      drm/radeon/kms: fix regression in rs4xx i2c setup
      drm/radeon/kms: fix interlaced and doublescan handling

Andiry Xu (1):
      xHCI: fix wMaxPacketSize mask

Andres Salomon (1):
      cs5535-gpio: apply CS5536 errata workaround for GPIOs

Andrew Morton (2):
      kfifo: disable __kfifo_must_check_helper()
      drivers/media/video/cx23885/cx23885-core.c: fix cx23885_dev_checkrevision()

Anton Vorontsov (1):
      ARM: cns3xxx: Fix build with CONFIG_PCI=y

Anupam Chanda (1):
      e1000: fix screaming IRQ

Arnaud Lacombe (1):
      kbuild: use getopt_long(), not its _only() variant

Arnaud Patard (1):
      phy/marvell: fix 88e1121 support

Avi Kivity (2):
      KVM: Correct ordering of ldt reload wrt fs/gs reload
      KVM: VMX: Fix host userspace gsbase corruption

Axel Lin (2):
      ASoC: wm8961 - clear WM8961_DACSLOPE bit for normal mode
      ASoC: wm8961 - clear WM8961_MCLKDIV bit for freq <= 16500000

Ben Hutchings (2):
      r6040: Fix multicast filter some more
      net: NETIF_F_HW_CSUM does not imply FCoE CRC offload

Björn Smedman (3):
      ath9k: built-in rate control A-MPDU fix
      ath9k: A-MPDU rate control info fix
      mac80211: minstrel_ht A-MPDU fix

Brian J. Tarricone (1):
      USB: ehci: disable LPM and PPCD for nVidia MCP89 chips

Chad Dupuis (1):
      qla2xxx: Add module parameter to enable/disable GFF_ID device type check.

Chris Wilson (3):
      drm/i915/overlay: Ensure that the reg_bo is in the GTT prior to writing.
      agp/intel: Also add B43.1 to list of supported devices
      drm/i915/sdvo: Always add a 30ms delay to make SDVO TV detection reliable

Christian Lamparter (3):
      mac80211: fix possible null-pointer de-reference
      mac80211: clear txflags for ps-filtered frames
      mac80211: don't sanitize invalid rates

Clemens Ladisch (3):
      hpet: fix unwanted interrupt due to stale irq status bit
      firewire: ohci: fix buffer overflow in AR split packet handling
      firewire: ohci: fix race in AR split packet handling

Colin Cross (1):
      PM / PM QoS: Fix reversed min and max

Daisuke Nishimura (1):
      memcg: avoid deadlock between move charge and try_charge()

Dan Rosenberg (4):
      ipc: initialize structure memory to zero for compat functions
      DECnet: don't leak uninitialized stack byte
      x25: Prevent crashing when parsing bad X.25 facilities
      rds: Integer overflow in RDS cmsg handling

Daniel Klaffenbach (1):
      ssb: b43-pci-bridge: Add new vendor for BCM4318

Daniel T Chen (6):
      ALSA: hda: Use hp-laptop quirk to enable headphones automute for Asus A52J
      ALSA: hda: Use BIOS auto-parsing instead of existing model quirk for MEDION MD2
      ALSA: ac97: Apply quirk for Dell Latitude D610 binding Master and Headphone controls
      ALSA: hda: Add speaker pin to automute Acer Aspire 8943G
      ALSA: hda: Add Samsung R720 SSID for subwoofer pin fixup
      ALSA: hda: Use "alienware" model quirk for another SSID

Daniel Vetter (1):
      intel-gtt: fix gtt_total_entries detection

Darrick J. Wong (1):
      PCI: fix offset check for sysfs mmapped files

Dave Hansen (1):
      mm/vfs: revalidate page->mapping in do_generic_file_read()

Dave Jones (1):
      ACPI: debugfs custom_method open to non-root

David Henningsson (3):
      ALSA: HDA: Enable internal mic on Dell E6410 and Dell E6510
      ALSA: HDA: Add fixup pins for Ideapad Y550
      ALSA: HDA: Add an extra DAC for Realtek ALC887-VD

David Howells (1):
      SH: Add missing consts to sys_execve() declaration

David S. Miller (2):
      net: Limit socket I/O iovec total length to INT_MAX.
      filter: make sure filters dont read uninitialized memory

Dean Nelson (2):
      mm/hugetlb.c: add missing spin_lock() to hugetlb_cow()
      mm/hugetlb.c: avoid double unlock_page() in hugetlb_fault()

Dmitri Belimov (1):
      saa7134: Fix autodetect for Behold A7 and H7 TV cards

Dmitry Torokhov (2):
      PNPACPI: cope with invalid device IDs
      Input: i8042 - add Sony VAIO VPCZ122GX to nomux list

Eric Dumazet (4):
      ipmi: proper spinlock initialization
      numa: fix slab_node(MPOL_BIND)
      netfilter: nf_conntrack: allow nf_ct_alloc_hashtable() to get highmem pages
      r8169: fix rx checksum offload

Eric Paris (1):
      netfilter: NF_HOOK_COND has wrong conditional

Eric W. Biederman (1):
      Revert "vfs: show unreachable paths in getcwd and proc"

Felix Fietkau (8):
      ath9k: fix channel flag / regd issues with multiple cards
      ath9k: clean up / fix aggregation session flush
      ath9k: fix an aggregation start related race condition
      ath9k_hw: handle rx key miss
      ath9k: fix spurious MIC failure reports
      ath9k: resume aggregation immediately after a hardware reset
      ath9k: fix tx aggregation flush on AR9003
      ath9k: fix timeout on stopping rx dma

Feng Tang (1):
      serial: mfd: adjust the baud rate setting

Florian Tobias Schandinat (2):
      viafb: fix i2c_transfer error handling
      viafb: use proper register for colour when doing fill ops

Frederic Weisbecker (3):
      reiserfs: fix inode mutex - reiserfs lock misordering
      reiserfs: don't acquire lock recursively in reiserfs_acl_chmod
      x86: Ignore trap bits on single step exceptions

Graham Gower (1):
      drivers/char/vt_ioctl.c: fix VT_OPENQRY error value

Greg Kroah-Hartman (17):
      Staging: asus_oled: fix up some sysfs attribute permissions
      Staging: asus_oled: fix up my fixup for some sysfs attribute permissions
      Staging: line6: fix up some sysfs attribute permissions
      USB: ehci: fix debugfs 'lpm' permissions
      USB: storage: sierra_ms: fix sysfs file attribute
      USB: atm: ueagle-atm: fix up some permissions on the sysfs files
      USB: misc: cypress_cy7c63: fix up some sysfs attribute permissions
      USB: misc: usbled: fix up some sysfs attribute permissions
      USB: misc: trancevibrator: fix up a sysfs attribute permission
      USB: misc: usbsevseg: fix up some sysfs attribute permissions
      Staging: udlfb: fix up some sysfs attribute permissions
      Staging: iio: adis16220: fix up some sysfs attribute permissions
      Staging: iio: adis16220: fix up my fixup for some sysfs attribute permissions
      Staging: samsung-laptop: fix up some sysfs attribute permissions
      Staging: samsung-laptop: fix up my fixup for some sysfs attribute permissions
      Staging: frontier: fix up some sysfs attribute permissions
      Linux 2.6.36.2

Guennadi Liakhovetski (2):
      wireless: b43: fix error path in SDIO
      mmc: fix rmmod race for hosts using card-detection polling

Guo-Fu Tseng (1):
      jme: Fix PHY power-off error

Haitao Zhang (1):
      ath9k_htc: Add support for device ID 3346

Hans Verkuil (1):
      msp3400: fix mute audio regression

Heiko Carstens (2):
      nohz/s390: fix arch_needs_cpu() return value on offline cpus
      nmi: fix clock comparator revalidation

Herbert Xu (1):
      crypto: padlock - Fix AES-CBC handling on odd-block-sized input

Herton Ronaldo Krzesinski (1):
      ALSA: hda - Fix ALC660-VD/ALC861-VD capture/playback mixers

Ian Campbell (1):
      xen: ensure that all event channels start off bound to VCPU 0

Jacques Viviers (1):
      USB: serial: ftdi_sio: Vardaan USB RS422/485 converter PID added

James Jones (1):
      ARM: 6482/2: Fix find_next_zero_bit and related assembly

James M McLaren (1):
      hdpvr: Add missing URB_NO_TRANSFER_DMA_MAP flag

Jan Kara (1):
      block: Fix race during disk initialization

Jarkko Nikula (1):
      omap: dma: Fix buffering disable bit setting for omap24xx

Jaroslav Kysela (1):
      ALSA: OSS mixer emulation - fix locking

Jean Delvare (1):
      hwmon: (lm85) Fix ADT7468 frequency table

Jean-François Moine (2):
      gspca - main: Fix a regression with the PS3 Eye webcam
      gspca - sonixj: Fix a regression of sensors hv7131r and mi0360

Jeff Layton (2):
      nfs: handle lock context allocation failures in nfs_create_request
      cifs: fix parsing of hostname in dfs referrals

Jens Axboe (4):
      block: limit vec count in bio_kmalloc() and bio_alloc_map_data()
      block: take care not to overflow when calculating total iov length
      block: check for proper length of iov entries in blk_rq_map_user_iov()
      bio: take care not overflow page count when mapping/copying user data

Jeremy Fitzhardinge (1):
      xen: don't bother to stop other cpus on shutdown/reboot

Jesse Barnes (1):
      drm/i915: diasable clock gating for the panel power sequencer

Jesse Gross (1):
      vlan: Avoid hwaccel vlan packets when vid not used.

Jiri Olsa (1):
      tty: prevent DOS in the flush_to_ldisc

Jiri Slaby (5):
      hpet: unmap unused I/O space
      TTY: restore tty_ldisc_wait_idle
      TTY: ldisc, fix open flag handling
      TTY: don't allow reopen when ldisc is changing
      TTY: open/hangup race fixup

Johannes Berg (3):
      cfg80211: fix BSS double-unlinking
      cfg80211: fix locking
      mac80211: use correct station flags lock

John Tapsell (1):
      Staging: rt2870: Add USB ID for Buffalo Airstation WLI-UC-GN

Josh Wu (1):
      USB: gadget: AT91: fix typo in atmel_usba_udc driver

Jouni Malinen (1):
      mac80211: Fix signal strength average initialization for CQM events

Justin Maggard (1):
      md: fix return value of rdev_size_change()

KAMEZAWA Hiroyuki (2):
      mm: fix return value of scan_lru_pages in memory unplug
      mm: fix is_mem_section_removable() page_order BUG_ON check

Kailang Yang (1):
      ALSA: hda - Fixed ALC887-VD initial error

Keith Packard (1):
      drm/i915: Free hardware status page on unload when physically mapped

Ken Chen (1):
      latencytop: fix per task accumulator

Ken Kawasaki (1):
      pcnet_cs: add new_id

Ken Sumrall (1):
      fuse: fix attributes after open(O_TRUNC)

Kenji Kaneshige (1):
      genirq: Fix incorrect proc spurious output

Kyle McMartin (1):
      i915: reprogram power monitoring registers on resume

Larry Finger (3):
      staging: rt2870: Add new USB ID for Belkin F6D4050 v1
      b43: Fix warning at drivers/mmc/core/core.c:237 in mmc_wait_for_cmd
      staging: rtl8187se: Change panic to warn when RF switch turned off

Linus Torvalds (4):
      net: Truncate recvfrom and sendto length to INT_MAX.
      Rename 'pipe_info()' to 'get_pipe_info()'
      Export 'get_pipe_info()' to other users
      Un-inline get_pipe_info() helper function

Luis R. Rodriguez (19):
      ath9k: fix power save race conditions
      ath9k: fix regression which disabled ps on ath9k
      ath9k: fix regression on beacon loss after bgscan
      ath9k_hw: Fix TX carrier leakage for IEEE compliance on AR9003 2.2
      ath9k: rename rxflushlock to pcu_lock
      ath9k: add locking for stopping RX
      ath9k: fix enabling ANI / tx monitor after bg scan
      ath9k: add locking for starting the PCU on RX
      ath9k: lock reset and PCU start/stopping
      cfg80211: fix regression on processing country IEs
      mac80211: fix channel assumption for association done work
      mac80211: fix offchannel assumption upon association
      mac80211: reset connection idle when going offchannel
      mac80211: add helper for reseting the connection monitor
      mac80211: make the beacon monitor available externally
      mac80211: send last 3/5 probe requests as unicast
      mac80211: disable beacon monitor while going offchannel
      mac80211: reset probe send counter upon connection timer reset
      cfg80211: fix extension channel checks to initiate communication

Marcelo Roberto Jimenez (1):
      ARM: 6456/1: Fix for building DEBUG with sa11xx_base.c as a module.

Marek Lindner (1):
      Staging: batman-adv: ensure that eth_type_trans gets linear memory

Mark Brown (1):
      ASoC: Remove volatility from WM8900 POWER1 register

Martin K. Petersen (1):
      block: Ensure physical block size is unsigned int

Martin Wilck (1):
      PCI: fix size checks for mmap() on /proc/bus/pci files

Masanori ITOH (1):
      percpu: fix list_head init bug in __percpu_counter_init()

Mel Gorman (1):
      mm, page-allocator: do not check the state of a non-existant buddy during free

Michael Hennerich (1):
      drivers/misc/ad525x_dpot.c: fix typo in spi write16 and write24 transfer counts

Michael Neuling (1):
      powerpc: Fix call to subpage_protection()

Michael S. Tsirkin (1):
      KVM: Write protect memory after slot swap

Michael Stuermer (1):
      USB: ftdi_sio: Add ID for RT Systems USB-29B radio cable

Michel Dänzer (1):
      drm/radeon/kms: Fix retrying ttm_bo_init() after it failed once.

Mika Westerberg (1):
      ARM: 6464/2: fix spinlock recursion in adjust_pte()

Ming Lei (2):
      usbnet: fix usb_autopm_get_interface failure(v1)
      usb: musb: fix kernel oops when loading musb_hdrc module for the 2nd time

Mohammed Shafi Shajakhan (1):
      ath9k: Fix incorrect access of rate flags in RC

NeilBrown (2):
      md: Fix regression with raid1 arrays without persistent metadata.
      md/raid1: really fix recovery looping when single good device fails.

Nelson Elhage (1):
      do_exit(): make sure that we run with get_fs() == USER_DS

Nick Piggin (1):
      radix-tree: fix RCU bug

Nobuhiro Iwamatsu (1):
      i2c-pca-platform: Change device name of request_irq

Oleg Nesterov (2):
      exec: make argv/envp memory visible to oom-killer
      exec: copy-and-paste the fixes into compat_do_execve() paths

Oliver Hartkopp (1):
      can-bcm: fix minor heap overflow

Oskar Schirmer (1):
      cifs: fix another memleak, in cifs_root_iget

Paul Zimmerman (1):
      xhci: Fix reset-device and configure-endpoint commands

Pekka Enberg (1):
      perf_events: Fix perf_counter_mmap() hook in mprotect()

Peter Ujfalusi (1):
      OMAP3: DMA: Errata i541: sDMA FIFO draining does not finish

Peter Zijlstra (1):
      sched: fix RCU lockdep splat from task_group()

Phil Blundell (3):
      econet: disallow NULL remote addr for sendmsg(), fixes CVE-2010-3849
      econet: fix CVE-2010-3850
      econet: fix CVE-2010-3848

Philipp Merkel (1):
      HID: Fix for problems with eGalax/DWAV multi-touch-screen

Philippe Rétornaz (1):
      tty_ldisc: Fix BUG() on hangup

Rafael J. Wysocki (1):
      PM / Hibernate: Fix memory corruption related to swap

Rajkumar Manoharan (7):
      ath9k_htc: Set proper firmware offset for Netgear WNDA3200
      ath9k_hw: Fix memory leak on ath9k_hw_rf_alloc_ext_banks failure
      ath9k_htc: Avoid setting QoS control for non-QoS frames
      ath9k_hw: Set proper eeprom offset for AR9287 HTC devices
      ath9k_htc: Add new devices into AR7010
      ath9k_htc: Update usb device ID list
      mac80211: Fix ibss station got expired immediately

Richard A. Smith (1):
      olpc_battery: Fix endian neutral breakage for s16 values

Richard Weinberger (3):
      hostfs: fix UML crash: remove f_spare from hostfs
      um: remove PAGE_SIZE alignment in linker script causing kernel segfault.
      um: fix global timer issue when using CONFIG_NO_HZ

Roberto Sassu (1):
      ecryptfs: call vfs_setxattr() in ecryptfs_setxattr()

Robin@sgi.com (1):
      sgi-xpc: XPC fails to discover partitions with all nasids above 128

Samuel Ortiz (2):
      irda: Fix parameter extraction stack overflow
      irda: Fix heap memory corruption in iriap.c

Santosh Shilimkar (1):
      oprofile: Fix the hang while taking the cpu offline

Sarah Sharp (3):
      xhci: Remove excessive printks with shared IRQs.
      xhci: Setup array of USB 2.0 and USB 3.0 ports.
      xhci: Don't let the USB core disable SuperSpeed ports.

Sebastien Bourdeauducq (1):
      USB: ftdi_sio: add device IDs for Milkymist One JTAG/serial

Senthil Balasubramanian (2):
      ath9k: fix regression which prevents chip sleep after CAB data
      ath9k_hw: Fix divide by zero cases in paprd.

Sergey Senozhatsky (1):
      ext4: fix NULL pointer dereference in print_daily_error_info()

Shan Wei (1):
      r8169: fix checksum broken

Stanislaw Gruszka (1):
      r8169: (re)init phy on resume

Stefan Weil (1):
      USB: ohci-jz4740: Fix spelling in MODULE_ALIAS

Steven J. Magnani (1):
      nommu: yield CPU while disposing VM

Steven Rostedt (1):
      leds: fix bug with reading NAS SS4200 dmi code

Takashi Iwai (6):
      ALSA: hda - Disable sticky PCM stream assignment for AD codecs
      ALSA: hda - Add workarounds for CT-IBG controllers
      ALSA: hda - Fix wrong SPDIF NID assignment for CA0110
      ALSA: hda - Add some workarounds for Creative IBG
      ALSA: hda - Use ALC_INIT_DEFAULT for really default initialization
      ALSA: Fix SNDCTL_DSP_RESET ioctl for OSS emulation

Tejun Heo (2):
      sata_via: apply magic FIFO fix to vt6420 too
      libata: fix NULL sdev dereference race in atapi_qc_complete()

Thadeu Lima de Souza Cascardo (1):
      wmi: use memcmp instead of strncmp to compare GUIDs

Thomas Backlund (1):
      microblaze: Fix build with make 3.82

Thomas Gleixner (1):
      perf: Fix inherit vs. context rotation bug

Tilman Schmidt (3):
      isdn/gigaset: fix bas_gigaset AT read error handling
      isdn/gigaset: correct bas_gigaset rx buffer handling
      isdn/gigaset: bas_gigaset locking fix

Trond Myklebust (5):
      SUNRPC: After calling xprt_release(), we must restart from call_reserve
      NFSv4: Don't call nfs4_reclaim_complete() on receiving NFS4ERR_STALE_CLIENTID
      NFSv4: Don't call nfs4_state_mark_reclaim_reboot() from error handlers
      NFSv4: Fix open recovery
      NFS: Don't SIGBUS if nfs_vm_page_mkwrite races with a cache invalidation

Tyler Hicks (1):
      eCryptfs: Clear LOOKUP_OPEN flag when creating lower file

Uwe Kleine-König (1):
      backlight: grab ops_lock before testing bd->ops

Valentine Sinitsyn (1):
      ALSA: hda - Added fixup for Lenovo Y550P

Vasanthakumar Thiagarajan (2):
      ath9k: Fix tx struck state with paprd
      ath9k_hw: Fix AR9280 surprise removal during frequent idle on/off

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

Yuanhan Liu (2):
      drm/i915: Update hotplug interrupts register definitions for Sandybridge
      drm/i915/crt: Make sure the hotplug interrupt is enabled

Zhang Rui (3):
      ACPI: install ACPI table handler before any dynamic tables being loaded
      ACPI battery: support percentage battery remaining capacity
      acpi-cpufreq: fix a memleak when unloading driver

andrew hendry (1):
      memory corruption in X.25 facilities parsing

françois romieu (1):
      r8169: revert "Handle rxfifo errors on 8168 chips"

ma rui (1):
      USB: option: fix when the driver is loaded incorrectly for some Huawei devices.

