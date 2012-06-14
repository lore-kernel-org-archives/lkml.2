Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab2FNIiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:38:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60666 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab2FNIir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:38:47 -0400
Date: Thu, 14 Jun 2012 01:38:29 -0700
From: tip-bot for Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <tip-ed88bed881c9948c4035828c5d63f60c7b015f86@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@kernel.org, yinghai@kernel.org, joerg.roedel@amd.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        dan.carpenter@oracle.com
Reply-To: mingo@kernel.org, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, joerg.roedel@amd.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        dan.carpenter@oracle.com
In-Reply-To: <20120612162633.GA11077@elgon.mountain>
References: <20120612162633.GA11077@elgon.mountain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic/irq_remap: Silence a bogus pr_err()
Git-Commit-ID: ed88bed881c9948c4035828c5d63f60c7b015f86
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 14 Jun 2012 01:38:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ed88bed881c9948c4035828c5d63f60c7b015f86
Gitweb:     http://git.kernel.org/tip/ed88bed881c9948c4035828c5d63f60c7b015f86
Author:     Dan Carpenter <dan.carpenter@oracle.com>
AuthorDate: Tue, 12 Jun 2012 19:26:33 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Jun 2012 09:51:04 +0200

x86/apic/irq_remap: Silence a bogus pr_err()

There is an extra semicolon here so the pr_err() message is
printed when it is not intended.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: Alexander Gordeev <agordeev@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Link: http://lkml.kernel.org/r/20120612162633.GA11077@elgon.mountain
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/iommu/intel_irq_remapping.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
