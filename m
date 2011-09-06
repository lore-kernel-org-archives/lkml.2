Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab1IFQdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 12:33:43 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:54196 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab1IFQdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 12:33:39 -0400
X-IronPort-AV: E=Sophos;i="4.68,339,1312171200"; 
   d="scan'208";a="161862817"
From: <stefano.stabellini@eu.citrix.com>
To: konrad.wilk@oracle.com
CC: linux-kernel@vger.kernel.org, Stefano.Stabellini@eu.citrix.com,
        xen-devel@lists.xensource.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH] xen: disable PV spinlocks on HVM
Date: Tue, 6 Sep 2011 17:41:47 +0100
Message-ID: <1315327307-392-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

PV spinlocks cannot possibly work with the current code because they are
enabled after pvops patching has already been done, and because PV
spinlocks use a different data structure than native spinlocks so we
cannot switch between them dynamically. A spinlock that has been taken
once by the native code (__ticket_spin_lock) cannot be taken by
__xen_spin_lock even after it has been released.

Reported-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/smp.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index e79dbb9..51339b4 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -522,7 +522,6 @@ static void __init xen_hvm_smp_prepare_cpus(unsigned int max_cpus)
 	WARN_ON(xen_smp_intr_init(0));
 
 	xen_init_lock_cpu(0);
-	xen_init_spinlocks();
 }
 
 static int __cpuinit xen_hvm_cpu_up(unsigned int cpu)
-- 
1.7.2.3

