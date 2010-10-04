Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab0JDL2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 07:28:01 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:14830 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab0JDL17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 07:27:59 -0400
X-IronPort-AV: E=Sophos;i="4.57,278,1283731200"; 
   d="scan'208";a="2173475"
Date: Mon, 4 Oct 2010 12:27:29 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: [PATCH v2 00/10] xen: initial domain support
Message-ID: <alpine.DEB.2.00.1009301536300.2864@kaball-desktop>
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


Changes compared to v1:

- the last three patches that added Xen mtrr support have been removed;

- a new patch to mask the cpu mtrr feature from the cpuid on Xen has
been added instead.


This series depends on two other patch series not yet applied but
already sent to the list for comments a little while back:

Konrad's "Xen PCI frontend driver" series
http://lkml.org/lkml/2010/8/4/374

my "PV on HVM: receive interrupts as xen events" series
http://lkml.org/lkml/2010/8/30/170


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
      xen: use vcpu_ops to setup cpu masks
      xen: introduce XEN_DOM0 as a silent option
      xen: mask the MTRR feature from the cpuid

 arch/x86/pci/xen.c                |  199 +++++++++++++++++++++++++++++++++----
 arch/x86/xen/Kconfig              |    5 +
 arch/x86/xen/enlighten.c          |    2 +
 arch/x86/xen/mmu.c                |   47 ++++++++-
 arch/x86/xen/setup.c              |   46 ++++++++-
 arch/x86/xen/smp.c                |    8 ++-
 drivers/char/hvc_xen.c            |   98 ++++++++++++------
 drivers/xen/events.c              |   73 +++++++++++++-
 drivers/xen/xenbus/xenbus_probe.c |   29 +++++-
 include/xen/events.h              |    5 +
 include/xen/interface/memory.h    |   28 +++++
 include/xen/interface/physdev.h   |   10 ++
 12 files changed, 489 insertions(+), 61 deletions(-)


A git tree with this and the other two series on top of Linux 2.6.36-rc1
is available here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.36-rc1-initial-domain-v2

Cheers,

Stefano Stabellini

