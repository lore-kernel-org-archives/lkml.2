Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab0KSWER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:04:17 -0500
Received: from kroah.org ([198.145.64.141]:52884 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758012Ab0KSWEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:04:11 -0500
Date: Fri, 19 Nov 2010 14:03:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/66] 2.6.36.1-stable review
Message-ID: <20101119220309.GA15562@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.36.1 release.
There are 66 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Monday, November 22, 2010, 12:00:00 UTC
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.36.1-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                                         |    2 +-
 arch/arm/include/asm/kgdb.h                      |    5 ++-
 arch/arm/kernel/kgdb.c                           |    2 +-
 arch/arm/mach-cns3xxx/include/mach/debug-macro.S |    2 +-
 arch/powerpc/kernel/ppc970-pmu.c                 |    2 +
 arch/x86/include/asm/cpufeature.h                |    2 +-
 arch/x86/include/asm/io.h                        |    1 +
 arch/x86/include/asm/mrst.h                      |    2 +-
 arch/x86/include/asm/smp.h                       |    9 ++++-
 arch/x86/kernel/apic/io_apic.c                   |    2 +
 arch/x86/kernel/cpu/mtrr/cleanup.c               |    2 +-
 arch/x86/kernel/cpu/perf_event_amd.c             |    4 +-
 arch/x86/kernel/crash_dump_64.c                  |    3 +-
 arch/x86/kernel/olpc.c                           |    5 ++-
 arch/x86/kernel/reboot.c                         |    2 +-
 arch/x86/kernel/smp.c                            |   15 +++++---
 arch/x86/kernel/traps.c                          |    1 +
 arch/x86/kernel/vm86_32.c                        |   10 ++++-
 arch/x86/kvm/svm.c                               |   37 +++++++++++++++++++-
 arch/x86/kvm/x86.c                               |    4 +-
 arch/x86/xen/enlighten.c                         |    2 +-
 arch/x86/xen/smp.c                               |    6 ++--
 drivers/ata/ahci.h                               |    1 +
 drivers/ata/libahci.c                            |   18 ++++++++--
 drivers/bluetooth/hci_ldisc.c                    |    7 ++++
 drivers/char/pcmcia/synclink_cs.c                |    2 +
 drivers/idle/intel_idle.c                        |    2 +-
 drivers/misc/sgi-xp/xpc_uv.c                     |   17 +++++++++
 drivers/net/wireless/p54/eeprom.c                |    4 ++-
 drivers/net/wireless/p54/p54usb.c                |   15 ++++++++-
 drivers/platform/x86/asus-laptop.c               |    6 ++--
 drivers/scsi/gdth.c                              |    8 ++++
 drivers/scsi/libsas/sas_ata.c                    |    1 +
 drivers/scsi/pmcraid.h                           |    1 -
 drivers/scsi/qla4xxx/ql4_nx.c                    |    1 +
 drivers/scsi/scsi_lib.c                          |    3 +-
 drivers/scsi/scsi_sysfs.c                        |    3 +-
 drivers/scsi/sd.c                                |   15 +++++---
 drivers/staging/phison/phison.c                  |    2 +-
 drivers/staging/usbip/usbip_event.c              |   16 ++-------
 drivers/staging/usbip/vhci_hcd.c                 |    2 +
 drivers/usb/core/hcd-pci.c                       |    4 ++-
 drivers/usb/core/hub.c                           |    9 +++--
 drivers/usb/core/message.c                       |   14 ++++----
 drivers/usb/gadget/atmel_usba_udc.c              |    3 ++
 drivers/usb/gadget/composite.c                   |    3 +-
 drivers/usb/gadget/f_acm.c                       |    2 +-
 drivers/usb/gadget/g_ffs.c                       |    4 +-
 drivers/usb/gadget/multi.c                       |    4 +-
 drivers/usb/host/ohci-hcd.c                      |    9 ++++-
 drivers/usb/host/ohci-pci.c                      |   18 ++++++++++
 drivers/usb/host/ohci.h                          |    1 +
 drivers/usb/host/pci-quirks.c                    |   18 ++++++----
 drivers/usb/host/r8a66597.h                      |    2 +-
 drivers/usb/musb/blackfin.c                      |    7 +++-
 drivers/usb/musb/davinci.c                       |    2 +
 drivers/usb/musb/musb_core.c                     |    4 --
 drivers/usb/musb/omap2430.c                      |    1 +
 drivers/usb/musb/tusb6010.c                      |    4 ++
 drivers/usb/serial/cp210x.c                      |    2 +
 drivers/usb/serial/ftdi_sio.c                    |   39 +++++++++++++++++++---
 drivers/usb/serial/ftdi_sio_ids.h                |   39 +++++++++++++++++++++-
 drivers/usb/serial/mct_u232.c                    |    7 +++-
 drivers/usb/serial/opticon.c                     |    6 ++--
 drivers/usb/serial/option.c                      |   23 +++++++++++--
 drivers/usb/serial/visor.c                       |   11 +++++-
 fs/cifs/cifsproto.h                              |    3 +-
 fs/cifs/dir.c                                    |   12 +++----
 fs/cifs/file.c                                   |    4 +-
 fs/nfs/direct.c                                  |    2 +-
 fs/pipe.c                                        |    2 +-
 kernel/futex.c                                   |   31 +++++++++--------
 kernel/perf_event.c                              |    8 ++++-
 kernel/sched.c                                   |   13 ++-----
 mm/vmalloc.c                                     |    9 +++++
 net/bluetooth/l2cap.c                            |    4 +-
 net/netfilter/xt_SECMARK.c                       |    2 +-
 77 files changed, 420 insertions(+), 150 deletions(-)
