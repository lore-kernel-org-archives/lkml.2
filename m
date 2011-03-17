Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab1CQVjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:39:16 -0400
Received: from kroah.org ([198.145.64.141]:50547 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755673Ab1CQVjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:39:14 -0400
Date: Thu, 17 Mar 2011 14:38:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mgalbraith@suse.de, tglx@linutronix.de
Subject: [000/474] 2.6.33.8-longterm review
Message-ID: <20110317213822.GA27980@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah, I know what you are thinking, "What, 2.6.33, are you crazy?"

I'd prefer it if you didn't answer that question...

Anyway, yes, a .33 kernel release, strange isn't it.

Turns out there are a lot of people "stuck" on the 2.6.33 kernel series
for a variety of valid reasons, not the least being the Real Time
patchset.  So, in the copious spare time I have, I've been trying to
keep up with the patches that have been applied to the different
longterm and stable kernel trees and have been queueing them up for .33
as well.

Here's the result of that.  A 474 patch series that is bigger than most
people ever want to review, or see in their inboxes.  Because of that,
it is ONLY being sent to the stable-review@kernel.org mailing list.  If
you want to see the individual patches, look at the git tree of the
patch queue, or look at that mailing list.

So, if you are using .33, please give this patch a test and let me know
if I've messed up anything (hint, I think I did, it's up to you to
figure it out, consider it a test to see if anyone actually cares about
this kernel version.)

If I missed anything that I should have in here, please let me know.

