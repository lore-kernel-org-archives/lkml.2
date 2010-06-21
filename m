Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125Ab0FUQYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 12:24:19 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:18059 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758106Ab0FUQYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 12:24:10 -0400
X-IronPort-AV: E=Sophos;i="4.53,453,1272859200"; 
   d="scan'208";a="102450207"
From: stefano@stabellini.net
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Stefano.Stabellini@eu.citrix.com,
       sheng@linux.intel.com, ddutile@redhat.com, jeremy@goop.org,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 08/13] Fix possible NULL pointer dereference in print_IO_APIC
Date: Mon, 21 Jun 2010 17:14:02 +0100
Message-Id: <1277136847-13266-8-git-send-email-stefano@stabellini.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop>
References: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop>
X-OriginalArrivalTime: 21 Jun 2010 16:14:43.0755 (UTC) FILETIME=[DC1A0FB0:01CB115C]
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

