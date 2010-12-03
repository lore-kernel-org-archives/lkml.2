Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab0LCJyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 04:54:11 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:6835 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755853Ab0LCJyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 04:54:10 -0500
X-IronPort-AV: E=Sophos;i="4.59,292,1288584000"; 
   d="scan'208";a="125178592"
From: Ian Campbell <ian.campbell@citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: xen-devel@lists.xensource.com, Vincent Caron <vcaron@bearstech.com>,
        linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH] xen: disable ACPI NUMA for PV guests
Date: Fri,  3 Dec 2010 09:54:03 +0000
Message-Id: <1291370043-3075-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1291369764.5514.15168.camel@zakaz.uk.xensource.com>
References: <1291369764.5514.15168.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 03 Dec 2010 09:54:08.0606 (UTC) FILETIME=[077397E0:01CB92D0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen does not currently expose PV-NUMA information to PV
guests. Therefore disable NUMA for the time being to prevent the
kernel picking up on an host-level NUMA information which it might
come across in the firmware.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 arch/x86/xen/enlighten.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index fbb35cd..7cdf2f3 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1195,6 +1195,10 @@ asmlinkage void __init xen_start_kernel(void)
 
 	xen_smp_init();
 
+#ifdef CONFIG_ACPI_NUMA
+	acpi_numa = -1;
+#endif
+
 	pgd = (pgd_t *)xen_start_info->pt_base;
 
 	__supported_pte_mask |= _PAGE_IOMAP;
-- 
1.5.6.5

