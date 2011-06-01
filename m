Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257Ab1FAIGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:06:24 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:45153 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933235Ab1FAIGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:06:18 -0400
X-Sasl-enc: CRZ6YEvDd4jSxbyWur2QDfdI2jX3cN5ZWDU6cnxQDOll 1306915577
Date: Wed, 1 Jun 2011 17:06:06 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [000/146] 2.6.38.8 stable review
Message-ID: <20110601080606.GA522@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.38.8 release.

NOTE, this is going to be the LAST .38-stable kernel release.  After
this release, unless I really messed something up, it will be
end-of-life.  Please move to the .39 kernel series at this time.

There are 146 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, June 3, 2011, 15:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.38.8-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Documentation/i2c/writing-clients              |    2 +-
 Documentation/usb/linux-cdc-acm.inf            |    4 +-
 Documentation/usb/linux.inf                    |    6 +-
 Makefile                                       |    4 +-
 arch/arm/mm/cache-v6.S                         |    1 +
 arch/arm/mm/cache-v7.S                         |    2 +
 arch/parisc/include/asm/unistd.h               |    8 ++-
 arch/parisc/kernel/sys_parisc32.c              |    8 ++
 arch/parisc/kernel/syscall_table.S             |    6 ++
 arch/powerpc/kernel/crash.c                    |    2 +-
 arch/powerpc/kernel/misc_64.S                  |   13 ++-
 arch/powerpc/kernel/paca.c                     |    2 +-
 arch/powerpc/kernel/setup-common.c             |    3 +
 arch/powerpc/oprofile/op_model_power4.c        |   24 ++++++-
 arch/sh/kernel/cpu/Makefile                    |    4 +-
 arch/x86/include/asm/cpufeature.h              |    2 +-
 arch/x86/include/asm/uaccess.h                 |    2 +-
 arch/x86/kernel/apic/io_apic.c                 |    4 +-
 arch/x86/kernel/cpu/amd.c                      |   16 +++-
 arch/x86/kernel/cpu/common.c                   |    3 +-
 arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c      |    4 +-
 arch/x86/lib/copy_user_64.S                    |    4 +-
 arch/x86/oprofile/op_model_amd.c               |   95 +++++++++++++----------
 arch/x86/xen/mmu.c                             |    2 +-
 block/blk-settings.c                           |    3 +-
 block/blk-sysfs.c                              |    3 +-
 block/blk.h                                    |    3 +-
 block/genhd.c                                  |    2 +-
 drivers/ata/pata_cmd64x.c                      |   42 ++++++++++-
 drivers/block/brd.c                            |   11 ++-
 drivers/block/loop.c                           |   11 ++-
 drivers/block/paride/pcd.c                     |   19 +++--
 drivers/block/paride/pd.c                      |    7 +-
 drivers/block/paride/pf.c                      |   10 ++-
 drivers/cdrom/gdrom.c                          |   16 +++--
 drivers/cdrom/viocd.c                          |   20 +++--
 drivers/char/i8k.c                             |    4 +-
 drivers/cpufreq/cpufreq.c                      |   20 +++++-
 drivers/cpufreq/cpufreq_stats.c                |   21 +++++-
 drivers/cpuidle/governors/menu.c               |    4 +-
 drivers/gpu/drm/drm_irq.c                      |   23 ++++++
 drivers/gpu/drm/i915/intel_ringbuffer.c        |   29 +++++++-
 drivers/gpu/drm/radeon/evergreen.c             |    6 +-
 drivers/gpu/drm/radeon/evergreend.h            |    2 +
 drivers/gpu/drm/radeon/radeon_asic.c           |    4 +
 drivers/hid/hid-magicmouse.c                   |   10 ++-
 drivers/ide/ide-cd.c                           |   12 ++-
 drivers/ide/ide-cd.h                           |    3 +-
 drivers/ide/ide-cd_ioctl.c                     |    8 +-
 drivers/ide/ide-gd.c                           |   14 ++--
 drivers/md/bitmap.c                            |   10 ++-
 drivers/md/dm-table.c                          |   17 ++++
 drivers/md/md.c                                |   11 ++-
 drivers/media/video/cx88/cx88-blackbird.c      |    5 +-
 drivers/media/video/cx88/cx88-dvb.c            |    2 +
 drivers/media/video/cx88/cx88-mpeg.c           |   20 ++---
 drivers/media/video/cx88/cx88.h                |    7 ++-
 drivers/mtd/mtdconcat.c                        |    4 +-
 drivers/mtd/nand/nand_base.c                   |    2 +
 drivers/net/bonding/bond_3ad.c                 |    7 +-
 drivers/net/bonding/bond_alb.c                 |    4 -
 drivers/net/bonding/bond_main.c                |   16 +++--
 drivers/net/bonding/bond_sysfs.c               |    6 --
 drivers/net/macvlan.c                          |    4 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   14 +++-
 drivers/net/wireless/ath/ath9k/calib.c         |   13 +++
 drivers/net/wireless/iwlwifi/iwl-core.c        |   10 +++
 drivers/net/wireless/iwlwifi/iwl-dev.h         |   19 +++--
 drivers/net/wireless/p54/p54usb.c              |    1 +
 drivers/pci/quirks.c                           |   10 +++
 drivers/platform/x86/intel_ips.c               |    2 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c                 |    1 +
 drivers/scsi/bnx2i/bnx2i_init.c                |    2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c               |    5 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c           |   94 +++++++++++++++++-------
 drivers/scsi/qla2xxx/qla_attr.c                |    5 +-
 drivers/scsi/qla2xxx/qla_os.c                  |   32 +++++---
 drivers/scsi/sr.c                              |    2 +-
 drivers/scsi/ultrastor.c                       |    2 +-
 drivers/sh/clk/cpg.c                           |    2 +-
 drivers/staging/rtl8712/rtl871x_ioctl_set.c    |    5 +-
 drivers/staging/usbip/usbip_common.c           |    2 +-
 drivers/target/target_core_device.c            |    4 +-
 drivers/target/target_core_tmr.c               |    7 +-
 drivers/target/target_core_transport.c         |   46 +++++++++---
 drivers/usb/class/cdc-acm.c                    |   13 +++-
 drivers/usb/class/cdc-acm.h                    |    1 +
 drivers/usb/core/hcd.c                         |    5 +-
 drivers/usb/gadget/at91_udc.c                  |    2 +-
 drivers/usb/gadget/f_rndis.c                   |    3 +-
 drivers/usb/host/ehci-hcd.c                    |    4 +-
 drivers/usb/host/ehci-sched.c                  |    8 ++-
 drivers/usb/host/isp116x-hcd.c                 |    1 +
 drivers/usb/host/ohci-hcd.c                    |    4 +-
 drivers/usb/host/ohci-pci.c                    |   12 +++-
 drivers/usb/host/oxu210hp-hcd.c                |    6 +-
 drivers/usb/host/xhci-mem.c                    |   11 +--
 drivers/usb/host/xhci-ring.c                   |   18 ++--
 drivers/usb/host/xhci.c                        |   11 +++-
 drivers/usb/serial/cp210x.c                    |    4 +
 drivers/usb/serial/ftdi_sio.c                  |    1 +
 drivers/usb/serial/ftdi_sio_ids.h              |    5 +
 drivers/usb/serial/garmin_gps.c                |   20 +++--
 drivers/usb/serial/moto_modem.c                |    1 +
 drivers/usb/serial/option.c                    |   10 ++-
 fs/block_dev.c                                 |   45 +++++++----
 fs/cifs/connect.c                              |   31 ++++++--
 fs/ecryptfs/keystore.c                         |   46 +++++------
 fs/ext3/namei.c                                |   13 +++-
 fs/ext4/ext4.h                                 |    4 -
 fs/ext4/mballoc.c                              |    2 +
 fs/ext4/super.c                                |   41 +++-------
 fs/jbd/commit.c                                |    9 ++-
 fs/jbd/journal.c                               |   16 +++-
 fs/nfs/nfs4proc.c                              |    9 ++-
 fs/nfs/nfs4state.c                             |    6 +-
 fs/partitions/ldm.c                            |    5 +
 fs/ubifs/sb.c                                  |    3 +-
 fs/ubifs/super.c                               |    1 +
 include/linux/blkdev.h                         |    7 +-
 include/linux/genhd.h                          |    1 +
 include/linux/pci_ids.h                        |    2 +
 include/linux/pm_qos_params.h                  |    4 +
 include/linux/seqlock.h                        |    4 +-
 include/target/target_core_base.h              |    1 +
 include/target/target_core_transport.h         |    1 +
 init/main.c                                    |    2 +-
 kernel/pm_qos_params.c                         |   37 ++++++---
 kernel/trace/ftrace.c                          |   12 ++-
 lib/locking-selftest.c                         |    2 +-
 mm/kmemleak.c                                  |    7 +-
 mm/page_alloc.c                                |    2 +-
 mm/shmem.c                                     |    2 +-
 mm/vmscan.c                                    |   11 ++-
 net/8021q/vlan.c                               |    3 +
 net/8021q/vlan_dev.c                           |    3 -
 net/atm/atm_sysfs.c                            |   10 +++
 net/bridge/br_input.c                          |    2 +-
 net/bridge/br_netfilter.c                      |    2 +-
 net/core/dev.c                                 |    2 +-
 net/core/skbuff.c                              |    3 +
 net/ieee802154/Makefile                        |    2 -
 net/ipv4/igmp.c                                |   10 +-
 net/ipv4/inet_connection_sock.c                |    5 +-
 net/ipv4/inetpeer.c                            |   13 ++--
 net/ipv4/sysctl_net_ipv4.c                     |    3 -
 net/ipv4/tcp_output.c                          |    3 +-
 net/ipv6/inet6_connection_sock.c               |    2 +-
 net/ipv6/route.c                               |    1 -
 net/ipv6/udp.c                                 |    2 +-
 net/irda/af_irda.c                             |    3 +-
 net/mac80211/cfg.c                             |   12 ++-
 net/sched/sch_sfq.c                            |   22 ++----
 net/sctp/associola.c                           |   16 ++++
 net/sctp/bind_addr.c                           |   10 +--
 net/socket.c                                   |    6 +-
 net/sunrpc/xprtsock.c                          |   16 +++-
 net/wireless/nl80211.c                         |    8 --
 security/apparmor/lsm.c                        |    3 +-
 sound/pci/hda/hda_intel.c                      |    9 ++-
 sound/pci/hda/patch_analog.c                   |    3 +-
 sound/pci/hda/patch_conexant.c                 |    1 +
 sound/pci/hda/patch_sigmatel.c                 |    2 +-
 sound/soc/codecs/wm_hubs.c                     |   24 ++++---
 164 files changed, 1071 insertions(+), 517 deletions(-)
