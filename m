Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760532Ab2FUWCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 18:02:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:57088 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760463Ab2FUWCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 18:02:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="168713930"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>, Ingo Molnar <mingo@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, gorcunov@openvz.org
Subject: [PATCH v2 0/3] -tip cleanups/fixes for x2apic cluster mode routing
Date: Thu, 21 Jun 2012 15:02:22 -0700
Message-Id: <1340316145-4431-1-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patches will reserve the vector only on the cpu's where
the interrupt will be routed to based on the specified affinity mask
(not on the complete x2apic cluster which is the current behavior).
And by default during boot, device bringup etc, only one cpu
is used for interrupt destination. All this will reduce the vector
pressure (specifically for the case of single/two socket systems where
there will be atmost one or two x2apic clusters per-socket) when
there are more interrupt sources than the number of x2apic clusters.

Changes from the previous version:

* cleaned up the apic driver's vector_allocation_domain() API.
* Minimize the vector usage during boot/device bringup.

Suresh Siddha (3):
  x86, apic: optimize cpu traversal in __assign_irq_vector() using
    domain membership
  x86, x2apic: limit the vector reservation to the user specified mask
  x86, x2apic: use multiple cluster members for the irq destination
    only with the explicit affinity

 arch/x86/include/asm/apic.h           |   15 ++++++-----
 arch/x86/kernel/apic/apic_noop.c      |    4 +-
 arch/x86/kernel/apic/io_apic.c        |   44 ++++++++++++++++----------------
 arch/x86/kernel/apic/x2apic_cluster.c |   26 +++++++++++++++---
 4 files changed, 53 insertions(+), 36 deletions(-)

-- 
1.7.6.5

