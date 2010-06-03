Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab0FCNMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 09:12:24 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:30773 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab0FCNL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 09:11:29 -0400
X-IronPort-AV: E=Sophos;i="4.53,354,1272859200"; 
   d="scan'208";a="99908960"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: Stefano.Stabellini@eu.citrix.com, xen-devel@lists.xensource.com,
       jeremy@goop.org, ddutile@redhat.com, sheng@linux.intel.com,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 08/12] Fix possible NULL pointer dereference in print_IO_APIC
Date: Thu,  3 Jun 2010 14:10:41 +0100
Message-Id: <1275570645-27189-8-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-OriginalArrivalTime: 03 Jun 2010 13:11:29.0084 (UTC) FILETIME=[4754E7C0:01CB031E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Make sure chip_data is not NULL before accessing it (the VIRQ_TIMER
handler and virq handlers in general don't have any chip_data).

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/kernel/apic/io_apic.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index eb2789c..c64499c 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1732,6 +1732,8 @@ __apicdebuginit(void) print_IO_APIC(void)
 		struct irq_pin_list *entry;
 
 		cfg = desc->chip_data;
+		if (!cfg)
+			continue;
 		entry = cfg->irq_2_pin;
 		if (!entry)
 			continue;
-- 
1.7.0.4

