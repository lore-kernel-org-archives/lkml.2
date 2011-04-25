Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab1DYUWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:22:41 -0400
Received: from 1wt.eu ([62.212.114.60]:33621 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339Ab1DYUWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:22:39 -0400
Message-Id: <20110425200232.973382611@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:02:32 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Subject: [PATCH 000/173] 2.6.27.59-longterm review
Message-ID: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.27.59 release.

This release is quite large, because it contains accumulated changes
from the last 2.5 months.  I spent all the day carefully reviewing 380
patches and backporting 173 of them.  I *think* the patches are OK, make
allmodconfig is happy and the code runs here, though I have only tested
x86 and x86_64.  There were a bunch of powerpc fixes that I could not
test but which applied well.  Any check on them will be appreciated.

All patches will be posted as a response to this one.  If anyone has any
issues with these being applied, please let me know.  If anyone is a
maintainer of the proper subsystem, and wants to add a Signed-off-by:
line to the patch, please respond with it.

The full quilt queue can be found at
git://git.kernel.org/pub/scm/linux/kernel/git/longterm/longterm-queue-2.6.27.git

Responses should be made within 72 hours. Anything received after that
time might be too late.

The whole patch series can be found in one patch at:
        kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.27.59-rc1.gz
and the diffstat can be found below.

 Documentation/kernel-parameters.txt             |    1 +
 MAINTAINERS                                     |    2 -
 arch/arm/kernel/signal.c                        |    4 +-
 arch/ia64/sn/pci/tioca_provider.c               |    2 +-
 arch/parisc/kernel/firmware.c                   |   23 +------
 arch/parisc/kernel/irq.c                        |    2 +-
 arch/powerpc/include/asm/hvcall.h               |    1 +
 arch/powerpc/kernel/cpu_setup_6xx.S             |   40 ++++++------
 arch/powerpc/kernel/crash.c                     |   42 ++++++++++++-
 arch/powerpc/kernel/machine_kexec_64.c          |   25 +++++++
 arch/powerpc/kernel/rtas_flash.c                |   39 ++++++-----
 arch/powerpc/kernel/setup_64.c                  |   17 ++++-
 arch/powerpc/platforms/pseries/hvCall.S         |   38 +++++++++++
 arch/powerpc/platforms/pseries/lpar.c           |   35 ++++++----
 arch/powerpc/platforms/pseries/plpar_wrappers.h |   18 +++++
 arch/powerpc/sysdev/fsl_rio.c                   |    1 -
 arch/s390/include/asm/processor.h               |    5 --
 arch/s390/kernel/traps.c                        |   37 -----------
 arch/x86/kernel/e820.c                          |    3 +
 arch/x86/kernel/early-quirks.c                  |    7 ++-
 arch/x86/kernel/entry_64.S                      |    2 +-
 arch/x86/lib/semaphore_32.S                     |    2 +-
 arch/x86/mm/pgtable.c                           |    3 +-
 drivers/acpi/asus_acpi.c                        |    8 +--
 drivers/ata/ahci.c                              |   15 ++++
 drivers/ata/libata-core.c                       |   24 ++++---
 drivers/ata/pata_mpc52xx.c                      |    2 +-
 drivers/block/cciss.h                           |    1 +
 drivers/block/pktcdvd.c                         |    2 +-
 drivers/bluetooth/btusb.c                       |    3 +
 drivers/char/tpm/tpm.c                          |   12 ++--
 drivers/firmware/dcdbas.c                       |    4 +-
 drivers/hwmon/f71882fg.c                        |    2 +-
 drivers/hwmon/via686a.c                         |   14 +++-
 drivers/infiniband/core/cm.c                    |    1 +
 drivers/infiniband/core/cma.c                   |   15 ++++
 drivers/input/serio/i8042-x86ia64io.h           |   21 ++++++
 drivers/input/serio/i8042.c                     |    6 ++-
 drivers/input/xen-kbdfront.c                    |   45 +++++++------
 drivers/isdn/hisax/config.c                     |   18 ++++-
 drivers/isdn/hisax/hisax.h                      |    1 +
 drivers/isdn/i4l/isdn_tty.c                     |    6 --
 drivers/md/dm-raid1.c                           |    2 +-
 drivers/md/md.c                                 |    8 ++-
 drivers/media/dvb/ttpci/av7110_ca.c             |    2 +-
 drivers/media/radio/radio-aimslab.c             |   24 ++-----
 drivers/media/video/sn9c102/sn9c102_core.c      |    6 +-
 drivers/message/fusion/mptscsih.c               |    2 +
 drivers/mfd/ucb1x00-ts.c                        |   12 +++-
 drivers/misc/acer-wmi.c                         |    6 +-
 drivers/misc/tc1100-wmi.c                       |    2 +-
 drivers/net/myri10ge/myri10ge.c                 |    1 +
 drivers/net/r8169.c                             |    6 ++
 drivers/net/wireless/hostap/hostap_cs.c         |   10 +--
 drivers/net/wireless/rt2x00/rt73usb.c           |    1 +
 drivers/pci/quirks.c                            |   63 +++++++++++++++---
 drivers/rtc/rtc-ds1511.c                        |    2 +-
 drivers/s390/char/keyboard.c                    |    3 +-
 drivers/scsi/libsas/sas_scsi_host.c             |    1 +
 drivers/scsi/sd.c                               |    9 ++-
 drivers/scsi/ses.c                              |    4 +-
 drivers/serial/8250.c                           |    3 +-
 drivers/usb/class/cdc-acm.c                     |    3 +-
 drivers/usb/core/hcd-pci.c                      |    4 +-
 drivers/usb/core/hub.c                          |    5 ++
 drivers/usb/gadget/printer.c                    |   14 ++--
 drivers/usb/host/ehci-hcd.c                     |   28 ++++++--
 drivers/usb/host/ehci-pci.c                     |   39 +++++++++++
 drivers/usb/host/ehci-q.c                       |   27 +++-----
 drivers/usb/host/ehci-sched.c                   |   79 +++++++++++++++++++++++
 drivers/usb/host/ehci.h                         |    1 +
 drivers/usb/host/ohci-hcd.c                     |    9 ++-
 drivers/usb/host/ohci-pci.c                     |   18 +++++
 drivers/usb/host/ohci.h                         |    1 +
 drivers/usb/host/pci-quirks.c                   |   18 +++--
 drivers/usb/misc/iowarrior.c                    |    2 +-
 drivers/usb/misc/uss720.c                       |    7 +-
 drivers/usb/musb/omap2430.c                     |    1 +
 drivers/usb/serial/ch341.c                      |    1 +
 drivers/usb/serial/io_edgeport.c                |    4 +-
 drivers/usb/serial/kobil_sct.c                  |    2 +-
 drivers/usb/serial/pl2303.c                     |    2 +
 drivers/usb/serial/pl2303.h                     |    2 +
 drivers/usb/serial/ti_usb_3410_5052.c           |    2 +-
 drivers/usb/storage/unusual_devs.h              |   16 +++++
 drivers/video/console/tileblit.c                |    2 +-
 drivers/virtio/virtio_pci.c                     |    1 +
 fs/aio.c                                        |    4 +-
 fs/compat.c                                     |   28 ++++----
 fs/dquot.c                                      |   11 +--
 fs/ecryptfs/keystore.c                          |    1 +
 fs/exec.c                                       |   30 ++++++++-
 fs/ext2/namei.c                                 |    9 +--
 fs/ext3/namei.c                                 |    2 +-
 fs/ext3/super.c                                 |    7 ++
 fs/ext4/inode.c                                 |   11 ++--
 fs/gfs2/bmap.c                                  |    2 +-
 fs/nfs/direct.c                                 |   34 ++++++----
 fs/nfs/file.c                                   |    2 +-
 fs/nfsd/lockd.c                                 |    1 -
 fs/nfsd/nfs4xdr.c                               |    8 +-
 fs/nfsd/vfs.c                                   |    2 +-
 fs/ocfs2/aops.c                                 |    6 ++
 fs/ocfs2/stack_user.c                           |    2 +-
 fs/partitions/ldm.c                             |    5 ++
 fs/partitions/mac.c                             |   17 +++--
 fs/proc/array.c                                 |    7 +--
 fs/proc/base.c                                  |    9 ++-
 fs/proc/task_mmu.c                              |    4 +-
 fs/ramfs/file-nommu.c                           |    1 +
 fs/ubifs/commit.c                               |    2 +-
 fs/ubifs/file.c                                 |    3 +
 fs/ubifs/lpt.c                                  |    7 +-
 fs/xfs/linux-2.6/xfs_ioctl.c                    |   11 ++-
 fs/xfs/xfs_fsops.c                              |    3 +
 include/asm-x86/mach-default/smpboot_hooks.h    |    2 +-
 include/asm-x86/mmu_context_32.h                |    5 +-
 include/asm-x86/mmu_context_64.h                |    5 +-
 include/asm-x86/pgtable-3level.h                |   11 +--
 include/drm/drm_pciids.h                        |    1 -
 include/linux/binfmts.h                         |    5 ++
 include/linux/pid.h                             |    2 +-
 include/net/sctp/command.h                      |    1 +
 include/scsi/scsi_device.h                      |    2 +-
 include/sound/soc-dapm.h                        |   16 ++--
 init/calibrate.c                                |    6 +-
 kernel/irq/manage.c                             |    2 +-
 kernel/kgdb.c                                   |    9 +--
 kernel/pid.c                                    |    5 +-
 kernel/ptrace.c                                 |    2 +-
 kernel/signal.c                                 |    8 ++-
 mm/mremap.c                                     |   19 ++++--
 mm/shmem.c                                      |    1 +
 net/ax25/af_ax25.c                              |    2 +-
 net/bluetooth/bnep/sock.c                       |    1 +
 net/bluetooth/sco.c                             |    1 +
 net/bridge/netfilter/ebtables.c                 |    2 +
 net/can/bcm.c                                   |    4 +-
 net/core/filter.c                               |   64 ++++++++++--------
 net/dccp/input.c                                |    7 +-
 net/econet/af_econet.c                          |    8 ++-
 net/ipv4/inet_diag.c                            |   27 +++++---
 net/ipv4/netfilter/arp_tables.c                 |    3 +
 net/ipv4/netfilter/ip_tables.c                  |    3 +
 net/ipv4/netfilter/ipt_CLUSTERIP.c              |    5 +-
 net/ipv4/tcp.c                                  |    3 +-
 net/ipv6/netfilter/ip6_tables.c                 |    3 +
 net/irda/af_irda.c                              |   16 +++--
 net/irda/iriap.c                                |    6 ++
 net/irda/irnet/irnet_ppp.c                      |    3 +
 net/mac80211/sta_info.c                         |    1 +
 net/packet/af_packet.c                          |    3 +-
 net/rose/rose_subr.c                            |   18 +++++-
 net/sctp/auth.c                                 |    8 ++-
 net/sctp/sm_make_chunk.c                        |   32 +++------
 net/sctp/sm_sideeffect.c                        |   26 ++++++++
 net/sctp/sm_statefuns.c                         |    8 ++-
 net/sunrpc/cache.c                              |    4 +-
 net/sunrpc/sched.c                              |   14 ++--
 net/tipc/socket.c                               |    1 +
 net/x25/x25_link.c                              |    4 +
 sound/oss/dev_table.h                           |    2 +-
 sound/oss/midi_synth.c                          |   34 +++++-----
 sound/oss/midi_synth.h                          |    2 +-
 sound/oss/opl3.c                                |   23 ++++--
 sound/oss/sequencer.c                           |    2 +-
 sound/pci/au88x0/au88x0_pcm.c                   |   24 ++++++-
 sound/pci/ens1370.c                             |   23 ++++++-
 168 files changed, 1162 insertions(+), 560 deletions(-)



