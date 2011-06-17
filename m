Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002Ab1FQT5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 15:57:44 -0400
Received: from outmail015.snc4.facebook.com ([66.220.144.147]:39082 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756556Ab1FQT5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 15:57:40 -0400
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>, Andrew Morton <akpm@osdl.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH 1/4] atomic: use <linux/atomic.h>
Date: Fri, 17 Jun 2011 12:57:07 -0700
Message-Id: <1308340630-16008-1-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to move duplicated code in <asm/atomic.h>
(atomic_inc_not_zero() for now) to <linux/atomic.h>

Signed-off-by: Arun Sharma <asharma@fb.com>
Reviewed-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@osdl.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
LKML-Reference: <20110531105019.GF24172@elte.hu>
---
 arch/alpha/include/asm/atomic.h                    |    1 -
 arch/alpha/include/asm/local.h                     |    2 +-
 arch/alpha/kernel/perf_event.c                     |    2 +-
 arch/alpha/kernel/smp.c                            |    2 +-
 arch/alpha/lib/dec_and_lock.c                      |    2 +-
 arch/arm/include/asm/atomic.h                      |    1 -
 arch/arm/kernel/smp.c                              |    2 +-
 arch/arm/kernel/traps.c                            |    2 +-
 arch/arm/mach-at91/pm.c                            |    2 +-
 arch/arm/mach-bcmring/dma.c                        |    2 +-
 arch/arm/mach-cns3xxx/include/mach/pm.h            |    2 +-
 arch/arm/mach-cns3xxx/pm.c                         |    2 +-
 arch/arm/mach-omap1/pm.c                           |    2 +-
 arch/arm/mach-s3c2440/clock.c                      |    2 +-
 arch/arm/mach-s3c2440/s3c2442.c                    |    2 +-
 arch/arm/mach-s3c2440/s3c244x-clock.c              |    2 +-
 arch/avr32/include/asm/atomic.h                    |    1 -
 arch/blackfin/include/asm/atomic.h                 |    1 -
 arch/blackfin/include/asm/dma.h                    |    2 +-
 arch/blackfin/include/asm/ipipe.h                  |    2 +-
 arch/blackfin/include/asm/spinlock.h               |    2 +-
 arch/blackfin/kernel/ftrace.c                      |    2 +-
 arch/blackfin/kernel/ipipe.c                       |    2 +-
 arch/blackfin/kernel/nmi.c                         |    2 +-
 arch/blackfin/mach-common/smp.c                    |    2 +-
 arch/cris/arch-v32/drivers/cryptocop.c             |    2 +-
 arch/cris/arch-v32/kernel/smp.c                    |    2 +-
 arch/cris/include/asm/atomic.h                     |    1 -
 arch/cris/include/asm/bitops.h                     |    2 +-
 arch/cris/kernel/process.c                         |    2 +-
 arch/frv/include/asm/atomic.h                      |    1 -
 arch/frv/include/asm/hardirq.h                     |    2 +-
 arch/frv/kernel/irq.c                              |    2 +-
 arch/h8300/include/asm/atomic.h                    |    1 -
 arch/ia64/include/asm/atomic.h                     |    1 -
 arch/ia64/include/asm/processor.h                  |    2 +-
 arch/ia64/include/asm/spinlock.h                   |    2 +-
 arch/ia64/kernel/smp.c                             |    2 +-
 arch/ia64/kernel/smpboot.c                         |    2 +-
 arch/ia64/kernel/uncached.c                        |    2 +-
 arch/m32r/include/asm/atomic.h                     |    1 -
 arch/m32r/include/asm/mmu_context.h                |    2 +-
 arch/m32r/include/asm/spinlock.h                   |    2 +-
 arch/m32r/kernel/smp.c                             |    2 +-
 arch/m32r/kernel/traps.c                           |    2 +-
 arch/m68k/include/asm/atomic.h                     |    1 -
 arch/microblaze/include/asm/mmu_context_mm.h       |    2 +-
 arch/microblaze/include/asm/prom.h                 |    2 +-
 arch/mips/include/asm/atomic.h                     |    1 -
 arch/mips/include/asm/hw_irq.h                     |    2 +-
 arch/mips/include/asm/local.h                      |    2 +-
 arch/mips/include/asm/smp.h                        |    2 +-
 arch/mips/kernel/irq.c                             |    2 +-
 arch/mips/kernel/mips-mt.c                         |    2 +-
 arch/mips/kernel/rtlx.c                            |    2 +-
 arch/mips/kernel/smp-cmp.c                         |    2 +-
 arch/mips/kernel/smp-mt.c                          |    2 +-
 arch/mips/kernel/smp.c                             |    2 +-
 arch/mips/kernel/smtc-proc.c                       |    2 +-
 arch/mips/kernel/smtc.c                            |    2 +-
 arch/mips/kernel/sync-r4k.c                        |    2 +-
 arch/mips/kernel/vpe.c                             |    2 +-
 arch/mips/mipssim/sim_smtc.c                       |    2 +-
 arch/mips/sgi-ip27/ip27-nmi.c                      |    2 +-
 arch/mn10300/include/asm/atomic.h                  |    1 -
 arch/mn10300/include/asm/mmu_context.h             |    2 +-
 arch/mn10300/include/asm/spinlock.h                |    2 +-
 arch/mn10300/include/asm/system.h                  |    2 +-
 arch/mn10300/kernel/mn10300-watchdog.c             |    2 +-
 arch/mn10300/kernel/traps.c                        |    2 +-
 arch/mn10300/mm/misalignment.c                     |    2 +-
 arch/mn10300/proc-mn2ws0050/proc-init.c            |    2 +-
 arch/parisc/include/asm/atomic.h                   |    1 -
 arch/parisc/include/asm/bitops.h                   |    2 +-
 arch/parisc/include/asm/mmu_context.h              |    2 +-
 arch/parisc/kernel/parisc_ksyms.c                  |    2 +-
 arch/parisc/kernel/smp.c                           |    2 +-
 arch/parisc/kernel/traps.c                         |    2 +-
 arch/parisc/lib/bitops.c                           |    2 +-
 arch/powerpc/include/asm/atomic.h                  |    1 -
 arch/powerpc/include/asm/emulated_ops.h            |    2 +-
 arch/powerpc/include/asm/irq.h                     |    2 +-
 arch/powerpc/include/asm/local.h                   |    2 +-
 arch/powerpc/include/asm/prom.h                    |    2 +-
 arch/powerpc/kernel/of_platform.c                  |    2 +-
 arch/powerpc/kernel/ppc_ksyms.c                    |    2 +-
 arch/powerpc/kernel/rtas.c                         |    2 +-
 arch/powerpc/kernel/rtasd.c                        |    2 +-
 arch/powerpc/kernel/smp-tbsync.c                   |    2 +-
 arch/powerpc/kernel/smp.c                          |    2 +-
 arch/powerpc/platforms/83xx/km83xx.c               |    2 +-
 arch/powerpc/platforms/83xx/mpc832x_mds.c          |    2 +-
 arch/powerpc/platforms/83xx/mpc834x_itx.c          |    2 +-
 arch/powerpc/platforms/83xx/mpc834x_mds.c          |    2 +-
 arch/powerpc/platforms/83xx/mpc836x_mds.c          |    2 +-
 arch/powerpc/platforms/83xx/sbc834x.c              |    2 +-
 arch/powerpc/platforms/85xx/mpc85xx_cds.c          |    2 +-
 arch/powerpc/platforms/85xx/mpc85xx_mds.c          |    2 +-
 arch/powerpc/platforms/85xx/sbc8548.c              |    2 +-
 arch/powerpc/platforms/cell/cpufreq_spudemand.c    |    2 +-
 arch/powerpc/platforms/cell/smp.c                  |    2 +-
 arch/powerpc/platforms/cell/spufs/context.c        |    2 +-
 arch/powerpc/platforms/chrp/smp.c                  |    2 +-
 arch/powerpc/platforms/iseries/smp.c               |    2 +-
 arch/powerpc/platforms/powermac/backlight.c        |    2 +-
 arch/powerpc/platforms/powermac/smp.c              |    2 +-
 arch/powerpc/platforms/pseries/eeh.c               |    2 +-
 arch/powerpc/platforms/pseries/eeh_cache.c         |    2 +-
 arch/powerpc/platforms/pseries/smp.c               |    2 +-
 arch/powerpc/sysdev/fsl_soc.c                      |    2 +-
 arch/powerpc/sysdev/tsi108_dev.c                   |    2 +-
 arch/s390/include/asm/atomic.h                     |    1 -
 arch/s390/kernel/dis.c                             |    2 +-
 arch/s390/kernel/traps.c                           |    2 +-
 arch/sh/include/asm/atomic.h                       |    1 -
 arch/sh/include/asm/hw_irq.h                       |    2 +-
 arch/sh/include/asm/smp.h                          |    2 +-
 arch/sh/kernel/idle.c                              |    2 +-
 arch/sh/kernel/smp.c                               |    2 +-
 arch/sh/kernel/traps_64.c                          |    2 +-
 arch/sh/kernel/unwinder.c                          |    2 +-
 arch/sparc/include/asm/atomic_32.h                 |    1 -
 arch/sparc/include/asm/atomic_64.h                 |    1 -
 arch/sparc/include/asm/prom.h                      |    2 +-
 arch/sparc/include/asm/smp_32.h                    |    2 +-
 arch/sparc/include/asm/smp_64.h                    |    2 +-
 arch/sparc/kernel/irq_64.c                         |    2 +-
 arch/sparc/kernel/leon_smp.c                       |    2 +-
 arch/sparc/kernel/perf_event.c                     |    2 +-
 arch/sparc/kernel/smp_32.c                         |    2 +-
 arch/sparc/kernel/smp_64.c                         |    2 +-
 arch/sparc/lib/atomic32.c                          |    2 +-
 arch/tile/include/asm/atomic.h                     |    9 ---------
 arch/tile/include/asm/atomic_32.h                  |    4 ++--
 arch/tile/include/asm/atomic_64.h                  |    2 +-
 arch/tile/include/asm/bitops_32.h                  |    2 +-
 arch/tile/include/asm/bitops_64.h                  |    2 +-
 arch/tile/include/asm/spinlock_32.h                |    2 +-
 arch/tile/kernel/intvec_32.S                       |    2 +-
 arch/tile/lib/atomic_32.c                          |    2 +-
 arch/tile/lib/atomic_asm_32.S                      |    2 +-
 arch/x86/ia32/sys_ia32.c                           |    2 +-
 arch/x86/include/asm/apic.h                        |    2 +-
 arch/x86/include/asm/atomic.h                      |    1 -
 arch/x86/include/asm/hw_irq.h                      |    2 +-
 arch/x86/include/asm/local.h                       |    2 +-
 arch/x86/include/asm/mce.h                         |    2 +-
 arch/x86/include/asm/mmu_context.h                 |    2 +-
 arch/x86/include/asm/prom.h                        |    2 +-
 arch/x86/include/asm/spinlock.h                    |    2 +-
 arch/x86/include/asm/thread_info.h                 |    2 +-
 arch/x86/kernel/amd_gart_64.c                      |    2 +-
 arch/x86/kernel/apic/apic.c                        |    2 +-
 arch/x86/kernel/apic/es7000_32.c                   |    2 +-
 arch/x86/kernel/cpu/common.c                       |    2 +-
 arch/x86/kernel/i8259.c                            |    2 +-
 arch/x86/kernel/irqinit.c                          |    2 +-
 arch/x86/kernel/traps.c                            |    2 +-
 arch/x86/kvm/lapic.c                               |    2 +-
 arch/x86/kvm/timer.c                               |    2 +-
 arch/x86/lib/atomic64_32.c                         |    2 +-
 arch/x86/mm/mmio-mod.c                             |    2 +-
 arch/xtensa/include/asm/atomic.h                   |    1 -
 arch/xtensa/kernel/process.c                       |    2 +-
 crypto/af_alg.c                                    |    2 +-
 crypto/proc.c                                      |    2 +-
 crypto/rng.c                                       |    2 +-
 drivers/atm/ambassador.c                           |    2 +-
 drivers/atm/atmtcp.c                               |    2 +-
 drivers/atm/eni.c                                  |    2 +-
 drivers/atm/eni.h                                  |    2 +-
 drivers/atm/firestream.c                           |    2 +-
 drivers/atm/fore200e.c                             |    2 +-
 drivers/atm/horizon.c                              |    2 +-
 drivers/atm/idt77252.c                             |    2 +-
 drivers/atm/iphase.c                               |    2 +-
 drivers/atm/nicstar.c                              |    2 +-
 drivers/atm/suni.c                                 |    2 +-
 drivers/atm/uPD98402.c                             |    2 +-
 drivers/atm/zatm.c                                 |    2 +-
 drivers/base/memory.c                              |    2 +-
 drivers/base/power/sysfs.c                         |    2 +-
 drivers/block/cciss_scsi.c                         |    2 +-
 drivers/char/ipmi/ipmi_watchdog.c                  |    2 +-
 drivers/char/mspec.c                               |    2 +-
 drivers/connector/cn_proc.c                        |    2 +-
 drivers/edac/edac_stub.c                           |    2 +-
 drivers/firewire/core-card.c                       |    2 +-
 drivers/firewire/core-device.c                     |    2 +-
 drivers/firewire/core-topology.c                   |    2 +-
 drivers/firewire/core.h                            |    2 +-
 drivers/firewire/nosy.c                            |    2 +-
 drivers/gpu/drm/radeon/radeon.h                    |    2 +-
 drivers/gpu/drm/radeon/radeon_fence.c              |    2 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |    2 +-
 drivers/gpu/drm/ttm/ttm_lock.c                     |    2 +-
 drivers/gpu/drm/ttm/ttm_object.c                   |    2 +-
 drivers/gpu/drm/ttm/ttm_page_alloc.c               |    2 +-
 drivers/hwmon/sht15.c                              |    2 +-
 drivers/infiniband/hw/cxgb4/mem.c                  |    2 +-
 drivers/infiniband/hw/ehca/ehca_tools.h            |    2 +-
 drivers/infiniband/hw/nes/nes_cm.c                 |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib.h               |    2 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |    2 +-
 drivers/isdn/gigaset/gigaset.h                     |    2 +-
 drivers/md/dm-crypt.c                              |    2 +-
 drivers/md/dm-kcopyd.c                             |    2 +-
 drivers/md/dm-mpath.c                              |    2 +-
 drivers/md/dm-queue-length.c                       |    2 +-
 drivers/md/dm-table.c                              |    2 +-
 drivers/media/video/hdpvr/hdpvr-core.c             |    2 +-
 drivers/media/video/tlg2300/pd-dvb.c               |    2 +-
 drivers/media/video/uvc/uvc_ctrl.c                 |    2 +-
 drivers/media/video/uvc/uvc_driver.c               |    2 +-
 drivers/media/video/uvc/uvc_queue.c                |    2 +-
 drivers/media/video/uvc/uvc_v4l2.c                 |    2 +-
 drivers/media/video/uvc/uvc_video.c                |    2 +-
 drivers/message/i2o/i2o_scsi.c                     |    2 +-
 drivers/misc/phantom.c                             |    2 +-
 drivers/net/atlx/atl1.c                            |    2 +-
 drivers/net/atlx/atl2.c                            |    2 +-
 drivers/net/atlx/atl2.h                            |    2 +-
 drivers/net/cassini.c                              |    2 +-
 drivers/net/cpmac.c                                |    2 +-
 drivers/net/cxgb3/cxgb3_offload.c                  |    2 +-
 drivers/net/cxgb3/l2t.h                            |    2 +-
 drivers/net/cxgb3/t3cdev.h                         |    2 +-
 drivers/net/cxgb4/cxgb4_uld.h                      |    2 +-
 drivers/net/cxgb4/l2t.h                            |    2 +-
 drivers/net/hamradio/6pack.c                       |    2 +-
 drivers/net/hamradio/dmascc.c                      |    2 +-
 drivers/net/ibmveth.c                              |    2 +-
 drivers/net/phy/phy.c                              |    2 +-
 drivers/net/ppp_generic.c                          |    2 +-
 drivers/net/wimax/i2400m/i2400m.h                  |    2 +-
 drivers/net/wireless/b43legacy/b43legacy.h         |    2 +-
 drivers/net/wireless/b43legacy/dma.h               |    2 +-
 drivers/oprofile/oprofile_stats.h                  |    2 +-
 drivers/pci/hotplug/cpci_hotplug_core.c            |    2 +-
 drivers/pci/xen-pcifront.c                         |    2 +-
 drivers/s390/block/dasd_eer.c                      |    2 +-
 drivers/s390/char/sclp_quiesce.c                   |    2 +-
 drivers/s390/char/vmlogrdr.c                       |    2 +-
 drivers/s390/cio/device.h                          |    2 +-
 drivers/s390/cio/qdio_main.c                       |    2 +-
 drivers/s390/cio/qdio_thinint.c                    |    2 +-
 drivers/s390/crypto/ap_bus.c                       |    2 +-
 drivers/s390/crypto/zcrypt_api.c                   |    2 +-
 drivers/s390/crypto/zcrypt_cex2a.c                 |    2 +-
 drivers/s390/crypto/zcrypt_mono.c                  |    2 +-
 drivers/s390/crypto/zcrypt_pcica.c                 |    2 +-
 drivers/s390/crypto/zcrypt_pcicc.c                 |    2 +-
 drivers/s390/crypto/zcrypt_pcixcc.c                |    2 +-
 drivers/s390/net/fsm.h                             |    2 +-
 drivers/s390/scsi/zfcp_scsi.c                      |    2 +-
 drivers/sbus/char/display7seg.c                    |    2 +-
 drivers/scsi/dpt/dpti_i2o.h                        |    2 +-
 drivers/scsi/hpsa.c                                |    2 +-
 drivers/scsi/pm8001/pm8001_sas.h                   |    2 +-
 drivers/staging/octeon/ethernet-rx.c               |    2 +-
 drivers/staging/octeon/ethernet-tx.c               |    2 +-
 drivers/staging/rtl8712/osdep_service.h            |    2 +-
 drivers/staging/solo6x10/solo6x10.h                |    2 +-
 .../tidspbridge/include/dspbridge/host_os.h        |    2 +-
 drivers/staging/winbond/mds_s.h                    |    2 +-
 drivers/staging/winbond/wb35reg_s.h                |    2 +-
 drivers/tty/bfin_jtag_comm.c                       |    2 +-
 drivers/tty/rocket.c                               |    2 +-
 drivers/tty/serial/dz.c                            |    2 +-
 drivers/tty/serial/sb1250-duart.c                  |    2 +-
 drivers/tty/serial/zs.c                            |    2 +-
 drivers/usb/gadget/f_audio.c                       |    2 +-
 drivers/usb/gadget/f_rndis.c                       |    2 +-
 drivers/usb/gadget/uvc_queue.c                     |    2 +-
 drivers/usb/image/microtek.c                       |    2 +-
 drivers/usb/misc/appledisplay.c                    |    2 +-
 drivers/usb/serial/garmin_gps.c                    |    2 +-
 drivers/usb/wusbcore/wa-rpipe.c                    |    2 +-
 drivers/vhost/vhost.h                              |    2 +-
 drivers/video/sh_mobile_lcdcfb.c                   |    2 +-
 drivers/video/vermilion/vermilion.h                |    2 +-
 drivers/w1/masters/matrox_w1.c                     |    2 +-
 drivers/w1/w1.c                                    |    2 +-
 drivers/w1/w1_family.h                             |    2 +-
 drivers/watchdog/intel_scu_watchdog.c              |    2 +-
 drivers/watchdog/sbc7240_wdt.c                     |    2 +-
 fs/btrfs/delayed-inode.h                           |    2 +-
 fs/direct-io.c                                     |    2 +-
 fs/eventpoll.c                                     |    2 +-
 fs/file_table.c                                    |    2 +-
 fs/gfs2/main.c                                     |    2 +-
 fs/nfs/cache_lib.h                                 |    2 +-
 fs/nfs/direct.c                                    |    2 +-
 fs/notify/group.c                                  |    2 +-
 fs/notify/inode_mark.c                             |    2 +-
 fs/notify/mark.c                                   |    2 +-
 fs/notify/notification.c                           |    2 +-
 fs/notify/vfsmount_mark.c                          |    2 +-
 fs/ntfs/inode.h                                    |    2 +-
 fs/posix_acl.c                                     |    2 +-
 fs/proc/meminfo.c                                  |    2 +-
 include/acpi/platform/aclinux.h                    |    2 +-
 include/asm-generic/atomic.h                       |    2 --
 include/asm-generic/local.h                        |    2 +-
 include/asm-generic/local64.h                      |    2 +-
 include/drm/ttm/ttm_lock.h                         |    2 +-
 include/linux/aio.h                                |    2 +-
 include/linux/atmdev.h                             |    2 +-
 include/linux/atomic.h                             |    9 +++++++++
 include/linux/backing-dev.h                        |    2 +-
 include/linux/bit_spinlock.h                       |    2 +-
 include/linux/buffer_head.h                        |    2 +-
 include/linux/configfs.h                           |    2 +-
 include/linux/connector.h                          |    2 +-
 include/linux/cred.h                               |    2 +-
 include/linux/crypto.h                             |    2 +-
 include/linux/dcache.h                             |    2 +-
 include/linux/debug_locks.h                        |    2 +-
 include/linux/device.h                             |    2 +-
 include/linux/edac.h                               |    2 +-
 include/linux/fault-inject.h                       |    2 +-
 include/linux/fdtable.h                            |    2 +-
 include/linux/filter.h                             |    2 +-
 include/linux/firewire.h                           |    2 +-
 include/linux/fs.h                                 |    2 +-
 include/linux/fsnotify_backend.h                   |    2 +-
 include/linux/interrupt.h                          |    2 +-
 include/linux/jump_label.h                         |    2 +-
 include/linux/kdb.h                                |    2 +-
 include/linux/key.h                                |    2 +-
 include/linux/kgdb.h                               |    2 +-
 include/linux/kobject.h                            |    2 +-
 include/linux/mlx4/device.h                        |    2 +-
 include/linux/mman.h                               |    2 +-
 include/linux/mmzone.h                             |    2 +-
 include/linux/mount.h                              |    2 +-
 include/linux/mutex.h                              |    2 +-
 include/linux/netdevice.h                          |    2 +-
 include/linux/nfs_fs_sb.h                          |    2 +-
 include/linux/oprofile.h                           |    2 +-
 include/linux/pci.h                                |    2 +-
 include/linux/perf_event.h                         |    2 +-
 include/linux/phy.h                                |    2 +-
 include/linux/proc_fs.h                            |    2 +-
 include/linux/quota.h                              |    2 +-
 include/linux/rwsem.h                              |    2 +-
 include/linux/sem.h                                |    2 +-
 include/linux/skbuff.h                             |    2 +-
 include/linux/sonet.h                              |    2 +-
 include/linux/spinlock.h                           |    2 +-
 include/linux/sunrpc/auth.h                        |    2 +-
 include/linux/sunrpc/cache.h                       |    2 +-
 include/linux/sunrpc/timer.h                       |    2 +-
 include/linux/swap.h                               |    2 +-
 include/linux/sysfs.h                              |    2 +-
 include/linux/vmstat.h                             |    2 +-
 include/linux/workqueue.h                          |    2 +-
 include/net/ax25.h                                 |    2 +-
 include/net/cipso_ipv4.h                           |    2 +-
 include/net/flow.h                                 |    2 +-
 include/net/inet_hashtables.h                      |    2 +-
 include/net/inet_timewait_sock.h                   |    2 +-
 include/net/inetpeer.h                             |    2 +-
 include/net/ip_vs.h                                |    2 +-
 include/net/lib80211.h                             |    2 +-
 include/net/llc.h                                  |    2 +-
 include/net/neighbour.h                            |    2 +-
 include/net/net_namespace.h                        |    2 +-
 include/net/netfilter/nf_conntrack.h               |    2 +-
 include/net/netlabel.h                             |    2 +-
 include/net/netns/conntrack.h                      |    2 +-
 include/net/sctp/structs.h                         |    2 +-
 include/pcmcia/ds.h                                |    2 +-
 include/rdma/ib_sa.h                               |    2 +-
 include/rdma/ib_verbs.h                            |    2 +-
 include/rxrpc/types.h                              |    2 +-
 include/scsi/scsi_device.h                         |    2 +-
 include/video/omapdss.h                            |    2 +-
 kernel/async.c                                     |    2 +-
 kernel/audit.c                                     |    2 +-
 kernel/auditsc.c                                   |    2 +-
 kernel/cgroup.c                                    |    2 +-
 kernel/cpuset.c                                    |    2 +-
 kernel/debug/debug_core.c                          |    2 +-
 kernel/rcupdate.c                                  |    2 +-
 kernel/rcutorture.c                                |    2 +-
 kernel/rcutree_trace.c                             |    2 +-
 kernel/rwsem.c                                     |    2 +-
 kernel/stop_machine.c                              |    2 +-
 kernel/taskstats.c                                 |    2 +-
 kernel/trace/trace.h                               |    2 +-
 kernel/trace/trace_mmiotrace.c                     |    2 +-
 lib/atomic64.c                                     |    2 +-
 lib/atomic64_test.c                                |    2 +-
 lib/crc32.c                                        |    2 +-
 lib/dec_and_lock.c                                 |    2 +-
 mm/init-mm.c                                       |    2 +-
 mm/kmemleak.c                                      |    2 +-
 mm/slob.c                                          |    2 +-
 mm/vmalloc.c                                       |    2 +-
 net/atm/atm_misc.c                                 |    2 +-
 net/atm/clip.c                                     |    2 +-
 net/atm/common.c                                   |    2 +-
 net/atm/lec.c                                      |    2 +-
 net/atm/proc.c                                     |    2 +-
 net/bridge/br_fdb.c                                |    2 +-
 net/core/flow.c                                    |    2 +-
 net/decnet/dn_fib.c                                |    2 +-
 net/decnet/dn_neigh.c                              |    2 +-
 net/decnet/dn_table.c                              |    2 +-
 net/decnet/dn_timer.c                              |    2 +-
 net/ipv4/cipso_ipv4.c                              |    2 +-
 net/ipv4/raw.c                                     |    2 +-
 net/ipv6/ip6_tunnel.c                              |    2 +-
 net/iucv/iucv.c                                    |    2 +-
 net/l2tp/l2tp_core.c                               |    2 +-
 net/l2tp/l2tp_ppp.c                                |    2 +-
 net/netfilter/nfnetlink_log.c                      |    2 +-
 net/netfilter/nfnetlink_queue.c                    |    2 +-
 net/netlabel/netlabel_cipso_v4.c                   |    2 +-
 net/netlabel/netlabel_kapi.c                       |    2 +-
 net/netlabel/netlabel_mgmt.c                       |    2 +-
 net/netlabel/netlabel_mgmt.h                       |    2 +-
 net/netlabel/netlabel_unlabeled.c                  |    2 +-
 net/sunrpc/xprtrdma/xprt_rdma.h                    |    2 +-
 net/tipc/core.h                                    |    2 +-
 security/selinux/hooks.c                           |    2 +-
 security/selinux/xfrm.c                            |    2 +-
 sound/pci/echoaudio/darla20.c                      |    2 +-
 sound/pci/echoaudio/darla24.c                      |    2 +-
 sound/pci/echoaudio/echo3g.c                       |    2 +-
 sound/pci/echoaudio/gina20.c                       |    2 +-
 sound/pci/echoaudio/gina24.c                       |    2 +-
 sound/pci/echoaudio/indigo.c                       |    2 +-
 sound/pci/echoaudio/indigodj.c                     |    2 +-
 sound/pci/echoaudio/indigodjx.c                    |    2 +-
 sound/pci/echoaudio/indigoio.c                     |    2 +-
 sound/pci/echoaudio/indigoiox.c                    |    2 +-
 sound/pci/echoaudio/layla20.c                      |    2 +-
 sound/pci/echoaudio/layla24.c                      |    2 +-
 sound/pci/echoaudio/mia.c                          |    2 +-
 sound/pci/echoaudio/mona.c                         |    2 +-
 sound/pci/lx6464es/lx6464es.h                      |    2 +-
 sound/sparc/dbri.c                                 |    2 +-
 444 files changed, 431 insertions(+), 453 deletions(-)

