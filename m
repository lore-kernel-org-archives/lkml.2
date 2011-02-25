Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab1BYRLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 12:11:09 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:5473 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468Ab1BYRK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 12:10:56 -0500
X-IronPort-AV: E=Sophos;i="4.62,226,1297036800"; 
   d="scan'208";a="4512678"
Date: Fri, 25 Feb 2011 17:11:33 +0000
From: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: [PATCH v2 0/6] Xen PV on HVM fixes and improvements
Message-ID: <alpine.DEB.2.00.1102251651570.19277@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch series is a collection of fixes and improvements for Linux
running as Xen PV on HVM guest.
Changes to the previous version:

- patch 5 and 6 have been squashed together;

- xen_hvm_spinlock_init has been merged into xen_hvm_smp_prepare_cpus.


The list of patches with diffstat follows:

Stefano Stabellini (6):
      xen: no need to delay xen_setup_shutdown_event for hvm guests anymore
      xen: do not use xen_info on HVM, set pv_info name to "Xen HVM"
      xen-blkfront: handle Xen major numbers other than XENVBD
      xen: make the ballon driver work for hvm domains
      xen: PV on HVM: support PV spinlocks and IPIs
      xen: fix compile issue if XEN is enabled but XEN_PVHVM is disabled

 arch/x86/xen/enlighten.c         |    6 ++-
 arch/x86/xen/smp.c               |   38 ++++++++++++++++++
 arch/x86/xen/suspend.c           |    2 +
 arch/x86/xen/xen-ops.h           |    2 +
 drivers/block/xen-blkfront.c     |   79 +++++++++++++++++++++++++++++++++++--
 drivers/xen/balloon.c            |   14 ++++--
 drivers/xen/manage.c             |   17 ++------
 drivers/xen/platform-pci.c       |    3 -
 include/xen/interface/io/blkif.h |   21 ++++++++++
 9 files changed, 154 insertions(+), 28 deletions(-)

A branch with these patches on 2.6.38-rc6 is available here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.38-rc6-pvhvm

Cheers,

Stefano
