Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742Ab1E0Bcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 21:32:31 -0400
Received: from relay2.sgi.com ([192.48.179.30]:36041 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758636Ab1E0BcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 21:32:25 -0400
Message-Id: <20110527013222.261166889@gulag1.americas.sgi.com>
References: <20110527013221.231071058@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 26 May 2011 20:32:28 -0500
From: Mike Travis <travis@sgi.com>
To: David Woodhouse <dwmw2@infradead.org>, Chris Wright <chrisw@sous-sol.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Mike Habeck <habeck@sgi.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        stable@kernel.org, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dimitri Sivanich <sivanich@sgi.com>
Subject: [PATCH 7/7] Intel pci: Indicate 64-bit IOMMU passthrough available
Content-Disposition: inline; filename=indicate-iommu-fixed.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Prior to these IOMMU patches, the passthrough option
    could not be used because it would cause the kernel to
    panic.  Provide an indication that a kernel is capable
    of handling passthrough mode through the introduction
    of a specific variable name.  This allows automatic
    configuration utilities to set the "iommu=pt" kernel
    cmdline option safely.

Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Dimitri Sivanich <sivanich@sgi.com>
---
 drivers/pci/intel-iommu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- linux.orig/drivers/pci/intel-iommu.c
+++ linux/drivers/pci/intel-iommu.c
@@ -390,6 +390,9 @@ static int dmar_map_gfx = 1;
 static int dmar_forcedac;
 static int intel_iommu_strict;
 
+/* specifically named variable that indicates "iommu=pt" is available */
+static int __initdata intel_iommu_64bit_pt;
+
 #define DUMMY_DEVICE_DOMAIN_INFO ((struct device_domain_info *)(-1))
 static DEFINE_SPINLOCK(device_domain_lock);
 static LIST_HEAD(device_domain_list);
@@ -425,6 +428,7 @@ static int __init intel_iommu_setup(char
 		while (*str == ',')
 			str++;
 	}
+	intel_iommu_64bit_pt = 1;
 	return 0;
 }
 __setup("intel_iommu=", intel_iommu_setup);

-- 
