Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab1BBAyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:54:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:54182 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675Ab1BBAou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028561"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: kaneshige.kenji@jp.fujitsu.com, ak@linux.intel.com,
        suresh.b.siddha@intel.com, chrisw@sous-sol.org,
        indou.takao@jp.fujitsu.com, hpa@linux.intel.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [92/139] x86, vt-d: Fix the vt-d fault handling irq migration in the x2apic mode
Message-Id: <20110202004450.1045D3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

commit 086e8ced65d9bcc4a8e8f1cd39b09640f2883f90 upstream.

In x2apic mode, we need to set the upper address register of the fault
handling interrupt register of the vt-d hardware. Without this
irq migration of the vt-d fault handling interrupt is broken.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <1291225233.2648.39.camel@sbsiddha-MOBL3>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Tested-by: Takao Indoh <indou.takao@jp.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/apic/io_apic.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6.35.y/arch/x86/kernel/apic/io_apic.c
@@ -3626,6 +3626,7 @@ static int dmar_msi_set_affinity(unsigne
 	msg.data |= MSI_DATA_VECTOR(cfg->vector);
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
+	msg.address_hi = MSI_ADDR_BASE_HI | MSI_ADDR_EXT_DEST_ID(dest);
 
 	dmar_msi_write(irq, &msg);
 
