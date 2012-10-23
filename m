Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399Ab2JWS0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 14:26:34 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47651 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933251Ab2JWSYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 14:24:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        stefano.stabellini@eu.citrix.com, Ian.Campbell@citrix.com,
        mukesh.rathor@oracle.com
Subject: [PATCH V5] PVH patches for v3.8.
Date: Tue, 23 Oct 2012 14:12:01 -0400
Message-Id: <1351015931-16991-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog [since v4]
 - Mukesh addressed the reviewer's concerns.
 - Took Mukesh's patches and redid the changelogs.
 - Added Ack-ed as appropiate.
 - Fixed PVHVM 32-bit bootup issues.
 - Did some various cleanups, split some patches up.

The big change is that I've made the xen_remove_from_physmap structure
be of the same size and offset on 32 and 64 bit builds. Currently PVH 
only runs with 64-bit guests, but in the future it could run with 32-bit.
This change will eliminate having to add a compat layer to deal with
32-bit hypercalls.

Besides that the patches boot on an normal hypervisor - in
dom0 (32 or 64bit), PV domU (32 or 64) and PVHVM domU (32 or 64).
I don't have the PVH hypervisor patches so I could not address the
change to xen_remove_from_physmap but I hope Mukesh can do that.

The patches are also located at:
 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/pvh.v5


 arch/x86/include/asm/xen/interface.h |   11 ++-
 arch/x86/include/asm/xen/page.h      |    3 +
 arch/x86/xen/Kconfig                 |   10 ++
 arch/x86/xen/enlighten.c             |   78 ++++++++++++----
 arch/x86/xen/irq.c                   |    5 +-
 arch/x86/xen/mmu.c                   |  162 ++++++++++++++++++++++++++++++++--
 arch/x86/xen/mmu.h                   |    2 +
 arch/x86/xen/p2m.c                   |    2 +-
 arch/x86/xen/setup.c                 |   58 +++++++++----
 arch/x86/xen/smp.c                   |   75 ++++++++++------
 arch/x86/xen/xen-head.S              |   11 ++-
 drivers/xen/balloon.c                |   15 ++--
 drivers/xen/cpu_hotplug.c            |    4 +-
 drivers/xen/events.c                 |    9 ++-
 drivers/xen/gntdev.c                 |    3 +-
 drivers/xen/grant-table.c            |   27 +++++-
 drivers/xen/privcmd.c                |   72 ++++++++++++++-
 drivers/xen/xenbus/xenbus_client.c   |    3 +-
 include/xen/interface/memory.h       |   29 ++++++-
 include/xen/interface/physdev.h      |   10 ++
 include/xen/xen-ops.h                |    5 +-
 21 files changed, 504 insertions(+), 90 deletions(-)

Konrad Rzeszutek Wilk (4):
      xen/pvh: Fix PVHVM 32-bit bootup problems.
      xen/hypercall: Make xen_remove_from_physmap the same on 64/32 builds.
      xen/smp: Move the common CPU init code a bit to prep for PVH patch.
      xen/e820: Coalesce the PVH release/populate logic in the generic case.

Mukesh Rathor (6):
      xen/pvh: Support ParaVirtualized Hardware extensions.
      xen/pvh: Extend vcpu_guest_context, p2m, event, and XenBus.
      xen/pvh: Implement MMU changes for PVH.
      xen/pvh: bootup and setup (E820) related changes.
      xen/pvh: balloon and grant changes.
      xen/pvh: /dev/xen/privcmd changes.

