Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367Ab0EXSZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 14:25:13 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:24383 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758252Ab0EXSYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 14:24:14 -0400
X-IronPort-AV: E=Sophos;i="4.53,292,1272859200"; 
   d="scan'208";a="98432037"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Don Dutile <ddutile@redhat.com>,
       Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 09/11] __setup_vector_irq: handle NULL chip_data
Date: Mon, 24 May 2010 19:27:35 +0100
Message-Id: <1274725657-1149-9-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <alpine.DEB.2.00.1005241615300.25605@kaball-desktop>
References: <alpine.DEB.2.00.1005241615300.25605@kaball-desktop>
X-OriginalArrivalTime: 24 May 2010 18:24:13.0941 (UTC) FILETIME=[4FED5A50:01CAFB6E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.5.4.3