diff --git a/arch/alpha/include/asm/atomic.h b/arch/alpha/include/asm/atomic.h
index e756d04..88b7491 100644
--- a/arch/alpha/include/asm/atomic.h
+++ b/arch/alpha/include/asm/atomic.h
@@ -199,7 +199,6 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 	return c != (u);
 }
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 /**
  * atomic64_add_unless - add unless the number is a given value
diff --git a/arch/alpha/include/asm/local.h b/arch/alpha/include/asm/local.h
index b9e3e33..9c94b84 100644
--- a/arch/alpha/include/asm/local.h
+++ b/arch/alpha/include/asm/local.h
@@ -2,7 +2,7 @@
 #define _ALPHA_LOCAL_H
 
 #include <linux/percpu.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 typedef struct
 {
diff --git a/arch/alpha/kernel/perf_event.c b/arch/alpha/kernel/perf_event.c
index 90561c4..6c8abee 100644
--- a/arch/alpha/kernel/perf_event.c
+++ b/arch/alpha/kernel/perf_event.c
@@ -17,7 +17,7 @@
 #include <linux/init.h>
 
 #include <asm/hwrpb.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/irq.h>
 #include <asm/irq_regs.h>
 #include <asm/pal.h>
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index d739703..4087a56 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -31,7 +31,7 @@
 
 #include <asm/hwrpb.h>
 #include <asm/ptrace.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
diff --git a/arch/alpha/lib/dec_and_lock.c b/arch/alpha/lib/dec_and_lock.c
index 0f5520d..f9f5fe8 100644
--- a/arch/alpha/lib/dec_and_lock.c
+++ b/arch/alpha/lib/dec_and_lock.c
@@ -6,7 +6,7 @@
  */
 
 #include <linux/spinlock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
   asm (".text					\n\
 	.global _atomic_dec_and_lock		\n\
diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
index 7e79503..4d501f1 100644
--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
@@ -217,7 +217,6 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 		c = old;
 	return c != u;
 }
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 #define atomic_inc(v)		atomic_add(1, v)
 #define atomic_dec(v)		atomic_sub(1, v)
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 344e52b..0ea910c 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -27,7 +27,7 @@
 #include <linux/clockchips.h>
 #include <linux/completion.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cacheflush.h>
 #include <asm/cpu.h>
 #include <asm/cputype.h>
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index d52eec2..973f87c 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -25,7 +25,7 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cacheflush.h>
 #include <asm/system.h>
 #include <asm/unistd.h>
diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index ea53f4d..4159eca 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -20,7 +20,7 @@
 #include <linux/io.h>
 
 #include <asm/irq.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/mach/time.h>
 #include <asm/mach/irq.h>
 
diff --git a/arch/arm/mach-bcmring/dma.c b/arch/arm/mach-bcmring/dma.c
index d87ad30..f7c658a 100644
--- a/arch/arm/mach-bcmring/dma.c
+++ b/arch/arm/mach-bcmring/dma.c
@@ -34,7 +34,7 @@
 
 #include <linux/mm.h>
 #include <linux/pfn.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <mach/dma.h>
 
 /* I don't quite understand why dc4 fails when this is set to 1 and DMA is enabled */
diff --git a/arch/arm/mach-cns3xxx/include/mach/pm.h b/arch/arm/mach-cns3xxx/include/mach/pm.h
index 6eae7f7..c2588cc 100644
--- a/arch/arm/mach-cns3xxx/include/mach/pm.h
+++ b/arch/arm/mach-cns3xxx/include/mach/pm.h
@@ -11,7 +11,7 @@
 #ifndef __CNS3XXX_PM_H
 #define __CNS3XXX_PM_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 void cns3xxx_pwr_clk_en(unsigned int block);
 void cns3xxx_pwr_clk_dis(unsigned int block);
diff --git a/arch/arm/mach-cns3xxx/pm.c b/arch/arm/mach-cns3xxx/pm.c
index 5e57955..0c04678 100644
--- a/arch/arm/mach-cns3xxx/pm.c
+++ b/arch/arm/mach-cns3xxx/pm.c
@@ -10,7 +10,7 @@
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/delay.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <mach/system.h>
 #include <mach/cns3xxx.h>
 #include <mach/pm.h>
diff --git a/arch/arm/mach-omap1/pm.c b/arch/arm/mach-omap1/pm.c
index 98ba978..495b398 100644
--- a/arch/arm/mach-omap1/pm.c
+++ b/arch/arm/mach-omap1/pm.c
@@ -44,7 +44,7 @@
 #include <linux/io.h>
 
 #include <asm/irq.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/mach/time.h>
 #include <asm/mach/irq.h>
 
diff --git a/arch/arm/mach-s3c2440/clock.c b/arch/arm/mach-s3c2440/clock.c
index 3dc2426..485383f 100644
--- a/arch/arm/mach-s3c2440/clock.c
+++ b/arch/arm/mach-s3c2440/clock.c
@@ -36,7 +36,7 @@
 #include <linux/io.h>
 
 #include <mach/hardware.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/irq.h>
 
 #include <mach/regs-clock.h>
diff --git a/arch/arm/mach-s3c2440/s3c2442.c b/arch/arm/mach-s3c2440/s3c2442.c
index 6224bad..9ad99f8 100644
--- a/arch/arm/mach-s3c2440/s3c2442.c
+++ b/arch/arm/mach-s3c2440/s3c2442.c
@@ -38,7 +38,7 @@
 #include <linux/io.h>
 
 #include <mach/hardware.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/irq.h>
 
 #include <mach/regs-clock.h>
diff --git a/arch/arm/mach-s3c2440/s3c244x-clock.c b/arch/arm/mach-s3c2440/s3c244x-clock.c
index f8d9613..7f5ea0a 100644
--- a/arch/arm/mach-s3c2440/s3c244x-clock.c
+++ b/arch/arm/mach-s3c2440/s3c244x-clock.c
@@ -35,7 +35,7 @@
 #include <linux/io.h>
 
 #include <mach/hardware.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/irq.h>
 
 #include <mach/regs-clock.h>
diff --git a/arch/avr32/include/asm/atomic.h b/arch/avr32/include/asm/atomic.h
index bbce6a1..f229c38 100644
--- a/arch/avr32/include/asm/atomic.h
+++ b/arch/avr32/include/asm/atomic.h
@@ -188,7 +188,6 @@ static inline int atomic_sub_if_positive(int i, atomic_t *v)
 #define atomic_dec_and_test(v) (atomic_sub_return(1, v) == 0)
 #define atomic_add_negative(i, v) (atomic_add_return(i, v) < 0)
 
-#define atomic_inc_not_zero(v)	atomic_add_unless(v, 1, 0)
 #define atomic_dec_if_positive(v) atomic_sub_if_positive(1, v)
 
 #define smp_mb__before_atomic_dec()	barrier()
diff --git a/arch/blackfin/include/asm/atomic.h b/arch/blackfin/include/asm/atomic.h
index e485089..1fcc2a8 100644
--- a/arch/blackfin/include/asm/atomic.h
+++ b/arch/blackfin/include/asm/atomic.h
@@ -102,7 +102,6 @@ static inline int atomic_test_mask(int mask, atomic_t *v)
 		c = old;					\
 	c != (u);						\
 })
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 /*
  * atomic_inc_and_test - increment and test
diff --git a/arch/blackfin/include/asm/dma.h b/arch/blackfin/include/asm/dma.h
index d9dbc1a..dac0c97 100644
--- a/arch/blackfin/include/asm/dma.h
+++ b/arch/blackfin/include/asm/dma.h
@@ -10,7 +10,7 @@
 
 #include <linux/interrupt.h>
 #include <mach/dma.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/blackfin.h>
 #include <asm/page.h>
 #include <asm-generic/dma.h>
diff --git a/arch/blackfin/include/asm/ipipe.h b/arch/blackfin/include/asm/ipipe.h
index 9e0cc0e..17b5e92 100644
--- a/arch/blackfin/include/asm/ipipe.h
+++ b/arch/blackfin/include/asm/ipipe.h
@@ -32,7 +32,7 @@
 #include <asm/ptrace.h>
 #include <asm/irq.h>
 #include <asm/bitops.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/traps.h>
 #include <asm/bitsperlong.h>
 
diff --git a/arch/blackfin/include/asm/spinlock.h b/arch/blackfin/include/asm/spinlock.h
index 1f286e7..10e7986 100644
--- a/arch/blackfin/include/asm/spinlock.h
+++ b/arch/blackfin/include/asm/spinlock.h
@@ -11,7 +11,7 @@
 # include <asm-generic/spinlock.h>
 #else
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 asmlinkage int __raw_spin_is_locked_asm(volatile int *ptr);
 asmlinkage void __raw_spin_lock_asm(volatile int *ptr);
diff --git a/arch/blackfin/kernel/ftrace.c b/arch/blackfin/kernel/ftrace.c
index 48808a1..9277905 100644
--- a/arch/blackfin/kernel/ftrace.c
+++ b/arch/blackfin/kernel/ftrace.c
@@ -9,7 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cacheflush.h>
 
 #ifdef CONFIG_DYNAMIC_FTRACE
diff --git a/arch/blackfin/kernel/ipipe.c b/arch/blackfin/kernel/ipipe.c
index 486426f..dbe1122 100644
--- a/arch/blackfin/kernel/ipipe.c
+++ b/arch/blackfin/kernel/ipipe.c
@@ -32,7 +32,7 @@
 #include <linux/unistd.h>
 #include <linux/io.h>
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/irq_handler.h>
 
 DEFINE_PER_CPU(struct pt_regs, __ipipe_tick_regs);
diff --git a/arch/blackfin/kernel/nmi.c b/arch/blackfin/kernel/nmi.c
index 679d0db..9919d29 100644
--- a/arch/blackfin/kernel/nmi.c
+++ b/arch/blackfin/kernel/nmi.c
@@ -18,7 +18,7 @@
 #include <linux/smp.h>
 #include <linux/timer.h>
 #include <asm/blackfin.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cacheflush.h>
 #include <asm/bfin_watchdog.h>
 
diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index 35e7e1e..0155a55 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -23,7 +23,7 @@
 #include <linux/seq_file.h>
 #include <linux/irq.h>
 #include <linux/slab.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cacheflush.h>
 #include <asm/irq_handler.h>
 #include <asm/mmu_context.h>
diff --git a/arch/cris/arch-v32/drivers/cryptocop.c b/arch/cris/arch-v32/drivers/cryptocop.c
index c03bc3b..642c6fe 100644
--- a/arch/cris/arch-v32/drivers/cryptocop.c
+++ b/arch/cris/arch-v32/drivers/cryptocop.c
@@ -16,7 +16,7 @@
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <linux/list.h>
 #include <linux/interrupt.h>
diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
index a0843a7..0b99df7 100644
--- a/arch/cris/arch-v32/kernel/smp.c
+++ b/arch/cris/arch-v32/kernel/smp.c
@@ -7,7 +7,7 @@
 #include <asm/mmu_context.h>
 #include <hwregs/asm/mmu_defs_asm.h>
 #include <hwregs/supp_reg.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <linux/err.h>
 #include <linux/init.h>
diff --git a/arch/cris/include/asm/atomic.h b/arch/cris/include/asm/atomic.h
index 88dc9b9..ce9f67e 100644
--- a/arch/cris/include/asm/atomic.h
+++ b/arch/cris/include/asm/atomic.h
@@ -150,7 +150,6 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 	cris_atomic_restore(v, flags);
 	return ret != u;
 }
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 /* Atomic operations are already serializing */
 #define smp_mb__before_atomic_dec()    barrier()
diff --git a/arch/cris/include/asm/bitops.h b/arch/cris/include/asm/bitops.h
index 310e0de..20aa25b 100644
--- a/arch/cris/include/asm/bitops.h
+++ b/arch/cris/include/asm/bitops.h
@@ -20,7 +20,7 @@
 
 #include <arch/bitops.h>
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/compiler.h>
 
 /*
diff --git a/arch/cris/kernel/process.c b/arch/cris/kernel/process.c
index c99aeab..aa585e4 100644
--- a/arch/cris/kernel/process.c
+++ b/arch/cris/kernel/process.c
@@ -12,7 +12,7 @@
  * This file handles the architecture-dependent parts of process handling..
  */
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
 #include <asm/irq.h>
diff --git a/arch/frv/include/asm/atomic.h b/arch/frv/include/asm/atomic.h
index fae32c7..b07b75f 100644
--- a/arch/frv/include/asm/atomic.h
+++ b/arch/frv/include/asm/atomic.h
@@ -256,7 +256,6 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 	return c != (u);
 }
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 #include <asm-generic/atomic-long.h>
 #endif /* _ASM_ATOMIC_H */
diff --git a/arch/frv/include/asm/hardirq.h b/arch/frv/include/asm/hardirq.h
index 5fc8b6f..c62833d 100644
--- a/arch/frv/include/asm/hardirq.h
+++ b/arch/frv/include/asm/hardirq.h
@@ -12,7 +12,7 @@
 #ifndef __ASM_HARDIRQ_H
 #define __ASM_HARDIRQ_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 extern atomic_t irq_err_count;
 static inline void ack_bad_irq(int irq)
diff --git a/arch/frv/kernel/irq.c b/arch/frv/kernel/irq.c
index a5f624a..3facbc2 100644
--- a/arch/frv/kernel/irq.c
+++ b/arch/frv/kernel/irq.c
@@ -25,7 +25,7 @@
 #include <linux/module.h>
 #include <linux/bitops.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/io.h>
 #include <asm/smp.h>
 #include <asm/system.h>
