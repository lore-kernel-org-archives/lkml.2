Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab1JUMaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 08:30:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab1JUMaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 08:30:17 -0400
Date: Fri, 21 Oct 2011 20:31:54 +0800
From: Dave Young <dyoung@redhat.com>
To: kexec@lists.infradead.org, iommu@lists.linux-foundation.org,
        vgoyal@redhat.com, linux-kernel@vger.kernel.org, luyu@redhat.com
Subject: [PATCH] intel-iommu:make identity_map default for crash dump
Message-ID: <20111021123154.GA5821@darkstar.nay.redhat.com>
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

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c621c98..8ac3895 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -40,6 +40,7 @@
 #include <linux/tboot.h>
 #include <linux/dmi.h>
 #include <linux/pci-ats.h>
+#include <linux/crash_dump.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
 
@@ -2481,7 +2482,7 @@ static int __init init_dmars(void)
 		}
 	}
 
-	if (iommu_pass_through)
+	if (iommu_pass_through || is_kdump_kernel())
 		iommu_identity_mapping |= IDENTMAP_ALL;
 
 #ifdef CONFIG_DMAR_BROKEN_GFX_WA
-- 
1.7.4.4

