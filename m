Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023Ab2DSVJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:09:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41537 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932943Ab2DSVJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:09:02 -0400
Date: Thu, 19 Apr 2012 14:06:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/59] 3.0.29-stable review
Message-ID: <20120419210623.GA12156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.29 release.
There are 59 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Apr 21 21:06:09 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.29-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                                   |    4 +-
 arch/arm/mm/proc-v7.S                      |   12 +++
 arch/ia64/include/asm/futex.h              |    9 +-
 arch/sparc/kernel/ds.c                     |    2 +-
 arch/sparc/kernel/rtrap_64.S               |    7 --
 drivers/acpi/acpica/acobject.h             |    1 +
 drivers/acpi/acpica/dsargs.c               |    2 +-
 drivers/acpi/acpica/excreate.c             |    6 ++
 drivers/block/cciss_scsi.c                 |    3 +-
 drivers/bluetooth/ath3k.c                  |    4 +
 drivers/bluetooth/btusb.c                  |    2 +
 drivers/bluetooth/hci_ldisc.c              |    4 +-
 drivers/dma/Kconfig                        |   13 ++-
 drivers/dma/pch_dma.c                      |  137 ++++++++++++++++++++--------
 drivers/gpu/drm/i915/intel_ringbuffer.c    |    2 +-
 drivers/gpu/drm/radeon/radeon_connectors.c |    4 +-
 drivers/gpu/drm/radeon/radeon_i2c.c        |    4 +
 drivers/gpu/drm/radeon/radeon_irq_kms.c    |    6 ++
 drivers/md/bitmap.c                        |    2 +
 drivers/misc/pch_phub.c                    |   62 +++++++++----
 drivers/net/wireless/ath/ath9k/calib.c     |    5 +-
 drivers/net/wireless/rtlwifi/pci.c         |    7 +-
 drivers/rtc/rtc-pl031.c                    |    3 +-
 drivers/staging/iio/magnetometer/hmc5843.c |    4 +-
 drivers/tty/serial/8250_pci.c              |   10 ++
 drivers/tty/serial/altera_uart.c           |    4 +-
 drivers/tty/serial/amba-pl011.c            |   15 ++-
 drivers/tty/serial/pch_uart.c              |    3 +-
 drivers/usb/core/message.c                 |   11 ++-
 drivers/usb/gadget/Kconfig                 |    7 +-
 drivers/usb/gadget/pch_udc.c               |   97 ++++++++++++++++++--
 drivers/usb/host/pci-quirks.c              |   10 +-
 drivers/usb/host/xhci-ext-caps.h           |    5 +-
 drivers/usb/host/xhci-mem.c                |    9 +-
 drivers/usb/host/xhci-pci.c                |    2 +
 drivers/usb/host/xhci-ring.c               |    2 +-
 drivers/usb/host/xhci.c                    |    9 +-
 drivers/usb/host/xhci.h                    |    4 +
 drivers/usb/serial/option.c                |    1 +
 drivers/usb/serial/pl2303.c                |    2 +-
 drivers/usb/serial/sierra.c                |    1 +
 drivers/usb/serial/usb-serial.c            |    8 ++
 drivers/video/uvesafb.c                    |   11 ++-
 include/net/bluetooth/hci.h                |    1 +
 kernel/futex.c                             |   36 +++-----
 kernel/futex_compat.c                      |   36 +++-----
 kernel/time/tick-sched.c                   |    4 +-
 mm/hugetlb.c                               |    2 +
 net/bluetooth/hci_core.c                   |    7 ++
 security/commoncap.c                       |    6 ++
 tools/perf/util/hist.c                     |   12 +++
 51 files changed, 440 insertions(+), 180 deletions(-)