diff --git a/arch/h8300/include/asm/atomic.h b/arch/h8300/include/asm/atomic.h
index 984221a..b641714 100644
--- a/arch/h8300/include/asm/atomic.h
+++ b/arch/h8300/include/asm/atomic.h
@@ -116,7 +116,6 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 	local_irq_restore(flags);
 	return ret != u;
 }
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 static __inline__ void atomic_clear_mask(unsigned long mask, unsigned long *v)
 {
diff --git a/arch/ia64/include/asm/atomic.h b/arch/ia64/include/asm/atomic.h
index 4468814..fdb8870 100644
--- a/arch/ia64/include/asm/atomic.h
+++ b/arch/ia64/include/asm/atomic.h
@@ -105,7 +105,6 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 	return c != (u);
 }
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 static __inline__ long atomic64_add_unless(atomic64_t *v, long a, long u)
 {
diff --git a/arch/ia64/include/asm/processor.h b/arch/ia64/include/asm/processor.h
index 03afe79..d9f397f 100644
--- a/arch/ia64/include/asm/processor.h
+++ b/arch/ia64/include/asm/processor.h
@@ -75,7 +75,7 @@
 #include <asm/percpu.h>
 #include <asm/rse.h>
 #include <asm/unwind.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #ifdef CONFIG_NUMA
 #include <asm/nodedata.h>
 #endif
diff --git a/arch/ia64/include/asm/spinlock.h b/arch/ia64/include/asm/spinlock.h
index 1a91c91..b77768d 100644
--- a/arch/ia64/include/asm/spinlock.h
+++ b/arch/ia64/include/asm/spinlock.h
@@ -13,7 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/bitops.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/intrinsics.h>
 #include <asm/system.h>
 
diff --git a/arch/ia64/kernel/smp.c b/arch/ia64/kernel/smp.c
index be450a3..0bd537b 100644
--- a/arch/ia64/kernel/smp.c
+++ b/arch/ia64/kernel/smp.c
@@ -32,7 +32,7 @@
 #include <linux/bitops.h>
 #include <linux/kexec.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/current.h>
 #include <asm/delay.h>
 #include <asm/machvec.h>
diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index 14ec641..5590979 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -40,7 +40,7 @@
 #include <linux/percpu.h>
 #include <linux/bitops.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cache.h>
 #include <asm/current.h>
 #include <asm/delay.h>
diff --git a/arch/ia64/kernel/uncached.c b/arch/ia64/kernel/uncached.c
index c4696d2..6a867dc 100644
--- a/arch/ia64/kernel/uncached.c
+++ b/arch/ia64/kernel/uncached.c
@@ -25,7 +25,7 @@
 #include <asm/pal.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/tlbflush.h>
 #include <asm/sn/arch.h>
 
diff --git a/arch/m32r/include/asm/atomic.h b/arch/m32r/include/asm/atomic.h
index d44a51e..d64d894 100644
--- a/arch/m32r/include/asm/atomic.h
+++ b/arch/m32r/include/asm/atomic.h
@@ -262,7 +262,6 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 	return c != (u);
 }
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 static __inline__ void atomic_clear_mask(unsigned long  mask, atomic_t *addr)
 {
diff --git a/arch/m32r/include/asm/mmu_context.h b/arch/m32r/include/asm/mmu_context.h
index a70a3df..a979a41 100644
--- a/arch/m32r/include/asm/mmu_context.h
+++ b/arch/m32r/include/asm/mmu_context.h
@@ -11,7 +11,7 @@
 
 #ifndef __ASSEMBLY__
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/pgalloc.h>
 #include <asm/mmu.h>
 #include <asm/tlbflush.h>
diff --git a/arch/m32r/include/asm/spinlock.h b/arch/m32r/include/asm/spinlock.h
index 179a064..b0ea2f2 100644
--- a/arch/m32r/include/asm/spinlock.h
+++ b/arch/m32r/include/asm/spinlock.h
@@ -10,7 +10,7 @@
  */
 
 #include <linux/compiler.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/page.h>
 
 /*
diff --git a/arch/m32r/kernel/smp.c b/arch/m32r/kernel/smp.c
index 092d40a..ce7aea3 100644
--- a/arch/m32r/kernel/smp.c
+++ b/arch/m32r/kernel/smp.c
@@ -26,7 +26,7 @@
 
 #include <asm/cacheflush.h>
 #include <asm/pgalloc.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/io.h>
 #include <asm/mmu_context.h>
 #include <asm/m32r.h>
diff --git a/arch/m32r/kernel/traps.c b/arch/m32r/kernel/traps.c
index fbd1090..ee6a919 100644
--- a/arch/m32r/kernel/traps.c
+++ b/arch/m32r/kernel/traps.c
@@ -21,7 +21,7 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <asm/smp.h>
 
diff --git a/arch/m68k/include/asm/atomic.h b/arch/m68k/include/asm/atomic.h
index 03ae3d1..7dc8873 100644
--- a/arch/m68k/include/asm/atomic.h
+++ b/arch/m68k/include/asm/atomic.h
@@ -198,7 +198,6 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 	return c != (u);
 }
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 /* Atomic operations are already serializing */
 #define smp_mb__before_atomic_dec()	barrier()
diff --git a/arch/microblaze/include/asm/mmu_context_mm.h b/arch/microblaze/include/asm/mmu_context_mm.h
index 3e5c254..d686477 100644
--- a/arch/microblaze/include/asm/mmu_context_mm.h
+++ b/arch/microblaze/include/asm/mmu_context_mm.h
@@ -11,7 +11,7 @@
 #ifndef _ASM_MICROBLAZE_MMU_CONTEXT_H
 #define _ASM_MICROBLAZE_MMU_CONTEXT_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/bitops.h>
 #include <asm/mmu.h>
 #include <asm-generic/mm_hooks.h>
diff --git a/arch/microblaze/include/asm/prom.h b/arch/microblaze/include/asm/prom.h
index d0890d3..e82b87b 100644
--- a/arch/microblaze/include/asm/prom.h
+++ b/arch/microblaze/include/asm/prom.h
@@ -21,7 +21,7 @@
 
 #include <linux/types.h>
 #include <asm/irq.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define HAVE_ARCH_DEVTREE_FIXUPS
 
diff --git a/arch/mips/include/asm/atomic.h b/arch/mips/include/asm/atomic.h
index 4a02fe8..833a402 100644
--- a/arch/mips/include/asm/atomic.h
+++ b/arch/mips/include/asm/atomic.h
@@ -325,7 +325,6 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 	}
 	return c != (u);
 }
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 #define atomic_dec_return(v) atomic_sub_return(1, (v))
 #define atomic_inc_return(v) atomic_add_return(1, (v))
diff --git a/arch/mips/include/asm/hw_irq.h b/arch/mips/include/asm/hw_irq.h
index 77adda2..9e8ef59 100644
--- a/arch/mips/include/asm/hw_irq.h
+++ b/arch/mips/include/asm/hw_irq.h
@@ -8,7 +8,7 @@
 #ifndef __ASM_HW_IRQ_H
 #define __ASM_HW_IRQ_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 extern atomic_t irq_err_count;
 
diff --git a/arch/mips/include/asm/local.h b/arch/mips/include/asm/local.h
index fffc830..94fde8d 100644
--- a/arch/mips/include/asm/local.h
+++ b/arch/mips/include/asm/local.h
@@ -3,7 +3,7 @@
 
 #include <linux/percpu.h>
 #include <linux/bitops.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cmpxchg.h>
 #include <asm/war.h>
 
diff --git a/arch/mips/include/asm/smp.h b/arch/mips/include/asm/smp.h
index af42385..d4fb4d8 100644
--- a/arch/mips/include/asm/smp.h
+++ b/arch/mips/include/asm/smp.h
@@ -17,7 +17,7 @@
 #include <linux/threads.h>
 #include <linux/cpumask.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/smp-ops.h>
 
 extern int smp_num_siblings;
diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
index 9b734d7..b53970d 100644
--- a/arch/mips/kernel/irq.c
+++ b/arch/mips/kernel/irq.c
@@ -23,7 +23,7 @@
 #include <linux/kgdb.h>
 #include <linux/ftrace.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 #include <asm/uaccess.h>
 
diff --git a/arch/mips/kernel/mips-mt.c b/arch/mips/kernel/mips-mt.c
index b2259e7..594ca69 100644
--- a/arch/mips/kernel/mips-mt.c
+++ b/arch/mips/kernel/mips-mt.c
@@ -12,7 +12,7 @@
 
 #include <asm/cpu.h>
 #include <asm/processor.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 #include <asm/hardirq.h>
 #include <asm/mmu_context.h>
diff --git a/arch/mips/kernel/rtlx.c b/arch/mips/kernel/rtlx.c
index 557ef72..7a80b7c 100644
--- a/arch/mips/kernel/rtlx.c
+++ b/arch/mips/kernel/rtlx.c
@@ -36,7 +36,7 @@
 #include <asm/mipsmtregs.h>
 #include <asm/mips_mt.h>
 #include <asm/cacheflush.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cpu.h>
 #include <asm/processor.h>
 #include <asm/system.h>
diff --git a/arch/mips/kernel/smp-cmp.c b/arch/mips/kernel/smp-cmp.c
index cc81771..fe30951 100644
--- a/arch/mips/kernel/smp-cmp.c
+++ b/arch/mips/kernel/smp-cmp.c
@@ -25,7 +25,7 @@
 #include <linux/interrupt.h>
 #include <linux/compiler.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cacheflush.h>
 #include <asm/cpu.h>
 #include <asm/processor.h>
diff --git a/arch/mips/kernel/smp-mt.c b/arch/mips/kernel/smp-mt.c
index 1ec56e6..ce9e286 100644
--- a/arch/mips/kernel/smp-mt.c
+++ b/arch/mips/kernel/smp-mt.c
@@ -24,7 +24,7 @@
 #include <linux/compiler.h>
 #include <linux/smp.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cacheflush.h>
 #include <asm/cpu.h>
 #include <asm/processor.h>
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 32a2561..32c1e95 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -34,7 +34,7 @@
 #include <linux/err.h>
 #include <linux/ftrace.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cpu.h>
 #include <asm/processor.h>
 #include <asm/r4k-timer.h>
diff --git a/arch/mips/kernel/smtc-proc.c b/arch/mips/kernel/smtc-proc.c
index fe25655..928a5a6 100644
--- a/arch/mips/kernel/smtc-proc.c
+++ b/arch/mips/kernel/smtc-proc.c
@@ -10,7 +10,7 @@
 
 #include <asm/cpu.h>
 #include <asm/processor.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 #include <asm/hardirq.h>
 #include <asm/mmu_context.h>
diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index cedac46..f0895e7 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -30,7 +30,7 @@
 
 #include <asm/cpu.h>
 #include <asm/processor.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 #include <asm/hardirq.h>
 #include <asm/hazards.h>
diff --git a/arch/mips/kernel/sync-r4k.c b/arch/mips/kernel/sync-r4k.c
index 05dd170..99f913c 100644
--- a/arch/mips/kernel/sync-r4k.c
+++ b/arch/mips/kernel/sync-r4k.c
@@ -16,7 +16,7 @@
 #include <linux/cpumask.h>
 
 #include <asm/r4k-timer.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/barrier.h>
 #include <asm/mipsregs.h>
 
diff --git a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
index dbb6b40..2cd50ad 100644
--- a/arch/mips/kernel/vpe.c
+++ b/arch/mips/kernel/vpe.c
@@ -46,7 +46,7 @@
 #include <asm/mipsregs.h>
 #include <asm/mipsmtregs.h>
 #include <asm/cacheflush.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cpu.h>
 #include <asm/mips_mt.h>
 #include <asm/processor.h>
diff --git a/arch/mips/mipssim/sim_smtc.c b/arch/mips/mipssim/sim_smtc.c
index 30df472..9150639 100644
--- a/arch/mips/mipssim/sim_smtc.c
+++ b/arch/mips/mipssim/sim_smtc.c
@@ -24,7 +24,7 @@
 #include <linux/interrupt.h>
 #include <linux/smp.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cpu.h>
 #include <asm/processor.h>
 #include <asm/smtc.h>
diff --git a/arch/mips/sgi-ip27/ip27-nmi.c b/arch/mips/sgi-ip27/ip27-nmi.c
index bc4fa8d..005c29e 100644
--- a/arch/mips/sgi-ip27/ip27-nmi.c
+++ b/arch/mips/sgi-ip27/ip27-nmi.c
@@ -3,7 +3,7 @@
 #include <linux/nodemask.h>
 #include <linux/spinlock.h>
 #include <linux/smp.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/sn/types.h>
 #include <asm/sn/addrs.h>
 #include <asm/sn/nmi.h>
diff --git a/arch/mn10300/include/asm/atomic.h b/arch/mn10300/include/asm/atomic.h
index 9d773a6..041b9d6 100644
--- a/arch/mn10300/include/asm/atomic.h
+++ b/arch/mn10300/include/asm/atomic.h
@@ -269,7 +269,6 @@ static inline void atomic_dec(atomic_t *v)
 	c != (u);						\
 })
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 /**
  * atomic_clear_mask - Atomically clear bits in memory
diff --git a/arch/mn10300/include/asm/mmu_context.h b/arch/mn10300/include/asm/mmu_context.h
index c8f6c82..c67c2b5 100644
--- a/arch/mn10300/include/asm/mmu_context.h
+++ b/arch/mn10300/include/asm/mmu_context.h
@@ -22,7 +22,7 @@
 #ifndef _ASM_MMU_CONTEXT_H
 #define _ASM_MMU_CONTEXT_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm-generic/mm_hooks.h>
diff --git a/arch/mn10300/include/asm/spinlock.h b/arch/mn10300/include/asm/spinlock.h
index 9342915..1ae580f 100644
--- a/arch/mn10300/include/asm/spinlock.h
+++ b/arch/mn10300/include/asm/spinlock.h
@@ -11,7 +11,7 @@
 #ifndef _ASM_SPINLOCK_H
 #define _ASM_SPINLOCK_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/rwlock.h>
 #include <asm/page.h>
 
diff --git a/arch/mn10300/include/asm/system.h b/arch/mn10300/include/asm/system.h
index 8ff3e5a..94b4c5e 100644
--- a/arch/mn10300/include/asm/system.h
+++ b/arch/mn10300/include/asm/system.h
@@ -19,7 +19,7 @@
 
 #include <linux/kernel.h>
 #include <linux/irqflags.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #if !defined(CONFIG_LAZY_SAVE_FPU)
 struct fpu_state_struct;
diff --git a/arch/mn10300/kernel/mn10300-watchdog.c b/arch/mn10300/kernel/mn10300-watchdog.c
index c5e12bf..a45f0c7 100644
--- a/arch/mn10300/kernel/mn10300-watchdog.c
+++ b/arch/mn10300/kernel/mn10300-watchdog.c
@@ -19,7 +19,7 @@
 #include <linux/nmi.h>
 #include <asm/processor.h>
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/intctl-regs.h>
 #include <asm/rtc-regs.h>
 #include <asm/div64.h>
diff --git a/arch/mn10300/kernel/traps.c b/arch/mn10300/kernel/traps.c
index f03cb27..2339281 100644
--- a/arch/mn10300/kernel/traps.c
+++ b/arch/mn10300/kernel/traps.c
@@ -30,7 +30,7 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/smp.h>
 #include <asm/pgalloc.h>
 #include <asm/cacheflush.h>
diff --git a/arch/mn10300/mm/misalignment.c b/arch/mn10300/mm/misalignment.c
index eef989c..f9bb8cb 100644
--- a/arch/mn10300/mm/misalignment.c
+++ b/arch/mn10300/mm/misalignment.c
@@ -26,7 +26,7 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/smp.h>
 #include <asm/pgalloc.h>
 #include <asm/cpu-regs.h>
diff --git a/arch/mn10300/proc-mn2ws0050/proc-init.c b/arch/mn10300/proc-mn2ws0050/proc-init.c
index c58249b..fe6e249 100644
--- a/arch/mn10300/proc-mn2ws0050/proc-init.c
+++ b/arch/mn10300/proc-mn2ws0050/proc-init.c
@@ -18,7 +18,7 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/smp.h>
 #include <asm/pgalloc.h>
 #include <asm/busctl-regs.h>
diff --git a/arch/parisc/include/asm/atomic.h b/arch/parisc/include/asm/atomic.h
index f819559..1924889 100644
--- a/arch/parisc/include/asm/atomic.h
+++ b/arch/parisc/include/asm/atomic.h
@@ -220,7 +220,6 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 	return c != (u);
 }
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 #define atomic_add(i,v)	((void)(__atomic_add_return( (i),(v))))
 #define atomic_sub(i,v)	((void)(__atomic_add_return(-(i),(v))))
diff --git a/arch/parisc/include/asm/bitops.h b/arch/parisc/include/asm/bitops.h
index 43c516f..92a2c6f 100644
--- a/arch/parisc/include/asm/bitops.h
+++ b/arch/parisc/include/asm/bitops.h
@@ -8,7 +8,7 @@
 #include <linux/compiler.h>
 #include <asm/types.h>		/* for BITS_PER_LONG/SHIFT_PER_LONG */
 #include <asm/byteorder.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * HP-PARISC specific bit operations
diff --git a/arch/parisc/include/asm/mmu_context.h b/arch/parisc/include/asm/mmu_context.h
index 354b2ac..59be257 100644
--- a/arch/parisc/include/asm/mmu_context.h
+++ b/arch/parisc/include/asm/mmu_context.h
@@ -3,7 +3,7 @@
 
 #include <linux/mm.h>
 #include <linux/sched.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
 #include <asm-generic/mm_hooks.h>
diff --git a/arch/parisc/kernel/parisc_ksyms.c b/arch/parisc/kernel/parisc_ksyms.c
index df65366..a7bb757 100644
--- a/arch/parisc/kernel/parisc_ksyms.c
+++ b/arch/parisc/kernel/parisc_ksyms.c
@@ -31,7 +31,7 @@
 #include <linux/string.h>
 EXPORT_SYMBOL(memset);
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 EXPORT_SYMBOL(__xchg8);
 EXPORT_SYMBOL(__xchg32);
 EXPORT_SYMBOL(__cmpxchg_u32);
diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
index 828305f..32d5884 100644
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -33,7 +33,7 @@
 #include <linux/ftrace.h>
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/current.h>
 #include <asm/delay.h>
 #include <asm/tlbflush.h>
diff --git a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
index 8b58bf0..f19e660 100644
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -33,7 +33,7 @@
 #include <asm/irq.h>
 #include <asm/traps.h>
 #include <asm/unaligned.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/smp.h>
 #include <asm/pdc.h>
 #include <asm/pdc_chassis.h>
diff --git a/arch/parisc/lib/bitops.c b/arch/parisc/lib/bitops.c
index 353963d..a8bffd8 100644
--- a/arch/parisc/lib/bitops.c
+++ b/arch/parisc/lib/bitops.c
@@ -9,7 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #ifdef CONFIG_SMP
 arch_spinlock_t __atomic_hash[ATOMIC_HASH_SIZE] __lock_aligned = {
diff --git a/arch/powerpc/include/asm/atomic.h b/arch/powerpc/include/asm/atomic.h
index b8f152e..b2bcbee 100644
--- a/arch/powerpc/include/asm/atomic.h
+++ b/arch/powerpc/include/asm/atomic.h
@@ -212,7 +212,6 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 	return t != u;
 }
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 #define atomic_sub_and_test(a, v)	(atomic_sub_return((a), (v)) == 0)
 #define atomic_dec_and_test(v)		(atomic_dec_return((v)) == 0)
diff --git a/arch/powerpc/include/asm/emulated_ops.h b/arch/powerpc/include/asm/emulated_ops.h
index 4592167..7c9ee31 100644
--- a/arch/powerpc/include/asm/emulated_ops.h
+++ b/arch/powerpc/include/asm/emulated_ops.h
@@ -18,7 +18,7 @@
 #ifndef _ASM_POWERPC_EMULATED_OPS_H
 #define _ASM_POWERPC_EMULATED_OPS_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/perf_event.h>
 
 
diff --git a/arch/powerpc/include/asm/irq.h b/arch/powerpc/include/asm/irq.h
index 1bff591..eac727c 100644
--- a/arch/powerpc/include/asm/irq.h
+++ b/arch/powerpc/include/asm/irq.h
@@ -14,7 +14,7 @@
 #include <linux/radix-tree.h>
 
 #include <asm/types.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 
 /* Define a way to iterate across irqs. */
