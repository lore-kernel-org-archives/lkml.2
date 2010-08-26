Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab0HZR7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:59:03 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19114 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab0HZR66 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 26 Aug 2010 13:58:58 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: hpa@zytor.com, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Muli Ben-Yehuda <muli@il.ibm.com>, "Jon D. Mason" <jdmason@kudzu.us>,
        "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 07/10] x86/calgary: Make Calgary IOMMU use IOMMU_INIT_* macros.
Date: Thu, 26 Aug 2010 13:58:02 -0400
Message-Id: <1282845485-8991-8-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1282845485-8991-1-git-send-email-konrad.wilk@oracle.com>
References: <1282845485-8991-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We utilize the IOMMU_INIT macros to create this dependency:

     [pci_xen_swiotlb_detect]
         |
     [pci_swiotlb_detect_override]
         |
     [pci_swiotlb_detect_4gb]
         |
      [detect_calgary]

Meaning that 'detect_calgary' is going to be called after
'pci_swiotlb_detect'.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Muli Ben-Yehuda <muli@il.ibm.com>
CC: "Jon D. Mason" <jdmason@kudzu.us>
CC: "Darrick J. Wong" <djwong@us.ibm.com>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-calgary_64.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 28c6b38..f56a117 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -47,6 +47,7 @@
 #include <asm/rio.h>
 #include <asm/bios_ebda.h>
 #include <asm/x86_init.h>
+#include <asm/iommu_table.h>
 
 #ifdef CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT
 int use_calgary __read_mostly = 1;
@@ -1595,3 +1596,5 @@ static int __init calgary_fixup_tce_spaces(void)
  * and before device_initcall.
  */
 rootfs_initcall(calgary_fixup_tce_spaces);
+
+IOMMU_INIT_POST(detect_calgary);
-- 
1.7.0.1

