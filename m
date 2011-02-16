Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab1BPRvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 12:51:09 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:34538 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab1BPRvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 12:51:08 -0500
X-IronPort-AV: E=Sophos;i="4.60,480,1291593600"; 
   d="scan'208";a="4363325"
Date: Wed, 16 Feb 2011 17:51:06 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: [PATCH 0/7] Xen PV on HVM fixes and improvements
Message-ID: <alpine.DEB.2.00.1102161739370.2826@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch series is a collection of fixes and improvements for Linux
running as Xen PV on HVM guest.
Most of the patches have already been sent to the list at least once,
some have already been acked.


The list of patches with diffstat follows:

Stefano Stabellini (7):
      xen: no need to delay xen_setup_shutdown_event for hvm guests anymore
      xen: do not use xen_info on HVM, set pv_info name to "Xen HVM"
      xen-blkfront: handle Xen major numbers other than XENVBD
      xen: make the ballon driver work for hvm domains
      xen: PV on HVM: support PV spinlocks
      xen: enable event channels to send and receive IPIs for PV on HVM guests
      xen: fix compile issue if XEN is enabled but XEN_PVHVM is disabled

 arch/x86/xen/enlighten.c         |    6 ++-
 arch/x86/xen/smp.c               |   42 ++++++++++++++++++++
 arch/x86/xen/suspend.c           |    2 +
 arch/x86/xen/xen-ops.h           |    2 +
 drivers/block/xen-blkfront.c     |   79 +++++++++++++++++++++++++++++++++++--
 drivers/xen/balloon.c            |   14 ++++--
 drivers/xen/manage.c             |   17 ++------
 drivers/xen/platform-pci.c       |    3 -
 include/xen/interface/io/blkif.h |   21 ++++++++++
 9 files changed, 158 insertions(+), 28 deletions(-)


A branch with these patches on 2.6.38-rc5 is available here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.38-rc5-pvhvm

Cheers,

Stefano