diff --git a/arch/powerpc/include/asm/local.h b/arch/powerpc/include/asm/local.h
index c2410af..b8da913 100644
--- a/arch/powerpc/include/asm/local.h
+++ b/arch/powerpc/include/asm/local.h
@@ -2,7 +2,7 @@
 #define _ARCH_POWERPC_LOCAL_H
 
 #include <linux/percpu.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 typedef struct
 {
diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
index c189aa5..8505fc5 100644
--- a/arch/powerpc/include/asm/prom.h
+++ b/arch/powerpc/include/asm/prom.h
@@ -18,7 +18,7 @@
  */
 #include <linux/types.h>
 #include <asm/irq.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define HAVE_ARCH_DEVTREE_FIXUPS
 
diff --git a/arch/powerpc/kernel/of_platform.c b/arch/powerpc/kernel/of_platform.c
index 2458218..59dbf6a 100644
--- a/arch/powerpc/kernel/of_platform.c
+++ b/arch/powerpc/kernel/of_platform.c
@@ -26,7 +26,7 @@
 #include <asm/topology.h>
 #include <asm/pci-bridge.h>
 #include <asm/ppc-pci.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #ifdef CONFIG_PPC_OF_PLATFORM_PCI
 
diff --git a/arch/powerpc/kernel/ppc_ksyms.c b/arch/powerpc/kernel/ppc_ksyms.c
index 7d28f54..f5ae872 100644
--- a/arch/powerpc/kernel/ppc_ksyms.c
+++ b/arch/powerpc/kernel/ppc_ksyms.c
@@ -18,7 +18,7 @@
 #include <asm/cacheflush.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/checksum.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 271ff63..f7a2143 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -38,7 +38,7 @@
 #include <asm/udbg.h>
 #include <asm/syscalls.h>
 #include <asm/smp.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/mmu.h>
 #include <asm/topology.h>
diff --git a/arch/powerpc/kernel/rtasd.c b/arch/powerpc/kernel/rtasd.c
index 67f6c3b..481ef06 100644
--- a/arch/powerpc/kernel/rtasd.c
+++ b/arch/powerpc/kernel/rtasd.c
@@ -27,7 +27,7 @@
 #include <asm/rtas.h>
 #include <asm/prom.h>
 #include <asm/nvram.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/machdep.h>
 
 
diff --git a/arch/powerpc/kernel/smp-tbsync.c b/arch/powerpc/kernel/smp-tbsync.c
index 03e45c4..640de83 100644
--- a/arch/powerpc/kernel/smp-tbsync.c
+++ b/arch/powerpc/kernel/smp-tbsync.c
@@ -11,7 +11,7 @@
 #include <linux/unistd.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/smp.h>
 #include <asm/time.h>
 
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 8ebc670..8e8f11c 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -33,7 +33,7 @@
 #include <linux/topology.h>
 
 #include <asm/ptrace.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/irq.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
diff --git a/arch/powerpc/platforms/83xx/km83xx.c b/arch/powerpc/platforms/83xx/km83xx.c
index a2b9b9e..efd0f03 100644
--- a/arch/powerpc/platforms/83xx/km83xx.c
+++ b/arch/powerpc/platforms/83xx/km83xx.c
@@ -28,7 +28,7 @@
 #include <linux/of_device.h>
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
 #include <asm/machdep.h>
diff --git a/arch/powerpc/platforms/83xx/mpc832x_mds.c b/arch/powerpc/platforms/83xx/mpc832x_mds.c
index ec0b401b..d43cb26 100644
--- a/arch/powerpc/platforms/83xx/mpc832x_mds.c
+++ b/arch/powerpc/platforms/83xx/mpc832x_mds.c
@@ -27,7 +27,7 @@
 #include <linux/of_device.h>
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
 #include <asm/machdep.h>
diff --git a/arch/powerpc/platforms/83xx/mpc834x_itx.c b/arch/powerpc/platforms/83xx/mpc834x_itx.c
index 81e44fa..6b45969 100644
--- a/arch/powerpc/platforms/83xx/mpc834x_itx.c
+++ b/arch/powerpc/platforms/83xx/mpc834x_itx.c
@@ -26,7 +26,7 @@
 #include <linux/of_platform.h>
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
 #include <asm/machdep.h>
diff --git a/arch/powerpc/platforms/83xx/mpc834x_mds.c b/arch/powerpc/platforms/83xx/mpc834x_mds.c
index d0a634b..8fdb80a 100644
--- a/arch/powerpc/platforms/83xx/mpc834x_mds.c
+++ b/arch/powerpc/platforms/83xx/mpc834x_mds.c
@@ -26,7 +26,7 @@
 #include <linux/of_platform.h>
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
 #include <asm/machdep.h>
diff --git a/arch/powerpc/platforms/83xx/mpc836x_mds.c b/arch/powerpc/platforms/83xx/mpc836x_mds.c
index 09e9d6f..621a7f3 100644
--- a/arch/powerpc/platforms/83xx/mpc836x_mds.c
+++ b/arch/powerpc/platforms/83xx/mpc836x_mds.c
@@ -34,7 +34,7 @@
 #include <linux/of_device.h>
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
 #include <asm/machdep.h>
diff --git a/arch/powerpc/platforms/83xx/sbc834x.c b/arch/powerpc/platforms/83xx/sbc834x.c
index 49023db..af41d8c 100644
--- a/arch/powerpc/platforms/83xx/sbc834x.c
+++ b/arch/powerpc/platforms/83xx/sbc834x.c
@@ -28,7 +28,7 @@
 #include <linux/of_platform.h>
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
 #include <asm/machdep.h>
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_cds.c b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
index 6299a2a..2bf9978 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_cds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
@@ -31,7 +31,7 @@
 #include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
 #include <asm/machdep.h>
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_mds.c b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
index 747d1ee..973b3f4 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_mds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
@@ -36,7 +36,7 @@
 #include <linux/memblock.h>
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
 #include <asm/machdep.h>
diff --git a/arch/powerpc/platforms/85xx/sbc8548.c b/arch/powerpc/platforms/85xx/sbc8548.c
index ecdd8c0..d07dcb7 100644
--- a/arch/powerpc/platforms/85xx/sbc8548.c
+++ b/arch/powerpc/platforms/85xx/sbc8548.c
@@ -34,7 +34,7 @@
 #include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
 #include <asm/machdep.h>
diff --git a/arch/powerpc/platforms/cell/cpufreq_spudemand.c b/arch/powerpc/platforms/cell/cpufreq_spudemand.c
index d809836..7f92096 100644
--- a/arch/powerpc/platforms/cell/cpufreq_spudemand.c
+++ b/arch/powerpc/platforms/cell/cpufreq_spudemand.c
@@ -24,7 +24,7 @@
 #include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/machdep.h>
 #include <asm/spu.h>
 
diff --git a/arch/powerpc/platforms/cell/smp.c b/arch/powerpc/platforms/cell/smp.c
index dbb641e..f2e1dfe 100644
--- a/arch/powerpc/platforms/cell/smp.c
+++ b/arch/powerpc/platforms/cell/smp.c
@@ -28,7 +28,7 @@
 #include <linux/cpu.h>
 
 #include <asm/ptrace.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/irq.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
diff --git a/arch/powerpc/platforms/cell/spufs/context.c b/arch/powerpc/platforms/cell/spufs/context.c
index 0c87bcd..bf4d41d 100644
--- a/arch/powerpc/platforms/cell/spufs/context.c
+++ b/arch/powerpc/platforms/cell/spufs/context.c
@@ -24,7 +24,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/spu.h>
 #include <asm/spu_csa.h>
 #include "spufs.h"
diff --git a/arch/powerpc/platforms/chrp/smp.c b/arch/powerpc/platforms/chrp/smp.c
index a800122..feab30b 100644
--- a/arch/powerpc/platforms/chrp/smp.c
+++ b/arch/powerpc/platforms/chrp/smp.c
@@ -18,7 +18,7 @@
 #include <linux/spinlock.h>
 
 #include <asm/ptrace.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/irq.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
diff --git a/arch/powerpc/platforms/iseries/smp.c b/arch/powerpc/platforms/iseries/smp.c
index e3265ad..3d206fd 100644
--- a/arch/powerpc/platforms/iseries/smp.c
+++ b/arch/powerpc/platforms/iseries/smp.c
@@ -29,7 +29,7 @@
 #include <linux/cpu.h>
 
 #include <asm/ptrace.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/irq.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
diff --git a/arch/powerpc/platforms/powermac/backlight.c b/arch/powerpc/platforms/powermac/backlight.c
index d679964..c2f3e86 100644
--- a/arch/powerpc/platforms/powermac/backlight.c
+++ b/arch/powerpc/platforms/powermac/backlight.c
@@ -12,7 +12,7 @@
 #include <linux/backlight.h>
 #include <linux/adb.h>
 #include <linux/pmu.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/prom.h>
 #include <asm/backlight.h>
 
diff --git a/arch/powerpc/platforms/powermac/smp.c b/arch/powerpc/platforms/powermac/smp.c
index db092d7..caf85e1 100644
--- a/arch/powerpc/platforms/powermac/smp.c
+++ b/arch/powerpc/platforms/powermac/smp.c
@@ -35,7 +35,7 @@
 #include <linux/compiler.h>
 
 #include <asm/ptrace.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/code-patching.h>
 #include <asm/irq.h>
 #include <asm/page.h>
diff --git a/arch/powerpc/platforms/pseries/eeh.c b/arch/powerpc/platforms/pseries/eeh.c
index 46b55cf..ada6e07 100644
--- a/arch/powerpc/platforms/pseries/eeh.c
+++ b/arch/powerpc/platforms/pseries/eeh.c
@@ -31,7 +31,7 @@
 #include <linux/spinlock.h>
 #include <linux/of.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/eeh.h>
 #include <asm/eeh_event.h>
 #include <asm/io.h>
diff --git a/arch/powerpc/platforms/pseries/eeh_cache.c b/arch/powerpc/platforms/pseries/eeh_cache.c
index 8ed0d2d..fc5ae76 100644
--- a/arch/powerpc/platforms/pseries/eeh_cache.c
+++ b/arch/powerpc/platforms/pseries/eeh_cache.c
@@ -25,7 +25,7 @@
 #include <linux/rbtree.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/pci-bridge.h>
 #include <asm/ppc-pci.h>
 
diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
index fbffd7e..73c90f2 100644
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -27,7 +27,7 @@
 #include <linux/cpu.h>
 
 #include <asm/ptrace.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/irq.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
diff --git a/arch/powerpc/sysdev/fsl_soc.c b/arch/powerpc/sysdev/fsl_soc.c
index 19e5015..173c3a7 100644
--- a/arch/powerpc/sysdev/fsl_soc.c
+++ b/arch/powerpc/sysdev/fsl_soc.c
@@ -32,7 +32,7 @@
 #include <linux/fs_uart_pd.h>
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/time.h>
diff --git a/arch/powerpc/sysdev/tsi108_dev.c b/arch/powerpc/sysdev/tsi108_dev.c
index ee05680..9f51f97 100644
--- a/arch/powerpc/sysdev/tsi108_dev.c
+++ b/arch/powerpc/sysdev/tsi108_dev.c
@@ -23,7 +23,7 @@
 #include <asm/tsi108.h>
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/prom.h>
diff --git a/arch/s390/include/asm/atomic.h b/arch/s390/include/asm/atomic.h
index d9db138..29d7563 100644
--- a/arch/s390/include/asm/atomic.h
+++ b/arch/s390/include/asm/atomic.h
@@ -108,7 +108,6 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 	return c != u;
 }
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 #undef __CS_LOOP
 
diff --git a/arch/s390/kernel/dis.c b/arch/s390/kernel/dis.c
index 1ca3d1d..45df6d4 100644
--- a/arch/s390/kernel/dis.c
+++ b/arch/s390/kernel/dis.c
@@ -27,7 +27,7 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/mathemu.h>
 #include <asm/cpcmd.h>
 #include <asm/lowcore.h>
diff --git a/arch/s390/kernel/traps.c b/arch/s390/kernel/traps.c
index a65d2e8..2450a63 100644
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -36,7 +36,7 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/mathemu.h>
 #include <asm/cpcmd.h>
 #include <asm/lowcore.h>
diff --git a/arch/sh/include/asm/atomic.h b/arch/sh/include/asm/atomic.h
index c798312..8ddb263 100644
--- a/arch/sh/include/asm/atomic.h
+++ b/arch/sh/include/asm/atomic.h
@@ -30,7 +30,6 @@
 #define atomic_inc_and_test(v)		(atomic_inc_return(v) == 0)
 #define atomic_sub_and_test(i,v)	(atomic_sub_return((i), (v)) == 0)
 #define atomic_dec_and_test(v)		(atomic_sub_return(1, (v)) == 0)
-#define atomic_inc_not_zero(v)		atomic_add_unless((v), 1, 0)
 
 #define atomic_inc(v)			atomic_add(1, (v))
 #define atomic_dec(v)			atomic_sub(1, (v))
diff --git a/arch/sh/include/asm/hw_irq.h b/arch/sh/include/asm/hw_irq.h
index 603cdde..693d441 100644
--- a/arch/sh/include/asm/hw_irq.h
+++ b/arch/sh/include/asm/hw_irq.h
@@ -3,7 +3,7 @@
 
 #include <linux/init.h>
 #include <linux/sh_intc.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 extern atomic_t irq_err_count;
 
diff --git a/arch/sh/include/asm/smp.h b/arch/sh/include/asm/smp.h
index 9070d94..78b0d0f4 100644
--- a/arch/sh/include/asm/smp.h
+++ b/arch/sh/include/asm/smp.h
@@ -8,7 +8,7 @@
 #ifdef CONFIG_SMP
 
 #include <linux/spinlock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/current.h>
 #include <asm/percpu.h>
 
diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
index 425d604..84db0d6 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
@@ -18,7 +18,7 @@
 #include <linux/smp.h>
 #include <asm/pgalloc.h>
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/smp.h>
 
 void (*pm_idle)(void) = NULL;
diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
index 6207561..3147a9a 100644
--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -21,7 +21,7 @@
 #include <linux/cpu.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/processor.h>
 #include <asm/system.h>
 #include <asm/mmu_context.h>
diff --git a/arch/sh/kernel/traps_64.c b/arch/sh/kernel/traps_64.c
index 6713ca9..2d4bf62 100644
--- a/arch/sh/kernel/traps_64.c
+++ b/arch/sh/kernel/traps_64.c
@@ -28,7 +28,7 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/processor.h>
 #include <asm/pgtable.h>
 #include <asm/fpu.h>
diff --git a/arch/sh/kernel/unwinder.c b/arch/sh/kernel/unwinder.c
index 468889d..521b543 100644
--- a/arch/sh/kernel/unwinder.c
+++ b/arch/sh/kernel/unwinder.c
@@ -13,7 +13,7 @@
 #include <linux/spinlock.h>
 #include <linux/module.h>
 #include <asm/unwinder.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * This is the most basic stack unwinder an architecture can
diff --git a/arch/sparc/include/asm/atomic_32.h b/arch/sparc/include/asm/atomic_32.h
index 7ae128b..7646f2c 100644
--- a/arch/sparc/include/asm/atomic_32.h
+++ b/arch/sparc/include/asm/atomic_32.h
@@ -52,7 +52,6 @@ extern void atomic_set(atomic_t *, int);
 #define atomic_dec_and_test(v) (atomic_dec_return(v) == 0)
 #define atomic_sub_and_test(i, v) (atomic_sub_return(i, v) == 0)
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 /* This is the old 24-bit implementation.  It's still used internally
  * by some sparc-specific code, notably the semaphore implementation.
diff --git a/arch/sparc/include/asm/atomic_64.h b/arch/sparc/include/asm/atomic_64.h
index bdb2ff8..337139e 100644
--- a/arch/sparc/include/asm/atomic_64.h
+++ b/arch/sparc/include/asm/atomic_64.h
@@ -85,7 +85,6 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 	return c != (u);
 }
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 #define atomic64_cmpxchg(v, o, n) \
 	((__typeof__((v)->counter))cmpxchg(&((v)->counter), (o), (n)))
diff --git a/arch/sparc/include/asm/prom.h b/arch/sparc/include/asm/prom.h
index 56bbaad..edd3d3cde 100644
--- a/arch/sparc/include/asm/prom.h
+++ b/arch/sparc/include/asm/prom.h
@@ -21,7 +21,7 @@
 #include <linux/of_pdt.h>
 #include <linux/proc_fs.h>
 #include <linux/mutex.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define OF_ROOT_NODE_ADDR_CELLS_DEFAULT	2
 #define OF_ROOT_NODE_SIZE_CELLS_DEFAULT	1
diff --git a/arch/sparc/include/asm/smp_32.h b/arch/sparc/include/asm/smp_32.h
index 093f108..01c51c7 100644
--- a/arch/sparc/include/asm/smp_32.h
+++ b/arch/sparc/include/asm/smp_32.h
@@ -22,7 +22,7 @@
 
 #include <asm/ptrace.h>
 #include <asm/asi.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  *	Private routines/data
diff --git a/arch/sparc/include/asm/smp_64.h b/arch/sparc/include/asm/smp_64.h
index 20bca89..29862a9 100644
--- a/arch/sparc/include/asm/smp_64.h
+++ b/arch/sparc/include/asm/smp_64.h
@@ -27,7 +27,7 @@
  */
 
 #include <linux/bitops.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/percpu.h>
 
 DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
diff --git a/arch/sparc/kernel/irq_64.c b/arch/sparc/kernel/irq_64.c
index 4e78862..0dd8422 100644
--- a/arch/sparc/kernel/irq_64.c
+++ b/arch/sparc/kernel/irq_64.c
@@ -26,7 +26,7 @@
 
 #include <asm/ptrace.h>
 #include <asm/processor.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/io.h>
diff --git a/arch/sparc/kernel/leon_smp.c b/arch/sparc/kernel/leon_smp.c
index fe8fb44..1210fde 100644
--- a/arch/sparc/kernel/leon_smp.c
+++ b/arch/sparc/kernel/leon_smp.c
@@ -28,7 +28,7 @@
 #include <asm/tlbflush.h>
 
 #include <asm/ptrace.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/irq_regs.h>
 #include <asm/traps.h>
 
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 2cb0e1c..df4b7f4 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -22,7 +22,7 @@
 #include <asm/stacktrace.h>
 #include <asm/cpudata.h>
 #include <asm/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/nmi.h>
 #include <asm/pcr.h>
 
diff --git a/arch/sparc/kernel/smp_32.c b/arch/sparc/kernel/smp_32.c
index d5b3958..afa78cd 100644
--- a/arch/sparc/kernel/smp_32.c
+++ b/arch/sparc/kernel/smp_32.c
@@ -22,7 +22,7 @@
 #include <linux/delay.h>
 
 #include <asm/ptrace.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <asm/irq.h>
 #include <asm/page.h>
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 99cb172..4a442c3 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -28,7 +28,7 @@
 
 #include <asm/head.h>
 #include <asm/ptrace.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <asm/cpudata.h>
diff --git a/arch/sparc/lib/atomic32.c b/arch/sparc/lib/atomic32.c
index d3c7a12..1a371f8 100644
--- a/arch/sparc/lib/atomic32.c
+++ b/arch/sparc/lib/atomic32.c
@@ -7,7 +7,7 @@
  * Based on asm-parisc/atomic.h Copyright (C) 2000 Philipp Rumpf
  */
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/spinlock.h>
 #include <linux/module.h>
 
diff --git a/arch/tile/include/asm/atomic.h b/arch/tile/include/asm/atomic.h
index 739cfe0..e327271 100644
--- a/arch/tile/include/asm/atomic.h
+++ b/arch/tile/include/asm/atomic.h
@@ -121,15 +121,6 @@ static inline int atomic_read(const atomic_t *v)
  */
 #define atomic_add_negative(i, v)	(atomic_add_return((i), (v)) < 0)
 
-/**
- * atomic_inc_not_zero - increment unless the number is zero
- * @v: pointer of type atomic_t
- *
- * Atomically increments @v by 1, so long as @v is non-zero.
- * Returns non-zero if @v was non-zero, and zero otherwise.
- */
-#define atomic_inc_not_zero(v)		atomic_add_unless((v), 1, 0)
-
 /* Nonexistent functions intended to cause link errors. */
 extern unsigned long __xchg_called_with_bad_pointer(void);
 extern unsigned long __cmpxchg_called_with_bad_pointer(void);
diff --git a/arch/tile/include/asm/atomic_32.h b/arch/tile/include/asm/atomic_32.h
index 92a8bee..246feed 100644
--- a/arch/tile/include/asm/atomic_32.h
+++ b/arch/tile/include/asm/atomic_32.h
@@ -11,7 +11,7 @@
  *   NON INFRINGEMENT.  See the GNU General Public License for
  *   more details.
  *
- * Do not include directly; use <asm/atomic.h>.
+ * Do not include directly; use <linux/atomic.h>.
  */
 
 #ifndef _ASM_TILE_ATOMIC_32_H
@@ -21,7 +21,7 @@
 
 #ifndef __ASSEMBLY__
 
-/* Tile-specific routines to support <asm/atomic.h>. */
+/* Tile-specific routines to support <linux/atomic.h>. */
 int _atomic_xchg(atomic_t *v, int n);
 int _atomic_xchg_add(atomic_t *v, int i);
 int _atomic_xchg_add_unless(atomic_t *v, int a, int u);
diff --git a/arch/tile/include/asm/atomic_64.h b/arch/tile/include/asm/atomic_64.h
index 1c1e60d..a48dda3 100644
--- a/arch/tile/include/asm/atomic_64.h
+++ b/arch/tile/include/asm/atomic_64.h
@@ -11,7 +11,7 @@
  *   NON INFRINGEMENT.  See the GNU General Public License for
  *   more details.
  *
- * Do not include directly; use <asm/atomic.h>.
+ * Do not include directly; use <linux/atomic.h>.
  */
 
 #ifndef _ASM_TILE_ATOMIC_64_H
diff --git a/arch/tile/include/asm/bitops_32.h b/arch/tile/include/asm/bitops_32.h
index d31ab90..571b118 100644
--- a/arch/tile/include/asm/bitops_32.h
+++ b/arch/tile/include/asm/bitops_32.h
@@ -16,7 +16,7 @@
 #define _ASM_TILE_BITOPS_32_H
 
 #include <linux/compiler.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 
 /* Tile-specific routines to support <asm/bitops.h>. */
diff --git a/arch/tile/include/asm/bitops_64.h b/arch/tile/include/asm/bitops_64.h
index 99615e8..3211032 100644
--- a/arch/tile/include/asm/bitops_64.h
+++ b/arch/tile/include/asm/bitops_64.h
@@ -16,7 +16,7 @@
 #define _ASM_TILE_BITOPS_64_H
 
 #include <linux/compiler.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 
 /* See <asm/bitops.h> for API comments. */
diff --git a/arch/tile/include/asm/spinlock_32.h b/arch/tile/include/asm/spinlock_32.h
index a8f2c6e..a5e4208 100644
--- a/arch/tile/include/asm/spinlock_32.h
+++ b/arch/tile/include/asm/spinlock_32.h
@@ -17,7 +17,7 @@
 #ifndef _ASM_TILE_SPINLOCK_32_H
 #define _ASM_TILE_SPINLOCK_32_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/page.h>
 #include <asm/system.h>
 #include <linux/compiler.h>
diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index 72ade79..fc94607 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -21,7 +21,7 @@
 #include <asm/ptrace.h>
 #include <asm/thread_info.h>
 #include <asm/irqflags.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/asm-offsets.h>
 #include <hv/hypervisor.h>
 #include <arch/abi.h>
diff --git a/arch/tile/lib/atomic_32.c b/arch/tile/lib/atomic_32.c
index 4657021..771b251 100644
--- a/arch/tile/lib/atomic_32.c
+++ b/arch/tile/lib/atomic_32.c
@@ -17,7 +17,7 @@
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/futex.h>
 #include <arch/chip.h>
 
diff --git a/arch/tile/lib/atomic_asm_32.S b/arch/tile/lib/atomic_asm_32.S
index 2444873..1f75a2a 100644
--- a/arch/tile/lib/atomic_asm_32.S
+++ b/arch/tile/lib/atomic_asm_32.S
@@ -70,7 +70,7 @@
  */
 
 #include <linux/linkage.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/page.h>
 #include <asm/processor.h>
 
diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index 5852519..f6f5c53 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -43,7 +43,7 @@
 #include <asm/mman.h>
 #include <asm/types.h>
 #include <asm/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/vgtod.h>
 #include <asm/sys_ia32.h>
 
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 4a0b7c7..7b3ca83 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -8,7 +8,7 @@
 #include <asm/cpufeature.h>
 #include <asm/processor.h>
 #include <asm/apicdef.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/fixmap.h>
 #include <asm/mpspec.h>
 #include <asm/system.h>
diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index 952a826..897969b 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -244,7 +244,6 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 	return c != (u);
 }
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 /*
  * atomic_dec_if_positive - decrement by 1 if old value positive
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index bb9efe8..d90c4d2 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -21,7 +21,7 @@
 #include <linux/profile.h>
 #include <linux/smp.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/irq.h>
 #include <asm/sections.h>
 
diff --git a/arch/x86/include/asm/local.h b/arch/x86/include/asm/local.h
index 2e99724..9cdae5d 100644
--- a/arch/x86/include/asm/local.h
+++ b/arch/x86/include/asm/local.h
@@ -4,7 +4,7 @@
 #include <linux/percpu.h>
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/asm.h>
 
 typedef struct {
diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 021979a..d0c5b3e 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -119,7 +119,7 @@ extern struct atomic_notifier_head x86_mce_decoder_chain;
 
 #include <linux/percpu.h>
 #include <linux/init.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 extern int mce_disabled;
 extern int mce_p5_enabled;
diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 8b5393e..6902152 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -2,7 +2,7 @@
 #define _ASM_X86_MMU_CONTEXT_H
 
 #include <asm/desc.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/paravirt.h>
diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
index 971e0b4..3942e95 100644
--- a/arch/x86/include/asm/prom.h
+++ b/arch/x86/include/asm/prom.h
@@ -19,7 +19,7 @@
 #include <linux/pci.h>
 
 #include <asm/irq.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/setup.h>
 #include <asm/irq_controller.h>
 
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 3089f70..7a9af89 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_X86_SPINLOCK_H
 #define _ASM_X86_SPINLOCK_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/rwlock.h>
 #include <asm/page.h>
 #include <asm/processor.h>
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 1f2e61e..a1fe5c1 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -21,7 +21,7 @@ struct task_struct;
 struct exec_domain;
 #include <asm/processor.h>
 #include <asm/ftrace.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct thread_info {
 	struct task_struct	*task;		/* main task structure */
