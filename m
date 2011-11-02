Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab1KBW2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 18:28:37 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:42779 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486Ab1KBW2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 18:28:34 -0400
X-Sasl-enc: kpJPhn+gSde9bbDQxWbpTHCk98zTCe/AGgqB+hErslKM 1320272912
Date: Wed, 2 Nov 2011 15:27:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [000/101] 2.6.33.20-longterm review
Message-ID: <20111102222755.GA10893@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note, this is going to be the LAST 2.6.33-longterm release.  After this
one, it is end-of-life, please move to the 3.0 kernel if you are relying
on this kernel for your real-time kernel usage.

This is the start of the stable review cycle for the 2.6.33.20 release.
There are 101 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, November 4, 22:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.33.20-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Documentation/stable_kernel_rules.txt       |   12 ++--
 Makefile                                    |    2 +-
 arch/arm/mach-davinci/board-da850-evm.c     |   28 +++++++++
 arch/arm/plat-mxc/include/mach/iomux-v3.h   |   10 ++--
 arch/mips/alchemy/mtx-1/platform.c          |    9 ---
 arch/powerpc/kernel/pci_of_scan.c           |    2 +
 arch/s390/kvm/kvm-s390.c                    |   14 +++-
 arch/sparc/include/asm/spinlock_32.h        |   11 +++-
 arch/sparc/include/asm/spinlock_64.h        |    6 --
 arch/sparc/kernel/pcic.c                    |    4 +-
 arch/x86/include/asm/processor.h            |   23 +++++++
 arch/x86/kernel/amd_iommu.c                 |    2 +-
 arch/x86/kernel/kprobes.c                   |    4 +-
 arch/x86/kernel/smpboot.c                   |   85 +--------------------------
 arch/x86/xen/smp.c                          |   10 +++
 arch/x86/xen/xen-asm_32.S                   |    8 ++-
 block/blk-map.c                             |    5 +-
 drivers/ata/ahci.c                          |   12 ++++
 drivers/block/xen-blkfront.c                |    2 +-
 drivers/char/hvc_console.c                  |    8 ++-
 drivers/char/tpm/tpm.c                      |    9 +++-
 drivers/gpu/drm/radeon/r100.c               |    4 +-
 drivers/hid/hid-ids.h                       |    3 +
 drivers/hid/usbhid/hid-quirks.c             |    1 +
 drivers/hwmon/w83627ehf.c                   |   15 ++++-
 drivers/md/linear.h                         |    2 +-
 drivers/md/md.c                             |   12 +++-
 drivers/media/video/cx23885/cx23885-dvb.c   |    2 +-
 drivers/media/video/uvc/uvc_driver.c        |    2 +-
 drivers/media/video/uvc/uvc_video.c         |   10 +++-
 drivers/media/video/uvc/uvcvideo.h          |    2 +-
 drivers/net/cnic.c                          |    4 +-
 drivers/net/e1000/e1000_hw.c                |    6 ++
 drivers/net/irda/smsc-ircc2.c               |    2 +-
 drivers/net/usb/asix.c                      |    4 +
 drivers/net/wireless/b43/main.c             |    3 +-
 drivers/net/wireless/rt2x00/rt2800lib.c     |   17 +++---
 drivers/net/wireless/rt2x00/rt2x00usb.c     |   14 +----
 drivers/platform/x86/thinkpad_acpi.c        |    7 ++-
 drivers/s390/cio/ccwgroup.c                 |   42 +++++++------
 drivers/scsi/3w-9xxx.c                      |    2 +
 drivers/scsi/aacraid/commsup.c              |    2 +
 drivers/scsi/fcoe/fcoe.c                    |   19 +++++-
 drivers/scsi/ipr.c                          |    2 +-
 drivers/scsi/libiscsi_tcp.c                 |   14 +----
 drivers/scsi/libsas/sas_expander.c          |   14 +++--
 drivers/scsi/qla2xxx/qla_init.c             |    3 -
 drivers/scsi/qla2xxx/qla_isr.c              |    1 -
 drivers/staging/quatech_usb2/quatech_usb2.c |    9 ++-
 drivers/usb/class/cdc-acm.c                 |    3 +
 drivers/usb/core/devio.c                    |   27 +++++++--
 drivers/usb/host/ehci-hub.c                 |    7 +-
 drivers/usb/host/fhci-sched.c               |   19 +++++-
 drivers/usb/host/xhci-mem.c                 |   22 ++++---
 drivers/usb/mon/mon_bin.c                   |    2 +-
 drivers/usb/musb/musb_core.c                |    1 -
 drivers/usb/serial/ftdi_sio.c               |   24 +++++++-
 drivers/usb/serial/ftdi_sio_ids.h           |    7 ++-
 drivers/usb/serial/pl2303.c                 |   27 +++++++-
 drivers/usb/serial/pl2303.h                 |    5 ++
 drivers/usb/serial/qcserial.c               |    1 +
 drivers/usb/storage/transport.c             |   34 ++++++-----
 drivers/video/carminefb.c                   |    6 +-
 drivers/watchdog/mtx-1_wdt.c                |    5 +-
 fs/9p/v9fs.c                                |   43 +++++++++++---
 fs/cifs/cifssmb.c                           |    3 +-
 fs/eventpoll.c                              |   25 ++++++--
 fs/lockd/clntproc.c                         |    8 ++-
 fs/nfsd/nfs4proc.c                          |    2 +-
 fs/nfsd/nfs4state.c                         |    2 +
 fs/nfsd/nfs4xdr.c                           |   12 ++++
 fs/nfsd/state.h                             |    6 --
 fs/proc/kcore.c                             |    2 +-
 fs/splice.c                                 |    3 +-
 include/linux/jiffies.h                     |    2 +-
 include/linux/sunrpc/sched.h                |    4 +-
 include/net/scm.h                           |    5 +-
 kernel/kmod.c                               |    4 +-
 kernel/time.c                               |    2 +-
 kernel/trace/trace.c                        |    4 +-
 lib/kobject_uevent.c                        |    2 +-
 mm/mmap.c                                   |   20 ++++--
 net/9p/client.c                             |   13 +++--
 net/atm/br2684.c                            |    7 +-
 net/bluetooth/l2cap.c                       |    3 +-
 net/bluetooth/rfcomm/sock.c                 |    1 +
 net/core/dev.c                              |    2 +-
 net/core/scm.c                              |   10 ++-
 net/core/skbuff.c                           |   14 ++++-
 net/ipv6/ip6_output.c                       |    2 +-
 net/sched/sch_api.c                         |   14 ++--
 net/sunrpc/clnt.c                           |    3 +
 net/sunrpc/sched.c                          |    1 +
 net/wireless/nl80211.c                      |    9 ++-
 net/wireless/reg.c                          |    1 +
 net/x25/af_x25.c                            |    3 +-
 sound/pci/hda/patch_cirrus.c                |    2 +-
 sound/pci/hda/patch_realtek.c               |    6 ++-
 sound/soc/codecs/ak4535.c                   |   10 ++--
 sound/soc/codecs/ak4642.c                   |   22 ++++----
 sound/soc/soc-jack.c                        |    2 +-
 101 files changed, 588 insertions(+), 360 deletions(-)
