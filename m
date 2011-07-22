Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab1GVDeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 23:34:10 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:46953 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab1GVDeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 23:34:09 -0400
Date: Thu, 21 Jul 2011 23:33:26 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: ijc@hellion.org.uk, jeremy@goop.org, yu.zhao@intel.com,
        jbeulich@novell.com, jeremy.fitzhardinge@citrix.com,
        dan.magenheimer@oracle.com, waldi@debian.org, joe@perches.com
Subject: [GIT PULL] (xen) stable/drivers for 3.1
Message-ID: <20110722033326.GC22901@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090201.4E28EF98.0033,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please pull:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/drivers

which has patches since git commit 56299378726d5f2ba8d3c8cbbd13cb280ba45e4f
Linus Torvalds (1):
    Linux 3.0-rc4

This pull contains the following components:
 - VGA text support. Since Xen is the first payload on the bootloader it gets the
   screen information - now with this patch we can copy it from the hypervisor
   and enjoy 80x25 old-school text output.
 - MODULE_ALIAS on backends so that udev will autoload them.
 - tmem driver to shuffle file-system and swap pages between guests as appropiate.
   Runtime it is disabled unless 'tmem' parameter is supplied.
 - self balloon driver to decrease memory in the guest and make the swap pages
   be shuffled by tmem to be compressed/shared/etc. Runtime wise it is disabled
   by default (use 'selfballooning' to enable it and make sure you have a swap disk).
 - pciback backend. It complements the xen pci front driver which together
   allow guests to have host's PCI devices.

The credit list and diff stat is as follow:

Bastian Blank (2):
      xen: Populate xenbus device attributes
      xen: Add module alias to autoload backend drivers

Dan Magenheimer (2):
      xen: prepare tmem shim to handle frontswap
      xen: tmem: self-ballooning and frontswap-selfshrinking

Ian Campbell (1):
      xen: rename pciback module to xen-pciback.

Jeremy Fitzhardinge (1):
      xen: allow enable use of VGA console on dom0

Joe Perches (1):
      xen: Add __attribute__((format(printf... where appropriate

Konrad Rzeszutek Wilk (11):
      xen/pciback: xen pci backend driver.
      xen/pciback: Cleanup the driver based on checkpatch warnings and errors.
      xen/pciback: Register the owner (domain) of the PCI device.
      xen/pciback: Disable MSI/MSI-X when reseting a device
      xen/pciback: Allocate IRQ handler for device that is shared with guest.
      xen/pciback: Fine-grain the spinlocks and fix BUG: scheduling while atomic cases.
      xen/pciback: Don't setup an fake IRQ handler for SR-IOV devices.
      xen/pciback: Print out the MSI/MSI-X (PIRQ) values
      xen/pciback: Drop two backends, squash and cleanup some code.
      xen/pciback: Remove the DEBUG option.
      xen/pciback: Have 'passthrough' option instead of XEN_PCIDEV_BACKEND_PASS and XEN_PCIDEV_BACKEND_VPCI

Zhao, Yu (1):
      xen/pciback: guest SR-IOV support for PV guest

 arch/x86/xen/Makefile                           |    2 +-
 arch/x86/xen/enlighten.c                        |    8 +
 arch/x86/xen/vga.c                              |   67 ++
 arch/x86/xen/xen-ops.h                          |   11 +
 drivers/block/xen-blkback/xenbus.c              |    2 +-
 drivers/xen/Kconfig                             |   46 +
 drivers/xen/Makefile                            |    4 +-
 drivers/xen/tmem.c                              |  170 +++-
 drivers/xen/xen-balloon.c                       |    2 +
 drivers/xen/xen-pciback/Makefile                |    7 +
 drivers/xen/xen-pciback/conf_space.c            |  438 +++++++
 drivers/xen/xen-pciback/conf_space.h            |  126 +++
 drivers/xen/xen-pciback/conf_space_capability.c |  207 ++++
 drivers/xen/xen-pciback/conf_space_header.c     |  386 +++++++
 drivers/xen/xen-pciback/conf_space_quirks.c     |  140 +++
 drivers/xen/xen-pciback/conf_space_quirks.h     |   33 +
 drivers/xen/xen-pciback/passthrough.c           |  194 ++++
 drivers/xen/xen-pciback/pci_stub.c              | 1376 +++++++++++++++++++++++
 drivers/xen/xen-pciback/pciback.h               |  183 +++
 drivers/xen/xen-pciback/pciback_ops.c           |  384 +++++++
 drivers/xen/xen-pciback/vpci.c                  |  259 +++++
 drivers/xen/xen-pciback/xenbus.c                |  749 ++++++++++++
 drivers/xen/xen-selfballoon.c                   |  485 ++++++++
 drivers/xen/xenbus/xenbus_probe.c               |   44 +-
 drivers/xen/xenbus/xenbus_probe.h               |    2 +
 drivers/xen/xenbus/xenbus_probe_backend.c       |    9 +-
 drivers/xen/xenbus/xenbus_probe_frontend.c      |    6 +-
 include/xen/balloon.h                           |   10 +
 include/xen/hvc-console.h                       |    4 +-
 include/xen/interface/xen.h                     |   39 +
 include/xen/tmem.h                              |    5 +
 include/xen/xenbus.h                            |    2 +
 32 files changed, 5346 insertions(+), 54 deletions(-)
