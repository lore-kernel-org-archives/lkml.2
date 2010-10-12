Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab0JLQlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 12:41:47 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:6405 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932492Ab0JLQlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 12:41:46 -0400
X-IronPort-AV: E=Sophos;i="4.57,320,1283731200"; 
   d="scan'208";a="2307060"
Date: Tue, 12 Oct 2010 17:41:38 +0100
From: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: [PATCH v3 00/10] xen: initial domain support
Message-ID: <alpine.DEB.2.00.1010121043030.2422@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this series implements the basic support needed to boot Linux as initial
domain on Xen: the target is not to add full featured dom0 support in
the kernel but to be able to boot Linux on Xen on native.
We tried to minimize the impact to generic x86 code and interfaces and
since v2 of the series we were able to eliminate all the modifications
to non-Xen specific code.


New changes in v2:
- remove the last three patches that added Xen mtrr support;

- add a new patch to mask the cpu mtrr feature from the cpuid on Xen.


New changes in v3:
- compile all the initial domain functions in arch/x86/pci/xen.c only if
CONFIG_XEN_DOM0 is defined;

- compile the msi functions in drivers/xen/events.c only if
CONFIG_PCI_MSI is defined;

- move the xen_setup_pirqs declaration to
arch/x86/include/asm/xen/pci.h.


This series depends on two other patch series not yet applied but
already sent to the list for comments a little while back:

Konrad's "Xen PCI frontend driver" series
http://lkml.org/lkml/2010/10/12/207

my "PV on HVM: receive interrupts as xen events" series
http://lkml.org/lkml/2010/10/12/246



The list of patches with a diffstat follows:

Ian Campbell (1):
      xen: use host E820 map for dom0

Jeremy Fitzhardinge (3):
      xen: remap GSIs as pirqs when running as initial domain
      xen: map a dummy page for local apic and ioapic in xen_set_fixmap
      xen: make hvc_xen console work for dom0.

Juan Quintela (2):
      xen: Initialize xenbus for dom0.
      xen: add the direct mapping area for ISA bus access

Qing He (1):
      xen: remap MSIs into pirqs when running as initial domain

Stefano Stabellini (3):
      xen: introduce XEN_DOM0 as a silent option
      xen: use vcpu_ops to setup cpu masks
      xen: mask the MTRR feature from the cpuid

 arch/x86/include/asm/xen/pci.h    |    7 ++
 arch/x86/pci/xen.c                |  187 +++++++++++++++++++++++++++++++++----
 arch/x86/xen/Kconfig              |    5 +
 arch/x86/xen/enlighten.c          |    2 +
 arch/x86/xen/mmu.c                |   47 +++++++++-
 arch/x86/xen/setup.c              |   46 +++++++++-
 arch/x86/xen/smp.c                |    8 ++-
 drivers/char/hvc_xen.c            |   98 +++++++++++++-------
 drivers/xen/events.c              |   75 +++++++++++++++-
 drivers/xen/xenbus/xenbus_probe.c |   29 ++++++-
 include/xen/events.h              |    5 +
 include/xen/interface/memory.h    |   28 ++++++
 include/xen/interface/physdev.h   |   10 ++
 13 files changed, 487 insertions(+), 60 deletions(-)


A git tree with this and the other two series on top of Linux 2.6.36-rc6
is available here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.36-rc6-initial-domain-v3

Cheers,

Stefano Stabellini
