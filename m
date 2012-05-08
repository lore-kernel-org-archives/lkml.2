Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab2EHHFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 03:05:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:26160 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab2EHHFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 03:05:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="141277184"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@kernel.org
Cc: joro@8bytes.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/3] irq_remap: fix compiler warning with !CONFIG_IRQ_REMAP
Date: Tue,  8 May 2012 00:08:52 -0700
Message-Id: <1336460934-23592-1-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <20120508035153.GA30652@gmail.com>
References: <20120508035153.GA30652@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the below compiler warning:
arch/x86/include/asm/irq_remapping.h:72:19: warning: ‘struct IO_APIC_route_entry’ declared inside parameter list [enabled by default]

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/irq_remapping.h |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index dcb0c72..5fb9bbb 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -22,11 +22,9 @@
 #ifndef __X86_IRQ_REMAPPING_H
 #define __X86_IRQ_REMAPPING_H
 
-#ifdef CONFIG_IRQ_REMAP
+#include <asm/io_apic.h>
 
-struct IO_APIC_route_entry;
-struct io_apic_irq_attr;
-struct pci_dev;
+#ifdef CONFIG_IRQ_REMAP
 
 extern int irq_remapping_enabled;
 
-- 
1.7.6.5

