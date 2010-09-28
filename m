Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab0I1MQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 08:16:51 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:60980 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab0I1MQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 08:16:50 -0400
X-IronPort-AV: E=Sophos;i="4.57,247,1283731200"; 
   d="scan'208";a="2073287"
Date: Tue, 28 Sep 2010 13:16:37 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: [PATCH 00/12] xen: initial domain support
Message-ID: <alpine.DEB.2.00.1009281217540.2864@kaball-desktop>
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
as you can see from the diffstat below we were able to reduce them
significantly. The only generic code modifications regard mtrr setups
(see the last two patches in the series).


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

Stefano Stabellini (2):
      xen: use vcpu_ops to setup cpu masks
      xen: introduce XEN_DOM0 as a silent option

Stephen Tweedie (3):
      xen: add support for the platform_ops hypercall
      x86/mtrr: Extend mtrr_if to include num_var_ranges
      xen/mtrr: Add mtrr_if support for Xen mtrr

 arch/x86/include/asm/xen/hypercall.h |    8 ++
 arch/x86/kernel/cpu/mtrr/Makefile    |    2 +-
 arch/x86/kernel/cpu/mtrr/amd.c       |    6 +
 arch/x86/kernel/cpu/mtrr/centaur.c   |    6 +
 arch/x86/kernel/cpu/mtrr/cyrix.c     |    6 +
 arch/x86/kernel/cpu/mtrr/generic.c   |    8 ++
 arch/x86/kernel/cpu/mtrr/main.c      |   20 +---
 arch/x86/kernel/cpu/mtrr/mtrr.h      |    8 ++
 arch/x86/kernel/cpu/mtrr/xen.c       |  110 +++++++++++++++++++
 arch/x86/pci/xen.c                   |  199 ++++++++++++++++++++++++++++++----
 arch/x86/xen/Kconfig                 |    5 +
 arch/x86/xen/enlighten.c             |    1 +
 arch/x86/xen/mmu.c                   |   47 ++++++++-
 arch/x86/xen/setup.c                 |   46 ++++++++-
 arch/x86/xen/smp.c                   |    8 ++-
 drivers/char/hvc_xen.c               |   98 +++++++++++------
 drivers/xen/events.c                 |   73 ++++++++++++-
 drivers/xen/xenbus/xenbus_probe.c    |   29 +++++-
 include/xen/events.h                 |    5 +
 include/xen/interface/memory.h       |   28 +++++
 include/xen/interface/physdev.h      |   10 ++
 include/xen/interface/platform.h     |   96 ++++++++++++++++
 22 files changed, 741 insertions(+), 78 deletions(-)


A git tree with this and the other two series on top of Linux 2.6.36-rc1
is available here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.36-rc1-initial-domain

Cheers,

Stefano Stabellini

