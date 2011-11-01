Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab1KAJRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 05:17:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab1KAJRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 05:17:47 -0400
Date: Tue, 1 Nov 2011 17:19:39 +0800
From: Dave Young <dyoung@redhat.com>
To: kexec@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: vgoyal@redhat.com, horms@verge.net.au, luyu@redhat.com,
        dwmw2@infradead.org
Subject: [PATCH retry] intel-iommu:make identity_map default for crash dump
Message-ID: <20111101091939.GA8985@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kdump kernel sometimes will get DMAR faults which
is caused by random in-flight dma from 1st kernel

Here make the identity_mapping as default for this case

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 drivers/iommu/intel-iommu.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

--- linux-2.6.orig/drivers/iommu/intel-iommu.c	2011-11-01 13:06:18.667505962 +0800
+++ linux-2.6/drivers/iommu/intel-iommu.c	2011-11-01 17:07:50.789137864 +0800
@@ -40,6 +40,7 @@
 #include <linux/tboot.h>
 #include <linux/dmi.h>
 #include <linux/pci-ats.h>
+#include <linux/crash_dump.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
 
@@ -2488,7 +2489,7 @@ static int __init init_dmars(void)
 		}
 	}
 
-	if (iommu_pass_through)
+	if (iommu_pass_through || is_kdump_kernel())
 		iommu_identity_mapping |= IDENTMAP_ALL;
 
 #ifdef CONFIG_INTEL_IOMMU_BROKEN_GFX_WA
