Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab2FYUfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 16:35:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:33742 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091Ab2FYUfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 16:35:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="162462537"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, agordeev@redhat.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        gorcunov@openvz.org
Subject: [PATCH v3 0/3] -tip cleanups/fixes for x2apic cluster mode routing
Date: Mon, 25 Jun 2012 13:35:36 -0700
Message-Id: <1340656539-11342-1-git-send-email-suresh.b.siddha@intel.com>
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

Changes in v3:
* Fixed missing vsmp changes.

Changes in v2:

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
 arch/x86/kernel/vsmp_64.c             |    4 +-
 5 files changed, 55 insertions(+), 38 deletions(-)

-- 
1.7.6.5

