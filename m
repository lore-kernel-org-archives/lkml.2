Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649Ab2DJMY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 08:24:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:33538 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782Ab2DJMYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 08:24:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="129136475"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, benh@kernel.crashing.org, grant.likely@secretlab.ca,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 2/2] irq_domain: fix formatting of chip data pointer in virq_debug_show()
Date: Tue, 10 Apr 2012 15:25:43 +0300
Message-Id: <1334060743-7901-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1334060743-7901-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1334060743-7901-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 32-bit machines reading the /sys/kernel/debug/irq_domain_mapping file
outputs following:

virq   hwirq    chip name        chip data           domain name
    9  0x00000  IO-APIC          0x        c175a0f8  none
   10  0x00000  IO-APIC          0x        c175a108  none
   11  0x00000  IO-APIC          0x        c175a118  none
...

which looks a bit funny. Fix that with filling the gap with zeroes instead
of spaces.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 kernel/irq/irqdomain.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 3601f3f..d350c72 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -666,7 +666,7 @@ static int virq_debug_show(struct seq_file *m, void *private)
 			seq_printf(m, "%-15s  ", p);
 
 			data = irq_desc_get_chip_data(desc);
-			seq_printf(m, "0x%16p  ", data);
+			seq_printf(m, "0x%016lx  ", (unsigned long)data);
 
 			if (desc->irq_data.domain && desc->irq_data.domain->of_node)
 				p = desc->irq_data.domain->of_node->full_name;
-- 
1.7.9.1

