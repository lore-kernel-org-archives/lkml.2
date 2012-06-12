Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab2FLQ1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 12:27:01 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:22636 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab2FLQ1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 12:27:00 -0400
Date: Tue, 12 Jun 2012 19:26:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch -next] irq_remap: silence a bogus pr_err()
Message-ID: <20120612162633.GA11077@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an extra semicolon here so the pr_err() message is printed when
it is not intended.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index dafbad0..853902a 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -938,7 +938,7 @@ intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 
 	err = apic->cpu_mask_to_apicid_and(cfg->domain, mask, &dest);
 	if (err) {
-		if (assign_irq_vector(irq, cfg, data->affinity));
+		if (assign_irq_vector(irq, cfg, data->affinity))
 			pr_err("Failed to recover vector for irq %d\n", irq);
 		return err;
 	}
