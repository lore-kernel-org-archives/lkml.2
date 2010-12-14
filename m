Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871Ab0LNBQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 20:16:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:46585 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758790Ab0LNBQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 20:16:40 -0500
Date: Tue, 14 Dec 2010 01:16:20 GMT
From: tip-bot for Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        kaneshige.kenji@jp.fujitsu.com, indou.takao@jp.fujitsu.com,
        chrisw@sous-sol.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kaneshige.kenji@jp.fujitsu.com, indou.takao@jp.fujitsu.com,
        chrisw@sous-sol.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1291225233.2648.39.camel@sbsiddha-MOBL3>
References: <1291225233.2648.39.camel@sbsiddha-MOBL3>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, vt-d: Fix the vt-d fault handling irq migration in the x2apic mode
Message-ID: <tip-086e8ced65d9bcc4a8e8f1cd39b09640f2883f90@git.kernel.org>
Git-Commit-ID: 086e8ced65d9bcc4a8e8f1cd39b09640f2883f90
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 14 Dec 2010 01:16:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  086e8ced65d9bcc4a8e8f1cd39b09640f2883f90
Gitweb:     http://git.kernel.org/tip/086e8ced65d9bcc4a8e8f1cd39b09640f2883f90
Author:     Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
AuthorDate: Wed, 1 Dec 2010 09:40:32 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 13 Dec 2010 16:52:52 -0800

x86, vt-d: Fix the vt-d fault handling irq migration in the x2apic mode

In x2apic mode, we need to set the upper address register of the fault
handling interrupt register of the vt-d hardware. Without this
irq migration of the vt-d fault handling interrupt is broken.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
LKML-Reference: <1291225233.2648.39.camel@sbsiddha-MOBL3>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: stable@kernel.org [v2.6.32+]
Acked-by: Chris Wright <chrisw@sous-sol.org>
Tested-by: Takao Indoh <indou.takao@jp.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/apic/io_apic.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 226060e..fadcd74 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3412,6 +3412,7 @@ dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	msg.data |= MSI_DATA_VECTOR(cfg->vector);
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
+	msg.address_hi = MSI_ADDR_BASE_HI | MSI_ADDR_EXT_DEST_ID(dest);
 
 	dmar_msi_write(irq, &msg);
 
