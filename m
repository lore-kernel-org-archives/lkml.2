Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab1I1W0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:26:49 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:58474 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752805Ab1I1W0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:26:48 -0400
X-Sasl-enc: elGYiQLA6fsXPWUxylj0aY1M/T/cuE+WkooBcEc7MDiI 1317248807
Date: Wed, 28 Sep 2011 15:26:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [000/244] 3.0.5-stable review
Message-ID: <20110928222643.GA28394@kroah.com>
References: <20110928220225.GA27128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110928220225.GA27128@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 03:02:25PM -0700, Greg KH wrote:
> This is the start of the stable review cycle for the 3.0.5 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let us know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.
> 
> Responses should be made by Friday, September 30, 20:00:00 UTC.
> Anything received after that time might be too late.
> 
> The whole patch series would normally be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.5-rc1.gz
> and the diffstat can be found below.

Doh, I forgot the diffstat, here it is.


 Makefile                                           |    4 +-
 arch/arm/Kconfig                                   |   14 ++
 arch/arm/include/asm/futex.h                       |   34 ++--
 arch/arm/include/asm/hardware/cache-l2x0.h         |    2 +-
 arch/arm/kernel/smp_scu.c                          |   10 +
 arch/arm/mach-davinci/board-da850-evm.c            |   28 +++
 arch/arm/mach-davinci/sleep.S                      |    6 +-
 arch/arm/mach-dove/common.c                        |    2 +-
 arch/arm/mach-integrator/integrator_ap.c           |    6 +-
 arch/arm/mm/cache-v7.S                             |   20 ++
 arch/arm/mm/dma-mapping.c                          |    2 +
 arch/arm/plat-mxc/include/mach/iomux-v3.h          |    2 +-
 arch/powerpc/sysdev/fsl_rio.c                      |    5 +-
 arch/sparc/Kconfig                                 |    1 +
 arch/sparc/include/asm/sigcontext.h                |   14 ++
 arch/sparc/include/asm/spinlock_32.h               |   11 +-
 arch/sparc/include/asm/spinlock_64.h               |    6 -
 arch/sparc/kernel/Makefile                         |    1 +
 arch/sparc/kernel/irq.h                            |    2 +-
 arch/sparc/kernel/pcic.c                           |    4 +-
 arch/sparc/kernel/setup_64.c                       |   10 +-
 arch/sparc/kernel/signal32.c                       |  184 +++++++++++---------
 arch/sparc/kernel/signal_32.c                      |  172 +++++++++----------
 arch/sparc/kernel/signal_64.c                      |  108 +++++-------
 arch/sparc/kernel/sigutil.h                        |    9 +
 arch/sparc/kernel/sigutil_32.c                     |  120 +++++++++++++
 arch/sparc/kernel/sigutil_64.c                     |   93 ++++++++++
 arch/x86/kernel/amd_iommu.c                        |   18 +-
 arch/x86/kernel/cpu/perf_event.c                   |    3 +
 arch/x86/kernel/cpu/perf_event_intel.c             |    1 +
 arch/x86/pci/acpi.c                                |    9 +
 arch/x86/platform/mrst/mrst.c                      |    4 +-
 arch/x86/xen/setup.c                               |   21 +++
 arch/x86/xen/smp.c                                 |   10 +
 arch/x86/xen/xen-asm_32.S                          |    8 +-
 block/blk-cgroup.c                                 |   37 ++---
 block/blk-core.c                                   |   13 +-
 block/blk-sysfs.c                                  |    5 +
 drivers/acpi/acpica/acconfig.h                     |    2 +-
 drivers/acpi/acpica/aclocal.h                      |    1 +
 drivers/acpi/acpica/nspredef.c                     |    1 +
 drivers/acpi/acpica/nsrepair2.c                    |   15 ++
 drivers/ata/ahci.c                                 |    1 +
 drivers/ata/pata_via.c                             |   18 ++
 drivers/base/firmware_class.c                      |   11 +-
 drivers/block/floppy.c                             |    8 +-
 drivers/char/tpm/tpm.c                             |    9 +-
 drivers/cpufreq/pcc-cpufreq.c                      |    3 +
 drivers/firewire/ohci.c                            |    3 +
 drivers/gpu/drm/nouveau/nouveau_sgdma.c            |    5 +-
 drivers/gpu/drm/radeon/evergreen.c                 |   42 ++++-
 drivers/gpu/drm/radeon/ni.c                        |   16 +-
 drivers/gpu/drm/radeon/r100.c                      |   22 +--
 drivers/gpu/drm/radeon/r200.c                      |    4 +-
 drivers/gpu/drm/radeon/r600.c                      |   14 +-
 drivers/gpu/drm/radeon/radeon.h                    |    7 +-
 drivers/gpu/drm/radeon/radeon_asic.h               |    8 +-
 drivers/gpu/drm/radeon/radeon_clocks.c             |    3 +
 drivers/gpu/drm/radeon/radeon_combios.c            |    8 +
 drivers/gpu/drm/radeon/radeon_encoders.c           |    9 +-
 drivers/gpu/drm/radeon/radeon_ttm.c                |    7 +-
 drivers/hwmon/ds620.c                              |    2 +-
 drivers/hwmon/max16065.c                           |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c              |   10 +-
 drivers/leds/ledtrig-timer.c                       |    2 +
 drivers/md/linear.h                                |    2 +-
 drivers/md/md.c                                    |   12 +-
 drivers/media/dvb/dvb-usb/vp7045.c                 |   26 +---
 drivers/media/rc/nuvoton-cir.c                     |   45 +----
 drivers/media/rc/nuvoton-cir.h                     |    1 -
 drivers/mfd/omap-usb-host.c                        |    1 -
 drivers/mfd/tps65910-irq.c                         |    2 +
 drivers/mmc/core/core.c                            |   35 ++++-
 drivers/mmc/core/host.c                            |   12 +-
 drivers/mmc/core/host.h                            |    8 +-
 drivers/mmc/host/sdhci-s3c.c                       |    2 +
 drivers/net/bnx2.c                                 |    7 +
 drivers/net/bnx2x/bnx2x_dcb.c                      |    1 +
 drivers/net/bnx2x/bnx2x_main.c                     |    6 +-
 drivers/net/bnx2x/bnx2x_reg.h                      |   12 ++
 drivers/net/cnic.c                                 |   57 +++---
 drivers/net/cxgb3/cxgb3_offload.c                  |   23 ++-
 drivers/net/cxgb3/l2t.c                            |   15 ++-
 drivers/net/cxgb3/l2t.h                            |   16 ++-
 drivers/net/e1000/e1000_hw.c                       |    6 +
 drivers/net/ibmveth.c                              |   31 +++-
 drivers/net/igb/igb_main.c                         |    2 +-
 drivers/net/irda/smsc-ircc2.c                      |    2 +-
 drivers/net/ixgbe/ixgbe_main.c                     |    4 +-
 drivers/net/rionet.c                               |   23 +--
 drivers/net/sfc/efx.c                              |   18 +--
 drivers/net/sfc/io.h                               |   15 +--
 drivers/net/sfc/mcdi.c                             |   46 ++---
 drivers/net/sfc/nic.c                              |    7 -
 drivers/net/sfc/nic.h                              |    2 -
 drivers/net/sfc/siena.c                            |   25 +---
 drivers/net/sfc/workarounds.h                      |    2 -
 drivers/net/tg3.c                                  |   30 ++--
 drivers/net/usb/asix.c                             |    4 +
 drivers/net/usb/cdc_ncm.c                          |  156 ++++++-----------
 drivers/net/wireless/ath/ath9k/ar9002_calib.c      |    3 +-
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |    2 +-
 drivers/net/wireless/ath/ath9k/main.c              |    4 +
 drivers/net/wireless/ath/carl9170/main.c           |    4 +-
 drivers/net/wireless/b43/main.c                    |    3 +-
 drivers/net/wireless/iwlegacy/iwl-3945-rs.c        |   13 +-
 drivers/net/wireless/iwlegacy/iwl-core.c           |    4 +-
 drivers/net/wireless/iwlegacy/iwl-hcmd.c           |    2 +-
 drivers/net/wireless/iwlegacy/iwl-tx.c             |    4 +-
 drivers/net/wireless/iwlegacy/iwl3945-base.c       |    8 +-
 drivers/net/wireless/iwlegacy/iwl4965-base.c       |   10 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c             |    5 +
 drivers/net/wireless/iwlwifi/iwl-scan.c            |   30 ++--
 drivers/net/wireless/iwlwifi/iwl-tx.c              |    2 +
 drivers/net/wireless/rt2x00/rt2800lib.c            |   64 ++++---
 drivers/net/wireless/rt2x00/rt2800usb.c            |    4 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c            |   14 +--
 drivers/net/wireless/rtlwifi/core.c                |    8 +
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c       |   11 +-
 drivers/net/wireless/rtlwifi/usb.c                 |    1 +
 drivers/pci/dmar.c                                 |    2 +-
 drivers/pci/hotplug/pcihp_slot.c                   |   45 +-----
 drivers/pci/pci.c                                  |   67 +++++++
 drivers/pci/probe.c                                |  150 ++++++++++++++++
 drivers/rapidio/rio-scan.c                         |    3 +-
 drivers/regulator/tps65910-regulator.c             |    7 +
 drivers/rtc/interface.c                            |    2 +-
 drivers/s390/cio/qdio_thinint.c                    |   15 +-
 drivers/scsi/3w-9xxx.c                             |    2 +
 drivers/scsi/Makefile                              |    2 +-
 drivers/scsi/aacraid/commsup.c                     |    2 +
 drivers/scsi/bnx2fc/bnx2fc.h                       |    8 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |   28 +++-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c                   |   24 +++-
 drivers/scsi/bnx2fc/bnx2fc_io.c                    |    2 +-
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c                 |    2 +-
 drivers/scsi/fcoe/fcoe.c                           |   19 ++-
 drivers/scsi/hpsa.c                                |   57 ++++--
 drivers/scsi/isci/host.c                           |    3 +
 drivers/scsi/isci/phy.c                            |   13 ++
 drivers/scsi/isci/registers.h                      |   12 ++
 drivers/scsi/isci/request.c                        |   30 ++--
 drivers/scsi/isci/unsolicited_frame_control.c      |    2 +-
 drivers/scsi/isci/unsolicited_frame_control.h      |    2 +-
 drivers/scsi/iscsi_tcp.c                           |   61 +++++--
 drivers/scsi/libfc/fc_rport.c                      |   14 ++
 drivers/scsi/libiscsi_tcp.c                        |   14 +--
 drivers/scsi/libsas/sas_expander.c                 |    2 +-
 drivers/scsi/lpfc/lpfc.h                           |    8 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |  147 ++++++++--------
 drivers/scsi/lpfc/lpfc_bsg.c                       |   52 +++---
 drivers/scsi/lpfc/lpfc_crtn.h                      |    2 +
 drivers/scsi/lpfc/lpfc_els.c                       |  103 +++++++----
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |    2 +-
 drivers/scsi/lpfc/lpfc_hw.h                        |    7 +-
 drivers/scsi/lpfc/lpfc_hw4.h                       |   30 ++--
 drivers/scsi/lpfc/lpfc_init.c                      |   82 +++++++--
 drivers/scsi/lpfc/lpfc_mbox.c                      |    2 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |   97 ++++-------
 drivers/scsi/lpfc/lpfc_sli.c                       |  106 +++++++----
 drivers/scsi/lpfc/lpfc_sli4.h                      |    2 +
 drivers/scsi/mpt2sas/mpt2sas_base.c                |   19 ++-
 drivers/scsi/mpt2sas/mpt2sas_base.h                |    3 +
 drivers/scsi/mpt2sas/mpt2sas_scsih.c               |    3 +-
 drivers/scsi/qla2xxx/qla_init.c                    |    3 -
 drivers/scsi/qla2xxx/qla_isr.c                     |    1 -
 drivers/tty/pty.c                                  |   17 ++-
 drivers/tty/serial/8250.c                          |    8 +-
 drivers/tty/serial/8250_pci.c                      |    6 +-
 drivers/tty/serial/8250_pnp.c                      |    3 +
 drivers/tty/serial/max3107-aava.c                  |    2 +-
 drivers/tty/serial/max3107.c                       |    2 +-
 drivers/tty/serial/mrst_max3110.c                  |    2 +-
 drivers/tty/serial/omap-serial.c                   |    3 +-
 drivers/tty/tty_io.c                               |    3 +-
 drivers/usb/host/ehci-hub.c                        |    7 +-
 drivers/usb/host/ehci-s5p.c                        |    1 +
 drivers/usb/host/pci-quirks.c                      |   28 +++-
 drivers/usb/host/xhci-hub.c                        |   19 ++-
 drivers/usb/host/xhci-ring.c                       |   90 +++++++---
 drivers/usb/host/xhci.c                            |   28 +++-
 drivers/usb/musb/cppi_dma.c                        |   26 ++-
 drivers/usb/serial/ftdi_sio.c                      |   20 ++-
 drivers/usb/serial/option.c                        |  104 +++++++++++-
 drivers/usb/serial/pl2303.c                        |   26 +++-
 drivers/video/savage/savagefb.h                    |    2 +-
 drivers/zorro/zorro.c                              |    7 +-
 fs/9p/acl.c                                        |   22 ++-
 fs/9p/acl.h                                        |    6 +-
 fs/9p/cache.c                                      |   20 +--
 fs/9p/cache.h                                      |    9 -
 fs/9p/v9fs.c                                       |   45 ++++-
 fs/9p/v9fs.h                                       |   29 +++-
 fs/9p/v9fs_vfs.h                                   |    6 +-
 fs/9p/vfs_file.c                                   |   36 +++-
 fs/9p/vfs_inode.c                                  |  177 +++++++++++++------
 fs/9p/vfs_inode_dotl.c                             |  162 ++++++++++++++---
 fs/9p/vfs_super.c                                  |    2 +-
 fs/block_dev.c                                     |    7 +-
 fs/btrfs/inode.c                                   |    5 +-
 fs/cifs/cifssmb.c                                  |    3 +-
 fs/cifs/connect.c                                  |    4 +-
 fs/ext4/inode.c                                    |    4 +-
 fs/fs-writeback.c                                  |   26 ++-
 fs/namei.c                                         |    4 +
 fs/proc/task_mmu.c                                 |   80 ++++++---
 include/linux/mfd/wm8994/pdata.h                   |    2 +-
 include/linux/pci.h                                |   15 ++-
 include/linux/rio_regs.h                           |   18 +-
 include/linux/rtc.h                                |    3 +
 include/linux/tty.h                                |    2 +
 include/linux/tty_driver.h                         |    3 +
 include/linux/writeback.h                          |    1 +
 include/net/9p/9p.h                                |   29 +++
 ipc/mqueue.c                                       |  127 +++++++-------
 kernel/irq/chip.c                                  |    2 +-
 kernel/printk.c                                    |    2 +-
 kernel/sched.c                                     |   41 +++--
 kernel/time/alarmtimer.c                           |   18 ++-
 kernel/workqueue.c                                 |    7 +-
 lib/xz/xz_dec_bcj.c                                |   27 ++-
 mm/page-writeback.c                                |    4 +-
 mm/page_alloc.c                                    |   58 +++++--
 mm/vmalloc.c                                       |    8 +
 mm/vmscan.c                                        |   18 ++-
 net/8021q/vlan_core.c                              |    2 +
 net/9p/client.c                                    |   13 +-
 net/9p/trans_virtio.c                              |   17 ++-
 net/atm/br2684.c                                   |    7 +-
 net/bluetooth/hci_event.c                          |   17 +-
 net/bridge/br_if.c                                 |    6 +-
 net/bridge/br_multicast.c                          |   21 ++-
 net/core/fib_rules.c                               |    4 +-
 net/core/neighbour.c                               |    8 +-
 net/core/scm.c                                     |    2 +-
 net/ipv4/igmp.c                                    |    2 +-
 net/ipv4/netfilter.c                               |   18 +-
 net/ipv4/route.c                                   |    8 +-
 net/ipv4/syncookies.c                              |    2 +-
 net/ipv4/tcp_input.c                               |    2 +-
 net/ipv6/ipv6_sockglue.c                           |    9 +-
 net/ipv6/mcast.c                                   |    2 +-
 net/ipv6/syncookies.c                              |    2 +-
 net/mac80211/sta_info.c                            |    2 +-
 net/sched/sch_prio.c                               |    2 +-
 net/socket.c                                       |   10 +-
 net/wireless/nl80211.c                             |    5 +-
 net/wireless/reg.c                                 |    1 +
 net/xfrm/xfrm_input.c                              |    5 +
 sound/core/pcm_lib.c                               |   33 +++-
 sound/pci/fm801.c                                  |   15 +-
 sound/pci/hda/patch_cirrus.c                       |    2 +-
 sound/pci/hda/patch_realtek.c                      |   13 +-
 sound/pci/hda/patch_sigmatel.c                     |    1 +
 sound/soc/blackfin/bf5xx-ad193x.c                  |    4 +-
 sound/soc/codecs/ad193x.c                          |    3 +-
 sound/soc/codecs/ad193x.h                          |    5 +-
 sound/soc/codecs/ssm2602.c                         |    3 +-
 sound/soc/fsl/mpc5200_dma.c                        |    6 +-
 sound/soc/omap/omap-mcbsp.c                        |    6 +
 sound/soc/soc-jack.c                               |    4 +-
 sound/usb/card.c                                   |    7 +-
 tools/perf/util/symbol.c                           |    2 +
 264 files changed, 3338 insertions(+), 1714 deletions(-)
