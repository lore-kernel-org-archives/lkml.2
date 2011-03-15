Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab1COMg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 08:36:27 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:57799 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429Ab1COMg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 08:36:26 -0400
X-IronPort-AV: E=Sophos;i="4.62,322,1297036800"; 
   d="scan'208";a="4795227"
Date: Tue, 15 Mar 2011 12:35:37 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [GIT PULL] Xen PV on HVM cleanups, fixes and improvements for
 2.6.39
Message-ID: <alpine.DEB.2.00.1103151214290.3382@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,
please pull this branch, based on Linux 2.6.38-rc6:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git for-linus

It contains several PV on HVM cleanups, refactoring and fixes,
especially in the area of suspend/resume.
It also enables the balloon driver, PV spinlocks and event channels for
IPI delivery when running as an HVM guest.


The list of changes with a diffstat follows:

Ian Campbell (11):
      xen: do not respond to unknown xenstore control requests
      xen: use new schedop interface for suspend
      xen: switch to new schedop hypercall by default.
      xen: suspend: use HYPERVISOR_suspend for PVHVM case instead of open coding
      xen: suspend: refactor cancellation flag into a structure
      xen: suspend: pass extra hypercall argument via suspend_info struct
      xen: suspend: add "arch" to pre/post suspend hooks
      xen: suspend: refactor non-arch specific pre/post suspend hooks
      xen: suspend: move arch specific pre/post suspend hooks into generic hooks
      xen: suspend: pull pre/post suspend hooks out into suspend_info
      xen: suspend: remove xen_hvm_suspend

Stefano Stabellini (6):
      xen: no need to delay xen_setup_shutdown_event for hvm guests anymore
      xen: do not use xen_info on HVM, set pv_info name to "Xen HVM"
      xen-blkfront: handle Xen major numbers other than XENVBD
      xen: make the ballon driver work for hvm domains
      xen: PV on HVM: support PV spinlocks and IPIs
      xen: fix compile issue if XEN is enabled but XEN_PVHVM is disabled

 arch/ia64/xen/suspend.c              |    9 +--
 arch/x86/include/asm/xen/hypercall.h |   15 +++-
 arch/x86/xen/enlighten.c             |    6 +-
 arch/x86/xen/smp.c                   |   38 +++++++++
 arch/x86/xen/suspend.c               |    8 +-
 arch/x86/xen/xen-ops.h               |    2 +
 drivers/block/xen-blkfront.c         |   79 ++++++++++++++++-
 drivers/xen/balloon.c                |   14 ++-
 drivers/xen/manage.c                 |  153 +++++++++++++++++++---------------
 drivers/xen/platform-pci.c           |    3 -
 include/xen/interface/io/blkif.h     |   21 +++++
 include/xen/interface/xen.h          |    4 +-
 include/xen/xen-ops.h                |    6 +-
 13 files changed, 257 insertions(+), 101 deletions(-)

Cheers,

Stefano