diff --git a/arch/x86/kernel/amd_gart_64.c b/arch/x86/kernel/amd_gart_64.c
index b117efd..8a439d3 100644
--- a/arch/x86/kernel/amd_gart_64.c
+++ b/arch/x86/kernel/amd_gart_64.c
@@ -30,7 +30,7 @@
 #include <linux/syscore_ops.h>
 #include <linux/io.h>
 #include <linux/gfp.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/mtrr.h>
 #include <asm/pgtable.h>
 #include <asm/proto.h>
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b961af8..2b26c97 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -37,7 +37,7 @@
 #include <asm/perf_event.h>
 #include <asm/x86_init.h>
 #include <asm/pgalloc.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/mpspec.h>
 #include <asm/i8253.h>
 #include <asm/i8259.h>
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 9536b3f..5d513bc 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -48,7 +48,7 @@
 #include <linux/io.h>
 
 #include <asm/apicdef.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/fixmap.h>
 #include <asm/mpspec.h>
 #include <asm/setup.h>
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 22a073d..6218439 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -21,7 +21,7 @@
 #include <linux/topology.h>
 #include <linux/cpumask.h>
 #include <asm/pgtable.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/proto.h>
 #include <asm/setup.h>
 #include <asm/apic.h>
diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index 65b8f5c..6104852 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -14,7 +14,7 @@
 #include <linux/io.h>
 #include <linux/delay.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 #include <asm/timer.h>
 #include <asm/hw_irq.h>
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index f470e4e..25fbd85 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -15,7 +15,7 @@
 #include <linux/io.h>
 #include <linux/delay.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 #include <asm/timer.h>
 #include <asm/hw_irq.h>
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b9b6716..6913369 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -49,7 +49,7 @@
 #include <asm/stacktrace.h>
 #include <asm/processor.h>
 #include <asm/debugreg.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/desc.h>
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 2b2255b..57dcbd4 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -33,7 +33,7 @@
 #include <asm/page.h>
 #include <asm/current.h>
 #include <asm/apicdef.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "kvm_cache_regs.h"
 #include "irq.h"
 #include "trace.h"
diff --git a/arch/x86/kvm/timer.c b/arch/x86/kvm/timer.c
index abd86e86..ae432ea 100644
--- a/arch/x86/kvm/timer.c
+++ b/arch/x86/kvm/timer.c
@@ -15,7 +15,7 @@
 #include <linux/kvm_host.h>
 #include <linux/kvm.h>
 #include <linux/hrtimer.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "kvm_timer.h"
 
 static int __kvm_timer_fn(struct kvm_vcpu *vcpu, struct kvm_timer *ktimer)
diff --git a/arch/x86/lib/atomic64_32.c b/arch/x86/lib/atomic64_32.c
index 540179e..042f682 100644
--- a/arch/x86/lib/atomic64_32.c
+++ b/arch/x86/lib/atomic64_32.c
@@ -4,7 +4,7 @@
 
 #include <asm/processor.h>
 #include <asm/cmpxchg.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 long long atomic64_read_cx8(long long, const atomic64_t *v);
 EXPORT_SYMBOL(atomic64_read_cx8);
diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index 3adff7d..67421f3 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -34,7 +34,7 @@
 #include <asm/pgtable.h>
 #include <linux/mmiotrace.h>
 #include <asm/e820.h> /* for ISA_START_ADDRESS */
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/percpu.h>
 #include <linux/cpu.h>
 
diff --git a/arch/xtensa/include/asm/atomic.h b/arch/xtensa/include/asm/atomic.h
index a96a061..7cca2fb 100644
--- a/arch/xtensa/include/asm/atomic.h
+++ b/arch/xtensa/include/asm/atomic.h
@@ -248,7 +248,6 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 	return c != (u);
 }
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
 {
diff --git a/arch/xtensa/kernel/process.c b/arch/xtensa/kernel/process.c
index e3558b9..47041e7 100644
--- a/arch/xtensa/kernel/process.c
+++ b/arch/xtensa/kernel/process.c
@@ -40,7 +40,7 @@
 #include <asm/platform.h>
 #include <asm/mmu.h>
 #include <asm/irq.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/asm-offsets.h>
 #include <asm/regs.h>
 
diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 940d70c..ac33d5f 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -12,7 +12,7 @@
  *
  */
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <crypto/if_alg.h>
 #include <linux/crypto.h>
 #include <linux/init.h>
diff --git a/crypto/proc.c b/crypto/proc.c
index 58fef67..3808697 100644
--- a/crypto/proc.c
+++ b/crypto/proc.c
@@ -13,7 +13,7 @@
  *
  */
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/init.h>
 #include <linux/crypto.h>
 #include <linux/rwsem.h>
diff --git a/crypto/rng.c b/crypto/rng.c
index f93cb53..45229ae 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -12,7 +12,7 @@
  *
  */
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <crypto/internal/rng.h>
 #include <linux/err.h>
 #include <linux/module.h>
diff --git a/drivers/atm/ambassador.c b/drivers/atm/ambassador.c
index a5fcb1e..ff28f8f 100644
--- a/drivers/atm/ambassador.c
+++ b/drivers/atm/ambassador.c
@@ -38,7 +38,7 @@
 #include <linux/ihex.h>
 #include <linux/slab.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/io.h>
 #include <asm/byteorder.h>
 
diff --git a/drivers/atm/atmtcp.c b/drivers/atm/atmtcp.c
index 0b06250..b22d71c 100644
--- a/drivers/atm/atmtcp.c
+++ b/drivers/atm/atmtcp.c
@@ -11,7 +11,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <asm/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 
 extern int atm_init_aal5(struct atm_vcc *vcc); /* "raw" AAL5 transport */
diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index 3230ea0..9307141 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -21,7 +21,7 @@
 #include <linux/slab.h>
 #include <asm/system.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 #include <asm/string.h>
 #include <asm/byteorder.h>
diff --git a/drivers/atm/eni.h b/drivers/atm/eni.h
index e4c9525..be7bbf0 100644
--- a/drivers/atm/eni.h
+++ b/drivers/atm/eni.h
@@ -13,7 +13,7 @@
 #include <linux/time.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "midway.h"
 
diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index ef7a658..0dffa7c 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -51,7 +51,7 @@
 #include <asm/system.h>
 #include <asm/string.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 #include <linux/wait.h>
 
diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
index bc9e702..361f5ae 100644
--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -44,7 +44,7 @@
 #include <asm/dma.h>
 #include <asm/byteorder.h>
 #include <asm/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #ifdef CONFIG_SBUS
 #include <linux/of.h>
diff --git a/drivers/atm/horizon.c b/drivers/atm/horizon.c
index d58e3fc..fd66755 100644
--- a/drivers/atm/horizon.c
+++ b/drivers/atm/horizon.c
@@ -44,7 +44,7 @@
 
 #include <asm/system.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 #include <asm/string.h>
 #include <asm/byteorder.h>
diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 1f8d724..d66f412 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -45,7 +45,7 @@
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/byteorder.h>
 
 #ifdef CONFIG_ATM_IDT77252_USE_SUNI
diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index dee4f01..080b0ab 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -57,7 +57,7 @@
 #include <linux/slab.h>
 #include <asm/system.h>  
 #include <asm/io.h>  
-#include <asm/atomic.h>  
+#include <linux/atomic.h>  
 #include <asm/uaccess.h>  
 #include <asm/string.h>  
 #include <asm/byteorder.h>  
diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index 6b313ee..1c70c45 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -51,7 +51,7 @@
 #include <linux/idr.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "nicstar.h"
 #ifdef CONFIG_ATM_NICSTAR_USE_SUNI
 #include "suni.h"
diff --git a/drivers/atm/suni.c b/drivers/atm/suni.c
index 41c56ea..90f1ccc 100644
--- a/drivers/atm/suni.c
+++ b/drivers/atm/suni.c
@@ -25,7 +25,7 @@
 #include <asm/system.h>
 #include <asm/param.h>
 #include <asm/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "suni.h"
 
diff --git a/drivers/atm/uPD98402.c b/drivers/atm/uPD98402.c
index c45ae05..5120a96 100644
--- a/drivers/atm/uPD98402.c
+++ b/drivers/atm/uPD98402.c
@@ -11,7 +11,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <asm/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "uPD98402.h"
 
diff --git a/drivers/atm/zatm.c b/drivers/atm/zatm.c
index 6249179..f6a9d4a 100644
--- a/drivers/atm/zatm.c
+++ b/drivers/atm/zatm.c
@@ -26,7 +26,7 @@
 #include <asm/system.h>
 #include <asm/string.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 
 #include "uPD98401.h"
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 9f9b235..8b50335 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -24,7 +24,7 @@
 #include <linux/stat.h>
 #include <linux/slab.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 
 static DEFINE_MUTEX(mem_sysfs_mutex);
diff --git a/drivers/base/power/sysfs.c b/drivers/base/power/sysfs.c
index a9f5b89..fbf1dfc 100644
--- a/drivers/base/power/sysfs.c
+++ b/drivers/base/power/sysfs.c
@@ -5,7 +5,7 @@
 #include <linux/device.h>
 #include <linux/string.h>
 #include <linux/pm_runtime.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/jiffies.h>
 #include "power.h"
 
diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 6961002..951a4e3 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -33,7 +33,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index 320668f..3302586 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -52,7 +52,7 @@
 #include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/delay.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #ifdef CONFIG_X86
 /*
diff --git a/drivers/char/mspec.c b/drivers/char/mspec.c
index 25d139c..5c0d96a 100644
--- a/drivers/char/mspec.c
+++ b/drivers/char/mspec.c
@@ -46,7 +46,7 @@
 #include <asm/page.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/tlbflush.h>
 #include <asm/uncached.h>
 #include <asm/sn/addrs.h>
diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 2b46a7e..23a882f 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -28,7 +28,7 @@
 #include <linux/init.h>
 #include <linux/connector.h>
 #include <linux/gfp.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/unaligned.h>
 
 #include <linux/cn_proc.h>
diff --git a/drivers/edac/edac_stub.c b/drivers/edac/edac_stub.c
index aab9707..86ad2ee 100644
--- a/drivers/edac/edac_stub.c
+++ b/drivers/edac/edac_stub.c
@@ -14,7 +14,7 @@
  */
 #include <linux/module.h>
 #include <linux/edac.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/edac.h>
 
 int edac_op_state = EDAC_OPSTATE_INVAL;
diff --git a/drivers/firewire/core-card.c b/drivers/firewire/core-card.c
index 29d2423..85661b0 100644
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -32,7 +32,7 @@
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/byteorder.h>
 
 #include "core.h"
diff --git a/drivers/firewire/core-device.c b/drivers/firewire/core-device.c
index 95a4714..8ba7f79 100644
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -38,7 +38,7 @@
 #include <linux/string.h>
 #include <linux/workqueue.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/byteorder.h>
 #include <asm/system.h>
 
diff --git a/drivers/firewire/core-topology.c b/drivers/firewire/core-topology.c
index 193ed92..94d3b49 100644
--- a/drivers/firewire/core-topology.c
+++ b/drivers/firewire/core-topology.c
@@ -29,7 +29,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/byteorder.h>
 #include <asm/system.h>
 
diff --git a/drivers/firewire/core.h b/drivers/firewire/core.h
index 0fe4e4e..b45be57 100644
--- a/drivers/firewire/core.h
+++ b/drivers/firewire/core.h
@@ -9,7 +9,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct device;
 struct fw_card;
diff --git a/drivers/firewire/nosy.c b/drivers/firewire/nosy.c
index 0618145..763626b 100644
--- a/drivers/firewire/nosy.c
+++ b/drivers/firewire/nosy.c
@@ -37,7 +37,7 @@
 #include <linux/uaccess.h>
 #include <linux/wait.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/byteorder.h>
 
 #include "nosy.h"
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index ba643b5..d480b3a 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -60,7 +60,7 @@
  *                          are considered as fatal)
  */
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/wait.h>
 #include <linux/list.h>
 #include <linux/kref.h>
diff --git a/drivers/gpu/drm/radeon/radeon_fence.c b/drivers/gpu/drm/radeon/radeon_fence.c
index 1f82294..d2a6c64 100644
--- a/drivers/gpu/drm/radeon/radeon_fence.c
+++ b/drivers/gpu/drm/radeon/radeon_fence.c
@@ -29,7 +29,7 @@
  *    Dave Airlie
  */
 #include <linux/seq_file.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/wait.h>
 #include <linux/list.h>
 #include <linux/kref.h>
diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 2e618b5..56619f6 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -37,7 +37,7 @@
 #include <linux/mm.h>
 #include <linux/file.h>
 #include <linux/module.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define TTM_ASSERT_LOCKED(param)
 #define TTM_DEBUG(fmt, arg...)
