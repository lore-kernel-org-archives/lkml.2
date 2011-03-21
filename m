Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab1CUUlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 16:41:46 -0400
Received: from kroah.org ([198.145.64.141]:49003 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439Ab1CUUll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 16:41:41 -0400
Date: Mon, 21 Mar 2011 13:41:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.33.8
Message-ID: <20110321204104.GA2702@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.33.8 kernel.

This is primarily for the use of those people who are stuck using the
.33-rt kernel.  Anyone else who really wants to use the .33 kernel tree
is welcome to use this one as well.

I'll be maintaining it for a while longer as it looks like the -rt tree
isn't moving forward to any newer kernel any time soon.

The updated 2.6.33.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.33.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.33.y.git;a=summary

thanks,

greg k-h

------------

 MAINTAINERS                                     |    6 
 Makefile                                        |    2 
 arch/arm/include/asm/assembler.h                |    2 
 arch/arm/kernel/signal.c                        |    4 
 arch/arm/lib/findbit.S                          |    6 
 arch/ia64/include/asm/compat.h                  |    2 
 arch/ia64/kernel/fsys.S                         |   30 ++-
 arch/mips/alchemy/mtx-1/platform.c              |    9 +
 arch/mips/include/asm/compat.h                  |    2 
 arch/parisc/include/asm/compat.h                |    2 
 arch/powerpc/include/asm/compat.h               |    2 
 arch/powerpc/include/asm/hvcall.h               |    1 
 arch/powerpc/include/asm/reg.h                  |    1 
 arch/powerpc/kernel/cpu_setup_6xx.S             |   40 ++--
 arch/powerpc/kernel/crash.c                     |   11 +
 arch/powerpc/kernel/machine_kexec_64.c          |   25 ++
 arch/powerpc/kernel/perf_event.c                |   24 ++
 arch/powerpc/kernel/ppc970-pmu.c                |    2 
 arch/powerpc/kernel/setup_64.c                  |   17 +-
 arch/powerpc/platforms/pseries/hvCall.S         |   38 ++++
 arch/powerpc/platforms/pseries/lpar.c           |   70 ++++++--
 arch/powerpc/platforms/pseries/plpar_wrappers.h |   18 ++
 arch/powerpc/sysdev/fsl_rio.c                   |    1 
 arch/s390/include/asm/compat.h                  |    2 
 arch/s390/include/asm/processor.h               |    5 
 arch/s390/include/asm/vdso.h                    |    2 
 arch/s390/kernel/traps.c                        |   37 ----
 arch/s390/kernel/vtime.c                        |   19 ++
 arch/sparc/include/asm/compat.h                 |    2 
 arch/um/drivers/ubd_kern.c                      |    9 -
 arch/um/kernel/uml.lds.S                        |    2 
 arch/um/os-Linux/time.c                         |    2 
 arch/x86/ia32/ia32entry.S                       |   22 +-
 arch/x86/include/asm/acpi.h                     |    1 
 arch/x86/include/asm/amd_iommu_proto.h          |    6 
 arch/x86/include/asm/amd_iommu_types.h          |   12 +
 arch/x86/include/asm/compat.h                   |    2 
 arch/x86/include/asm/cpufeature.h               |    2 
 arch/x86/include/asm/io.h                       |    1 
 arch/x86/include/asm/mmu_context.h              |    5 
 arch/x86/include/asm/pgtable-3level.h           |   11 -
 arch/x86/include/asm/pgtable_32.h               |    1 
 arch/x86/include/asm/processor.h                |   23 --
 arch/x86/include/asm/pvclock.h                  |    1 
 arch/x86/include/asm/smp.h                      |    9 -
 arch/x86/include/asm/smpboot_hooks.h            |    2 
 arch/x86/include/asm/trampoline.h               |    5 
 arch/x86/kernel/Makefile                        |    2 
 arch/x86/kernel/acpi/boot.c                     |   14 +
 arch/x86/kernel/amd_iommu.c                     |    4 
 arch/x86/kernel/amd_iommu_init.c                |   67 +++++--
 arch/x86/kernel/apic/apic.c                     |    8 
 arch/x86/kernel/apic/io_apic.c                  |   14 +
 arch/x86/kernel/apic/probe_64.c                 |    7 
 arch/x86/kernel/cpu/amd.c                       |    3 
 arch/x86/kernel/cpu/common.c                    |    4 
 arch/x86/kernel/cpu/cpu.h                       |    1 
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c      |    1 
 arch/x86/kernel/cpu/intel.c                     |    1 
 arch/x86/kernel/cpu/mcheck/mce_amd.c            |    9 -
 arch/x86/kernel/cpu/mtrr/cleanup.c              |    2 
 arch/x86/kernel/cpu/mtrr/main.c                 |   10 +
 arch/x86/kernel/crash_dump_64.c                 |    3 
 arch/x86/kernel/e820.c                          |   10 -
 arch/x86/kernel/early-quirks.c                  |   21 +-
 arch/x86/kernel/head_32.S                       |    8 
 arch/x86/kernel/hpet.c                          |    2 
 arch/x86/kernel/hw_breakpoint.c                 |    4 
 arch/x86/kernel/olpc.c                          |    5 
 arch/x86/kernel/pvclock.c                       |    5 
 arch/x86/kernel/reboot.c                        |    2 
 arch/x86/kernel/setup.c                         |    2 
 arch/x86/kernel/smp.c                           |   15 +
 arch/x86/kernel/smpboot.c                       |  117 +++++++++++--
 arch/x86/kernel/trampoline.c                    |   17 ++
 arch/x86/kvm/x86.c                              |    2 
 arch/x86/mm/fault.c                             |    7 
 arch/x86/mm/pgtable.c                           |    3 
 arch/x86/mm/srat_64.c                           |    8 
 arch/x86/vdso/Makefile                          |    4 
 arch/x86/xen/enlighten.c                        |    4 
 arch/x86/xen/smp.c                              |    6 
 arch/x86/xen/time.c                             |    2 
 block/blk-map.c                                 |    2 
 block/blk-settings.c                            |    2 
 block/bsg.c                                     |    2 
 block/cfq-iosched.c                             |    4 
 block/scsi_ioctl.c                              |   34 ++--
 drivers/acpi/acpica/aclocal.h                   |    1 
 drivers/acpi/acpica/dswexec.c                   |   19 ++
 drivers/acpi/blacklist.c                        |   16 +
 drivers/acpi/ec.c                               |    3 
 drivers/ata/ahci.c                              |    5 
 drivers/ata/libata-core.c                       |   24 +-
 drivers/ata/libata-scsi.c                       |    5 
 drivers/ata/pata_mpc52xx.c                      |    2 
 drivers/block/pktcdvd.c                         |    2 
 drivers/bluetooth/hci_ldisc.c                   |    7 
 drivers/char/hpet.c                             |   17 ++
 drivers/char/hvc_iucv.c                         |    6 
 drivers/char/mem.c                              |    3 
 drivers/char/pcmcia/synclink_cs.c               |    2 
 drivers/char/tpm/tpm.c                          |   10 -
 drivers/char/tpm/tpm_tis.c                      |   24 ++
 drivers/char/tty_buffer.c                       |   14 +
 drivers/char/tty_ldisc.c                        |   51 +++++-
 drivers/char/vt_ioctl.c                         |   11 -
 drivers/crypto/padlock-aes.c                    |    2 
 drivers/dma/mv_xor.c                            |    4 
 drivers/edac/amd64_edac.c                       |    2 
 drivers/firewire/core-card.c                    |   11 +
 drivers/firewire/ohci.c                         |   60 +++++--
 drivers/gpu/drm/Kconfig                         |    3 
 drivers/gpu/drm/drm_crtc.c                      |   10 -
 drivers/gpu/drm/drm_irq.c                       |    3 
 drivers/gpu/drm/i915/intel_lvds.c               |    8 
 drivers/gpu/drm/radeon/atombios_dp.c            |    4 
 drivers/gpu/drm/radeon/radeon_atombios.c        |   16 +
 drivers/gpu/drm/radeon/radeon_display.c         |    6 
 drivers/gpu/drm/ttm/ttm_bo.c                    |   84 ++++++++-
 drivers/gpu/drm/ttm/ttm_bo_util.c               |    1 
 drivers/hwmon/adm1026.c                         |   20 +-
 drivers/hwmon/f71882fg.c                        |    2 
 drivers/hwmon/lm85.c                            |    1 
 drivers/hwmon/via686a.c                         |   14 +
 drivers/i2c/i2c-core.c                          |   14 +
 drivers/infiniband/core/cm.c                    |    1 
 drivers/infiniband/core/cma.c                   |   15 +
 drivers/infiniband/core/uverbs_cmd.c            |   99 ++++++-----
 drivers/infiniband/hw/cxgb3/iwch_cm.c           |    6 
 drivers/input/joydev.c                          |    3 
 drivers/input/mouse/bcm5974.c                   |   40 ++++
 drivers/isdn/hisax/config.c                     |   18 +-
 drivers/isdn/hisax/hisax.h                      |    1 
 drivers/isdn/i4l/isdn_tty.c                     |    6 
 drivers/leds/leds-ss4200.c                      |    1 
 drivers/md/dm-mpath.c                           |   12 -
 drivers/md/dm.c                                 |    5 
 drivers/md/md.c                                 |   19 +-
 drivers/md/raid1.c                              |    1 
 drivers/media/dvb/dvb-usb/dib0700_devices.c     |   21 ++
 drivers/media/dvb/frontends/dib7000m.c          |   19 ++
 drivers/media/dvb/frontends/dib7000m.h          |   15 +
 drivers/media/dvb/ttpci/av7110_ca.c             |    2 
 drivers/media/radio/radio-aimslab.c             |   24 --
 drivers/media/video/cx231xx/cx231xx-cards.c     |   14 -
 drivers/media/video/em28xx/em28xx-cards.c       |    4 
 drivers/media/video/ivtv/ivtvfb.c               |    2 
 drivers/media/video/v4l2-compat-ioctl32.c       |   32 ++-
 drivers/message/fusion/mptctl.c                 |    8 
 drivers/message/fusion/mptscsih.c               |    9 -
 drivers/mfd/ucb1x00-ts.c                        |   12 +
 drivers/misc/sgi-xp/xpc_partition.c             |   25 +-
 drivers/misc/sgi-xp/xpc_uv.c                    |   17 ++
 drivers/mmc/host/sdhci-s3c.c                    |    6 
 drivers/mtd/chips/jedec_probe.c                 |   32 +--
 drivers/mtd/nand/omap2.c                        |    2 
 drivers/mtd/onenand/generic.c                   |    2 
 drivers/mtd/onenand/omap2.c                     |    2 
 drivers/net/atlx/atl1.c                         |    5 
 drivers/net/b44.c                               |    4 
 drivers/net/benet/be.h                          |    2 
 drivers/net/benet/be_main.c                     |   18 +-
 drivers/net/bnx2.c                              |   20 ++
 drivers/net/e1000e/netdev.c                     |    3 
 drivers/net/igb/igb_main.c                      |    2 
 drivers/net/ixgbe/ixgbe_main.c                  |    5 
 drivers/net/netxen/netxen_nic_init.c            |    3 
 drivers/net/r6040.c                             |   12 -
 drivers/net/r8169.c                             |   12 +
 drivers/net/wireless/ath/ath9k/hw.c             |    4 
 drivers/net/wireless/iwlwifi/iwl-agn.c          |   15 +
 drivers/net/wireless/iwlwifi/iwl-helpers.h      |    6 
 drivers/net/wireless/orinoco/main.c             |    6 
 drivers/net/wireless/orinoco/wext.c             |    4 
 drivers/net/wireless/p54/eeprom.c               |    4 
 drivers/net/wireless/p54/p54pci.c               |   14 +
 drivers/net/wireless/p54/p54usb.c               |   22 ++
 drivers/net/wireless/p54/txrx.c                 |    2 
 drivers/net/wireless/rt2x00/rt73usb.c           |    1 
 drivers/pci/dmar.c                              |    5 
 drivers/pci/pci-stub.c                          |    3 
 drivers/pci/pci-sysfs.c                         |   24 ++
 drivers/pci/pci.h                               |    7 
 drivers/pci/proc.c                              |    2 
 drivers/pci/quirks.c                            |  156 +++++++++++-------
 drivers/platform/x86/acer-wmi.c                 |    4 
 drivers/platform/x86/asus_acpi.c                |    8 
 drivers/platform/x86/tc1100-wmi.c               |    2 
 drivers/platform/x86/wmi.c                      |    2 
 drivers/power/ds2760_battery.c                  |    2 
 drivers/power/olpc_battery.c                    |    8 
 drivers/rtc/rtc-cmos.c                          |   16 +
 drivers/s390/char/keyboard.c                    |    3 
 drivers/s390/cio/qdio.h                         |    6 
 drivers/s390/cio/qdio_main.c                    |   43 +++--
 drivers/scsi/bfa/bfa_core.c                     |   22 ++
 drivers/scsi/device_handler/scsi_dh_alua.c      |    5 
 drivers/scsi/gdth.c                             |    8 
 drivers/scsi/libsas/sas_ata.c                   |    1 
 drivers/scsi/libsas/sas_scsi_host.c             |    1 
 drivers/scsi/mpt2sas/mpt2sas_base.c             |   24 ++
 drivers/scsi/mpt2sas/mpt2sas_scsih.c            |    4 
 drivers/scsi/scsi_lib.c                         |    3 
 drivers/scsi/scsi_sysfs.c                       |    3 
 drivers/scsi/sd.c                               |   24 ++
 drivers/serial/8250.c                           |    3 
 drivers/ssb/b43_pci_bridge.c                    |    1 
 drivers/ssb/driver_chipcommon_pmu.c             |   17 +-
 drivers/ssb/pci.c                               |   20 --
 drivers/ssb/pcmcia.c                            |    2 
 drivers/staging/asus_oled/asus_oled.c           |    8 
 drivers/staging/comedi/drivers/jr3_pci.c        |    7 
 drivers/staging/comedi/drivers/ni_labpc.c       |    3 
 drivers/staging/frontier/tranzport.c            |    2 
 drivers/staging/hv/blkvsc_drv.c                 |    1 
 drivers/staging/line6/control.c                 |  204 ++++++++++++------------
 drivers/staging/line6/midi.c                    |    4 
 drivers/staging/line6/pod.c                     |   32 +--
 drivers/staging/line6/toneport.c                |    4 
 drivers/staging/line6/variax.c                  |   12 -
 drivers/staging/rt2860/chips/rt3090.c           |    3 
 drivers/staging/rt2860/chips/rt30xx.c           |    4 
 drivers/staging/rt2860/rt_main_dev.c            |    2 
 drivers/staging/rt2860/usb_main_dev.c           |    1 
 drivers/staging/rtl8187se/r8185b_init.c         |   30 ++-
 drivers/staging/samsung-laptop/samsung-laptop.c |    2 
 drivers/staging/usbip/usbip_event.c             |   16 -
 drivers/staging/usbip/vhci.h                    |    6 
 drivers/staging/usbip/vhci_hcd.c                |   70 +++++---
 drivers/staging/usbip/vhci_rx.c                 |   15 +
 drivers/usb/atm/ueagle-atm.c                    |    6 
 drivers/usb/core/devio.c                        |    7 
 drivers/usb/core/file.c                         |   35 +---
 drivers/usb/core/hub.c                          |   35 +++-
 drivers/usb/core/message.c                      |   15 -
 drivers/usb/core/quirks.c                       |    8 
 drivers/usb/gadget/atmel_usba_udc.c             |    3 
 drivers/usb/gadget/printer.c                    |   14 -
 drivers/usb/host/ehci-hcd.c                     |   29 ++-
 drivers/usb/host/isp1760-hcd.c                  |   22 +-
 drivers/usb/host/isp1760-hcd.h                  |    1 
 drivers/usb/host/xhci-ring.c                    |   50 ++++-
 drivers/usb/misc/cypress_cy7c63.c               |    6 
 drivers/usb/misc/iowarrior.c                    |    3 
 drivers/usb/misc/sisusbvga/sisusb.c             |    1 
 drivers/usb/misc/trancevibrator.c               |    2 
 drivers/usb/misc/usbled.c                       |    2 
 drivers/usb/misc/usbsevseg.c                    |   10 -
 drivers/usb/misc/uss720.c                       |    4 
 drivers/usb/musb/blackfin.c                     |    4 
 drivers/usb/musb/omap2430.c                     |    1 
 drivers/usb/serial/ch341.c                      |   11 +
 drivers/usb/serial/cp210x.c                     |   18 --
 drivers/usb/serial/digi_acceleport.c            |   10 -
 drivers/usb/serial/ftdi_sio.c                   |   76 ++++++++
 drivers/usb/serial/ftdi_sio_ids.h               |   64 ++++++-
 drivers/usb/serial/generic.c                    |   20 ++
 drivers/usb/serial/io_edgeport.c                |    4 
 drivers/usb/serial/keyspan_pda.c                |   17 --
 drivers/usb/serial/kobil_sct.c                  |    2 
 drivers/usb/serial/opticon.c                    |    6 
 drivers/usb/serial/option.c                     |   25 ++
 drivers/usb/serial/pl2303.c                     |   13 +
 drivers/usb/serial/pl2303.h                     |    2 
 drivers/usb/serial/sierra.c                     |    3 
 drivers/usb/serial/spcp8x5.c                    |    6 
 drivers/usb/serial/ti_usb_3410_5052.c           |    2 
 drivers/usb/serial/visor.c                      |   12 +
 drivers/usb/storage/sierra_ms.c                 |    2 
 drivers/usb/storage/unusual_cypress.h           |    5 
 drivers/usb/storage/unusual_devs.h              |   39 ++++
 drivers/video/backlight/backlight.c             |   12 -
 drivers/video/efifb.c                           |   61 +++++--
 drivers/video/sis/sis_main.c                    |    3 
 drivers/video/via/accel.c                       |    7 
 drivers/video/via/ioctl.c                       |    2 
 drivers/virtio/virtio_pci.c                     |   21 --
 drivers/xen/events.c                            |    2 
 fs/aio.c                                        |    3 
 fs/bio.c                                        |   23 ++
 fs/btrfs/super.c                                |    5 
 fs/char_dev.c                                   |    4 
 fs/cifs/cifsproto.h                             |    2 
 fs/cifs/cifssmb.c                               |    4 
 fs/cifs/file.c                                  |   17 +-
 fs/ecryptfs/inode.c                             |    6 
 fs/eventpoll.c                                  |   95 +++++++++++
 fs/exec.c                                       |   19 ++
 fs/ext2/namei.c                                 |    9 -
 fs/ext3/namei.c                                 |    2 
 fs/ext4/balloc.c                                |    3 
 fs/ext4/ext4.h                                  |    2 
 fs/ext4/extents.c                               |    9 -
 fs/ext4/mballoc.h                               |    2 
 fs/file_table.c                                 |    2 
 fs/fuse/file.c                                  |  134 ++++++++++++++-
 fs/fuse/fuse_i.h                                |    6 
 fs/nfs/direct.c                                 |   34 ++--
 fs/nfs/file.c                                   |    4 
 fs/nfs/mount_clnt.c                             |    4 
 fs/nfsd/nfs3xdr.c                               |    6 
 fs/nfsd/nfs4xdr.c                               |   12 -
 fs/nfsd/vfs.c                                   |    2 
 fs/nfsd/xdr4.h                                  |   21 +-
 fs/notify/inotify/inotify_user.c                |    7 
 fs/ocfs2/refcounttree.c                         |    7 
 fs/ocfs2/stack_user.c                           |    2 
 fs/ocfs2/symlink.c                              |    2 
 fs/partitions/ldm.c                             |    5 
 fs/partitions/mac.c                             |   17 +-
 fs/pipe.c                                       |    2 
 fs/proc/array.c                                 |    5 
 fs/proc/task_mmu.c                              |    8 
 fs/reiserfs/ioctl.c                             |    7 
 fs/reiserfs/xattr_acl.c                         |    6 
 fs/xfs/linux-2.6/xfs_ioctl.c                    |    2 
 include/drm/drmP.h                              |    2 
 include/drm/drm_pciids.h                        |    3 
 include/drm/ttm/ttm_bo_api.h                    |    4 
 include/keys/rxrpc-type.h                       |    1 
 include/linux/blkdev.h                          |    4 
 include/linux/compat.h                          |    2 
 include/linux/cred.h                            |   21 --
 include/linux/ftrace.h                          |    2 
 include/linux/ieee80211.h                       |    2 
 include/linux/klist.h                           |    2 
 include/linux/mmzone.h                          |   13 +
 include/linux/netdevice.h                       |    4 
 include/linux/pci_ids.h                         |    4 
 include/linux/ssb/ssb.h                         |    5 
 include/linux/ssb/ssb_driver_chipcommon.h       |   15 +
 include/linux/usb/serial.h                      |    3 
 include/linux/vmstat.h                          |   22 ++
 include/net/sctp/sm.h                           |    1 
 include/net/sctp/structs.h                      |    3 
 include/net/sock.h                              |    1 
 include/net/udp.h                               |    1 
 include/net/x25.h                               |    4 
 init/calibrate.c                                |    6 
 ipc/compat.c                                    |    6 
 ipc/compat_mq.c                                 |    5 
 ipc/sem.c                                       |    2 
 ipc/shm.c                                       |    1 
 kernel/compat.c                                 |   22 ++
 kernel/cpuset.c                                 |    7 
 kernel/cred.c                                   |   41 ++++
 kernel/exit.c                                   |   22 ++
 kernel/futex.c                                  |   31 +--
 kernel/hrtimer.c                                |   13 +
 kernel/hw_breakpoint.c                          |    3 
 kernel/irq/manage.c                             |    2 
 kernel/irq/proc.c                               |    2 
 kernel/latencytop.c                             |   17 --
 kernel/power/snapshot.c                         |    7 
 kernel/power/user.c                             |    2 
 kernel/printk.c                                 |    2 
 kernel/ptrace.c                                 |    2 
 kernel/sched.c                                  |   17 --
 kernel/signal.c                                 |   43 +++--
 kernel/smp.c                                    |   58 ++++++
 kernel/sys.c                                    |    2 
 kernel/time/tick-broadcast.c                    |   10 +
 kernel/time/tick-common.c                       |    6 
 kernel/time/tick-internal.h                     |    3 
 kernel/timer.c                                  |    6 
 kernel/trace/ftrace.c                           |   52 +++++-
 kernel/trace/ring_buffer.c                      |    2 
 kernel/trace/trace.c                            |   10 +
 lib/percpu_counter.c                            |    1 
 mm/filemap.c                                    |    3 
 mm/internal.h                                   |    2 
 mm/memory.c                                     |   32 +++
 mm/memory_hotplug.c                             |    2 
 mm/mempolicy.c                                  |    2 
 mm/mlock.c                                      |    8 
 mm/mmap.c                                       |   16 +
 mm/mmzone.c                                     |   21 ++
 mm/mprotect.c                                   |    2 
 mm/mremap.c                                     |    4 
 mm/nommu.c                                      |    1 
 mm/page_alloc.c                                 |   33 ++-
 mm/percpu.c                                     |    2 
 mm/swapfile.c                                   |    6 
 mm/vmalloc.c                                    |    9 +
 mm/vmscan.c                                     |   53 +++++-
 mm/vmstat.c                                     |   15 +
 net/can/bcm.c                                   |    2 
 net/compat.c                                    |   10 -
 net/core/dev.c                                  |   20 +-
 net/core/ethtool.c                              |    4 
 net/core/iovec.c                                |   17 --
 net/core/rtnetlink.c                            |    3 
 net/core/stream.c                               |    8 
 net/dccp/input.c                                |    7 
 net/decnet/af_decnet.c                          |    2 
 net/econet/af_econet.c                          |   91 ++++------
 net/ipv4/datagram.c                             |    5 
 net/ipv4/inet_timewait_sock.c                   |    2 
 net/ipv4/ip_gre.c                               |    1 
 net/ipv4/ip_output.c                            |   19 +-
 net/ipv4/ipip.c                                 |    1 
 net/ipv4/route.c                                |    7 
 net/ipv4/tcp.c                                  |   11 -
 net/ipv4/tcp_input.c                            |    2 
 net/ipv4/udp.c                                  |   44 +++++
 net/ipv4/xfrm4_policy.c                         |    4 
 net/ipv6/datagram.c                             |    7 
 net/ipv6/ip6_output.c                           |   18 +-
 net/ipv6/route.c                                |   28 ++-
 net/ipv6/sit.c                                  |    2 
 net/ipv6/udp.c                                  |   10 +
 net/irda/iriap.c                                |    3 
 net/irda/parameters.c                           |    4 
 net/mac80211/rx.c                               |    4 
 net/netfilter/nf_conntrack_core.c               |    3 
 net/netfilter/nf_log.c                          |    4 
 net/phonet/pep.c                                |    3 
 net/rds/page.c                                  |   27 ---
 net/rds/rdma.c                                  |    2 
 net/rose/af_rose.c                              |    4 
 net/sctp/auth.c                                 |    8 
 net/sctp/input.c                                |   22 ++
 net/sctp/output.c                               |    1 
 net/sctp/sm_sideeffect.c                        |   35 ++++
 net/sctp/transport.c                            |    2 
 net/socket.c                                    |    4 
 net/sunrpc/cache.c                              |    4 
 net/sunrpc/sched.c                              |   14 -
 net/sunrpc/svc_xprt.c                           |    9 -
 net/wireless/wext-priv.c                        |    2 
 net/x25/af_x25.c                                |   47 +++++
 net/x25/x25_facilities.c                        |   32 ++-
 net/x25/x25_in.c                                |   17 +-
 net/x25/x25_link.c                              |    4 
 security/integrity/ima/ima_policy.c             |    2 
 security/keys/keyctl.c                          |    6 
 security/selinux/hooks.c                        |   11 +
 security/selinux/nlmsgtab.c                     |    2 
 sound/core/control.c                            |    5 
 sound/core/hrtimer.c                            |    5 
 sound/core/rawmidi.c                            |    4 
 sound/oss/soundcard.c                           |    4 
 sound/pci/au88x0/au88x0_pcm.c                   |   24 ++
 sound/pci/ctxfi/ctatc.c                         |    2 
 sound/pci/ctxfi/ctdaio.c                        |    2 
 sound/pci/ctxfi/ctmixer.c                       |   19 --
 sound/pci/hda/hda_eld.c                         |    2 
 sound/pci/hda/hda_intel.c                       |    2 
 sound/pci/hda/patch_analog.c                    |    1 
 sound/pci/hda/patch_conexant.c                  |    8 
 sound/pci/hda/patch_realtek.c                   |   12 +
 sound/pci/hda/patch_sigmatel.c                  |   13 +
 sound/pci/intel8x0.c                            |    6 
 sound/pci/oxygen/oxygen.c                       |    4 
 sound/pci/rme9652/hdsp.c                        |    1 
 sound/pci/rme9652/hdspm.c                       |    1 
 sound/soc/blackfin/bf5xx-ac97.c                 |    4 
 sound/soc/codecs/wm8990.c                       |   10 -
 sound/usb/caiaq/audio.c                         |    2 
 sound/usb/caiaq/midi.c                          |    2 
 sound/usb/usx2y/us122l.c                        |   41 ++--
 462 files changed, 4039 insertions(+), 1589 deletions(-)


Ajit Khaparde (1):
      be2net: Maintain tx and rx counters in driver

Akinobu Mita (1):
      ext4: consolidate in_range() definitions

Alan Cox (1):
      bluetooth: Fix missing NULL check

Alan Stern (10):
      USB: fix bug in initialization of interface minor numbers
      USB: disable endpoints after unbinding interfaces, not before
      USB: accept some invalid ep0-maxpacket values
      USB: EHCI: fix obscure race in ehci_endpoint_disable
      USB: usb-storage: unusual_devs entry for CamSport Evo
      USB: usb-storage: unusual_devs entry for Coby MP3 player
      USB: EHCI: fix DMA deallocation bug
      USB: g_printer: fix bug in module parameter definitions
      USB: prevent buggy hubs from crashing the USB stack
      USB: add quirks entry for Keytouch QWERTY Panel

Alex Deucher (7):
      drm/kms: remove spaces from connector names (v2)
      drm/radeon/kms: add quirk for Mac Radeon HD 2600 card
      drm/radeon/kms: make the mac rv630 quirk generic
      drm/radeon/kms: add pll debugging output
      drm/radeon: remove 0x4243 pci id
      drm/radeon/kms: fix s/r issues with bios scratch regs
      Revert "drm/radeon/kms: switch back to min->max pll post divider iteration"

Alexander Duyck (1):
      igb: only use vlan_gro_receive if vlans are registered

Alexey Starikovskiy (1):
      ACPI: EC: Add another dmi match entry for MSI hardware

Alok Kataria (1):
      x86, kexec: Make sure to stop all CPUs before exiting the kernel

Alon Ziv (1):
      USB: opticon: Fix long-standing bugs in opticon driver

Amitkumar Karwar (1):
      ieee80211: correct IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK macro

Anders Larsen (1):
      USB: cp210x: Add WAGO 750-923 Service Cable device ID

Andre Przywara (1):
      x86, cpu: Fix renamed, not-yet-shipping AMD CPUID feature bit

Andreas Herrmann (4):
      x86, mtrr: Assume SYS_CFG[Tom2ForceMemTypeWB] exists on all future AMD CPUs
      x86, amd: Fix panic on AMD CPU family 0x15
      x86 quirk: Fix polarity for IRQ0 pin2 override on SB800 systems
      x86, quirk: Fix SB600 revision check

Andrey Vagin (1):
      x86/mm: Handle mm_fault_error() in kernel space

Anton Blanchard (7):
      powerpc: Fix hcall tracepoint recursion
      kernel/smp.c: fix smp_call_function_many() SMP race
      RxRPC: Fix v1 keys
      powerpc: Use more accurate limit for first segment memory allocations
      powerpc/kdump: CPUs assume the context of the oopsing CPU
      powerpc/kdump: Use chip->shutdown to disable IRQs
      perf, powerpc: Handle events that raise an exception without overflowing

Antony Pavlov (1):
      mtd: jedec_probe: Change variable name from cfi_p to cfi

Apollon Oikonomopoulos (1):
      x25: decrement netdev reference counts on unload

Axel Lin (1):
      mtd: add "platform:" prefix for platform modalias

Ben Hutchings (3):
      r6040: Fix multicast list iteration when hash filter is used
      net: NETIF_F_HW_CSUM does not imply FCoE CRC offload
      PCI: sysfs: Fix failure path for addition of "vpd" attribute

Benjamin Herrenschmidt (1):
      powerpc: Fix some 6xx/7xxx CPU setup functions

Benjamin Li (1):
      bnx2: Fix netpoll crash.

Bjørn Mork (1):
      USB: io_edgeport: fix the reported firmware major and minor

Bob Moore (1):
      ACPICA: Fix Scope() op in module level code

Borislav Petkov (2):
      x86, AMD, MCE thresholding: Fix the MCi_MISCj iteration order
      amd64_edac: Fix interleaving check

Brandeburg, Jesse (1):
      PCI: remove quirk for pre-production systems

Brian King (1):
      scsi_dh_alua: Add IBM Power Virtual SCSI ALUA device to dev list

Bruce Allan (1):
      e1000e: disable broken PHY wakeup for ICH10 LOMs, use MAC wakeup instead

Chen, Chien-Chia (2):
      Staging: rt3090: Fix RT3090 scan AP function
      Staging: rt2860: fix previous patch error

Chris Wilson (1):
      drm/i915: Add dependency on CONFIG_TMPFS

Christian Lamparter (6):
      p54usb: fix off-by-one on !CONFIG_PM
      p54usb: add five more USBIDs
      p54usb: add 5 more USBIDs
      p54: fix sequence no. accounting off-by-one error
      p54pci: update receive dma buffers before and after processing
      p54usb: add Senao NUB-350 usbid

Christof Schmitt (1):
      Fix race when removing SCSI devices

Christoph Fritz (1):
      ssb: fix NULL ptr deref when pcihost_wrapper is used

Christoph Lameter (1):
      mm: page allocator: calculate a better estimate of NR_FREE_PAGES when memory is low and kswapd is awake

Chuck Lever (2):
      NFS: Fix panic after nfs_umount()
      NFS: Fix "kernel BUG at fs/aio.c:554!"

Clemens Ladisch (5):
      ALSA: rawmidi: fix oops (use after free) when unloading a driver module
      hpet: fix unwanted interrupt due to stale irq status bit
      firewire: ohci: fix buffer overflow in AR split packet handling
      firewire: ohci: fix race in AR split packet handling
      ALSA: hrtimer: handle delayed timer interrupts

Cliff Wickman (2):
      mm, x86: Saving vmcore with non-lazy freeing of vmas
      x86, kdump: Change copy_oldmem_page() to use cached addressing

Colin Ian King (1):
      ACPI: enable repeated PCIEXP wakeup by clearing PCIEXP_WAKE_STS on resume

Craig Shelley (2):
      USB: CP210x Add two device IDs
      USB: CP210x Removed incorrect device ID

DJ Delorie (1):
      USB: cp210x: Add Renesas RX-Stick device ID

Dan Carpenter (4):
      gdth: integer overflow in ioctl
      IB/uverbs: Handle large number of entries in poll CQ
      av7110: check for negative array offset
      keyboard: integer underflow bug

Dan Rosenberg (14):
      ALSA: sound/pci/rme9652: prevent reading uninitialized stack memory
      ALSA: prevent heap corruption in snd_ctl_new()
      ipc: initialize structure memory to zero for compat functions
      sys_semctl: fix kernel stack leakage
      DECnet: don't leak uninitialized stack byte
      V4L/DVB: ivtvfb: prevent reading uninitialized stack memory
      x25: Prevent crashing when parsing bad X.25 facilities
      rds: Integer overflow in RDS cmsg handling
      sound: Prevent buffer overflow in OSS load_mixer_volumes
      sctp: Fix out-of-bounds reading in sctp_asoc_get_hmac()
      Fix pktcdvd ioctl dev_minor range check
      drivers/video/sis/sis_main.c: prevent reading uninitialized stack memory
      drivers/video/via/ioctl.c: prevent reading uninitialized stack memory
      xfs: prevent reading uninitialized stack memory

Daniel J Blueman (1):
      Fix unprotected access to task credentials in waitid()

Daniel Klaffenbach (1):
      ssb: b43-pci-bridge: Add new vendor for BCM4318

Daniel Suchy (1):
      USB: ftdi_sio: new VID/PIDs for various Papouch devices

Daniel T Chen (4):
      ALSA: ac97: Apply quirk for Dell Latitude D610 binding Master and Headphone controls
      ALSA: hda: Use "alienware" model quirk for another SSID
      ALSA: hda: Use model=lg quirk for LG P1 Express to enable playback and capture
      ALSA: hda: Use LPIB quirk for Dell Inspiron m101z/1120

Dario Lombardo (1):
      drivers: update to pl2303 usb-serial to support Motorola cables

Darren Hart (1):
      futex: Fix errors in nested key ref-counting

Darrick J. Wong (1):
      PCI: fix offset check for sysfs mmapped files

Dave Airlie (2):
      drm/radeon: fix PCI ID 5657 to be an RV410
      drm: fix unsigned vs signed comparison issue in modeset ctl ioctl.

Dave Hansen (1):
      mm/vfs: revalidate page->mapping in do_generic_file_read()

David Henningsson (3):
      ALSA: HDA: Add an extra DAC for Realtek ALC887-VD
      ALSA: HDA: Fix dmesg output of HDMI supported bits
      ALSA: HDA: Add position_fix quirk for an Asus device

David Howells (3):
      CRED: Fix get_task_cred() and task_state() to not resurrect dead credentials
      KEYS: Fix RCU no-lock warning in keyctl_session_to_parent()
      KEYS: Fix bug in keyctl_session_to_parent() if parent has no session keyring

David Kilroy (2):
      orinoco: fix TKIP countermeasure behaviour
      orinoco: clear countermeasure setting on commit

David Milburn (1):
      libsas: fix NCQ mixing with non-NCQ

David Miller (1):
      klist: Fix object alignment on 64-bit.

David S. Miller (6):
      rose: Fix signedness issues wrt. digi count.
      tcp: Fix >4GB writes on 64-bit.
      net: Limit socket I/O iovec total length to INT_MAX.
      tcp: Increase TCP_MAXSEG socket option minimum.
      tcp: Make TCP_MAXSEG minimum more correct.
      x25: Do not reference freed memory.

Davide Libenzi (1):
      epoll: prevent creating circular epoll structures

Denis Kirjanov (1):
      staging: rt2860: Fix incorrect netif_stop_queue usage warning

Dimitris Papastamos (1):
      ASoC: WM8990: msleep() takes milliseconds not jiffies

Don Fry (1):
      iwlagn: Re-enable RF_KILL interrupt when down

Don Skidmore (1):
      ixgbe: fix for 82599 erratum on Header Splitting

Don Zickus (1):
      x86: Use u32 instead of long to set reset vector back to 0

Edgar (gimli) Hucek (1):
      input: bcm5974: Add support for MacBookAir3

Eduardo Costa (1):
      p54usb: New USB ID for Gemtek WUBI-100GW

Eric Dumazet (7):
      ip: fix truesize mismatch in ip fragmentation
      netxen: dont set skb->truesize
      numa: fix slab_node(MPOL_BIND)
      netfilter: nf_conntrack: allow nf_ct_alloc_hashtable() to get highmem pages
      udp: add rehash on connect()
      net: deinit automatic LIST_HEAD
      tcp: fix inet_twsk_deschedule()

Eric Paris (3):
      SELinux: define permissions for DCB netlink messages
      SELinux: do not compute transition labels on mountpoint labeled filesystems
      inotify: send IN_UNMOUNT events

Eric Sandeen (1):
      ext3: Always set dx_node's fake_dirent explicitly.

Eric W. Biederman (1):
      net: Fix ip link add netns oops

Erik J. Staab (1):
      ALSA: oxygen: fix analog capture on Claro halo cards

FUJITA Tomonori (1):
      bsg: fix incorrect device_status value

Florian Fainelli (2):
      r6040: fix r6040_multicast_list
      MIPS: MTX-1: Make au1000_eth probe all PHY addresses

Florian Tobias Schandinat (1):
      viafb: use proper register for colour when doing fill ops

Francisco Jerez (1):
      drm/ttm: Clear the ghost cpu_writers flag on ttm_buffer_object_transfer.

Frederic Weisbecker (4):
      reiserfs: fix dependency inversion between inode and reiserfs mutexes
      reiserfs: fix unwanted reiserfs lock recursion
      reiserfs: don't acquire lock recursively in reiserfs_acl_chmod
      x86: Ignore trap bits on single step exceptions

Gabriele Gorla (2):
      hwmon: (adm1026) Allow 1 as a valid divider value
      hwmon: (adm1026) Fix setting fan_div

Geert Uytterhoeven (1):
      radio-aimslab.c needs #include <linux/delay.h>

Gerrit Renker (1):
      dccp: fix oops on Reset after close

Graham Gower (1):
      drivers/char/vt_ioctl.c: fix VT_OPENQRY error value

Greg Kroah-Hartman (15):
      Revert "ssb: Handle Netbook devices where the SPROM address is changed"
      Staging: asus_oled: fix up some sysfs attribute permissions
      Staging: asus_oled: fix up my fixup for some sysfs attribute permissions
      Staging: line6: fix up some sysfs attribute permissions
      USB: storage: sierra_ms: fix sysfs file attribute
      USB: atm: ueagle-atm: fix up some permissions on the sysfs files
      USB: misc: cypress_cy7c63: fix up some sysfs attribute permissions
      USB: misc: usbled: fix up some sysfs attribute permissions
      USB: misc: trancevibrator: fix up a sysfs attribute permission
      USB: misc: usbsevseg: fix up some sysfs attribute permissions
      Staging: samsung-laptop: fix up some sysfs attribute permissions
      Staging: samsung-laptop: fix up my fixup for some sysfs attribute permissions
      Staging: frontier: fix up some sysfs attribute permissions
      rt2x00: add device id for windy31 usb device
      Linux 2.6.33.8

H. Peter Anvin (6):
      x86, cpu: After uncapping CPUID, re-run CPU feature detection
      x86-32: Fix dummy trampoline-related inline stubs
      x86-64, compat: Test %rax for the syscall number, not %eax
      compat: Make compat_alloc_user_space() incorporate the access_ok()
      x86, hotplug: Use mwait to offline a processor, fix the legacy case
      x86, gcc-4.6: Use gcc -m options when building vdso

Hans de Goede (1):
      hwmon/f71882fg: Set platform drvdata to NULL later

Heiko Carstens (3):
      nohz/s390: fix arch_needs_cpu() return value on offline cpus
      nohz: Fix printk_needs_cpu() return value on offline cpus
      nohz: Fix get_next_timer_interrupt() vs cpu hotplug

Hendrik Brueckner (1):
      hvc_iucv: allocate memory buffers for IUCV in zone DMA

Herbert Xu (1):
      crypto: padlock - Fix AES-CBC handling on odd-block-sized input

Hugh Dickins (2):
      x86, mm: Fix CONFIG_VMSPLIT_1G and 2G_OPT trampoline
      mm: fix possible cause of a page_mapped BUG

Ian Abbott (1):
      staging: comedi: ni_labpc: Use shared IRQ for PCMCIA card

Ian Campbell (1):
      xen: ensure that all event channels start off bound to VCPU 0

Ionut Nicu (1):
      USB: ti_usb: fix module removal

Ivan Vecera (1):
      r8169: use RxFIFO overflow workaround for 8168c chipset.

J. R. Okajima (1):
      NFS: fix the return value of nfs_file_fsync()

Jacob Pan (1):
      x86: detect scattered cpuid features earlier

Jacques Viviers (1):
      USB: serial: ftdi_sio: Vardaan USB RS422/485 converter PID added

James Bottomley (2):
      fix medium error problems with some arrays which can cause data corruption
      libsas: fix runaway error handler problem

James Jones (1):
      ARM: 6482/2: Fix find_next_zero_bit and related assembly

Jan Engelhardt (1):
      netfilter: nf_log: avoid oops in (un)bind with invalid nfproto values

Jan Glauber (1):
      qdio: use proper QEBSM operand for SIGA-R and SIGA-S

Jan Kara (1):
      char: Mark /dev/zero and /dev/kmem as not capable of writeback

Jean Delvare (3):
      hwmon: (lm85) Fix ADT7468 frequency table
      i2c: Unregister dummy devices last on adapter removal
      hwmon: (via686a) Initialize fan_div values

Jean-Christophe PLAGNIOL-VILLARD (2):
      USB: atmel_usba_udc: force vbus_pin at -EINVAL when gpio_request failled
      USB: ftdi_sio: add ST Micro Connect Lite uart support

Jeff Moyer (1):
      aio: check for multiplication overflow in do_io_submit

Jens Axboe (4):
      block: limit vec count in bio_kmalloc() and bio_alloc_map_data()
      block: take care not to overflow when calculating total iov length
      block: check for proper length of iov entries in blk_rq_map_user_iov()
      bio: take care not overflow page count when mapping/copying user data

Jeremy Fitzhardinge (3):
      tracing/x86: Don't use mcount in pvclock.c
      xen: don't bother to stop other cpus on shutdown/reboot
      x86/pvclock: Zero last_value on resume

Jerome Glisse (1):
      radeon/kms: fix dp displayport mode validation

Jianzhao Wang (1):
      net: blackhole route should always be recalculated

Jiri Olsa (1):
      tty: prevent DOS in the flush_to_ldisc

Jiri Slaby (6):
      hpet: unmap unused I/O space
      TTY: restore tty_ldisc_wait_idle
      TTY: ldisc, fix open flag handling
      USB: serial/kobil_sct, fix potential tty NULL dereference
      PCI: add more checking to ICH region quirks
      PCI: do not create quirk I/O regions below PCIBIOS_MIN_IO for ICH

Jochen Friedrich (1):
      mfd: Fix NULL pointer due to non-initialized ucb1x00-ts absinfo

Joel Becker (1):
      ocfs2: Don't walk off the end of fast symlinks.

Joerg Roedel (4):
      x86/amd-iommu: Set iommu configuration flags in enable-loop
      x86/amd-iommu: Fix rounding-bug in __unmap_single
      x86/amd-iommu: Work around S3 BIOS bug
      x86-32: Separate 1:1 pagetables from swapper_pg_dir

Johan Hovold (2):
      USB: ftdi_sio: revert "USB: ftdi_sio: fix DTR/RTS line modes"
      usb: musb: omap2430: fix kernel panic on reboot

Johannes Berg (2):
      mac80211: fix use-after-free
      wext: fix potential private ioctl memory content leak

John Hughes (1):
      x25: Patch to fix bug 15678 - x25 accesses fields beyond end of packet.

John Tapsell (1):
      Staging: rt2870: Add USB ID for Buffalo Airstation WLI-UC-GN

John W. Linville (1):
      ssb: do not read SPROM if it does not exist

Jon Thomas (1):
      sierra: add new ID for Airprime/Sierra USB IP modem

Josef Bacik (1):
      Btrfs: kfree correct pointer during mount option parsing

Joseph Gruher (1):
      scsi_dh_alua: fix deadlock in stpg_endio

Josh Hunt (1):
      ext2: Fix link count corruption under heavy link+rename load

Julia Lawall (1):
      drivers/net/wireless/p54/eeprom.c: Return -ENOMEM on memory allocation failure

Justin Maggard (1):
      md: fix return value of rdev_size_change()

Justin TerAvest (1):
      cfq-iosched: Don't wait if queue already has requests.

KAMEZAWA Hiroyuki (3):
      mm: fix return value of scan_lru_pages in memory unplug
      mm: fix is_mem_section_removable() page_order BUG_ON check
      mm: fix corruption of hibernation caused by reusing swap during image saving

Kailang Yang (1):
      ALSA: hda - Fixed ALC887-VD initial error

Kamal Mostafa (2):
      x86: Fix panic when handling "mem={invalid}" param
      x86: Emit "mem=nopentium ignored" warning when not supported

Karsten Wiese (1):
      ALSA: snd-usb-us122l: Fix missing NULL checks

Kashyap, Desai (7):
      mpt2sas: fix Integrated Raid unsynced on shutdown problem
      mpt2sas: Fix device removal handshake for zoned devices
      mpt2sas: Correct resizing calculation for max_queue_depth
      mpt2sas: Kernel Panic during Large Topology discovery
      mpt2sas: add missing initialization of scsih_cmds
      mptfusion: mptctl_release is required in mptctl.c
      mptfusion: Fix Incorrect return value in mptscsih_dev_reset

Kees Cook (3):
      net: clear heap allocations for privileged ethtool actions
      net: clear heap allocation for ETHTOOL_GRXCLSRLALL
      usb: iowarrior: don't trust report_size for buffer size

Ken Chen (1):
      latencytop: fix per task accumulator

Ken Sumrall (1):
      fuse: fix attributes after open(O_TRUNC)

Kenji Kaneshige (3):
      genirq: Fix incorrect proc spurious output
      x86: Enable the intr-remap fault handling after local APIC setup
      x86, vt-d: Fix the vt-d fault handling irq migration in the x2apic mode

Kenneth Waters (1):
      Input: joydev - fix JSIOCSAXMAP ioctl

Knut Petersen (1):
      drm/i915/lvds: Add AOpen i915GMm-HFS to the list of false-positive LVDS

Konstantin Khorenko (1):
      NFSD: memory corruption due to writing beyond the stat array

Krishna Gudipati (1):
      bfa: fix system crash when reading sysfs fc_host statistics

Kumar Sanghvi (1):
      Phonet: Correct header retrieval after pskb_may_pull

Ky Srinivasan (1):
      Staging: hv: fix sysfs symlink on hv block device

Larry Finger (2):
      ssb: Handle alternate SSPROM location
      staging: rtl8187se: Change panic to warn when RF switch turned off

Len Brown (2):
      intel_idle: PCI quirk to prevent Lenovo Ideapad s10-3 boot hang
      ACPI: EC: add Vista incompatibility DMI entry for Toshiba Satellite L355

Li Zefan (2):
      sunrpc/cache: fix module refcnt leak in a failure path
      cpuset: add a missing unlock in cpuset_write_resmask()

Libor Pechacek (1):
      USB: serial: handle Data Carrier Detect changes

Linus Torvalds (8):
      v4l1: fix 32-bit compat microcode loading translation
      De-pessimize rds_page_copy_user
      mm: keep a guard page below a grow-down stack segment
      mm: fix missing page table unmap for stack guard page failure case
      mm: fix page table unmap for stack guard page properly
      mm: fix up some user-visible effects of the stack guard page
      Prioritize synchronous signals over 'normal' signals
      net: Truncate recvfrom and sendto length to INT_MAX.

Luca Tettamanti (1):
      atl1: fix resume

Luke Yelavich (1):
      ALSA: hda - Add Dell Latitude E6400 model quirk

Maciej Szmigiero (2):
      USB: Add Samsung SGH-I500/Android modem ID switch to visor driver
      USB: Add quirk for Samsung Android phone modem

Maciej Żenczykowski (1):
      net: Fix IPv6 PMTU disc. w/ asymmetric routes

Marek Szyprowski (1):
      mmc: sdhci-s3c: fix NULL ptr access in sdhci_s3c_remove

Martin K. Petersen (1):
      block: Ensure physical block size is unsigned int

Martin Schwidefsky (2):
      correct vdso version string
      s390: remove task_show_regs

Martin Wilck (1):
      PCI: fix size checks for mmap() on /proc/bus/pci files

Masanori ITOH (1):
      percpu: fix list_head init bug in __percpu_counter_init()

Mathieu Desnoyers (1):
      sched: Fix string comparison in /proc/sched_features

Matt Evans (1):
      powerpc/kexec: Fix orphaned offline CPUs across kexec

Matt Helsley (1):
      hw breakpoints: Fix pid namespace bug

Matthew Garrett (2):
      tpm: Autodetect itpm devices
      acer-wmi: Fix capitalisation of GUID

Mauro Carvalho Chehab (4):
      V4L/DVB: cx231xx: Avoid an OOPS when card is unknown (card=0)
      USB: option: Add more ZTE modem USB id's
      radio-aimslab.c: Fix gcc 4.5+ bug
      em28xx: Fix audio input for Terratec Grabby

Max Vozeler (6):
      staging: usbip: Notify usb core of port status changes
      staging: usbip: Process event flags without delay
      staging: usbip: vhci: update reference count for usb_device
      staging: usbip: vhci: give back URBs from in-flight unlink requests
      staging: usbip: vhci: refuse to enqueue for dead connections
      staging: usbip: vhci: use urb->dev->portnum to find port

Maxim Uvarov (1):
      powerpc/crashdump: Do not fail on NULL pointer dereferencing

Mel Gorman (2):
      mm: page allocator: drain per-cpu lists after direct reclaim allocation fails
      mm: page allocator: update free page counters after pages are placed on the free list

Michael Buesch (1):
      ssb-pcmcia: Fix parsing of invariants tuples

Michael Chan (1):
      bnx2: Fix hang during rmmod bnx2.

Michael Neuling (2):
      powerpc/pseries: Add hcall to read 4 ptes at a time in real mode
      powerpc/kexec: Speedup kexec hash PTE tear down

Michael Reed (1):
      sd name space exhaustion causes system hang

Michael S. Tsirkin (1):
      virtio: set pci bus master enable bit

Michael Stuermer (1):
      USB: ftdi_sio: Add ID for RT Systems USB-29B radio cable

Michael Williamson (1):
      USB: ftdi_sio: Add VID=0x0647, PID=0x0100 for Acton Research spectrograph

Mike Christie (2):
      Fix regressions in scsi_internal_device_block
      scsi_dh_alua: add netapp to dev list

Mike Frysinger (1):
      ASoC: Blackfin AC97: fix build error after multi-component update

Mike Snitzer (2):
      dm: dont take i_mutex to change device size
      dm mpath: disable blk_abort_queue

Miklos Szeredi (3):
      fuse: verify ioctl retries
      fuse: fix ioctl when server is 32bit
      fuse: fix hang of single threaded fuseblk filesystem

Milton Miller (4):
      virtio: remove virtio-pci root device
      ixgbe: prevent speculative processing of descriptors before ready
      call_function_many: fix list delete vs add race
      call_function_many: add missing ordering

Mimi Zohar (1):
      ima: fix add LSM rule bug

Márton Németh (1):
      staging: usbip: remove double giveback of URB

Nagendra Tomar (1):
      net: Fix the condition passed to sk_wait_event()

Neil Brown (1):
      nfsd: Fix possible BUG_ON firing in set_change_info

NeilBrown (6):
      md/raid1: really fix recovery looping when single good device fails.
      sunrpc: prevent use-after-free on clearing XPT_BUSY
      md: fix bug with re-adding of partially recovered device.
      md: fix regression with re-adding devices to arrays with no metadata
      nfsd: correctly handle return value from nfsd_map_name_to_*
      md: correctly handle probe of an 'mdp' device.

Nelson Elhage (1):
      do_exit(): make sure that we run with get_fs() == USER_DS

Nick Holloway (1):
      USB: Storage: Add unusual_devs entry for VTech Kidizoom

Nicolas Kaiser (1):
      pipe: fix failure to return error code on ->confirm()

Nikanth Karthikesan (1):
      ext4: Prevent creation of files larger than RLIMIT_FSIZE using fallocate

Oleg Nesterov (1):
      posix-cpu-timers: workaround to suppress the problems with mt exec

Oliver Hartkopp (1):
      can-bcm: fix minor heap overflow

Olivier Grenie (1):
      DiB7000M: add pid filtering

Paul E. McKenney (1):
      pid: make setpgid() system call use RCU read-side critical section

Paul Fertser (1):
      b44: fix carrier detection on bind

Paul Fox (2):
      x86, olpc: Don't retry EC commands forever
      rtc-cmos: fix suspend/resume

Paul Mackerras (1):
      powerpc/perf: Fix sampling enable for PPC970

Paul Zimmerman (4):
      xhci: Avoid BUG() in interrupt context
      xhci: Clarify some expressions in the TRB math
      xhci: Fix errors in the running total calculations in the TRB math
      xhci: Fix an error in count_sg_trbs_needed()

Pavel Machek (1):
      serial: unbreak billionton CF card

Pavel Shilovsky (1):
      CIFS: Fix oplock break handling (try #2)

Pekka Enberg (1):
      perf_events: Fix perf_counter_mmap() hook in mprotect()

Peter Jones (1):
      efifb: check that the base address is plausible on pci systems

Petr Tesarik (1):
      IA64: Optimize ticket spinlocks in fsys_rt_sigprocmask

Phil Blundell (3):
      econet: disallow NULL remote addr for sendmsg(), fixes CVE-2010-3849
      econet: fix CVE-2010-3850
      econet: fix CVE-2010-3848

Philippe Rétornaz (1):
      tty_ldisc: Fix BUG() on hangup

Pieter Maes (1):
      USB: serial: Updated support for ICOM devices

Przemyslaw Bruski (3):
      ALSA: ctxfi - Fix incorrect SPDIF status bit mask
      ALSA: ctxfi - Fix SPDIF status retrieval
      ALSA: ctxfi - Clear input settings before initialization

Rafał Miłecki (1):
      ssb: Look for SPROM at different offset on higher rev CC

Rainer Keller (1):
      USB: add PID for FTDI based OpenDCC hardware

Rajiv Andrade (1):
      TPM: Long default timeout fix

Raymond Yau (1):
      ALSA : au88x0 - Limit number of channels to fix Oops via OSS emu

Richard A. Smith (1):
      olpc_battery: Fix endian neutral breakage for s16 values

Richard Schütz (2):
      USB: usb-storage: unusual_devs update for Cypress ATACB
      USB: usb-storage: unusual_devs update for TrekStor DataStation maxi g.u external hard drive enclosure

Richard Weinberger (2):
      um: remove PAGE_SIZE alignment in linker script causing kernel segfault.
      um: fix global timer issue when using CONFIG_NO_HZ

Robin Holt (1):
      sgi-xp: incoming XPC channel messages can come in after the channel's partition structures have been torn down

Robin@sgi.com (1):
      sgi-xpc: XPC fails to discover partitions with all nasids above 128

Roland McGrath (4):
      setup_arg_pages: diagnose excessive argument size
      execve: improve interactivity with large arguments
      execve: make responsive to SIGKILL with large arguments
      x86-64, compat: Retruncate rax after ia32 syscall entry tracing

Ruben Smits (1):
      staging: comedi: add support for newer jr3 1-channel pci board

Russell King (1):
      ARM: Ensure predictable endian state on signal handler entry

Ryan Kuester (1):
      SCSI: mptsas: fix hangs caused by ATA pass-through

Saeed Bishara (1):
      mv_xor: fix race in tasklet function

Salman Qazi (1):
      hrtimer: Preserve timer state in remove_hrtimer()

Samuel Ortiz (2):
      irda: Fix parameter extraction stack overflow
      irda: Fix heap memory corruption in iriap.c

Sarah Sharp (2):
      usb: Realloc xHCI structures after a hub is verified.
      xhci: Fix cycle bit calculation during stall handling.

Sean Hefty (2):
      RDMA/cma: Fix crash in request handlers
      IB/cm: Bump reference count on cm_id before invoking callback

Sebastian Andrzej Siewior (1):
      USB: isp1760: Implement solution for erratum 2

Senthil Balasubramanian (1):
      ath9k_hw: Fix incorrect macversion and macrev checks

Sergei Shtylyov (1):
      usb: musb: blackfin: call gpio_free() on error path in musb_platform_init()

Sergey Vlasov (1):
      NFS: Fix fcntl F_GETLK not reporting some conflicts

Seth Heasley (3):
      ahci: AHCI and RAID mode SATA patch for Intel Patsburg DeviceIDs
      ahci: AHCI mode SATA patch for Intel DH89xxCC DeviceIDs
      ahci: AHCI mode SATA patch for Intel Patsburg SATA RAID controller

Shaohua Li (1):
      x86: Flush TLB if PGD entry is changed in i386 PAE mode

Simon Guinot (1):
      dmaengine: fix interrupt clearing for mv_xor

Simone Contini (1):
      USB: serial: pl2303: Hybrid reader Uniform HCR331

Slava Pestov (1):
      tracing: Fix panic when lseek() called on "trace" opened for writing

Stanislaw Gruszka (4):
      iwlagn: enable only rfkill interrupt when device is down
      PM / Hibernate: Return error code when alloc_image_page() fails
      r8169: disable ASPM
      sched: Fix user time incorrectly accounted as system time on 32-bit

Stefan Richter (1):
      firewire: core: fix unstable I/O with Canon camcorder

Steve Wise (1):
      RDMA/cxgb3: Turn off RX coalescing for iWARP connections

Steven J. Magnani (1):
      nommu: yield CPU while disposing VM

Steven Rostedt (4):
      tracing/x86: Don't use mcount in kvmclock.c
      ring-buffer: Fix typo of time extends per page
      leds: fix bug with reading NAS SS4200 dmi code
      ftrace: Fix memory leak with function graph and cpu hotplug

Suresh Siddha (5):
      x86, intr-remap: Set redirection hint in the IRTE
      x86, vt-d: Handle previous faults after enabling fault handling
      x86, vt-d: Quirk for masking vtd spec errors to platform error handling logic
      x86, mtrr: Avoid MTRR reprogramming on BP during boot on UP platforms
      x86, mm: avoid possible bogus tlb entries by clearing prev mm_cpumask after switching mm

Sven Neumann (1):
      ds2760_battery: Fix calculation of time_to_empty_now

Takashi Iwai (3):
      PM / Hibernate: Fix PM_POST_* notification with user-space suspend
      ALSA: hda - Fix memory leaks in conexant jack arrays
      ALSA: caiaq - Fix possible string-buffer overflow

Tavis Ormandy (1):
      install_special_mapping skips security_file_mmap check.

Tejun Heo (7):
      ubd: fix incorrect sector handling during request restart
      libata: fix NULL sdev dereference race in atapi_qc_complete()
      PCI: pci-stub: ignore zero-length id parameters
      ptrace: use safer wake up on ptrace_detach()
      pata_mpc52xx: inherit from ata_bmdma_port_ops
      libata: no special completion processing for EH commands
      percpu: fix pcpu_last_unit_cpu

Tetsuo Handa (3):
      CRED: Fix kernel panic upon security_file_alloc() failure.
      CRED: Fix BUG() upon security_cred_alloc_blank() failure
      CRED: Fix memory and refcount leaks upon security_prepare_creds() failure

Thadeu Lima de Souza Cascardo (1):
      wmi: use memcmp instead of strncmp to compare GUIDs

Thomas Gleixner (5):
      x86, hpet: Fix bogus error check in hpet_assign_irq()
      x86, irq: Plug memory leak in sparse irq
      isdn: hisax: Replace the bogus access to irq stats
      genirq: Disable the SHIRQ_DEBUG call in request_threaded_irq for now
      clockevents: Prevent oneshot mode when broadcast device is periodic

Thomas Hellstrom (1):
      drm/ttm: Fix two race conditions + fix busy codepaths

Thomas Sailer (1):
      USB: misc: uss720.c: add another vendor/product ID

Thomas Taranowski (1):
      rapidio: fix hang on RapidIO doorbell queue full condition

Tilman Schmidt (1):
      isdn: avoid calling tty_ldisc_flush() in atomic context

Tim Deegan (1):
      fix jiffy calculations in calibrate_delay_direct to handle overflow

Timo Warns (2):
      fs/partitions: Validate map_count in Mac partition tables
      ldm: corrupted partition table can cause kernel oops

Tom Marshall (1):
      tcp: Fix race in tcp_poll

Tony Luck (1):
      IA64: fix siglock

Tristan Ye (1):
      Ocfs2/refcounttree: Fix a bug for refcounttree to writeback clusters in a right number.

Trond Myklebust (1):
      SUNRPC: Ensure we always run the tk_callback before tk_action

Tyler Hicks (2):
      eCryptfs: Clear LOOKUP_OPEN flag when creating lower file
      eCryptfs: Copy up lower inode attrs in getattr

Ulrich Weber (1):
      xfrm4: strip ECN and IP Precedence bits in policy lookup

Uwe Kleine-König (1):
      backlight: grab ops_lock before testing bd->ops

Vasiliy Kulikov (9):
      pcmcia: synclink_cs: fix information leak to userland
      ipc: shm: fix information leak to userland
      usb: misc: sisusbvga: fix information leak to userland
      usb: misc: iowarrior: fix information leak to userland
      usb: core: fix information leak to userland
      platform: x86: acer-wmi: world-writable sysfs threeg file
      platform: x86: asus_acpi: world-writable procfs files
      platform: x86: tc1100-wmi: world-writable sysfs wireless and jogdial files
      net: don't allow CAP_NET_ADMIN to load non-netdev kernel modules

Vitaliy Kulikov (1):
      ALSA: hda - fix digital mic selection in mixer on 92HD8X codecs

Vitaly Kuznetsov (1):
      USB: usb-storage: unusual_devs entry for the Samsung YP-CP3

Vlad Yasevich (2):
      sctp: Fix a race between ICMP protocol unreachable and connect()
      sctp: Do not reset the packet during sctp_packet_config().

Will Deacon (1):
      ARM: 6489/1: thumb2: fix incorrect optimisation in usracc

Wu Fengguang (1):
      vmscan: raise the bar to PAGEOUT_IO_SYNC stalls

Yinghai Lu (1):
      x86, numa: For each node, register the memory blocks actually used

Zhang Rui (2):
      ACPI: Disable Windows Vista compatibility for Toshiba P305D
      acpi-cpufreq: fix a memleak when unloading driver

andrew hendry (1):
      memory corruption in X.25 facilities parsing

dann frazier (1):
      ocfs2_connection_find() returns pointer to bad structure

ma rui (1):
      USB: option: fix when the driver is loaded incorrectly for some Huawei devices.

roel (1):
      nfsd: wrong index used in inner loop

wangyanqing (1):
      USB: serial: ch341: add new id

