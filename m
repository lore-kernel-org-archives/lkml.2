Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab0KSVpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:45:15 -0500
Received: from kroah.org ([198.145.64.141]:51656 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757145Ab0KSVpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:45:13 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:44:09 2010
Message-Id: <20101119214240.084142225@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:42:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/45] 2.6.32.26-stable review
In-Reply-To: <20101119214439.GA26350@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.32.26 release.
There are @num@ patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Monday, November 22, 2010, 12:00:00 UTC
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.26-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                            |    2 +-
 arch/powerpc/kernel/ppc970-pmu.c    |    2 +
 arch/x86/include/asm/cpufeature.h   |    2 +-
 arch/x86/include/asm/io.h           |    1 +
 arch/x86/include/asm/kvm_host.h     |   24 -------------------
 arch/x86/include/asm/smp.h          |    9 +++++-
 arch/x86/kernel/apic/io_apic.c      |    2 +
 arch/x86/kernel/cpu/mtrr/cleanup.c  |    2 +-
 arch/x86/kernel/crash_dump_64.c     |    3 +-
 arch/x86/kernel/olpc.c              |    5 +++-
 arch/x86/kernel/reboot.c            |    2 +-
 arch/x86/kernel/smp.c               |   15 +++++++----
 arch/x86/kvm/paging_tmpl.h          |   29 +++++++++++++++++++++-
 arch/x86/kvm/svm.c                  |   44 +++++++++++++++++++---------------
 arch/x86/kvm/vmx.c                  |   28 ++++++++++------------
 arch/x86/kvm/x86.c                  |    2 +-
 arch/x86/xen/enlighten.c            |    2 +-
 arch/x86/xen/smp.c                  |    6 ++--
 drivers/bluetooth/hci_ldisc.c       |    7 +++++
 drivers/char/pcmcia/synclink_cs.c   |    2 +
 drivers/misc/sgi-xp/xpc_uv.c        |   17 +++++++++++++
 drivers/net/wireless/p54/eeprom.c   |    4 ++-
 drivers/net/wireless/p54/p54usb.c   |   15 +++++++++++-
 drivers/scsi/gdth.c                 |    8 ++++++
 drivers/scsi/libsas/sas_ata.c       |    1 +
 drivers/scsi/scsi_lib.c             |    3 +-
 drivers/scsi/scsi_sysfs.c           |    3 +-
 drivers/scsi/sd.c                   |   15 ++++++++----
 drivers/staging/usbip/usbip_event.c |   16 ++----------
 drivers/staging/usbip/vhci_hcd.c    |    2 +
 drivers/usb/core/hcd-pci.c          |    4 ++-
 drivers/usb/core/hub.c              |    9 ++++--
 drivers/usb/core/message.c          |   14 +++++-----
 drivers/usb/gadget/atmel_usba_udc.c |    3 ++
 drivers/usb/host/ohci-hcd.c         |    9 ++++++-
 drivers/usb/host/ohci-pci.c         |   18 ++++++++++++++
 drivers/usb/host/ohci.h             |    1 +
 drivers/usb/host/pci-quirks.c       |   18 ++++++++-----
 drivers/usb/musb/blackfin.c         |    4 ++-
 drivers/usb/serial/cp210x.c         |    2 +
 drivers/usb/serial/ftdi_sio.c       |   35 +++++++++++++++++++++++++++-
 drivers/usb/serial/ftdi_sio_ids.h   |   39 ++++++++++++++++++++++++++++++-
 drivers/usb/serial/opticon.c        |    6 ++--
 drivers/usb/serial/option.c         |   23 ++++++++++++++++--
 fs/pipe.c                           |    2 +-
 kernel/futex.c                      |   31 ++++++++++++------------
 kernel/sched.c                      |    7 ++---
 mm/vmalloc.c                        |    9 +++++++
 48 files changed, 358 insertions(+), 149 deletions(-)

