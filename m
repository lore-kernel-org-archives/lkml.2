Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab2IIXRj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:17:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51488 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756374Ab2IIXRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:17:09 -0400
Message-Id: <20120909224150.641491654@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:41:50 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/95] 3.2.29-stable review
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.29 release.
There are 95 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Sep 11 23:00:00 UTC 2012.
Anything received after that time might be too late.

A combined patch relative to 3.2.28 will be posted as an additional
response to this, and the diffstat can be found below.

Note to submitters: the last mainline commit I scanned for cc fields
was e1d33a5c634bcf5f944034a2127c0026308c005c.  If your patch went into
mainline after this (approximately the last 2 weeks), please do not be
surprised that it is not here yet.  It should end up in the next
review, if applicable.

Ben.

-------------
 MAINTAINERS                                  |    2 +-
 Makefile                                     |    4 +-
 arch/alpha/include/asm/atomic.h              |    4 +-
 arch/alpha/include/asm/socket.h              |    2 +
 arch/arm/include/asm/pgtable.h               |    6 +-
 arch/arm/mm/tlb-v7.S                         |    6 +-
 arch/arm/vfp/vfpmodule.c                     |    2 +
 arch/x86/mm/hugetlbpage.c                    |   21 +-
 drivers/acpi/acpica/tbxface.c                |    1 +
 drivers/base/power/runtime.c                 |    5 +-
 drivers/block/cciss_scsi.c                   |   11 +-
 drivers/block/virtio_blk.c                   |   35 +-
 drivers/char/random.c                        |   21 +-
 drivers/firmware/dmi_scan.c                  |    3 +
 drivers/gpu/drm/i915/intel_display.c         |   11 -
 drivers/gpu/drm/i915/intel_dp.c              |   14 +-
 drivers/gpu/drm/nouveau/nvd0_display.c       |    2 +-
 drivers/gpu/drm/radeon/atombios.h            |  929 ++++++++++++++++++++++++--
 drivers/gpu/drm/radeon/radeon.h              |   15 -
 drivers/gpu/drm/radeon/radeon_atombios.c     |    2 +-
 drivers/gpu/drm/radeon/radeon_atpx_handler.c |   55 +-
 drivers/gpu/drm/radeon/radeon_bios.c         |  140 +++-
 drivers/gpu/drm/radeon/radeon_object.c       |    3 +-
 drivers/hid/hid-chicony.c                    |    1 +
 drivers/hid/hid-core.c                       |    2 +
 drivers/hid/hid-cypress.c                    |    2 +
 drivers/hid/hid-ids.h                        |    2 +
 drivers/infiniband/ulp/srp/ib_srp.c          |   87 ++-
 drivers/md/md.c                              |    9 +-
 drivers/media/dvb/siano/smsusb.c             |    2 +-
 drivers/media/video/gspca/spca506.c          |    2 +-
 drivers/misc/sgi-xp/xpc_uv.c                 |   84 ++-
 drivers/net/netconsole.c                     |    1 -
 drivers/net/wireless/ath/ath9k/recv.c        |    2 +-
 drivers/net/wireless/p54/p54usb.c            |    2 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c   |    2 +-
 drivers/pci/pci-driver.c                     |    7 +
 drivers/platform/x86/asus-nb-wmi.c           |    4 +
 drivers/rapidio/devices/tsi721.c             |   12 +-
 drivers/rtc/rtc-rs5c348.c                    |    7 +-
 drivers/staging/speakup/main.c               |    2 +-
 drivers/staging/vt6656/main_usb.c            |    2 +-
 drivers/staging/winbond/wbusb.c              |    2 +-
 drivers/target/target_core_transport.c       |    4 +-
 drivers/tty/serial/pmac_zilog.c              |   12 +-
 drivers/usb/class/cdc-acm.c                  |    3 +-
 drivers/usb/gadget/u_ether.c                 |    6 +
 drivers/usb/host/pci-quirks.c                |    7 +
 drivers/usb/host/pci-quirks.h                |    1 +
 drivers/usb/host/xhci-pci.c                  |   10 +
 drivers/usb/host/xhci.c                      |    8 +-
 drivers/usb/host/xhci.h                      |    1 +
 drivers/usb/misc/emi62.c                     |    2 +-
 drivers/usb/serial/ftdi_sio.c                |    1 +
 drivers/usb/serial/ftdi_sio_ids.h            |    7 +
 drivers/usb/serial/mos7840.c                 |    9 +-
 drivers/usb/serial/option.c                  |  277 ++++----
 drivers/video/console/fbcon.c                |    9 +-
 fs/buffer.c                                  |   67 +-
 fs/compat.c                                  |   10 +-
 fs/ext4/super.c                              |    5 +
 fs/fuse/file.c                               |    2 +-
 fs/nfs/blocklayout/blocklayout.c             |    4 +-
 fs/nfs/blocklayout/extents.c                 |    2 +-
 fs/nfs/dir.c                                 |    4 +-
 fs/nfs/nfs3proc.c                            |    2 +-
 fs/nfs/nfs4filelayoutdev.c                   |    2 +-
 fs/nfs/nfs4proc.c                            |   57 +-
 fs/nfs/pnfs.c                                |   39 +-
 fs/nfs/pnfs.h                                |    2 +-
 fs/nfs/super.c                               |    2 +
 fs/nfs/write.c                               |   10 +-
 fs/open.c                                    |    7 +-
 fs/squashfs/super.c                          |    2 +-
 include/asm-generic/mutex-xchg.h             |   11 +-
 include/linux/usb.h                          |   21 +
 kernel/audit_tree.c                          |   11 +-
 kernel/sched.c                               |   34 +-
 mm/vmscan.c                                  |    6 +-
 net/bluetooth/hci_event.c                    |    8 +-
 net/bluetooth/l2cap_core.c                   |   15 +-
 net/dccp/ccid.h                              |    4 +-
 net/sunrpc/svc_xprt.c                        |   10 +-
 net/sunrpc/svcsock.c                         |    2 +-
 sound/pci/hda/hda_proc.c                     |    2 +-
 sound/pci/hda/patch_ca0132.c                 |    8 +
 sound/soc/codecs/wm9712.c                    |   19 +-
 87 files changed, 1697 insertions(+), 556 deletions(-)

-- 
Ben Hutchings
Time is nature's way of making sure that everything doesn't happen at once.

