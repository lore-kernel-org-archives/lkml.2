Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab1IIV7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 17:59:07 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:62159 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1IIV7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 17:59:05 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-160.messagelabs.com!1315605544!34091174!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] pci-iommu_table.c: quiet sparse noise about plain integer as NULL pointer
Date: Fri, 9 Sep 2011 14:58:52 -0700
User-Agent: KMail/1.9.9
CC: <x86@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <joe@perches.com>, <joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109091458.53253.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x->depend is an initcall_t, NULL should be used to zero it, not 0.  This
quiets the following sparse noise:

warning: Using plain integer as NULL pointer

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Joe Perches <joe@perches.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>


---

diff --git a/arch/x86/kernel/pci-iommu_table.c b/arch/x86/kernel/pci-iommu_table.c
index 35ccf75..75c3c40 100644
--- a/arch/x86/kernel/pci-iommu_table.c
+++ b/arch/x86/kernel/pci-iommu_table.c
@@ -59,7 +59,7 @@ void __init check_iommu_entries(struct iommu_table_entry *start,
 			printk(KERN_ERR "CYCLIC DEPENDENCY FOUND! %pS depends on %pS and vice-versa. BREAKING IT.\n",
 			       p->detect, q->detect);
 			/* Heavy handed way..*/
-			x->depend = 0;
+			x->depend = NULL;
 		}
 	}
 
