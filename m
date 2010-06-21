Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab0FUQZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 12:25:23 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:18059 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758074Ab0FUQYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 12:24:15 -0400
X-IronPort-AV: E=Sophos;i="4.53,453,1272859200"; 
   d="scan'208";a="102450213"
From: stefano@stabellini.net
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Stefano.Stabellini@eu.citrix.com,
       sheng@linux.intel.com, ddutile@redhat.com, jeremy@goop.org,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 09/13] __setup_vector_irq: handle NULL chip_data
Date: Mon, 21 Jun 2010 17:14:03 +0100
Message-Id: <1277136847-13266-9-git-send-email-stefano@stabellini.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop>
References: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop>
X-OriginalArrivalTime: 21 Jun 2010 16:14:47.0442 (UTC) FILETIME=[DE4CA720:01CB115C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

the VIRQ_TIMER handler and virq handlers in general don't have any
chip_data.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/kernel/apic/io_apic.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index c64499c..4d3d391 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1269,6 +1269,8 @@ void __setup_vector_irq(int cpu)
 	/* Mark the inuse vectors */
 	for_each_irq_desc(irq, desc) {
 		cfg = desc->chip_data;
+		if (!cfg)
+			continue;
 
 		/*
 		 * If it is a legacy IRQ handled by the legacy PIC, this cpu
-- 
1.7.0.4

