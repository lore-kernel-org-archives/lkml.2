Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab0KVTUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 14:20:10 -0500
Received: from kroah.org ([198.145.64.141]:55829 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938Ab0KVTUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 14:20:07 -0500
Date: Mon, 22 Nov 2010 11:15:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.26
Message-ID: <20101122191547.GC4340@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.26 kernel.

All users of the 2.6.32 kernel series must upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                            |    2 -
 arch/powerpc/kernel/ppc970-pmu.c    |    2 +
 arch/x86/include/asm/cpufeature.h   |    2 -
 arch/x86/include/asm/io.h           |    1 
 arch/x86/include/asm/kvm_host.h     |   24 -------------------
 arch/x86/include/asm/smp.h          |    9 +++++--
 arch/x86/kernel/apic/io_apic.c      |    2 +
 arch/x86/kernel/cpu/mtrr/cleanup.c  |    2 -
 arch/x86/kernel/crash_dump_64.c     |    3 +-
 arch/x86/kernel/olpc.c              |    5 +++-
 arch/x86/kernel/reboot.c            |    2 -
 arch/x86/kernel/smp.c               |   15 +++++++-----
 arch/x86/kvm/paging_tmpl.h          |   29 ++++++++++++++++++++++-
 arch/x86/kvm/svm.c                  |   44 ++++++++++++++++++++----------------
 arch/x86/kvm/vmx.c                  |   28 ++++++++++------------
 arch/x86/kvm/x86.c                  |    2 -
 arch/x86/xen/enlighten.c            |    2 -
 arch/x86/xen/smp.c                  |    6 ++--
 drivers/bluetooth/hci_ldisc.c       |    7 +++++
 drivers/char/pcmcia/synclink_cs.c   |    2 +
 drivers/misc/sgi-xp/xpc_uv.c        |   17 +++++++++++++
 drivers/net/wireless/p54/eeprom.c   |    4 ++-
 drivers/net/wireless/p54/p54usb.c   |   15 +++++++++++-
 drivers/scsi/gdth.c                 |    8 ++++++
 drivers/scsi/libsas/sas_ata.c       |    1 
 drivers/scsi/scsi_lib.c             |    3 +-
 drivers/scsi/scsi_sysfs.c           |    3 +-
 drivers/scsi/sd.c                   |   15 ++++++++----
 drivers/staging/usbip/usbip_event.c |   16 ++-----------
 drivers/staging/usbip/vhci_hcd.c    |    2 +
 drivers/usb/core/hub.c              |    9 ++++---
 drivers/usb/core/message.c          |   14 +++++------
 drivers/usb/gadget/atmel_usba_udc.c |    3 ++
 drivers/usb/musb/blackfin.c         |    4 ++-
 drivers/usb/serial/cp210x.c         |    2 +
 drivers/usb/serial/ftdi_sio.c       |   35 +++++++++++++++++++++++++++-
 drivers/usb/serial/ftdi_sio_ids.h   |   39 +++++++++++++++++++++++++++++++
 drivers/usb/serial/opticon.c        |    6 ++--
 drivers/usb/serial/option.c         |   23 ++++++++++++++++--
 fs/pipe.c                           |    2 -
 kernel/futex.c                      |   31 +++++++++++++------------
 kernel/sched.c                      |    7 ++---
 mm/vmalloc.c                        |    9 +++++++
 43 files changed, 317 insertions(+), 140 deletions(-)

Alan Cox (1):
      bluetooth: Fix missing NULL check

Alan Stern (2):
      USB: disable endpoints after unbinding interfaces, not before
      USB: accept some invalid ep0-maxpacket values

Alok Kataria (1):
      x86, kexec: Make sure to stop all CPUs before exiting the kernel

Alon Ziv (1):
      USB: opticon: Fix long-standing bugs in opticon driver

Anders Larsen (1):
      USB: cp210x: Add WAGO 750-923 Service Cable device ID

Andre Przywara (1):
      x86, cpu: Fix renamed, not-yet-shipping AMD CPUID feature bit

Andreas Herrmann (1):
      x86, mtrr: Assume SYS_CFG[Tom2ForceMemTypeWB] exists on all future AMD CPUs

Avi Kivity (2):
      KVM: VMX: Fix host GDT.LIMIT corruption
      KVM: Fix fs/gs reload oops with invalid ldt

Christian Lamparter (2):
      p54usb: fix off-by-one on !CONFIG_PM
      p54usb: add five more USBIDs

Christof Schmitt (1):
      Fix race when removing SCSI devices

Cliff Wickman (2):
      mm, x86: Saving vmcore with non-lazy freeing of vmas
      x86, kdump: Change copy_oldmem_page() to use cached addressing

DJ Delorie (1):
      USB: cp210x: Add Renesas RX-Stick device ID

Dan Carpenter (1):
      gdth: integer overflow in ioctl

Daniel Suchy (1):
      USB: ftdi_sio: new VID/PIDs for various Papouch devices

Darren Hart (1):
      futex: Fix errors in nested key ref-counting

David Milburn (1):
      libsas: fix NCQ mixing with non-NCQ

Greg Kroah-Hartman (2):
      USB: ftdi_sio: add device ids for ScienceScope
      Linux 2.6.32.26

Jean-Christophe PLAGNIOL-VILLARD (1):
      USB: atmel_usba_udc: force vbus_pin at -EINVAL when gpio_request failled

Joerg Roedel (2):
      KVM: SVM: Fix wrong intercept masks on 32 bit
      KVM: SVM: Adjust tsc_offset only if tsc_unstable

Julia Lawall (1):
      drivers/net/wireless/p54/eeprom.c: Return -ENOMEM on memory allocation failure

Mathieu Desnoyers (1):
      sched: Fix string comparison in /proc/sched_features

Mauro Carvalho Chehab (1):
      USB: option: Add more ZTE modem USB id's

Max Vozeler (2):
      staging: usbip: Notify usb core of port status changes
      staging: usbip: Process event flags without delay

Michael Reed (1):
      sd name space exhaustion causes system hang

Mike Christie (1):
      Fix regressions in scsi_internal_device_block

Nicolas Kaiser (1):
      pipe: fix failure to return error code on ->confirm()

Paul Fox (1):
      x86, olpc: Don't retry EC commands forever

Paul Mackerras (1):
      powerpc/perf: Fix sampling enable for PPC970

Rainer Keller (1):
      USB: add PID for FTDI based OpenDCC hardware

Rich Mattes (1):
      USB: ftdi_sio: Add PID for accesio products

Robin Holt (1):
      sgi-xp: incoming XPC channel messages can come in after the channel's partition structures have been torn down

Sergei Shtylyov (1):
      usb: musb: blackfin: call gpio_free() on error path in musb_platform_init()

Suresh Siddha (1):
      x86, intr-remap: Set redirection hint in the IRTE

Vasiliy Kulikov (1):
      pcmcia: synclink_cs: fix information leak to userland

Xiao Guangrong (2):
      KVM: MMU: fix direct sps access corrupted
      KVM: MMU: fix conflict access permissions in direct sp

Zachary Amsden (2):
      KVM: x86: Fix SVM VMCB reset
      KVM: x86: Move TSC reset out of vmcb_init

