Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab0HZXak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 19:30:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:58074 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614Ab0HZXaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 19:30:35 -0400
Date: Thu, 26 Aug 2010 23:30:01 GMT
From: tip-bot for Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        konrad.wilk@oracle.com, fujita.tomonori@lab.ntt.co.jp,
        djwong@us.ibm.com, muli@il.ibm.com, jdmason@kudzu.us,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, djwong@us.ibm.com,
        fujita.tomonori@lab.ntt.co.jp, muli@il.ibm.com, jdmason@kudzu.us,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1282845485-8991-8-git-send-email-konrad.wilk@oracle.com>
References: <1282845485-8991-8-git-send-email-konrad.wilk@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/iommu] x86, calgary: Make Calgary IOMMU use IOMMU_INIT_* macros.
Message-ID: <tip-d2aa232f3d0b5a3e22f91b736fe68eddcf0d5ea3@git.kernel.org>
Git-Commit-ID: d2aa232f3d0b5a3e22f91b736fe68eddcf0d5ea3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 26 Aug 2010 23:30:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d2aa232f3d0b5a3e22f91b736fe68eddcf0d5ea3
Gitweb:     http://git.kernel.org/tip/d2aa232f3d0b5a3e22f91b736fe68eddcf0d5ea3
Author:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
AuthorDate: Thu, 26 Aug 2010 13:58:02 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 26 Aug 2010 15:14:15 -0700

x86, calgary: Make Calgary IOMMU use IOMMU_INIT_* macros.

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
LKML-Reference: <1282845485-8991-8-git-send-email-konrad.wilk@oracle.com>
CC: Muli Ben-Yehuda <muli@il.ibm.com>
CC: "Jon D. Mason" <jdmason@kudzu.us>
CC: "Darrick J. Wong" <djwong@us.ibm.com>
CC: Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
