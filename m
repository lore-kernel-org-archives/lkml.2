Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab0LASWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:22:17 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:40578 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab0LASWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:22:16 -0500
X-IronPort-AV: E=Sophos;i="4.59,284,1288569600"; 
   d="scan'208";a="3140251"
Date: Wed, 1 Dec 2010 18:22:09 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: linux-kernel@vger.kernel.org
CC: xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: [PATCH 0/5] Xen PV on HVM fixes
Message-ID: <alpine.DEB.2.00.1012011442280.14723@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch series is a collection of fixes for Xen PV on HVM.

The first two patches fix two pirq remapping problems with MSIs, they
have been sent to the list few times already for comments.
The three following patches are new and fix save/restore bugs.

Stefano Stabellini (5):
      xen: use PHYSDEVOP_get_free_pirq to implement find_unbound_pirq
      xen: fix MSI setup and teardown for PV on HVM guests
      xen: resume the pv console for hvm guests too
      xen: fix save/restore for PV on HVM guests with pirq remapping
      xen: unplug the emulated devices at resume time

 arch/x86/pci/xen.c                 |   27 +++++++---
 arch/x86/xen/platform-pci-unplug.c |    2 +-
 arch/x86/xen/suspend.c             |    1 +
 arch/x86/xen/xen-ops.h             |    2 +-
 drivers/xen/events.c               |  105 +++++++++++++++++++++++++-----------
 drivers/xen/manage.c               |    1 +
 include/xen/events.h               |    7 ++-
 include/xen/interface/physdev.h    |   10 ++++
 8 files changed, 114 insertions(+), 41 deletions(-)

A branch with these fixes based on 2.6.37-rc4 is available here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.37-rc4-pvhvm-fixes

Cheers,

Stefano