diff --git a/drivers/gpu/drm/ttm/ttm_lock.c b/drivers/gpu/drm/ttm/ttm_lock.c
index de41e55..075daf4 100644
--- a/drivers/gpu/drm/ttm/ttm_lock.c
+++ b/drivers/gpu/drm/ttm/ttm_lock.c
@@ -30,7 +30,7 @@
 
 #include "ttm/ttm_lock.h"
 #include "ttm/ttm_module.h"
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/errno.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
diff --git a/drivers/gpu/drm/ttm/ttm_object.c b/drivers/gpu/drm/ttm/ttm_object.c
index ebddd44..93577f2 100644
--- a/drivers/gpu/drm/ttm/ttm_object.c
+++ b/drivers/gpu/drm/ttm/ttm_object.c
@@ -55,7 +55,7 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct ttm_object_file {
 	struct ttm_object_device *tdev;
diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
index d948575..f790b09 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -40,7 +40,7 @@
 #include <linux/slab.h>
 #include <linux/dma-mapping.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "ttm/ttm_bo_driver.h"
 #include "ttm/ttm_page_alloc.h"
diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
index cf4330b..da2230e 100644
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -32,7 +32,7 @@
 #include <linux/sht15.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /* Commands */
 #define SHT15_MEASURE_TEMP		0x03
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 273ffe4..930a043 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -31,7 +31,7 @@
  */
 
 #include <rdma/ib_umem.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "iw_cxgb4.h"
 
diff --git a/drivers/infiniband/hw/ehca/ehca_tools.h b/drivers/infiniband/hw/ehca/ehca_tools.h
index f09914c..54c0d23 100644
--- a/drivers/infiniband/hw/ehca/ehca_tools.h
+++ b/drivers/infiniband/hw/ehca/ehca_tools.h
@@ -58,7 +58,7 @@
 #include <linux/cpu.h>
 #include <linux/device.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/abs_addr.h>
 #include <asm/ibmebus.h>
 #include <asm/io.h>
diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index e74cdf9..aac6627 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -34,7 +34,7 @@
 
 #define TCPOPT_TIMESTAMP 8
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 7b6985a..b3cc1e0 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -45,7 +45,7 @@
 
 #include <net/neighbour.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_pack.h>
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index ee165fd..8498ecd 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -39,7 +39,7 @@
 #include <linux/random.h>
 #include <linux/jiffies.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
diff --git a/drivers/isdn/gigaset/gigaset.h b/drivers/isdn/gigaset/gigaset.h
index 6dd3607..212efaf 100644
--- a/drivers/isdn/gigaset/gigaset.h
+++ b/drivers/isdn/gigaset/gigaset.h
@@ -34,7 +34,7 @@
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
 #include <linux/list.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define GIG_VERSION {0, 5, 0, 0}
 #define GIG_COMPAT  {0, 4, 0, 0}
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index c8827ff..bae6c4e 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -19,7 +19,7 @@
 #include <linux/workqueue.h>
 #include <linux/backing-dev.h>
 #include <linux/percpu.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/scatterlist.h>
 #include <asm/page.h>
 #include <asm/unaligned.h>
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 819e37e..320401d 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -10,7 +10,7 @@
  */
 
 #include <linux/types.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/blkdev.h>
 #include <linux/fs.h>
 #include <linux/init.h>
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index aa4e570..c354701 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -19,7 +19,7 @@
 #include <linux/time.h>
 #include <linux/workqueue.h>
 #include <scsi/scsi_dh.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define DM_MSG_PREFIX "multipath"
 #define MESG_STR(x) x, sizeof(x)
diff --git a/drivers/md/dm-queue-length.c b/drivers/md/dm-queue-length.c
index f92b6ce..03a837a 100644
--- a/drivers/md/dm-queue-length.c
+++ b/drivers/md/dm-queue-length.c
@@ -20,7 +20,7 @@
 #include <linux/ctype.h>
 #include <linux/errno.h>
 #include <linux/module.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define DM_MSG_PREFIX	"multipath queue-length"
 #define QL_MIN_IO	128
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 451c3bb..bfe9c23 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -17,7 +17,7 @@
 #include <linux/interrupt.h>
 #include <linux/mutex.h>
 #include <linux/delay.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define DM_MSG_PREFIX "table"
 
diff --git a/drivers/media/video/hdpvr/hdpvr-core.c b/drivers/media/video/hdpvr/hdpvr-core.c
index a27d93b..5f1db46 100644
--- a/drivers/media/video/hdpvr/hdpvr-core.c
+++ b/drivers/media/video/hdpvr/hdpvr-core.c
@@ -17,7 +17,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/usb.h>
 #include <linux/mutex.h>
 #include <linux/i2c.h>
diff --git a/drivers/media/video/tlg2300/pd-dvb.c b/drivers/media/video/tlg2300/pd-dvb.c
index edd78f8..d0da11a 100644
--- a/drivers/media/video/tlg2300/pd-dvb.c
+++ b/drivers/media/video/tlg2300/pd-dvb.c
@@ -7,7 +7,7 @@
 
 #include "vendorcmds.h"
 #include <linux/sched.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 static void dvb_urb_cleanup(struct pd_dvb_adapter *pd_dvb);
 
diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index a4db26f..2c8954e 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -20,7 +20,7 @@
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "uvcvideo.h"
 
diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index b6eae48..5bd23ce 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -31,7 +31,7 @@
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/unaligned.h>
 
 #include <media/v4l2-common.h>
diff --git a/drivers/media/video/uvc/uvc_queue.c b/drivers/media/video/uvc/uvc_queue.c
index 109a063..13e8862 100644
--- a/drivers/media/video/uvc/uvc_queue.c
+++ b/drivers/media/video/uvc/uvc_queue.c
@@ -19,7 +19,7 @@
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "uvcvideo.h"
 
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 543a803..dde6533 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -21,7 +21,7 @@
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
 #include <linux/wait.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index fc766b9..bc29e264 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -19,7 +19,7 @@
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/unaligned.h>
 
 #include <media/v4l2-common.h>
diff --git a/drivers/message/i2o/i2o_scsi.c b/drivers/message/i2o/i2o_scsi.c
index 74fbe56..c8ed7b6 100644
--- a/drivers/message/i2o/i2o_scsi.c
+++ b/drivers/message/i2o/i2o_scsi.c
@@ -59,7 +59,7 @@
 #include <asm/dma.h>
 #include <asm/system.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index b05db55..21b28fc 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -26,7 +26,7 @@
 #include <linux/sched.h>
 #include <linux/mutex.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/io.h>
 
 #define PHANTOM_VERSION		"n0.9.8"
diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index cd5789f..ddf8333 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -44,7 +44,7 @@
  * SMP torture testing
  */
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/byteorder.h>
 
 #include <linux/compiler.h>
diff --git a/drivers/net/atlx/atl2.c b/drivers/net/atlx/atl2.c
index 16249e9..7f01b7e 100644
--- a/drivers/net/atlx/atl2.c
+++ b/drivers/net/atlx/atl2.c
@@ -20,7 +20,7 @@
  * Temple Place - Suite 330, Boston, MA  02111-1307, USA.
  */
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/crc32.h>
 #include <linux/dma-mapping.h>
 #include <linux/etherdevice.h>
diff --git a/drivers/net/atlx/atl2.h b/drivers/net/atlx/atl2.h
index 927e4de..d0beb89 100644
--- a/drivers/net/atlx/atl2.h
+++ b/drivers/net/atlx/atl2.h
@@ -25,7 +25,7 @@
 #ifndef _ATL2_H_
 #define _ATL2_H_
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/netdevice.h>
 
 #ifndef _ATL2_HW_H_
diff --git a/drivers/net/cassini.c b/drivers/net/cassini.c
index 22ce03e..dedb95e 100644
--- a/drivers/net/cassini.c
+++ b/drivers/net/cassini.c
@@ -97,7 +97,7 @@
 
 #include <net/checksum.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 #include <asm/io.h>
 #include <asm/byteorder.h>
diff --git a/drivers/net/cpmac.c b/drivers/net/cpmac.c
index fec939f..cf3c4b7 100644
--- a/drivers/net/cpmac.c
+++ b/drivers/net/cpmac.c
@@ -39,7 +39,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/clk.h>
 #include <linux/gpio.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 MODULE_AUTHOR("Eugene Konev <ejka@imfi.kspu.ru>");
 MODULE_DESCRIPTION("TI AR7 ethernet driver (CPMAC)");
diff --git a/drivers/net/cxgb3/cxgb3_offload.c b/drivers/net/cxgb3/cxgb3_offload.c
index 862804f..6606cff 100644
--- a/drivers/net/cxgb3/cxgb3_offload.c
+++ b/drivers/net/cxgb3/cxgb3_offload.c
@@ -34,7 +34,7 @@
 #include <linux/slab.h>
 #include <net/neighbour.h>
 #include <linux/notifier.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/proc_fs.h>
 #include <linux/if_vlan.h>
 #include <net/netevent.h>
diff --git a/drivers/net/cxgb3/l2t.h b/drivers/net/cxgb3/l2t.h
index fd3eb07..7a12d52 100644
--- a/drivers/net/cxgb3/l2t.h
+++ b/drivers/net/cxgb3/l2t.h
@@ -34,7 +34,7 @@
 
 #include <linux/spinlock.h>
 #include "t3cdev.h"
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 enum {
 	L2T_STATE_VALID,	/* entry is up to date */
diff --git a/drivers/net/cxgb3/t3cdev.h b/drivers/net/cxgb3/t3cdev.h
index be55e9a..705713b 100644
--- a/drivers/net/cxgb3/t3cdev.h
+++ b/drivers/net/cxgb3/t3cdev.h
@@ -33,7 +33,7 @@
 #define _T3CDEV_H_
 
 #include <linux/list.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/netdevice.h>
 #include <linux/proc_fs.h>
 #include <linux/skbuff.h>
diff --git a/drivers/net/cxgb4/cxgb4_uld.h b/drivers/net/cxgb4/cxgb4_uld.h
index 1b48c01..b1d39b8 100644
--- a/drivers/net/cxgb4/cxgb4_uld.h
+++ b/drivers/net/cxgb4/cxgb4_uld.h
@@ -38,7 +38,7 @@
 #include <linux/cache.h>
 #include <linux/spinlock.h>
 #include <linux/skbuff.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /* CPL message priority levels */
 enum {
diff --git a/drivers/net/cxgb4/l2t.h b/drivers/net/cxgb4/l2t.h
index 7bd8f42..02b31d0 100644
--- a/drivers/net/cxgb4/l2t.h
+++ b/drivers/net/cxgb4/l2t.h
@@ -37,7 +37,7 @@
 
 #include <linux/spinlock.h>
 #include <linux/if_ether.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct adapter;
 struct l2t_data;
diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 3e5d0b6..e583c16 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -36,7 +36,7 @@
 #include <linux/tcp.h>
 #include <linux/semaphore.h>
 #include <linux/compat.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define SIXPACK_VERSION    "Revision: 0.3.0"
 
diff --git a/drivers/net/hamradio/dmascc.c b/drivers/net/hamradio/dmascc.c
index 52b1425..ce555d9 100644
--- a/drivers/net/hamradio/dmascc.c
+++ b/drivers/net/hamradio/dmascc.c
@@ -36,7 +36,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/sockios.h>
 #include <linux/workqueue.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/dma.h>
 #include <asm/io.h>
 #include <asm/irq.h>
diff --git a/drivers/net/ibmveth.c b/drivers/net/ibmveth.c
index b388d78..bab1a20 100644
--- a/drivers/net/ibmveth.c
+++ b/drivers/net/ibmveth.c
@@ -42,7 +42,7 @@
 #include <linux/ipv6.h>
 #include <linux/slab.h>
 #include <asm/hvcall.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/vio.h>
 #include <asm/iommu.h>
 #include <asm/firmware.h>
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index a475957..3cbda08 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -33,7 +33,7 @@
 #include <linux/timer.h>
 #include <linux/workqueue.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/uaccess.h>
diff --git a/drivers/net/ppp_generic.c b/drivers/net/ppp_generic.c
index 4609bc0..10e5d98 100644
--- a/drivers/net/ppp_generic.c
+++ b/drivers/net/ppp_generic.c
@@ -48,7 +48,7 @@
 #include <linux/slab.h>
 #include <asm/unaligned.h>
 #include <net/slhc_vj.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <linux/nsproxy.h>
 #include <net/net_namespace.h>
diff --git a/drivers/net/wimax/i2400m/i2400m.h b/drivers/net/wimax/i2400m/i2400m.h
index 5eacc65..c421a61 100644
--- a/drivers/net/wimax/i2400m/i2400m.h
+++ b/drivers/net/wimax/i2400m/i2400m.h
@@ -155,7 +155,7 @@
 #include <linux/netdevice.h>
 #include <linux/completion.h>
 #include <linux/rwsem.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <net/wimax.h>
 #include <linux/wimax/i2400m.h>
 #include <asm/byteorder.h>
diff --git a/drivers/net/wireless/b43legacy/b43legacy.h b/drivers/net/wireless/b43legacy/b43legacy.h
index 23583be..6482bc5 100644
--- a/drivers/net/wireless/b43legacy/b43legacy.h
+++ b/drivers/net/wireless/b43legacy/b43legacy.h
@@ -8,7 +8,7 @@
 #include <linux/stringify.h>
 #include <linux/netdevice.h>
 #include <linux/pci.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/io.h>
 
 #include <linux/ssb/ssb.h>
diff --git a/drivers/net/wireless/b43legacy/dma.h b/drivers/net/wireless/b43legacy/dma.h
index f89c342..686941c 100644
--- a/drivers/net/wireless/b43legacy/dma.h
+++ b/drivers/net/wireless/b43legacy/dma.h
@@ -5,7 +5,7 @@
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/linkage.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "b43legacy.h"
 
diff --git a/drivers/oprofile/oprofile_stats.h b/drivers/oprofile/oprofile_stats.h
index 0b54e46..38b6fc0 100644
--- a/drivers/oprofile/oprofile_stats.h
+++ b/drivers/oprofile/oprofile_stats.h
@@ -10,7 +10,7 @@
 #ifndef OPROFILE_STATS_H
 #define OPROFILE_STATS_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct oprofile_stat_struct {
 	atomic_t sample_lost_no_mm;
diff --git a/drivers/pci/hotplug/cpci_hotplug_core.c b/drivers/pci/hotplug/cpci_hotplug_core.c
index d703e73..3fadf2f 100644
--- a/drivers/pci/hotplug/cpci_hotplug_core.c
+++ b/drivers/pci/hotplug/cpci_hotplug_core.c
@@ -32,7 +32,7 @@
 #include <linux/pci_hotplug.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include "cpci_hotplug.h"
diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 492b7d8..6fa215a 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -16,7 +16,7 @@
 #include <xen/interface/io/pciif.h>
 #include <asm/xen/pci.h>
 #include <linux/interrupt.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/workqueue.h>
 #include <linux/bitops.h>
 #include <linux/time.h>
diff --git a/drivers/s390/block/dasd_eer.c b/drivers/s390/block/dasd_eer.c
index 77f778b..16c5208 100644
--- a/drivers/s390/block/dasd_eer.c
+++ b/drivers/s390/block/dasd_eer.c
@@ -21,7 +21,7 @@
 #include <linux/slab.h>
 
 #include <asm/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/ebcdic.h>
 
 #include "dasd_int.h"
diff --git a/drivers/s390/char/sclp_quiesce.c b/drivers/s390/char/sclp_quiesce.c
index 05909a7..a90a02c 100644
--- a/drivers/s390/char/sclp_quiesce.c
+++ b/drivers/s390/char/sclp_quiesce.c
@@ -13,7 +13,7 @@
 #include <linux/smp.h>
 #include <linux/init.h>
 #include <linux/reboot.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/ptrace.h>
 #include <asm/sigp.h>
 #include <asm/smp.h>
diff --git a/drivers/s390/char/vmlogrdr.c b/drivers/s390/char/vmlogrdr.c
index c837d74..524d988 100644
--- a/drivers/s390/char/vmlogrdr.c
+++ b/drivers/s390/char/vmlogrdr.c
@@ -21,7 +21,7 @@
 #include <linux/types.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 #include <asm/cpcmd.h>
 #include <asm/debug.h>
diff --git a/drivers/s390/cio/device.h b/drivers/s390/cio/device.h
index 7e297c7..0b7245c 100644
--- a/drivers/s390/cio/device.h
+++ b/drivers/s390/cio/device.h
@@ -2,7 +2,7 @@
 #define S390_DEVICE_H
 
 #include <asm/ccwdev.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/wait.h>
 #include <linux/notifier.h>
 #include "io_sch.h"
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 55e8f72..7e0745c 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -15,7 +15,7 @@
 #include <linux/delay.h>
 #include <linux/gfp.h>
 #include <linux/kernel_stat.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/debug.h>
 #include <asm/qdio.h>
 
diff --git a/drivers/s390/cio/qdio_thinint.c b/drivers/s390/cio/qdio_thinint.c
index 5c4e741..57bc702 100644
--- a/drivers/s390/cio/qdio_thinint.c
+++ b/drivers/s390/cio/qdio_thinint.c
@@ -9,7 +9,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/kernel_stat.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/debug.h>
 #include <asm/qdio.h>
 #include <asm/airq.h>
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 16e4a25..f5b9a96 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -40,7 +40,7 @@
 #include <linux/mutex.h>
 #include <asm/reset.h>
 #include <asm/airq.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 #include <asm/isc.h>
 #include <linux/hrtimer.h>
diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
index 8e65447..88ad33e 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -36,7 +36,7 @@
 #include <linux/seq_file.h>
 #include <linux/compat.h>
 #include <linux/slab.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 #include <linux/hw_random.h>
 
diff --git a/drivers/s390/crypto/zcrypt_cex2a.c b/drivers/s390/crypto/zcrypt_cex2a.c
index 2176d00..da171b5 100644
--- a/drivers/s390/crypto/zcrypt_cex2a.c
+++ b/drivers/s390/crypto/zcrypt_cex2a.c
@@ -30,7 +30,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/err.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 
 #include "ap_bus.h"
diff --git a/drivers/s390/crypto/zcrypt_mono.c b/drivers/s390/crypto/zcrypt_mono.c
index 44253fd..eb313c3 100644
--- a/drivers/s390/crypto/zcrypt_mono.c
+++ b/drivers/s390/crypto/zcrypt_mono.c
@@ -32,7 +32,7 @@
 #include <linux/fs.h>
 #include <linux/proc_fs.h>
 #include <linux/compat.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 
 #include "ap_bus.h"
diff --git a/drivers/s390/crypto/zcrypt_pcica.c b/drivers/s390/crypto/zcrypt_pcica.c
index 1afb69c..d84816f 100644
--- a/drivers/s390/crypto/zcrypt_pcica.c
+++ b/drivers/s390/crypto/zcrypt_pcica.c
@@ -30,7 +30,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/err.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 
 #include "ap_bus.h"
diff --git a/drivers/s390/crypto/zcrypt_pcicc.c b/drivers/s390/crypto/zcrypt_pcicc.c
index aa4c050..bdbdbe1 100644
--- a/drivers/s390/crypto/zcrypt_pcicc.c
+++ b/drivers/s390/crypto/zcrypt_pcicc.c
@@ -30,7 +30,7 @@
 #include <linux/init.h>
 #include <linux/gfp.h>
 #include <linux/err.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 
 #include "ap_bus.h"
diff --git a/drivers/s390/crypto/zcrypt_pcixcc.c b/drivers/s390/crypto/zcrypt_pcixcc.c
index 4f85eb7..dd47378 100644
--- a/drivers/s390/crypto/zcrypt_pcixcc.c
+++ b/drivers/s390/crypto/zcrypt_pcixcc.c
@@ -31,7 +31,7 @@
 #include <linux/err.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 
 #include "ap_bus.h"
diff --git a/drivers/s390/net/fsm.h b/drivers/s390/net/fsm.h
index 1e8b235..a4510cf 100644
--- a/drivers/s390/net/fsm.h
+++ b/drivers/s390/net/fsm.h
@@ -8,7 +8,7 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/string.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /**
  * Define this to get debugging messages.
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 2a4991d..7cac873 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -13,7 +13,7 @@
 #include <linux/slab.h>
 #include <scsi/fc/fc_fcp.h>
 #include <scsi/scsi_eh.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "zfcp_ext.h"
 #include "zfcp_dbf.h"
 #include "zfcp_fc.h"
diff --git a/drivers/sbus/char/display7seg.c b/drivers/sbus/char/display7seg.c
index 740da446..965a1fc 100644
--- a/drivers/sbus/char/display7seg.c
+++ b/drivers/sbus/char/display7seg.c
@@ -16,7 +16,7 @@
 #include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>		/* put_/get_user			*/
 #include <asm/io.h>
 
diff --git a/drivers/scsi/dpt/dpti_i2o.h b/drivers/scsi/dpt/dpti_i2o.h
index 179ad77..bd9e31e 100644
--- a/drivers/scsi/dpt/dpti_i2o.h
+++ b/drivers/scsi/dpt/dpti_i2o.h
@@ -22,7 +22,7 @@
 #include <linux/i2o-dev.h>
 
 #include <linux/notifier.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 
 /*
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c6c0434..897c9cf 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -46,7 +46,7 @@
 #include <linux/cciss_ioctl.h>
 #include <linux/string.h>
 #include <linux/bitmap.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/kthread.h>
 #include "hpsa_cmd.h"
 #include "hpsa.h"
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index aa05e66..b97c8ab 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -54,7 +54,7 @@
 #include <scsi/libsas.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/sas_ata.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "pm8001_defs.h"
 
 #define DRV_NAME		"pm8001"
diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index cb38f9e..a304a53 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -41,7 +41,7 @@
 #include <net/xfrm.h>
 #endif /* CONFIG_XFRM */
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <asm/octeon/octeon.h>
 
diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index afc2b73..8d8474c 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -37,7 +37,7 @@
 #include <net/xfrm.h>
 #endif /* CONFIG_XFRM */
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <asm/octeon/octeon.h>
 
diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 3d3f73c..fc0c284 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -30,7 +30,7 @@
 #include <linux/circ_buf.h>
 #include <linux/uaccess.h>
 #include <asm/byteorder.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/wireless.h>
 #include <linux/rtnetlink.h>
 #include "ethernet.h"
diff --git a/drivers/staging/solo6x10/solo6x10.h b/drivers/staging/solo6x10/solo6x10.h
index fd59b09..17c06bd 100644
--- a/drivers/staging/solo6x10/solo6x10.h
+++ b/drivers/staging/solo6x10/solo6x10.h
@@ -29,7 +29,7 @@
 #include <linux/wait.h>
 #include <linux/delay.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-dev.h>
 #include <media/videobuf-core.h>
diff --git a/drivers/staging/tidspbridge/include/dspbridge/host_os.h b/drivers/staging/tidspbridge/include/dspbridge/host_os.h
index b1b8acb..1a213bd 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/host_os.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/host_os.h
@@ -18,7 +18,7 @@
 #define _HOST_OS_H_
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/semaphore.h>
 #include <linux/uaccess.h>
 #include <linux/irq.h>
diff --git a/drivers/staging/winbond/mds_s.h b/drivers/staging/winbond/mds_s.h
index eeedf01..07d835b 100644
--- a/drivers/staging/winbond/mds_s.h
+++ b/drivers/staging/winbond/mds_s.h
@@ -3,7 +3,7 @@
 
 #include <linux/timer.h>
 #include <linux/types.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "localpara.h"
 #include "mac_structures.h"
diff --git a/drivers/staging/winbond/wb35reg_s.h b/drivers/staging/winbond/wb35reg_s.h
index eb274ff..dc79faa 100644
--- a/drivers/staging/winbond/wb35reg_s.h
+++ b/drivers/staging/winbond/wb35reg_s.h
@@ -3,7 +3,7 @@
 
 #include <linux/spinlock.h>
 #include <linux/types.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct hw_data;
 
diff --git a/drivers/tty/bfin_jtag_comm.c b/drivers/tty/bfin_jtag_comm.c
index 03c285b..3a99776 100644
--- a/drivers/tty/bfin_jtag_comm.c
+++ b/drivers/tty/bfin_jtag_comm.c
@@ -25,7 +25,7 @@
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
 #include <linux/tty_flip.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define pr_init(fmt, args...) ({ static const __initconst char __fmt[] = fmt; printk(__fmt, ## args); })
 
diff --git a/drivers/tty/rocket.c b/drivers/tty/rocket.c
index 13043e8..6a1241c 100644
--- a/drivers/tty/rocket.c
+++ b/drivers/tty/rocket.c
@@ -83,7 +83,7 @@
 #include <linux/wait.h>
 #include <linux/pci.h>
 #include <linux/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/unaligned.h>
 #include <linux/bitops.h>
 #include <linux/spinlock.h>
diff --git a/drivers/tty/serial/dz.c b/drivers/tty/serial/dz.c
index 57421d7..ddc487a 100644
--- a/drivers/tty/serial/dz.c
+++ b/drivers/tty/serial/dz.c
@@ -48,7 +48,7 @@
 #include <linux/sysrq.h>
 #include <linux/tty.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/bootinfo.h>
 #include <asm/io.h>
 #include <asm/system.h>
diff --git a/drivers/tty/serial/sb1250-duart.c b/drivers/tty/serial/sb1250-duart.c
index ea2340b..6bc2e3f 100644
--- a/drivers/tty/serial/sb1250-duart.c
+++ b/drivers/tty/serial/sb1250-duart.c
@@ -39,7 +39,7 @@
 #include <linux/tty.h>
 #include <linux/types.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/io.h>
 #include <asm/war.h>
 
diff --git a/drivers/tty/serial/zs.c b/drivers/tty/serial/zs.c
index 1a7fd3e..0aebd71 100644
--- a/drivers/tty/serial/zs.c
+++ b/drivers/tty/serial/zs.c
@@ -65,7 +65,7 @@
 #include <linux/tty.h>
 #include <linux/types.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 
 #include <asm/dec/interrupts.h>
diff --git a/drivers/usb/gadget/f_audio.c b/drivers/usb/gadget/f_audio.c
index 8ee330a..95d5146 100644
--- a/drivers/usb/gadget/f_audio.c
+++ b/drivers/usb/gadget/f_audio.c
@@ -12,7 +12,7 @@
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "u_audio.h"
 
diff --git a/drivers/usb/gadget/f_rndis.c b/drivers/usb/gadget/f_rndis.c
index fa12ec8..35a93ea 100644
--- a/drivers/usb/gadget/f_rndis.c
+++ b/drivers/usb/gadget/f_rndis.c
@@ -29,7 +29,7 @@
 #include <linux/device.h>
 #include <linux/etherdevice.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "u_ether.h"
 #include "rndis.h"
diff --git a/drivers/usb/gadget/uvc_queue.c b/drivers/usb/gadget/uvc_queue.c
index f7395ac..aa0ad34 100644
--- a/drivers/usb/gadget/uvc_queue.c
+++ b/drivers/usb/gadget/uvc_queue.c
@@ -19,7 +19,7 @@
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "uvc.h"
 
diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index a003796..27e209a 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -131,7 +131,7 @@
 #include <linux/usb.h>
 #include <linux/proc_fs.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/blkdev.h>
 #include "../../scsi/scsi.h"
 #include <scsi/scsi_host.h>
diff --git a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
index 68ab460..ac0d75a 100644
--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -29,7 +29,7 @@
 #include <linux/backlight.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define APPLE_VENDOR_ID		0x05AC
 
diff --git a/drivers/usb/serial/garmin_gps.c b/drivers/usb/serial/garmin_gps.c
index b0a7a9e..1a49ca9 100644
--- a/drivers/usb/serial/garmin_gps.c
+++ b/drivers/usb/serial/garmin_gps.c
@@ -34,7 +34,7 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
diff --git a/drivers/usb/wusbcore/wa-rpipe.c b/drivers/usb/wusbcore/wa-rpipe.c
index ca80171..2acc7f5 100644
--- a/drivers/usb/wusbcore/wa-rpipe.c
+++ b/drivers/usb/wusbcore/wa-rpipe.c
@@ -58,7 +58,7 @@
  *  destination address.
  */
 #include <linux/init.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/bitmap.h>
 #include <linux/slab.h>
 
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 8e03379..d712703 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -11,7 +11,7 @@
 #include <linux/uio.h>
 #include <linux/virtio_config.h>
 #include <linux/virtio_ring.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct vhost_device;
 
diff --git a/drivers/video/sh_mobile_lcdcfb.c b/drivers/video/sh_mobile_lcdcfb.c
index 404c03b..a6dc039 100644
--- a/drivers/video/sh_mobile_lcdcfb.c
+++ b/drivers/video/sh_mobile_lcdcfb.c
@@ -24,7 +24,7 @@
 #include <linux/backlight.h>
 #include <linux/gpio.h>
 #include <video/sh_mobile_lcdc.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "sh_mobile_lcdcfb.h"
 #include "sh_mobile_meram.h"
diff --git a/drivers/video/vermilion/vermilion.h b/drivers/video/vermilion/vermilion.h
index 7491abf..43d11ec 100644
--- a/drivers/video/vermilion/vermilion.h
+++ b/drivers/video/vermilion/vermilion.h
@@ -31,7 +31,7 @@
 
 #include <linux/kernel.h>
 #include <linux/pci.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/mutex.h>
 
 #define VML_DEVICE_GPU 0x5002
diff --git a/drivers/w1/masters/matrox_w1.c b/drivers/w1/masters/matrox_w1.c
index 1550431..334d1cc 100644
--- a/drivers/w1/masters/matrox_w1.c
+++ b/drivers/w1/masters/matrox_w1.c
@@ -20,7 +20,7 @@
  */
 
 #include <asm/types.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/io.h>
 
 #include <linux/delay.h>
diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 10606c8..6c136c1 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -33,7 +33,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "w1.h"
 #include "w1_log.h"
diff --git a/drivers/w1/w1_family.h b/drivers/w1/w1_family.h
index 97479ae..90d0f5b 100644
--- a/drivers/w1/w1_family.h
+++ b/drivers/w1/w1_family.h
@@ -24,7 +24,7 @@
 
 #include <linux/types.h>
 #include <linux/device.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define W1_FAMILY_DEFAULT	0
 #define W1_FAMILY_SMEM_01	0x01
diff --git a/drivers/watchdog/intel_scu_watchdog.c b/drivers/watchdog/intel_scu_watchdog.c
index 919bdd1..a57e46c 100644
--- a/drivers/watchdog/intel_scu_watchdog.c
+++ b/drivers/watchdog/intel_scu_watchdog.c
@@ -44,7 +44,7 @@
 #include <linux/sfi.h>
 #include <linux/types.h>
 #include <asm/irq.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/intel_scu_ipc.h>
 #include <asm/apb_timer.h>
 #include <asm/mrst.h>
diff --git a/drivers/watchdog/sbc7240_wdt.c b/drivers/watchdog/sbc7240_wdt.c
index ff11504..93ac589 100644
--- a/drivers/watchdog/sbc7240_wdt.c
+++ b/drivers/watchdog/sbc7240_wdt.c
@@ -29,7 +29,7 @@
 #include <linux/watchdog.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 
 #define SBC7240_PREFIX "sbc7240_wdt: "
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index eb7d240..8b8ff0c 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -25,7 +25,7 @@
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/wait.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "ctree.h"
 
diff --git a/fs/direct-io.c b/fs/direct-io.c
index ac5f164..fbab37a 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -35,7 +35,7 @@
 #include <linux/buffer_head.h>
 #include <linux/rwsem.h>
 #include <linux/uio.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * How many user pages to map in one call to get_user_pages().  This determines
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index f9cfd16..fe047d96 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -37,7 +37,7 @@
 #include <asm/system.h>
 #include <asm/io.h>
 #include <asm/mman.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * LOCKING:
diff --git a/fs/file_table.c b/fs/file_table.c
index 01e4c1e..c322794 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -25,7 +25,7 @@
 #include <linux/percpu.h>
 #include <linux/ima.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "internal.h"
 
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index c2b34cd..5acdd15 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -16,7 +16,7 @@
 #include <linux/gfs2_ondisk.h>
 #include <linux/rcupdate.h>
 #include <linux/rculist_bl.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "gfs2.h"
 #include "incore.h"
diff --git a/fs/nfs/cache_lib.h b/fs/nfs/cache_lib.h
index 76f856e..7cf6caf 100644
--- a/fs/nfs/cache_lib.h
+++ b/fs/nfs/cache_lib.h
@@ -6,7 +6,7 @@
 
 #include <linux/completion.h>
 #include <linux/sunrpc/cache.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * Deferred request handling
diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 8eea253..5bbf1b8 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -53,7 +53,7 @@
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "internal.h"
 #include "iostat.h"
diff --git a/fs/notify/group.c b/fs/notify/group.c
index d309f38..63fc294 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -26,7 +26,7 @@
 #include <linux/fsnotify_backend.h>
 #include "fsnotify.h"
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * Final freeing of a group
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 07ea8d3..b13c00a 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -23,7 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <linux/fsnotify_backend.h>
 #include "fsnotify.h"
diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 252ab1f..e14587d 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -92,7 +92,7 @@
 #include <linux/spinlock.h>
 #include <linux/srcu.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <linux/fsnotify_backend.h>
 #include "fsnotify.h"
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index f39260f..ee18815 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -43,7 +43,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <linux/fsnotify_backend.h>
 #include "fsnotify.h"
diff --git a/fs/notify/vfsmount_mark.c b/fs/notify/vfsmount_mark.c
index e86577d..778fe6c 100644
--- a/fs/notify/vfsmount_mark.c
+++ b/fs/notify/vfsmount_mark.c
@@ -24,7 +24,7 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <linux/fsnotify_backend.h>
 #include "fsnotify.h"
diff --git a/fs/ntfs/inode.h b/fs/ntfs/inode.h
index 2dabf81..fe8e7e9 100644
--- a/fs/ntfs/inode.h
+++ b/fs/ntfs/inode.h
@@ -24,7 +24,7 @@
 #ifndef _LINUX_NTFS_INODE_H
 #define _LINUX_NTFS_INODE_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <linux/fs.h>
 #include <linux/list.h>
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index b1cf6bf..bd64fb5 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -14,7 +14,7 @@
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/posix_acl.h>
diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index ed257d1..5861741 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -10,7 +10,7 @@
 #include <linux/seq_file.h>
 #include <linux/swap.h>
 #include <linux/vmstat.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include "internal.h"
diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index 5d2a5e9..95ec524 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -59,7 +59,7 @@
 #include <linux/ctype.h>
 #include <linux/sched.h>
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/div64.h>
 #include <asm/acpi.h>
 #include <linux/slab.h>
diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index e994197..7f84414 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -138,8 +138,6 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
   return c != u;
 }
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
-
 static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
 {
 	unsigned long flags;
diff --git a/include/asm-generic/local.h b/include/asm-generic/local.h
index c8a5d68..9ceb03b 100644
--- a/include/asm-generic/local.h
+++ b/include/asm-generic/local.h
@@ -2,7 +2,7 @@
 #define _ASM_GENERIC_LOCAL_H
 
 #include <linux/percpu.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/types.h>
 
 /*
diff --git a/include/asm-generic/local64.h b/include/asm-generic/local64.h
index 02ac760..5980002 100644
--- a/include/asm-generic/local64.h
+++ b/include/asm-generic/local64.h
@@ -55,7 +55,7 @@ typedef struct {
 
 #else /* BITS_PER_LONG != 64 */
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /* Don't use typedef: don't want them to be mixed with atomic_t's. */
 typedef struct {
diff --git a/include/drm/ttm/ttm_lock.h b/include/drm/ttm/ttm_lock.h
index 81ba0b0..2e7f0c9 100644
--- a/include/drm/ttm/ttm_lock.h
+++ b/include/drm/ttm/ttm_lock.h
@@ -51,7 +51,7 @@
 
 #include "ttm/ttm_object.h"
 #include <linux/wait.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /**
  * struct ttm_lock
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 7a8db41..2dcb72b 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -7,7 +7,7 @@
 #include <linux/uio.h>
 #include <linux/rcupdate.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define AIO_MAXSEGS		4
 #define AIO_KIOGRP_NR_ATOMIC	8
diff --git a/include/linux/atmdev.h b/include/linux/atmdev.h
index 381f4ce..49a83ca 100644
--- a/include/linux/atmdev.h
+++ b/include/linux/atmdev.h
@@ -220,7 +220,7 @@ struct atm_cirange {
 #include <linux/skbuff.h> /* struct sk_buff */
 #include <linux/uio.h>
 #include <net/sock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #ifdef CONFIG_PROC_FS
 #include <linux/proc_fs.h>
diff --git a/include/linux/atomic.h b/include/linux/atomic.h
index ee456c7..ed0eb23 100644
--- a/include/linux/atomic.h
+++ b/include/linux/atomic.h
@@ -3,6 +3,15 @@
 #include <asm/atomic.h>
 
 /**
+ * atomic_inc_not_zero - increment unless the number is zero
+ * @v: pointer of type atomic_t
+ *
+ * Atomically increments @v by 1, so long as @v is non-zero.
+ * Returns non-zero if @v was non-zero, and zero otherwise.
+ */
+#define atomic_inc_not_zero(v)		atomic_add_unless((v), 1, 0)
+
+/**
  * atomic_inc_not_zero_hint - increment if not null
  * @v: pointer of type atomic_t
  * @hint: probable value of the atomic before the increment
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 96f4094..2555edf 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -16,7 +16,7 @@
 #include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/writeback.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct page;
 struct device;
diff --git a/include/linux/bit_spinlock.h b/include/linux/bit_spinlock.h
index b4326bf..a42f02d 100644
--- a/include/linux/bit_spinlock.h
+++ b/include/linux/bit_spinlock.h
@@ -3,7 +3,7 @@
 
 #include <linux/kernel.h>
 #include <linux/preempt.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  *  bit-based spin_lock()
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 503c8a6..458f497 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -12,7 +12,7 @@
 #include <linux/linkage.h>
 #include <linux/pagemap.h>
 #include <linux/wait.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #ifdef CONFIG_BLOCK
 
diff --git a/include/linux/configfs.h b/include/linux/configfs.h
index 645778a..3081c58 100644
--- a/include/linux/configfs.h
+++ b/include/linux/configfs.h
@@ -42,7 +42,7 @@
 #include <linux/mutex.h>
 #include <linux/err.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define CONFIGFS_ITEM_NAME_LEN	20
 
diff --git a/include/linux/connector.h b/include/linux/connector.h
index 7c60d09..33cfb9e 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -75,7 +75,7 @@ struct cn_msg {
 
 #ifdef __KERNEL__
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <linux/list.h>
 #include <linux/workqueue.h>
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 8260799..1b30dc7 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -16,7 +16,7 @@
 #include <linux/init.h>
 #include <linux/key.h>
 #include <linux/selinux.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct user_struct;
 struct cred;
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index a6a7a1c..e5e468e 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -17,7 +17,7 @@
 #ifndef _LINUX_CRYPTO_H
 #define _LINUX_CRYPTO_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 19d90a5..e6024d4 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -1,7 +1,7 @@
 #ifndef __LINUX_DCACHE_H
 #define __LINUX_DCACHE_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/list.h>
 #include <linux/rculist.h>
 #include <linux/rculist_bl.h>
diff --git a/include/linux/debug_locks.h b/include/linux/debug_locks.h
index 2833452..5033fb8 100644
--- a/include/linux/debug_locks.h
+++ b/include/linux/debug_locks.h
@@ -2,7 +2,7 @@
 #define __LINUX_DEBUG_LOCKING_H
 
 #include <linux/kernel.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 
 struct task_struct;
diff --git a/include/linux/device.h b/include/linux/device.h
index c66111a..d8d59de 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -22,7 +22,7 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pm.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/device.h>
 
 struct device;
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 36c6644..4a73257 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -12,7 +12,7 @@
 #ifndef _LINUX_EDAC_H_
 #define _LINUX_EDAC_H_
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/sysdev.h>
 
 #define EDAC_OPSTATE_INVAL	-1
diff --git a/include/linux/fault-inject.h b/include/linux/fault-inject.h
index 7b64ad4..140f712 100644
--- a/include/linux/fault-inject.h
+++ b/include/linux/fault-inject.h
@@ -5,7 +5,7 @@
 
 #include <linux/types.h>
 #include <linux/debugfs.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * For explanation of the elements of this struct, see
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 133c0ba..b3f82f2 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -13,7 +13,7 @@
 #include <linux/init.h>
 #include <linux/fs.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * The default fd array needs to be at least BITS_PER_LONG,
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 9ee3f9f..741956f 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -9,7 +9,7 @@
 #include <linux/types.h>
 
 #ifdef __KERNEL__
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #endif
 
 /*
diff --git a/include/linux/firewire.h b/include/linux/firewire.h
index 5e6f427..84ccf8e 100644
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -14,7 +14,7 @@
 #include <linux/types.h>
 #include <linux/workqueue.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/byteorder.h>
 
 #define fw_notify(s, args...) printk(KERN_NOTICE KBUILD_MODNAME ": " s, ## args)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c55d6b7..c62c23d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -392,7 +392,7 @@ struct inodes_stat_t {
 #include <linux/fiemap.h>
 #include <linux/rculist_bl.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/byteorder.h>
 
 struct export_operations;
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 69ad89b..91d0e0a3 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -16,7 +16,7 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * IN_* from inotfy.h lines up EXACTLY with FS_*, this is so we can easily
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 6c12989..67c9216 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -17,7 +17,7 @@
 #include <linux/kref.h>
 #include <linux/workqueue.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/ptrace.h>
 #include <asm/system.h>
 #include <trace/events/irq.h>
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 83e745f..66f23dc 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -54,7 +54,7 @@ extern void jump_label_apply_nops(struct module *mod);
 
 #else
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define JUMP_LABEL_INIT {ATOMIC_INIT(0)}
 
diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index aadff7c..529d9a0 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -16,7 +16,7 @@
 #ifdef	CONFIG_KGDB_KDB
 #include <linux/init.h>
 #include <linux/sched.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define KDB_POLL_FUNC_MAX	5
 extern int kdb_poll_idx;
diff --git a/include/linux/key.h b/include/linux/key.h
index 6ea4eeb..183a6af 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -21,7 +21,7 @@
 #include <linux/rcupdate.h>
 #include <linux/sysctl.h>
 #include <linux/rwsem.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #ifdef __KERNEL__
 
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 10ca03d..fa39183 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -16,7 +16,7 @@
 #include <linux/serial_8250.h>
 #include <linux/linkage.h>
 #include <linux/init.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #ifdef CONFIG_HAVE_ARCH_KGDB
 #include <asm/kgdb.h>
 #endif
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 9229b64..668729c 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -25,7 +25,7 @@
 #include <linux/kobject_ns.h>
 #include <linux/kernel.h>
 #include <linux/wait.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define UEVENT_HELPER_PATH_LEN		256
 #define UEVENT_NUM_ENVP			32	/* number of env pointers */
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 8985768..3d78cda 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -37,7 +37,7 @@
 #include <linux/completion.h>
 #include <linux/radix-tree.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define MAX_MSIX_P_PORT		17
 #define MAX_MSIX		64
diff --git a/include/linux/mman.h b/include/linux/mman.h
index 9872d6c..8b74e9b 100644
--- a/include/linux/mman.h
+++ b/include/linux/mman.h
@@ -14,7 +14,7 @@
 #include <linux/mm.h>
 #include <linux/percpu_counter.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index c928dac..889cdfb 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -16,7 +16,7 @@
 #include <linux/nodemask.h>
 #include <linux/pageblock-flags.h>
 #include <generated/bounds.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/page.h>
 
 /* Free memory management - zoned buddy allocator.  */
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 604f122..33fe53d 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -14,7 +14,7 @@
 #include <linux/nodemask.h>
 #include <linux/spinlock.h>
 #include <linux/seqlock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct super_block;
 struct vfsmount;
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index a940fe4..33df7df 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -15,7 +15,7 @@
 #include <linux/linkage.h>
 #include <linux/lockdep.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * Simple, straightforward mutexes with strict semantics:
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ca333e7..93a7009 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -35,7 +35,7 @@
 #include <linux/timer.h>
 #include <linux/delay.h>
 #include <linux/mm.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cache.h>
 #include <asm/byteorder.h>
 
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index 87694ca..08c444a 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -7,7 +7,7 @@
 #include <linux/nfs_xdr.h>
 #include <linux/sunrpc/xprt.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct nfs4_session;
 struct nfs_iostats;
diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index 7f5cfd3..49c8727 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -18,7 +18,7 @@
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/printk.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
  
 /* Each escaped entry is prefixed by ESCAPE_CODE
  * then one of the following codes, then the
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c446b5c..d67cfc1 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -49,7 +49,7 @@
 #include <linux/compiler.h>
 #include <linux/errno.h>
 #include <linux/kobject.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/device.h>
 #include <linux/io.h>
 #include <linux/irqreturn.h>
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3412684..4a29627 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -508,7 +508,7 @@ struct perf_guest_info_callbacks {
 #include <linux/cpu.h>
 #include <linux/irq_work.h>
 #include <linux/jump_label.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/local.h>
 
 #define PERF_MAX_STACK_DEPTH		255
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 7da5fa8..ad51863 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -26,7 +26,7 @@
 #include <linux/workqueue.h>
 #include <linux/mod_devicetable.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define PHY_BASIC_FEATURES	(SUPPORTED_10baseT_Half | \
 				 SUPPORTED_10baseT_Full | \
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index e7576cf..650af6d 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -5,7 +5,7 @@
 #include <linux/fs.h>
 #include <linux/spinlock.h>
 #include <linux/magic.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct net;
 struct completion;
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 9a85412..9865ed8 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -180,7 +180,7 @@ enum {
 #include <linux/dqblk_v1.h>
 #include <linux/dqblk_v2.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 typedef __kernel_uid32_t qid_t; /* Type in which we store ids in memory */
 typedef long long qsize_t;	/* Type in which we store sizes */
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index a8afe9c..c57b3a9 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -15,7 +15,7 @@
 #include <linux/spinlock.h>
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct rw_semaphore;
 
diff --git a/include/linux/sem.h b/include/linux/sem.h
index f2961af..1feb2de 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -77,7 +77,7 @@ struct  seminfo {
 #define SEMUSZ  20		/* sizeof struct sem_undo */
 
 #ifdef __KERNEL__
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/rcupdate.h>
 #include <linux/cache.h>
 
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e8b78ce..0662e9c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -20,7 +20,7 @@
 #include <linux/time.h>
 #include <linux/cache.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/types.h>
 #include <linux/spinlock.h>
 #include <linux/net.h>
diff --git a/include/linux/sonet.h b/include/linux/sonet.h
index 67ad11f..de8832d 100644
--- a/include/linux/sonet.h
+++ b/include/linux/sonet.h
@@ -58,7 +58,7 @@ struct sonet_stats {
 
 #ifdef __KERNEL__
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct k_sonet_stats {
 #define __HANDLE_ITEM(i) atomic_t i
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 0b22d51..7df6c17 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -384,7 +384,7 @@ static inline void assert_spin_locked(spinlock_t *lock)
  * Pull the atomic_t declaration:
  * (asm-mips/atomic.h needs above definitions)
  */
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 /**
  * atomic_dec_and_lock - lock on reaching reference count zero
  * @atomic: the atomic counter
diff --git a/include/linux/sunrpc/auth.h b/include/linux/sunrpc/auth.h
index 8521067..febc4db 100644
--- a/include/linux/sunrpc/auth.h
+++ b/include/linux/sunrpc/auth.h
@@ -15,7 +15,7 @@
 #include <linux/sunrpc/msg_prot.h>
 #include <linux/sunrpc/xdr.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/rcupdate.h>
 
 /* size of the nodename buffer */
diff --git a/include/linux/sunrpc/cache.h b/include/linux/sunrpc/cache.h
index 8d2eef1..a7fe03f 100644
--- a/include/linux/sunrpc/cache.h
+++ b/include/linux/sunrpc/cache.h
@@ -15,7 +15,7 @@
 
 #include <linux/kref.h>
 #include <linux/slab.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/proc_fs.h>
 
 /*
diff --git a/include/linux/sunrpc/timer.h b/include/linux/sunrpc/timer.h
index a67fd73..697d6e6 100644
--- a/include/linux/sunrpc/timer.h
+++ b/include/linux/sunrpc/timer.h
@@ -9,7 +9,7 @@
 #ifndef _LINUX_SUNRPC_TIMER_H
 #define _LINUX_SUNRPC_TIMER_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct rpc_rtt {
 	unsigned long timeo;	/* default timeout value */
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 384eb5f..653cee7 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -9,7 +9,7 @@
 #include <linux/sched.h>
 #include <linux/node.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/page.h>
 
 struct notifier_block;
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index c3acda6..81796f5 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -17,7 +17,7 @@
 #include <linux/list.h>
 #include <linux/lockdep.h>
 #include <linux/kobject_ns.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct kobject;
 struct module;
diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index bcd942f..65efb92 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -6,7 +6,7 @@
 #include <linux/mm.h>
 #include <linux/mmzone.h>
 #include <linux/vm_event_item.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 extern int sysctl_stat_interval;
 
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index f584aba..238f9b7 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -10,7 +10,7 @@
 #include <linux/bitops.h>
 #include <linux/lockdep.h>
 #include <linux/threads.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct workqueue_struct;
 
diff --git a/include/net/ax25.h b/include/net/ax25.h
index 206d222..94e09d3 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -11,7 +11,7 @@
 #include <linux/timer.h>
 #include <linux/list.h>
 #include <linux/slab.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define	AX25_T1CLAMPLO  		1
 #define	AX25_T1CLAMPHI 			(30 * HZ)
diff --git a/include/net/cipso_ipv4.h b/include/net/cipso_ipv4.h
index abd4436..3b93874 100644
--- a/include/net/cipso_ipv4.h
+++ b/include/net/cipso_ipv4.h
@@ -41,7 +41,7 @@
 #include <linux/skbuff.h>
 #include <net/netlabel.h>
 #include <net/request_sock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /* known doi values */
 #define CIPSO_V4_DOI_UNKNOWN          0x00000000
diff --git a/include/net/flow.h b/include/net/flow.h
index c6d5fe5..78113da 100644
--- a/include/net/flow.h
+++ b/include/net/flow.h
@@ -8,7 +8,7 @@
 #define _NET_FLOW_H
 
 #include <linux/in6.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct flowi_common {
 	int	flowic_oif;
diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index e9c2ed8..808fc5f 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -33,7 +33,7 @@
 #include <net/tcp_states.h>
 #include <net/netns/hash.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/byteorder.h>
 
 /* This is for all connections with a full identity, no wildcards.
diff --git a/include/net/inet_timewait_sock.h b/include/net/inet_timewait_sock.h
index 17404b5..f1a7709 100644
--- a/include/net/inet_timewait_sock.h
+++ b/include/net/inet_timewait_sock.h
@@ -28,7 +28,7 @@
 #include <net/tcp_states.h>
 #include <net/timewait_sock.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct inet_hashinfo;
 
diff --git a/include/net/inetpeer.h b/include/net/inetpeer.h
index 8a159cc..e47c4bd 100644
--- a/include/net/inetpeer.h
+++ b/include/net/inetpeer.h
@@ -13,7 +13,7 @@
 #include <linux/spinlock.h>
 #include <linux/rtnetlink.h>
 #include <net/ipv6.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct inetpeer_addr_base {
 	union {
diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 481f856..b237991 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -13,7 +13,7 @@
 #include <linux/sysctl.h>               /* for ctl_path */
 #include <linux/list.h>                 /* for struct list_head */
 #include <linux/spinlock.h>             /* for struct rwlock_t */
-#include <asm/atomic.h>                 /* for struct atomic_t */
+#include <linux/atomic.h>                 /* for struct atomic_t */
 #include <linux/compiler.h>
 #include <linux/timer.h>
 
diff --git a/include/net/lib80211.h b/include/net/lib80211.h
index 848cce1..b95bbb0 100644
--- a/include/net/lib80211.h
+++ b/include/net/lib80211.h
@@ -26,7 +26,7 @@
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/module.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/if.h>
 #include <linux/skbuff.h>
 #include <linux/ieee80211.h>
diff --git a/include/net/llc.h b/include/net/llc.h
index 5503b74..226c846 100644
--- a/include/net/llc.h
+++ b/include/net/llc.h
@@ -20,7 +20,7 @@
 #include <linux/hash.h>
 #include <linux/jhash.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct net_device;
 struct packet_type;
diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 4014b62..21b57ea 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -16,7 +16,7 @@
  *		- Add neighbour cache statistics like rtstat
  */
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/rcupdate.h>
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 2bf9ed9..35bb061 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -4,7 +4,7 @@
 #ifndef __NET_NET_NAMESPACE_H
 #define __NET_NET_NAMESPACE_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/workqueue.h>
 #include <linux/list.h>
 #include <linux/sysctl.h>
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index c7c42e7..34c6b13 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -16,7 +16,7 @@
 
 #include <linux/bitops.h>
 #include <linux/compiler.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <linux/netfilter/nf_conntrack_tcp.h>
 #include <linux/netfilter/nf_conntrack_dccp.h>
diff --git a/include/net/netlabel.h b/include/net/netlabel.h
index 9db401a..f21a16e 100644
--- a/include/net/netlabel.h
+++ b/include/net/netlabel.h
@@ -38,7 +38,7 @@
 #include <linux/in6.h>
 #include <net/netlink.h>
 #include <net/request_sock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct cipso_v4_doi;
 
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 341eb08..0249399 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -3,7 +3,7 @@
 
 #include <linux/list.h>
 #include <linux/list_nulls.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct ctl_table_header;
 struct nf_conntrack_ecache;
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 7df327a..9ed75d2 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -60,7 +60,7 @@
 #include <linux/in6.h>		/* We get struct in6_addr     */
 #include <linux/ipv6.h>
 #include <asm/param.h>		/* We get MAXHOSTNAMELEN.     */
-#include <asm/atomic.h>		/* This gets us atomic counters.  */
+#include <linux/atomic.h>		/* This gets us atomic counters.  */
 #include <linux/skbuff.h>	/* We need sk_buff_head. */
 #include <linux/workqueue.h>	/* We need tq_struct.	 */
 #include <linux/sctp.h>		/* We need sctp* header structs.  */
diff --git a/include/pcmcia/ds.h b/include/pcmcia/ds.h
index 7b82080..3bbbd78 100644
--- a/include/pcmcia/ds.h
+++ b/include/pcmcia/ds.h
@@ -26,7 +26,7 @@
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <pcmcia/ss.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 
 /*
diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
index 1082afa..d44a563 100644
--- a/include/rdma/ib_sa.h
+++ b/include/rdma/ib_sa.h
@@ -38,7 +38,7 @@
 #include <linux/completion.h>
 #include <linux/compiler.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_mad.h>
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 55cd0a0..706463e 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -49,7 +49,7 @@
 #include <linux/scatterlist.h>
 #include <linux/workqueue.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 
 extern struct workqueue_struct *ib_wq;
diff --git a/include/rxrpc/types.h b/include/rxrpc/types.h
index 327a5fc..30d48f6 100644
--- a/include/rxrpc/types.h
+++ b/include/rxrpc/types.h
@@ -17,7 +17,7 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/spinlock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 typedef uint32_t	rxrpc_seq_t;	/* Rx message sequence number */
 typedef uint32_t	rxrpc_serial_t;	/* Rx message serial number */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index dd82e02..d371c3c 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -7,7 +7,7 @@
 #include <linux/workqueue.h>
 #include <linux/blkdev.h>
 #include <scsi/scsi.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct request_queue;
 struct scsi_cmnd;
diff --git a/include/video/omapdss.h b/include/video/omapdss.h
index 892b97f..9aa0c4a 100644
--- a/include/video/omapdss.h
+++ b/include/video/omapdss.h
@@ -22,7 +22,7 @@
 #include <linux/kobject.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define DISPC_IRQ_FRAMEDONE		(1 << 0)
 #define DISPC_IRQ_VSYNC			(1 << 1)
diff --git a/kernel/async.c b/kernel/async.c
index cd9dbb9..b5e110a 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -54,7 +54,7 @@ asynchronous and synchronous parts of the kernel.
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 static async_cookie_t next_cookie = 1;
 
diff --git a/kernel/audit.c b/kernel/audit.c
index 9395003..d227984 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -43,7 +43,7 @@
 
 #include <linux/init.h>
 #include <asm/types.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 00d79df..ce4b054 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -44,7 +44,7 @@
 
 #include <linux/init.h>
 #include <asm/types.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/fs.h>
 #include <linux/namei.h>
 #include <linux/mm.h>
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2731d11..21e0338 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -59,7 +59,7 @@
 #include <linux/poll.h>
 #include <linux/flex_array.h> /* used in cgroup_attach_proc */
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 static DEFINE_MUTEX(cgroup_mutex);
 
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 9c9b754..8fd0507 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -55,7 +55,7 @@
 #include <linux/sort.h>
 
 #include <asm/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
 #include <linux/cgroup.h>
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index bad6786..0d7c087 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -51,7 +51,7 @@
 
 #include <asm/cacheflush.h>
 #include <asm/byteorder.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 
 #include "debug_core.h"
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 7784bd2..ddddb32 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -37,7 +37,7 @@
 #include <linux/smp.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/bitops.h>
 #include <linux/percpu.h>
 #include <linux/notifier.h>
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 2e138db..703bf0c 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -33,7 +33,7 @@
 #include <linux/rcupdate.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/bitops.h>
 #include <linux/completion.h>
 #include <linux/moduleparam.h>
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 9678cc3..2b31c2c 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -31,7 +31,7 @@
 #include <linux/rcupdate.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/bitops.h>
 #include <linux/module.h>
 #include <linux/completion.h>
diff --git a/kernel/rwsem.c b/kernel/rwsem.c
index cae050b..13c5bc3 100644
--- a/kernel/rwsem.c
+++ b/kernel/rwsem.c
@@ -11,7 +11,7 @@
 #include <linux/rwsem.h>
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * lock for reading
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index e3516b2..97a3eae 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -19,7 +19,7 @@
 #include <linux/interrupt.h>
 #include <linux/kallsyms.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * Structure to determine completion condition and record errors.  May
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 9ffea36..8c29da3 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -28,7 +28,7 @@
 #include <linux/fs.h>
 #include <linux/file.h>
 #include <net/genetlink.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * Maximum length of a cpumask that can be specified in
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 229f859..16ddfd5 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -2,7 +2,7 @@
 #define _LINUX_KERNEL_TRACE_H
 
 #include <linux/fs.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/sched.h>
 #include <linux/clocksource.h>
 #include <linux/ring_buffer.h>
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 017fa37..fd3c8aa 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -12,7 +12,7 @@
 #include <linux/slab.h>
 #include <linux/time.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "trace.h"
 #include "trace_output.h"
diff --git a/lib/atomic64.c b/lib/atomic64.c
index a21c12b..e12ae0d 100644
--- a/lib/atomic64.c
+++ b/lib/atomic64.c
@@ -14,7 +14,7 @@
 #include <linux/spinlock.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * We use a hashed array of spinlocks to provide exclusive access
diff --git a/lib/atomic64_test.c b/lib/atomic64_test.c
index 44524cc..0c33cde 100644
--- a/lib/atomic64_test.c
+++ b/lib/atomic64_test.c
@@ -10,7 +10,7 @@
  */
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define INIT(c) do { atomic64_set(&v, c); r = c; } while (0)
 static __init int test_atomic64(void)
diff --git a/lib/crc32.c b/lib/crc32.c
index 4855995..a6e633a 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -26,7 +26,7 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <linux/init.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "crc32defs.h"
 #if CRC_LE_BITS == 8
 # define tole(x) __constant_cpu_to_le32(x)
diff --git a/lib/dec_and_lock.c b/lib/dec_and_lock.c
index e73822a..b525772 100644
--- a/lib/dec_and_lock.c
+++ b/lib/dec_and_lock.c
@@ -1,6 +1,6 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * This is an implementation of the notion of "decrement a
diff --git a/mm/init-mm.c b/mm/init-mm.c
index 4019979..a56a851 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -5,7 +5,7 @@
 #include <linux/list.h>
 #include <linux/cpumask.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/pgtable.h>
 #include <asm/mmu.h>
 
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index aacee45..d6880f5 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -96,7 +96,7 @@
 
 #include <asm/sections.h>
 #include <asm/processor.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <linux/kmemcheck.h>
 #include <linux/kmemleak.h>
diff --git a/mm/slob.c b/mm/slob.c
index 46e0aee..f958e4e 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -70,7 +70,7 @@
 
 #include <trace/events/kmem.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * slob_block has a field 'units', which indicates size of block if +ve,
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 1d34d75..529c431 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -26,7 +26,7 @@
 #include <linux/rcupdate.h>
 #include <linux/pfn.h>
 #include <linux/kmemleak.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
diff --git a/net/atm/atm_misc.c b/net/atm/atm_misc.c
index fc63526..f41f026 100644
--- a/net/atm/atm_misc.c
+++ b/net/atm/atm_misc.c
@@ -9,7 +9,7 @@
 #include <linux/sonet.h>
 #include <linux/bitops.h>
 #include <linux/errno.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 int atm_charge(struct atm_vcc *vcc, int truesize)
 {
diff --git a/net/atm/clip.c b/net/atm/clip.c
index 1d4be60..dbaaeb6 100644
--- a/net/atm/clip.c
+++ b/net/atm/clip.c
@@ -37,7 +37,7 @@
 #include <linux/uaccess.h>
 #include <asm/byteorder.h> /* for htons etc. */
 #include <asm/system.h> /* save/restore_flags */
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "common.h"
 #include "resources.h"
diff --git a/net/atm/common.c b/net/atm/common.c
index 22b963d..14ff9fe 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -23,7 +23,7 @@
 #include <linux/uaccess.h>
 #include <linux/poll.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "resources.h"		/* atm_find_dev */
 #include "common.h"		/* prototypes */
diff --git a/net/atm/lec.c b/net/atm/lec.c
index ba48daa..215c9fa 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -1335,7 +1335,7 @@ static void lane2_associate_ind(struct net_device *dev, const u8 *mac_addr,
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/param.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/inetdevice.h>
 #include <net/route.h>
 
diff --git a/net/atm/proc.c b/net/atm/proc.c
index be3afde..0d020de 100644
--- a/net/atm/proc.c
+++ b/net/atm/proc.c
@@ -27,7 +27,7 @@
 #include <net/atmclip.h>
 #include <linux/uaccess.h>
 #include <linux/param.h> /* for HZ */
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "resources.h"
 #include "common.h" /* atm_proc_init prototype */
 #include "signaling.h" /* to get sigd - ugly too */
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index e0dfbc1..68def3b 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -21,7 +21,7 @@
 #include <linux/jhash.h>
 #include <linux/random.h>
 #include <linux/slab.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/unaligned.h>
 #include "br_private.h"
 
diff --git a/net/core/flow.c b/net/core/flow.c
index 990703b..bf32c33 100644
--- a/net/core/flow.c
+++ b/net/core/flow.c
@@ -22,7 +22,7 @@
 #include <linux/cpumask.h>
 #include <linux/mutex.h>
 #include <net/flow.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/security.h>
 
 struct flow_cache_entry {
diff --git a/net/decnet/dn_fib.c b/net/decnet/dn_fib.c
index 1c74ed3..09f2b2d 100644
--- a/net/decnet/dn_fib.c
+++ b/net/decnet/dn_fib.c
@@ -30,7 +30,7 @@
 #include <linux/netdevice.h>
 #include <linux/timer.h>
 #include <linux/spinlock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 #include <net/neighbour.h>
 #include <net/dst.h>
diff --git a/net/decnet/dn_neigh.c b/net/decnet/dn_neigh.c
index 602dade..4be37f1 100644
--- a/net/decnet/dn_neigh.c
+++ b/net/decnet/dn_neigh.c
@@ -38,7 +38,7 @@
 #include <linux/seq_file.h>
 #include <linux/rcupdate.h>
 #include <linux/jhash.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <net/net_namespace.h>
 #include <net/neighbour.h>
 #include <net/dst.h>
diff --git a/net/decnet/dn_table.c b/net/decnet/dn_table.c
index bd0a52d..5152ec0 100644
--- a/net/decnet/dn_table.c
+++ b/net/decnet/dn_table.c
@@ -25,7 +25,7 @@
 #include <linux/netdevice.h>
 #include <linux/timer.h>
 #include <linux/spinlock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 #include <linux/route.h> /* RTF_xxx */
 #include <net/neighbour.h>
diff --git a/net/decnet/dn_timer.c b/net/decnet/dn_timer.c
index 0982571..67f691b 100644
--- a/net/decnet/dn_timer.c
+++ b/net/decnet/dn_timer.c
@@ -22,7 +22,7 @@
 #include <linux/timer.h>
 #include <linux/spinlock.h>
 #include <net/sock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <net/flow.h>
 #include <net/dn.h>
 
diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 2b3c23c..2c2a98e 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -50,7 +50,7 @@
 #include <net/tcp.h>
 #include <net/netlabel.h>
 #include <net/cipso_ipv4.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/bug.h>
 #include <asm/unaligned.h>
 
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index c9893d4..8ccc74d 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -38,7 +38,7 @@
  */
 
 #include <linux/types.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/byteorder.h>
 #include <asm/current.h>
 #include <asm/uaccess.h>
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 36c2842..0bc9888 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -40,7 +40,7 @@
 #include <linux/slab.h>
 
 #include <asm/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <net/icmp.h>
 #include <net/ip.h>
diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index 7f91249..b7732b2 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -51,7 +51,7 @@
 #include <linux/cpu.h>
 #include <linux/reboot.h>
 #include <net/iucv/iucv.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/ebcdic.h>
 #include <asm/io.h>
 #include <asm/irq.h>
diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index ed8a233..ad4ac26 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -55,7 +55,7 @@
 #include <net/protocol.h>
 
 #include <asm/byteorder.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "l2tp_core.h"
 
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 39a21d0..f42cd09 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -97,7 +97,7 @@
 #include <net/xfrm.h>
 
 #include <asm/byteorder.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "l2tp_core.h"
 
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index e0ee010..766b67d 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -33,7 +33,7 @@
 #include <net/netfilter/nf_log.h>
 #include <net/netfilter/nfnetlink_log.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #ifdef CONFIG_BRIDGE_NETFILTER
 #include "../bridge/br_private.h"
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index b83123f..6efda51 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -31,7 +31,7 @@
 #include <net/sock.h>
 #include <net/netfilter/nf_queue.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #ifdef CONFIG_BRIDGE_NETFILTER
 #include "../bridge/br_private.h"
diff --git a/net/netlabel/netlabel_cipso_v4.c b/net/netlabel/netlabel_cipso_v4.c
index bae5756..dd53a36 100644
--- a/net/netlabel/netlabel_cipso_v4.c
+++ b/net/netlabel/netlabel_cipso_v4.c
@@ -39,7 +39,7 @@
 #include <net/genetlink.h>
 #include <net/netlabel.h>
 #include <net/cipso_ipv4.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "netlabel_user.h"
 #include "netlabel_cipso_v4.h"
diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
index 1b83e00..b528dd9 100644
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -39,7 +39,7 @@
 #include <net/netlabel.h>
 #include <net/cipso_ipv4.h>
 #include <asm/bug.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "netlabel_domainhash.h"
 #include "netlabel_unlabeled.h"
diff --git a/net/netlabel/netlabel_mgmt.c b/net/netlabel/netlabel_mgmt.c
index 4f251b1..dff8a08 100644
--- a/net/netlabel/netlabel_mgmt.c
+++ b/net/netlabel/netlabel_mgmt.c
@@ -42,7 +42,7 @@
 #include <net/ipv6.h>
 #include <net/netlabel.h>
 #include <net/cipso_ipv4.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "netlabel_domainhash.h"
 #include "netlabel_user.h"
diff --git a/net/netlabel/netlabel_mgmt.h b/net/netlabel/netlabel_mgmt.h
index 0a25838..8db37f4 100644
--- a/net/netlabel/netlabel_mgmt.h
+++ b/net/netlabel/netlabel_mgmt.h
@@ -32,7 +32,7 @@
 #define _NETLABEL_MGMT_H
 
 #include <net/netlabel.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * The following NetLabel payloads are supported by the management interface.
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 9c38658..73695d3 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -52,7 +52,7 @@
 #include <net/net_namespace.h>
 #include <net/netlabel.h>
 #include <asm/bug.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "netlabel_user.h"
 #include "netlabel_addrlist.h"
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index cae761a..ddf0528 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -42,7 +42,7 @@
 
 #include <linux/wait.h> 		/* wait_queue_head_t, etc */
 #include <linux/spinlock.h> 		/* spinlock_t, etc */
-#include <asm/atomic.h>			/* atomic_t, etc */
+#include <linux/atomic.h>			/* atomic_t, etc */
 
 #include <rdma/rdma_cm.h>		/* RDMA connection api */
 #include <rdma/ib_verbs.h>		/* RDMA verbs api */
diff --git a/net/tipc/core.h b/net/tipc/core.h
index 436dda1..e981e0c 100644
--- a/net/tipc/core.h
+++ b/net/tipc/core.h
@@ -47,7 +47,7 @@
 #include <linux/string.h>
 #include <asm/uaccess.h>
 #include <linux/interrupt.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/hardirq.h>
 #include <linux/netdevice.h>
 #include <linux/in.h>
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index a0d3845..c103f4d 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -57,7 +57,7 @@
 #include <net/netlabel.h>
 #include <linux/uaccess.h>
 #include <asm/ioctls.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/bitops.h>
 #include <linux/interrupt.h>
 #include <linux/netdevice.h>	/* for network interface checks */
diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index 68178b7..48665ec 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -46,7 +46,7 @@
 #include <net/xfrm.h>
 #include <net/checksum.h>
 #include <net/udp.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "avc.h"
 #include "objsec.h"
diff --git a/sound/pci/echoaudio/darla20.c b/sound/pci/echoaudio/darla20.c
index fe7ad64..43c7e12 100644
--- a/sound/pci/echoaudio/darla20.c
+++ b/sound/pci/echoaudio/darla20.c
@@ -52,7 +52,7 @@
 #include <sound/asoundef.h>
 #include <sound/initval.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/darla20_dsp.fw");
diff --git a/sound/pci/echoaudio/darla24.c b/sound/pci/echoaudio/darla24.c
index d1fd34b..95b0330 100644
--- a/sound/pci/echoaudio/darla24.c
+++ b/sound/pci/echoaudio/darla24.c
@@ -56,7 +56,7 @@
 #include <sound/asoundef.h>
 #include <sound/initval.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/darla24_dsp.fw");
diff --git a/sound/pci/echoaudio/echo3g.c b/sound/pci/echoaudio/echo3g.c
index 1dffdc5..8723c40 100644
--- a/sound/pci/echoaudio/echo3g.c
+++ b/sound/pci/echoaudio/echo3g.c
@@ -64,7 +64,7 @@
 #include <sound/initval.h>
 #include <sound/rawmidi.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/loader_dsp.fw");
diff --git a/sound/pci/echoaudio/gina20.c b/sound/pci/echoaudio/gina20.c
index 050e54a..0058c67 100644
--- a/sound/pci/echoaudio/gina20.c
+++ b/sound/pci/echoaudio/gina20.c
@@ -56,7 +56,7 @@
 #include <sound/asoundef.h>
 #include <sound/initval.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/gina20_dsp.fw");
diff --git a/sound/pci/echoaudio/gina24.c b/sound/pci/echoaudio/gina24.c
index 5748fc6..14e4925 100644
--- a/sound/pci/echoaudio/gina24.c
+++ b/sound/pci/echoaudio/gina24.c
@@ -62,7 +62,7 @@
 #include <sound/asoundef.h>
 #include <sound/initval.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/loader_dsp.fw");
diff --git a/sound/pci/echoaudio/indigo.c b/sound/pci/echoaudio/indigo.c
index 4ae5e35..f416b15 100644
--- a/sound/pci/echoaudio/indigo.c
+++ b/sound/pci/echoaudio/indigo.c
@@ -54,7 +54,7 @@
 #include <sound/asoundef.h>
 #include <sound/initval.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/loader_dsp.fw");
diff --git a/sound/pci/echoaudio/indigodj.c b/sound/pci/echoaudio/indigodj.c
index 3550715..e594a3b 100644
--- a/sound/pci/echoaudio/indigodj.c
+++ b/sound/pci/echoaudio/indigodj.c
@@ -54,7 +54,7 @@
 #include <sound/asoundef.h>
 #include <sound/initval.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/loader_dsp.fw");
diff --git a/sound/pci/echoaudio/indigodjx.c b/sound/pci/echoaudio/indigodjx.c
index 19b191f..f0d00bf 100644
--- a/sound/pci/echoaudio/indigodjx.c
+++ b/sound/pci/echoaudio/indigodjx.c
@@ -54,7 +54,7 @@
 #include <sound/pcm_params.h>
 #include <sound/asoundef.h>
 #include <sound/initval.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/loader_dsp.fw");
diff --git a/sound/pci/echoaudio/indigoio.c b/sound/pci/echoaudio/indigoio.c
index a9fcedf..1af0037 100644
--- a/sound/pci/echoaudio/indigoio.c
+++ b/sound/pci/echoaudio/indigoio.c
@@ -55,7 +55,7 @@
 #include <sound/asoundef.h>
 #include <sound/initval.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/loader_dsp.fw");
diff --git a/sound/pci/echoaudio/indigoiox.c b/sound/pci/echoaudio/indigoiox.c
index bcdfac6..0b51163 100644
--- a/sound/pci/echoaudio/indigoiox.c
+++ b/sound/pci/echoaudio/indigoiox.c
@@ -55,7 +55,7 @@
 #include <sound/pcm_params.h>
 #include <sound/asoundef.h>
 #include <sound/initval.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/loader_dsp.fw");
diff --git a/sound/pci/echoaudio/layla20.c b/sound/pci/echoaudio/layla20.c
index d3a98c5..3f63ab8 100644
--- a/sound/pci/echoaudio/layla20.c
+++ b/sound/pci/echoaudio/layla20.c
@@ -62,7 +62,7 @@
 #include <sound/initval.h>
 #include <sound/rawmidi.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/layla20_dsp.fw");
diff --git a/sound/pci/echoaudio/layla24.c b/sound/pci/echoaudio/layla24.c
index 2a1dca6..2831372 100644
--- a/sound/pci/echoaudio/layla24.c
+++ b/sound/pci/echoaudio/layla24.c
@@ -64,7 +64,7 @@
 #include <sound/initval.h>
 #include <sound/rawmidi.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/loader_dsp.fw");
diff --git a/sound/pci/echoaudio/mia.c b/sound/pci/echoaudio/mia.c
index 9cdf14c..eddaeb4 100644
--- a/sound/pci/echoaudio/mia.c
+++ b/sound/pci/echoaudio/mia.c
@@ -63,7 +63,7 @@
 #include <sound/initval.h>
 #include <sound/rawmidi.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/loader_dsp.fw");
diff --git a/sound/pci/echoaudio/mona.c b/sound/pci/echoaudio/mona.c
index 1047be4..0364011 100644
--- a/sound/pci/echoaudio/mona.c
+++ b/sound/pci/echoaudio/mona.c
@@ -60,7 +60,7 @@
 #include <sound/asoundef.h>
 #include <sound/initval.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/loader_dsp.fw");
diff --git a/sound/pci/lx6464es/lx6464es.h b/sound/pci/lx6464es/lx6464es.h
index aea621e..3c25ac1 100644
--- a/sound/pci/lx6464es/lx6464es.h
+++ b/sound/pci/lx6464es/lx6464es.h
@@ -26,7 +26,7 @@
 #define LX6464ES_H
 
 #include <linux/spinlock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <sound/core.h>
 #include <sound/pcm.h>
diff --git a/sound/sparc/dbri.c b/sound/sparc/dbri.c
index 73f9cba..1b839a0 100644
--- a/sound/sparc/dbri.c
+++ b/sound/sparc/dbri.c
@@ -69,7 +69,7 @@
 
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 MODULE_AUTHOR("Rudolf Koenig, Brent Baccala and Martin Habets");
 MODULE_DESCRIPTION("Sun DBRI");
-- 
1.7.4

