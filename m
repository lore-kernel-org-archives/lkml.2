Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab2AJV53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 16:57:29 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59823 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756573Ab2AJV47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 16:56:59 -0500
X-Sasl-enc: ok3MdTuD6uU6X1gdZOFlKp/UWDt/8sM3UnHQSVYu95rL 1326232618
Date: Tue, 10 Jan 2012 13:50:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [00/42] 3.1.9-stable review
Message-ID: <20120110215031.GA19398@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

**************************************************************************
* Note, this is most likely the LAST 3.1.y kernel released.  Please move *
* now to the 3.2 kernel series.  You have been warned.                   *
**************************************************************************

This is the start of the stable review cycle for the 3.1.9 release.

There are 42 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Thursday, January 12, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.1.9-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Documentation/HOWTO                          |    4 +-
 Documentation/development-process/5.Posting  |    8 ++--
 Documentation/usb/usbmon.txt                 |   14 +++--
 MAINTAINERS                                  |    2 +-
 Makefile                                     |    4 +-
 arch/powerpc/include/asm/time.h              |    2 +
 arch/powerpc/kernel/irq.c                    |   15 ++---
 arch/powerpc/kernel/time.c                   |    9 +++
 arch/powerpc/platforms/pseries/hvCall_inst.c |    4 +-
 arch/powerpc/platforms/pseries/lpar.c        |    2 +
 drivers/base/firmware_class.c                |   14 +++---
 drivers/infiniband/hw/qib/qib_iba6120.c      |    4 +-
 drivers/infiniband/hw/qib/qib_iba7220.c      |    4 +-
 drivers/infiniband/hw/qib/qib_iba7322.c      |    6 ++-
 drivers/net/bonding/bond_main.c              |    9 +++-
 drivers/net/usb/asix.c                       |    6 ++-
 drivers/net/wireless/rt2x00/rt2800usb.c      |    2 +-
 drivers/net/wireless/wl12xx/boot.c           |   14 +++++
 drivers/net/wireless/wl12xx/cmd.c            |   22 ++++++++
 drivers/net/wireless/wl12xx/testmode.c       |    1 +
 drivers/scsi/mpt2sas/mpt2sas_scsih.c         |    1 +
 drivers/tty/serial/atmel_serial.c            |    5 +-
 drivers/usb/class/cdc-acm.c                  |   16 +++++-
 drivers/usb/core/hcd.c                       |    5 +-
 drivers/usb/core/quirks.c                    |    5 ++-
 drivers/usb/host/ehci-q.c                    |    2 +-
 drivers/usb/host/ohci-hcd.c                  |   15 ++---
 drivers/usb/host/ohci-pci.c                  |   26 ---------
 drivers/usb/host/ohci.h                      |    1 -
 drivers/usb/host/pci-quirks.c                |   50 ++++++++----------
 drivers/usb/host/uhci-q.c                    |    2 +-
 drivers/usb/host/whci/qset.c                 |    4 +-
 drivers/usb/host/xhci-ring.c                 |    4 +-
 drivers/usb/host/xhci.c                      |    4 +-
 drivers/usb/host/xhci.h                      |    1 -
 drivers/usb/misc/isight_firmware.c           |    6 ++-
 drivers/usb/musb/musb_core.c                 |    2 -
 drivers/usb/serial/cp210x.c                  |    1 +
 drivers/usb/serial/omninet.c                 |    2 +-
 drivers/usb/serial/option.c                  |   10 ++++
 drivers/usb/storage/usb.c                    |    1 +
 drivers/video/offb.c                         |   52 ++++++++----------
 fs/ext3/inode.c                              |   24 +++++++-
 fs/reiserfs/super.c                          |   27 ++++++----
 fs/udf/file.c                                |    6 +-
 fs/udf/inode.c                               |   21 ++++++-
 fs/xfs/xfs_acl.c                             |    4 +-
 include/linux/usb.h                          |    1 +
 include/linux/usb/ch9.h                      |   20 +++++++-
 kernel/cgroup.c                              |    6 +-
 kernel/cpu.c                                 |   74 ++++++++++++++++++++++++++
 net/ipv4/igmp.c                              |    2 +
 tools/perf/util/trace-event-parse.c          |    2 +
 53 files changed, 368 insertions(+), 180 deletions(-)
