Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab2AJV5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 16:57:05 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43067 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756874Ab2AJV5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 16:57:00 -0500
X-Sasl-enc: +1LxSeNR2ruw2g98K12rHtMLkIfmo3Jz/OaEMsCW5SI3 1326232619
Date: Tue, 10 Jan 2012 13:56:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [00/49] 3.2.1-stable review
Message-ID: <20120110215609.GA22505@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.1 release.
There are 49 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Thursday, January 12, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.2.1-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Documentation/HOWTO                               |    4 +-
 Documentation/development-process/5.Posting       |    8 +-
 Documentation/usb/usbmon.txt                      |   14 +++--
 MAINTAINERS                                       |    2 +-
 Makefile                                          |    4 +-
 arch/powerpc/include/asm/time.h                   |    2 +
 arch/powerpc/kernel/irq.c                         |   15 ++---
 arch/powerpc/kernel/time.c                        |    9 +++
 arch/powerpc/platforms/pseries/hvCall_inst.c      |    4 +-
 arch/powerpc/platforms/pseries/lpar.c             |    2 +
 drivers/base/firmware_class.c                     |   14 ++--
 drivers/bcma/bcma_private.h                       |    3 +
 drivers/bcma/host_pci.c                           |   37 ++++++++++
 drivers/bcma/main.c                               |   16 ++++
 drivers/hv/vmbus_drv.c                            |   17 ++++-
 drivers/infiniband/core/uverbs_cmd.c              |   21 +++++-
 drivers/infiniband/hw/qib/qib_iba6120.c           |    4 +-
 drivers/infiniband/hw/qib/qib_iba7220.c           |    4 +-
 drivers/infiniband/hw/qib/qib_iba7322.c           |    6 +-
 drivers/net/bonding/bond_main.c                   |    9 ++-
 drivers/net/usb/asix.c                            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    2 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |   73 ++++++++-----------
 drivers/net/wireless/libertas/cfg.c               |   10 ++-
 drivers/net/wireless/rt2x00/rt2800usb.c           |    2 +-
 drivers/net/wireless/wl12xx/boot.c                |   14 ++++
 drivers/net/wireless/wl12xx/cmd.c                 |   22 ++++++
 drivers/net/wireless/wl12xx/testmode.c            |    1 +
 drivers/tty/serial/atmel_serial.c                 |    5 +-
 drivers/usb/class/cdc-acm.c                       |   16 ++++-
 drivers/usb/core/devio.c                          |    3 +-
 drivers/usb/core/hcd.c                            |    5 +-
 drivers/usb/core/quirks.c                         |    5 +-
 drivers/usb/host/ehci-pxa168.c                    |    2 +-
 drivers/usb/host/ehci-q.c                         |    2 +-
 drivers/usb/host/uhci-q.c                         |    2 +-
 drivers/usb/host/whci/qset.c                      |    4 +-
 drivers/usb/host/xhci-ring.c                      |    4 +-
 drivers/usb/host/xhci.c                           |    4 +-
 drivers/usb/host/xhci.h                           |    1 -
 drivers/usb/misc/isight_firmware.c                |    6 +-
 drivers/usb/musb/musb_core.c                      |    2 -
 drivers/usb/serial/cp210x.c                       |    1 +
 drivers/usb/serial/omninet.c                      |    2 +-
 drivers/usb/serial/option.c                       |    5 ++
 drivers/usb/storage/usb.c                         |    1 +
 drivers/video/offb.c                              |   52 ++++++--------
 fs/Kconfig                                        |    2 +
 fs/exofs/Kconfig                                  |   11 ---
 fs/exofs/Kconfig.ore                              |   12 +++
 fs/exofs/ore.c                                    |    8 +-
 fs/exofs/ore_raid.c                               |   78 +++++++++++++++++----
 fs/ext3/inode.c                                   |   24 ++++++-
 fs/reiserfs/super.c                               |   27 ++++---
 fs/udf/file.c                                     |    6 +-
 fs/udf/inode.c                                    |   21 +++++-
 fs/xfs/xfs_acl.c                                  |    2 +-
 include/linux/usb.h                               |    1 +
 include/linux/usb/ch9.h                           |   20 +++++-
 kernel/cgroup.c                                   |    6 +-
 net/ipv4/igmp.c                                   |    2 +
 tools/perf/util/trace-event-parse.c               |    2 +
 63 files changed, 466 insertions(+), 201 deletions(-)