Responses should be made by Saturday, March 19, 2011, 21:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.33.8-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 MAINTAINERS                                     |    6 +
 Makefile                                        |    2 +-
 arch/arm/include/asm/assembler.h                |    2 +-
 arch/arm/kernel/signal.c                        |    4 +-
 arch/arm/lib/findbit.S                          |    6 +-
 arch/ia64/include/asm/compat.h                  |    2 +-
 arch/ia64/kernel/fsys.S                         |   30 +++-
 arch/mips/alchemy/mtx-1/platform.c              |    9 +
 arch/mips/include/asm/compat.h                  |    2 +-
 arch/parisc/include/asm/compat.h                |    2 +-
 arch/powerpc/include/asm/compat.h               |    2 +-
 arch/powerpc/include/asm/hvcall.h               |    1 +
 arch/powerpc/kernel/cpu_setup_6xx.S             |   40 +++---
 arch/powerpc/kernel/crash.c                     |   11 +-
 arch/powerpc/kernel/machine_kexec_64.c          |   25 +++
 arch/powerpc/kernel/ppc970-pmu.c                |    2 +
 arch/powerpc/kernel/setup_64.c                  |   17 ++-
 arch/powerpc/platforms/pseries/hvCall.S         |   38 +++++
 arch/powerpc/platforms/pseries/lpar.c           |   70 +++++++--
 arch/powerpc/platforms/pseries/plpar_wrappers.h |   18 ++
 arch/powerpc/sysdev/fsl_rio.c                   |    1 -
 arch/s390/include/asm/compat.h                  |    2 +-
 arch/s390/include/asm/processor.h               |    5 -
 arch/s390/include/asm/vdso.h                    |    2 +-
 arch/s390/kernel/traps.c                        |   37 ----
 arch/s390/kernel/vtime.c                        |   19 ++
 arch/sparc/include/asm/compat.h                 |    2 +-
 arch/um/drivers/ubd_kern.c                      |    9 +-
 arch/um/kernel/uml.lds.S                        |    2 +-
 arch/um/os-Linux/time.c                         |    2 +-
 arch/x86/ia32/ia32entry.S                       |   22 ++-
 arch/x86/include/asm/acpi.h                     |    1 +
 arch/x86/include/asm/amd_iommu_proto.h          |    6 +
 arch/x86/include/asm/amd_iommu_types.h          |   12 ++
 arch/x86/include/asm/compat.h                   |    2 +-
 arch/x86/include/asm/cpufeature.h               |    2 +-
 arch/x86/include/asm/io.h                       |    1 +
 arch/x86/include/asm/mmu_context.h              |    5 +-
 arch/x86/include/asm/pgtable_32.h               |    1 +
 arch/x86/include/asm/processor.h                |   23 ---
 arch/x86/include/asm/pvclock.h                  |    1 +
 arch/x86/include/asm/smp.h                      |    9 +-
 arch/x86/include/asm/smpboot_hooks.h            |    2 +-
 arch/x86/include/asm/trampoline.h               |    5 +-
 arch/x86/kernel/Makefile                        |    2 +
 arch/x86/kernel/acpi/boot.c                     |   14 +-
 arch/x86/kernel/amd_iommu.c                     |    4 +-
 arch/x86/kernel/amd_iommu_init.c                |   67 +++++---
 arch/x86/kernel/apic/apic.c                     |    8 +
 arch/x86/kernel/apic/io_apic.c                  |   14 ++-
 arch/x86/kernel/apic/probe_64.c                 |    7 -
 arch/x86/kernel/cpu/amd.c                       |    3 +-
 arch/x86/kernel/cpu/common.c                    |    4 +-
 arch/x86/kernel/cpu/cpu.h                       |    1 +
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c      |    1 +
 arch/x86/kernel/cpu/intel.c                     |    1 +
 arch/x86/kernel/cpu/mcheck/mce_amd.c            |    9 +-
 arch/x86/kernel/cpu/mtrr/cleanup.c              |    2 +-
 arch/x86/kernel/cpu/mtrr/main.c                 |   10 +-
 arch/x86/kernel/crash_dump_64.c                 |    3 +-
 arch/x86/kernel/e820.c                          |   10 +-
 arch/x86/kernel/early-quirks.c                  |   21 ++-
 arch/x86/kernel/head_32.S                       |    8 +-
 arch/x86/kernel/hpet.c                          |    2 +-
 arch/x86/kernel/hw_breakpoint.c                 |    4 +
 arch/x86/kernel/olpc.c                          |    5 +-
 arch/x86/kernel/pvclock.c                       |    5 +
 arch/x86/kernel/reboot.c                        |    2 +-
 arch/x86/kernel/setup.c                         |    2 +
 arch/x86/kernel/smp.c                           |   15 +-
 arch/x86/kernel/smpboot.c                       |  117 +++++++++++---
 arch/x86/kernel/trampoline.c                    |   17 ++
 arch/x86/kvm/x86.c                              |    2 +-
 arch/x86/mm/fault.c                             |    7 +
 arch/x86/mm/srat_64.c                           |    8 +-
 arch/x86/vdso/Makefile                          |    4 +-
 arch/x86/xen/enlighten.c                        |    4 -
 arch/x86/xen/smp.c                              |    6 +-
 arch/x86/xen/time.c                             |    2 +
 block/blk-map.c                                 |    2 +
 block/blk-settings.c                            |    2 +-
 block/bsg.c                                     |    2 +-
 block/cfq-iosched.c                             |    4 +
 block/scsi_ioctl.c                              |   34 +++-
 drivers/acpi/acpica/aclocal.h                   |    1 +
 drivers/acpi/acpica/dswexec.c                   |   19 ++-
 drivers/acpi/blacklist.c                        |   16 ++
 drivers/acpi/ec.c                               |    3 +
 drivers/ata/ahci.c                              |    5 +
 drivers/ata/libata-core.c                       |   24 ++-
 drivers/ata/libata-scsi.c                       |    5 +-
 drivers/ata/pata_mpc52xx.c                      |    2 +-
 drivers/block/pktcdvd.c                         |    2 +-
 drivers/bluetooth/hci_ldisc.c                   |    7 +
 drivers/char/hpet.c                             |   17 ++
 drivers/char/hvc_iucv.c                         |    6 +-
 drivers/char/mem.c                              |    3 +-
 drivers/char/pcmcia/synclink_cs.c               |    2 +
 drivers/char/tpm/tpm.c                          |   28 +++-
 drivers/char/tpm/tpm.h                          |    2 +
 drivers/char/tpm/tpm_tis.c                      |   28 +++-
 drivers/char/tty_buffer.c                       |   14 ++-
 drivers/char/tty_ldisc.c                        |   51 +++++-
 drivers/char/vt_ioctl.c                         |   11 +-
 drivers/crypto/padlock-aes.c                    |    2 +-
 drivers/dma/mv_xor.c                            |    4 +-
 drivers/edac/amd64_edac.c                       |    2 +-
 drivers/firewire/core-card.c                    |   11 +-
 drivers/firewire/ohci.c                         |   64 ++++++--
 drivers/gpu/drm/Kconfig                         |    3 +
 drivers/gpu/drm/drm_crtc.c                      |   10 +-
 drivers/gpu/drm/drm_irq.c                       |    3 +-
 drivers/gpu/drm/i915/intel_lvds.c               |    8 +
 drivers/gpu/drm/radeon/atombios_dp.c            |    4 +-
 drivers/gpu/drm/radeon/radeon_atombios.c        |   16 ++-
 drivers/gpu/drm/radeon/radeon_display.c         |    6 +-
 drivers/gpu/drm/ttm/ttm_bo.c                    |   84 ++++++++--
 drivers/gpu/drm/ttm/ttm_bo_util.c               |    1 +
 drivers/hwmon/adm1026.c                         |   20 +-
 drivers/hwmon/f71882fg.c                        |    2 +-
 drivers/hwmon/lm85.c                            |    1 +
 drivers/hwmon/via686a.c                         |   14 ++-
 drivers/i2c/i2c-core.c                          |   14 ++-
 drivers/infiniband/core/cm.c                    |    1 +
 drivers/infiniband/core/cma.c                   |   15 ++
 drivers/infiniband/core/uverbs_cmd.c            |  101 +++++++-----
 drivers/infiniband/hw/cxgb3/iwch_cm.c           |    6 +-
 drivers/input/joydev.c                          |    3 +
 drivers/input/mouse/bcm5974.c                   |   40 +++++
 drivers/isdn/hisax/config.c                     |   18 ++-
 drivers/isdn/hisax/hisax.h                      |    1 +
 drivers/leds/leds-ss4200.c                      |    1 +
 drivers/md/dm-mpath.c                           |   12 --
 drivers/md/dm.c                                 |    5 +-
 drivers/md/md.c                                 |   19 ++-
 drivers/md/raid1.c                              |    1 +
 drivers/media/dvb/dvb-usb/dib0700_devices.c     |   21 ++-
 drivers/media/dvb/frontends/dib7000m.c          |   19 ++
 drivers/media/dvb/frontends/dib7000m.h          |   15 ++
 drivers/media/dvb/ttpci/av7110_ca.c             |    2 +-
 drivers/media/radio/radio-aimslab.c             |   24 +--
 drivers/media/video/cx231xx/cx231xx-cards.c     |   14 +-
 drivers/media/video/em28xx/em28xx-cards.c       |    4 +-
 drivers/media/video/ivtv/ivtvfb.c               |    2 +
 drivers/media/video/v4l2-compat-ioctl32.c       |   32 +++--
 drivers/message/fusion/mptctl.c                 |    8 +
 drivers/message/fusion/mptscsih.c               |    9 +-
 drivers/mfd/ucb1x00-ts.c                        |   12 +-
 drivers/misc/sgi-xp/xpc_partition.c             |   25 ++-
 drivers/misc/sgi-xp/xpc_uv.c                    |   17 ++
 drivers/mmc/host/sdhci-s3c.c                    |    6 +-
 drivers/mtd/chips/jedec_probe.c                 |   32 ++--
 drivers/mtd/nand/omap2.c                        |    2 +-
 drivers/mtd/onenand/generic.c                   |    2 +-
 drivers/mtd/onenand/omap2.c                     |    2 +-
 drivers/net/atlx/atl1.c                         |    5 +-
 drivers/net/b44.c                               |    4 +-
 drivers/net/benet/be.h                          |    2 +
 drivers/net/benet/be_main.c                     |   18 +-
 drivers/net/bnx2.c                              |   20 ++-
 drivers/net/e1000e/netdev.c                     |    3 +-
 drivers/net/igb/igb_main.c                      |    2 +-
 drivers/net/ixgbe/ixgbe_main.c                  |    5 +
 drivers/net/netxen/netxen_nic_init.c            |    3 -
 drivers/net/r6040.c                             |   12 +-
 drivers/net/r8169.c                             |   12 +-
 drivers/net/wireless/ath/ath9k/hw.c             |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c          |   15 ++-
 drivers/net/wireless/iwlwifi/iwl-helpers.h      |    6 +
 drivers/net/wireless/orinoco/main.c             |    6 +
 drivers/net/wireless/orinoco/wext.c             |    4 +-
 drivers/net/wireless/p54/eeprom.c               |    4 +-
 drivers/net/wireless/p54/p54pci.c               |   14 +-
 drivers/net/wireless/p54/p54usb.c               |   22 +++-
 drivers/net/wireless/p54/txrx.c                 |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c           |    1 +
 drivers/pci/dmar.c                              |    5 +
 drivers/pci/pci-stub.c                          |    3 +
 drivers/pci/pci-sysfs.c                         |   22 ++-
 drivers/pci/pci.h                               |    7 +-
 drivers/pci/proc.c                              |    2 +-
 drivers/pci/quirks.c                            |   43 +++++
 drivers/platform/x86/acer-wmi.c                 |    4 +-
 drivers/platform/x86/asus_acpi.c                |    8 +-
 drivers/platform/x86/tc1100-wmi.c               |    2 +-
 drivers/platform/x86/wmi.c                      |    2 +-
 drivers/power/ds2760_battery.c                  |    2 +-
 drivers/power/olpc_battery.c                    |    8 +-
 drivers/rtc/rtc-cmos.c                          |   16 +-
 drivers/s390/char/keyboard.c                    |    3 +-
 drivers/s390/cio/qdio.h                         |    6 +
 drivers/s390/cio/qdio_main.c                    |   43 +++--
 drivers/scsi/bfa/bfa_core.c                     |   22 +++
 drivers/scsi/device_handler/scsi_dh_alua.c      |    2 +
 drivers/scsi/gdth.c                             |    8 +
 drivers/scsi/libsas/sas_ata.c                   |    1 +
 drivers/scsi/libsas/sas_scsi_host.c             |    1 +
 drivers/scsi/mpt2sas/mpt2sas_base.c             |   24 ++-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c            |    4 +-
 drivers/scsi/scsi_lib.c                         |    3 +-
 drivers/scsi/scsi_sysfs.c                       |    3 +-
 drivers/scsi/sd.c                               |   24 ++-
 drivers/serial/8250.c                           |    3 +-
 drivers/ssb/b43_pci_bridge.c                    |    1 +
 drivers/ssb/driver_chipcommon_pmu.c             |   17 +-
 drivers/ssb/pci.c                               |   20 +--
 drivers/ssb/pcmcia.c                            |    2 +-
 drivers/staging/asus_oled/asus_oled.c           |    8 +-
 drivers/staging/comedi/drivers/jr3_pci.c        |    7 +
 drivers/staging/comedi/drivers/ni_labpc.c       |    3 +-
 drivers/staging/frontier/tranzport.c            |    2 +-
 drivers/staging/hv/blkvsc_drv.c                 |    1 +
 drivers/staging/hv/netvsc_drv.c                 |    1 +
 drivers/staging/line6/control.c                 |  204 +++++++++++-----------
 drivers/staging/line6/midi.c                    |    4 +-
 drivers/staging/line6/pod.c                     |   32 ++--
 drivers/staging/line6/toneport.c                |    4 +-
 drivers/staging/line6/variax.c                  |   12 +-
 drivers/staging/rt2860/chips/rt3090.c           |    3 +-
 drivers/staging/rt2860/chips/rt30xx.c           |    4 +-
 drivers/staging/rt2860/rt_main_dev.c            |    2 -
 drivers/staging/rt2860/usb_main_dev.c           |    1 +
 drivers/staging/rtl8187se/r8185b_init.c         |   30 +++-
 drivers/staging/samsung-laptop/samsung-laptop.c |    2 +-
 drivers/staging/usbip/usbip_event.c             |   16 +--
 drivers/staging/usbip/vhci.h                    |    6 +-
 drivers/staging/usbip/vhci_hcd.c                |   70 ++++++---
 drivers/staging/usbip/vhci_rx.c                 |   15 +-
 drivers/usb/atm/ueagle-atm.c                    |    6 +-
 drivers/usb/core/devio.c                        |    7 +-
 drivers/usb/core/file.c                         |   35 ++--
 drivers/usb/core/hub.c                          |   35 ++++-
 drivers/usb/core/message.c                      |   15 +-
 drivers/usb/core/quirks.c                       |    8 +
 drivers/usb/gadget/atmel_usba_udc.c             |    3 +
 drivers/usb/gadget/printer.c                    |   14 +-
 drivers/usb/host/ehci-hcd.c                     |   29 ++--
 drivers/usb/host/isp1760-hcd.c                  |   22 ++-
 drivers/usb/host/isp1760-hcd.h                  |    1 +
 drivers/usb/host/xhci-ring.c                    |   50 ++++--
 drivers/usb/misc/cypress_cy7c63.c               |    6 +-
 drivers/usb/misc/iowarrior.c                    |    3 +-
 drivers/usb/misc/sisusbvga/sisusb.c             |    1 +
 drivers/usb/misc/trancevibrator.c               |    2 +-
 drivers/usb/misc/usbled.c                       |    2 +-
 drivers/usb/misc/usbsevseg.c                    |   10 +-
 drivers/usb/misc/uss720.c                       |    4 +-
 drivers/usb/musb/blackfin.c                     |    4 +-
 drivers/usb/musb/omap2430.c                     |    1 +
 drivers/usb/serial/ch341.c                      |   11 ++
 drivers/usb/serial/cp210x.c                     |   18 +--
 drivers/usb/serial/digi_acceleport.c            |   10 -
 drivers/usb/serial/ftdi_sio.c                   |   76 ++++++++-
 drivers/usb/serial/ftdi_sio_ids.h               |   64 +++++++-
 drivers/usb/serial/generic.c                    |   20 +++
 drivers/usb/serial/io_edgeport.c                |    4 +-
 drivers/usb/serial/keyspan_pda.c                |   17 --
 drivers/usb/serial/kobil_sct.c                  |    2 +-
 drivers/usb/serial/opticon.c                    |    6 +-
 drivers/usb/serial/option.c                     |   25 +++-
 drivers/usb/serial/pl2303.c                     |   13 ++
 drivers/usb/serial/pl2303.h                     |    2 +
 drivers/usb/serial/sierra.c                     |    3 +
 drivers/usb/serial/spcp8x5.c                    |    6 +-
 drivers/usb/serial/ti_usb_3410_5052.c           |    2 +-
 drivers/usb/serial/visor.c                      |   12 ++
 drivers/usb/storage/sierra_ms.c                 |    2 +-
 drivers/usb/storage/unusual_cypress.h           |    5 +
 drivers/usb/storage/unusual_devs.h              |   39 +++++
 drivers/video/backlight/backlight.c             |   12 +-
 drivers/video/efifb.c                           |   61 ++++++--
 drivers/video/sis/sis_main.c                    |    3 +
 drivers/video/via/accel.c                       |    7 +-
 drivers/video/via/ioctl.c                       |    2 +
 drivers/virtio/virtio_pci.c                     |   21 +--
 drivers/xen/events.c                            |    2 +-
 fs/aio.c                                        |    3 +
 fs/bio.c                                        |   23 +++-
 fs/btrfs/super.c                                |    5 +-
 fs/char_dev.c                                   |    4 +-
 fs/cifs/cifsproto.h                             |    2 +-
 fs/cifs/cifssmb.c                               |    4 +-
 fs/cifs/file.c                                  |   17 +-
 fs/ecryptfs/inode.c                             |    6 +
 fs/eventpoll.c                                  |   95 +++++++++++
 fs/exec.c                                       |   19 ++
 fs/ext2/namei.c                                 |    9 +-
 fs/ext4/balloc.c                                |    3 -
 fs/ext4/ext4.h                                  |    2 +
 fs/ext4/extents.c                               |    9 +-
 fs/ext4/mballoc.h                               |    2 -
 fs/file_table.c                                 |    2 +-
 fs/fuse/file.c                                  |  134 ++++++++++++++--
 fs/fuse/fuse_i.h                                |    6 +-
 fs/nfs/direct.c                                 |   34 +++--
 fs/nfs/file.c                                   |    4 +-
 fs/nfs/mount_clnt.c                             |    4 +-
 fs/nfsd/nfs3xdr.c                               |    6 +-
 fs/nfsd/nfs4xdr.c                               |   12 +-
 fs/nfsd/vfs.c                                   |    2 +-
 fs/nfsd/xdr4.h                                  |   21 +--
 fs/notify/inotify/inotify_user.c                |    7 +-
 fs/ocfs2/refcounttree.c                         |    7 +-
 fs/ocfs2/stack_user.c                           |    2 +-
 fs/ocfs2/symlink.c                              |    2 +-
 fs/partitions/ldm.c                             |    5 +
 fs/partitions/mac.c                             |   17 +-
 fs/pipe.c                                       |    2 +-
 fs/proc/array.c                                 |    5 +-
 fs/proc/task_mmu.c                              |    8 +-
 fs/reiserfs/ioctl.c                             |    7 +-
 fs/reiserfs/xattr_acl.c                         |    6 +-
 fs/xfs/linux-2.6/xfs_ioctl.c                    |    2 +
 include/drm/drmP.h                              |    2 +-
 include/drm/drm_pciids.h                        |    3 +-
 include/drm/ttm/ttm_bo_api.h                    |    4 +-
 include/keys/rxrpc-type.h                       |    1 -
 include/linux/blkdev.h                          |    4 +-
 include/linux/compat.h                          |    2 +
 include/linux/cred.h                            |   21 +---
 include/linux/ftrace.h                          |    2 +
 include/linux/ieee80211.h                       |    2 +-
 include/linux/klist.h                           |    2 +-
 include/linux/mmzone.h                          |   13 ++
 include/linux/netdevice.h                       |    4 +
 include/linux/pci_ids.h                         |    4 +
 include/linux/ssb/ssb.h                         |    5 +-
 include/linux/ssb/ssb_driver_chipcommon.h       |   15 ++-
 include/linux/usb/serial.h                      |    3 +
 include/linux/vmstat.h                          |   22 +++
 include/net/sctp/sm.h                           |    1 +
 include/net/sctp/structs.h                      |    3 +
 include/net/sock.h                              |    1 +
 include/net/udp.h                               |    1 +
 include/net/x25.h                               |    4 +
 init/calibrate.c                                |    6 +-
 ipc/compat.c                                    |    6 +
 ipc/compat_mq.c                                 |    5 +
 ipc/sem.c                                       |    2 +
 ipc/shm.c                                       |    1 +
 kernel/compat.c                                 |   21 +++
 kernel/cpuset.c                                 |    7 +-
 kernel/cred.c                                   |   41 ++++-
 kernel/exit.c                                   |   22 ++-
 kernel/futex.c                                  |   31 ++--
 kernel/hrtimer.c                                |   13 ++-
 kernel/hw_breakpoint.c                          |    3 +-
 kernel/irq/manage.c                             |    2 +-
 kernel/irq/proc.c                               |    2 +-
 kernel/latencytop.c                             |   17 +-
 kernel/power/snapshot.c                         |    7 +-
 kernel/power/user.c                             |    2 +-
 kernel/printk.c                                 |    2 +
 kernel/ptrace.c                                 |    2 +-
 kernel/sched.c                                  |   17 +-
 kernel/signal.c                                 |   43 ++++--
 kernel/smp.c                                    |   30 ++++
 kernel/sys.c                                    |    2 +
 kernel/time/tick-broadcast.c                    |   10 +
 kernel/time/tick-common.c                       |    6 +-
 kernel/time/tick-internal.h                     |    3 +
 kernel/timer.c                                  |    6 +
 kernel/trace/ftrace.c                           |   52 +++++-
 kernel/trace/ring_buffer.c                      |    2 +-
 kernel/trace/trace.c                            |   10 +-
 lib/percpu_counter.c                            |    1 +
 mm/filemap.c                                    |    3 +
 mm/internal.h                                   |    2 +-
 mm/memory.c                                     |   32 +++-
 mm/memory_hotplug.c                             |    2 +-
 mm/mempolicy.c                                  |    2 +-
 mm/mlock.c                                      |    8 +
 mm/mmap.c                                       |   16 ++-
 mm/mmzone.c                                     |   21 +++
 mm/mprotect.c                                   |    2 +-
 mm/mremap.c                                     |    4 +-
 mm/nommu.c                                      |    1 +
 mm/page_alloc.c                                 |   33 +++-
 mm/percpu.c                                     |    2 +-
 mm/swapfile.c                                   |    6 +-
 mm/vmalloc.c                                    |    9 +
 mm/vmscan.c                                     |   53 +++++-
 mm/vmstat.c                                     |   15 ++-
 net/can/bcm.c                                   |    2 +-
 net/compat.c                                    |   10 +-
 net/core/dev.c                                  |   20 ++-
 net/core/ethtool.c                              |    4 +-
 net/core/iovec.c                                |   17 +-
 net/core/rtnetlink.c                            |    3 +
 net/core/stream.c                               |    8 +-
 net/dccp/input.c                                |    7 +-
 net/decnet/af_decnet.c                          |    2 +
 net/econet/af_econet.c                          |   91 +++++------
 net/ipv4/datagram.c                             |    5 +-
 net/ipv4/inet_timewait_sock.c                   |    2 +
 net/ipv4/ip_gre.c                               |    1 +
 net/ipv4/ip_output.c                            |   19 ++-
 net/ipv4/ipip.c                                 |    1 +
 net/ipv4/route.c                                |    7 +-
 net/ipv4/tcp.c                                  |   11 +-
 net/ipv4/tcp_input.c                            |    2 +
 net/ipv4/udp.c                                  |   44 +++++
 net/ipv4/xfrm4_policy.c                         |    4 +-
 net/ipv6/datagram.c                             |    7 +-
 net/ipv6/ip6_output.c                           |   18 ++-
 net/ipv6/route.c                                |   28 +++-
 net/ipv6/sit.c                                  |    2 +-
 net/ipv6/udp.c                                  |   10 +
 net/irda/iriap.c                                |    3 +-
 net/irda/parameters.c                           |    4 +-
 net/mac80211/rx.c                               |    4 -
 net/netfilter/nf_conntrack_core.c               |    3 +-
 net/netfilter/nf_log.c                          |    4 +
 net/phonet/pep.c                                |    3 +-
 net/rds/page.c                                  |   27 +---
 net/rds/rdma.c                                  |    2 +-
 net/rose/af_rose.c                              |    4 +-
 net/sctp/auth.c                                 |    8 +-
 net/sctp/input.c                                |   22 ++-
 net/sctp/output.c                               |    1 -
 net/sctp/sm_sideeffect.c                        |   35 ++++
 net/sctp/transport.c                            |    2 +
 net/socket.c                                    |    4 +
 net/sunrpc/cache.c                              |    4 +-
 net/sunrpc/svc_xprt.c                           |    9 +-
 net/wireless/wext-priv.c                        |    2 +-
 net/x25/af_x25.c                                |   47 +++++-
 net/x25/x25_facilities.c                        |   32 +++-
 net/x25/x25_in.c                                |   17 ++-
 net/x25/x25_link.c                              |    4 +
 security/integrity/ima/ima_policy.c             |    2 +
 security/keys/keyctl.c                          |    6 +-
 security/selinux/hooks.c                        |   11 +-
 security/selinux/nlmsgtab.c                     |    2 +
 sound/core/control.c                            |    5 +
 sound/core/hrtimer.c                            |    5 +-
 sound/core/rawmidi.c                            |    4 +-
 sound/oss/soundcard.c                           |    4 +-
 sound/pci/au88x0/au88x0_pcm.c                   |   24 +++-
 sound/pci/hda/hda_eld.c                         |    2 +-
 sound/pci/hda/hda_intel.c                       |    2 +
 sound/pci/hda/patch_analog.c                    |    1 +
 sound/pci/hda/patch_conexant.c                  |    8 +-
 sound/pci/hda/patch_realtek.c                   |   22 ++-
 sound/pci/hda/patch_sigmatel.c                  |    2 +
 sound/pci/intel8x0.c                            |    6 +
 sound/pci/oxygen/oxygen.c                       |    4 +
 sound/pci/rme9652/hdsp.c                        |    1 +
 sound/pci/rme9652/hdspm.c                       |    1 +
 sound/soc/blackfin/bf5xx-ac97.c                 |    4 +-
 sound/soc/codecs/wm8990.c                       |   10 +-
 sound/usb/caiaq/audio.c                         |    2 +-
 sound/usb/caiaq/midi.c                          |    2 +-
 sound/usb/usx2y/us122l.c                        |   41 +++---
 454 files changed, 3937 insertions(+), 1490 deletions(-)
