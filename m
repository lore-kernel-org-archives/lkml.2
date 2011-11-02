Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab1KBWUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 18:20:19 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:37849 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838Ab1KBWUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 18:20:17 -0400
X-Sasl-enc: tvKgMfQm18uUsj2ANy6eXAnHq5SmfjeiWHTeWQAJlOst 1320272416
Date: Wed, 2 Nov 2011 15:16:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [000/107] 2.6.32.47-longterm review
Message-ID: <20111102221600.GA26650@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.47 release.
There are 107 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, November 4, 22:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.47-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Documentation/stable_kernel_rules.txt       |    4 +-
 Makefile                                    |    2 +-
 arch/arm/mach-davinci/board-da850-evm.c     |   28 +++
 arch/arm/plat-mxc/include/mach/iomux-v3.h   |   10 +-
 arch/mips/alchemy/mtx-1/platform.c          |    9 -
 arch/powerpc/kernel/pci_of_scan.c           |    2 +
 arch/powerpc/sysdev/mpic.c                  |   17 +--
 arch/s390/kvm/kvm-s390.c                    |   14 +-
 arch/sparc/include/asm/sigcontext.h         |   14 ++
 arch/sparc/kernel/Makefile                  |    1 +
 arch/sparc/kernel/pcic.c                    |    4 +-
 arch/sparc/kernel/signal32.c                |  184 +++++++++++--------
 arch/sparc/kernel/signal_32.c               |  172 ++++++++----------
 arch/sparc/kernel/signal_64.c               |  108 +++++------
 arch/sparc/kernel/sigutil.h                 |    9 +
 arch/sparc/kernel/sigutil_32.c              |  120 ++++++++++++
 arch/sparc/kernel/sigutil_64.c              |   93 ++++++++++
 arch/um/drivers/ubd_kern.c                  |   31 +++-
 arch/x86/include/asm/processor.h            |   23 +++
 arch/x86/kernel/amd_iommu.c                 |    2 +-
 arch/x86/kernel/kprobes.c                   |    4 +-
 arch/x86/kernel/smpboot.c                   |   85 +---------
 arch/x86/kvm/svm.c                          |    1 +
 arch/x86/kvm/vmx.c                          |    1 +
 arch/x86/xen/smp.c                          |   10 +
 arch/x86/xen/time.c                         |    4 +-
 arch/x86/xen/xen-asm_32.S                   |    8 +-
 block/blk-map.c                             |    5 +-
 block/cfq-iosched.c                         |  264 +++++++++++++++++++++------
 drivers/ata/ahci.c                          |   12 ++
 drivers/base/sys.c                          |    6 +
 drivers/block/xen-blkfront.c                |    2 +-
 drivers/char/hvc_console.c                  |    8 +-
 drivers/char/tpm/tpm.c                      |    9 +-
 drivers/gpu/drm/radeon/r100.c               |    4 +-
 drivers/hid/hid-ids.h                       |    3 +
 drivers/hid/usbhid/hid-quirks.c             |    1 +
 drivers/hwmon/w83627ehf.c                   |   15 +-
 drivers/md/linear.h                         |    2 +-
 drivers/md/md.c                             |   12 +-
 drivers/media/video/cx23885/cx23885-dvb.c   |    2 +-
 drivers/media/video/uvc/uvc_driver.c        |    2 +-
 drivers/media/video/uvc/uvc_video.c         |   10 +-
 drivers/media/video/uvc/uvcvideo.h          |    2 +-
 drivers/net/cnic.c                          |    4 +-
 drivers/net/e1000/e1000_hw.c                |    6 +
 drivers/net/e1000e/netdev.c                 |    2 +-
 drivers/net/igb/igb_main.c                  |    2 +-
 drivers/net/igbvf/netdev.c                  |    2 +-
 drivers/net/irda/smsc-ircc2.c               |    2 +-
 drivers/net/ixgbe/ixgbe_main.c              |    2 +-
 drivers/net/usb/asix.c                      |    4 +
 drivers/net/wireless/b43/main.c             |    3 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c     |   14 +--
 drivers/platform/x86/thinkpad_acpi.c        |    7 +-
 drivers/s390/cio/ccwgroup.c                 |   42 +++--
 drivers/scsi/3w-9xxx.c                      |    2 +
 drivers/scsi/aacraid/commsup.c              |    2 +
 drivers/scsi/ipr.c                          |    2 +-
 drivers/scsi/libiscsi_tcp.c                 |   14 +-
 drivers/scsi/libsas/sas_expander.c          |   14 +-
 drivers/scsi/qla2xxx/qla_init.c             |    3 -
 drivers/scsi/qla2xxx/qla_isr.c              |    1 -
 drivers/staging/quatech_usb2/quatech_usb2.c |    9 +-
 drivers/usb/class/cdc-acm.c                 |    3 +
 drivers/usb/core/devio.c                    |    6 +-
 drivers/usb/core/quirks.c                   |   21 ++
 drivers/usb/host/ehci-hub.c                 |    7 +-
 drivers/usb/host/fhci-sched.c               |   19 ++-
 drivers/usb/host/xhci-mem.c                 |   22 ++-
 drivers/usb/mon/mon_bin.c                   |    2 +-
 drivers/usb/musb/musb_core.c                |    1 -
 drivers/usb/serial/ftdi_sio.c               |   24 +++-
 drivers/usb/serial/ftdi_sio_ids.h           |    7 +-
 drivers/usb/serial/pl2303.c                 |   27 +++-
 drivers/usb/serial/pl2303.h                 |    5 +
 drivers/usb/serial/qcserial.c               |    1 +
 drivers/usb/storage/transport.c             |   34 ++--
 drivers/video/carminefb.c                   |    6 +-
 drivers/watchdog/mtx-1_wdt.c                |    5 +-
 drivers/xen/events.c                        |    2 +-
 fs/cifs/cifssmb.c                           |    3 +-
 fs/eventpoll.c                              |   25 ++-
 fs/lockd/clntproc.c                         |    8 +-
 fs/nfsd/nfs4proc.c                          |    2 +-
 fs/nfsd/nfs4state.c                         |    2 +
 fs/proc/base.c                              |   69 +++++--
 fs/proc/kcore.c                             |    2 +-
 fs/splice.c                                 |    3 +-
 include/linux/interrupt.h                   |    5 +
 include/linux/iocontext.h                   |    5 -
 include/linux/jiffies.h                     |    2 +-
 include/linux/sunrpc/sched.h                |    4 +-
 include/net/scm.h                           |    5 +-
 kernel/irq/pm.c                             |   35 +++-
 kernel/kmod.c                               |    4 +-
 kernel/time.c                               |    2 +-
 lib/kobject_uevent.c                        |    2 +-
 mm/mmap.c                                   |   20 ++-
 net/9p/client.c                             |   13 +-
 net/atm/br2684.c                            |    7 +-
 net/bluetooth/l2cap.c                       |    3 +-
 net/bluetooth/rfcomm/sock.c                 |    1 +
 net/core/scm.c                              |   10 +-
 net/core/skbuff.c                           |    8 +-
 net/ipv6/ip6_output.c                       |    2 +-
 net/ipv6/ip6_tunnel.c                       |    4 +-
 net/sched/sch_api.c                         |   14 +-
 net/sunrpc/clnt.c                           |    3 +
 net/sunrpc/sched.c                          |    1 +
 net/wireless/nl80211.c                      |    9 +-
 net/wireless/reg.c                          |    1 +
 net/x25/af_x25.c                            |    3 +-
 sound/pci/hda/patch_cirrus.c                |    2 +-
 sound/pci/hda/patch_realtek.c               |    6 +-
 sound/soc/codecs/ak4535.c                   |   10 +-
 sound/soc/codecs/ak4642.c                   |   22 +-
 sound/soc/codecs/wm8940.c                   |    2 +
 sound/soc/soc-jack.c                        |    2 +-
 119 files changed, 1308 insertions(+), 661 deletions(-)
