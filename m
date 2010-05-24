Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382Ab0EXSZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 14:25:44 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:24383 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758185Ab0EXSYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 14:24:13 -0400
X-IronPort-AV: E=Sophos;i="4.53,292,1272859200"; 
   d="scan'208";a="98432032"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Don Dutile <ddutile@redhat.com>,
       Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 08/11] Fix possible NULL pointer dereference in print_IO_APIC
Date: Mon, 24 May 2010 19:27:34 +0100
Message-Id: <1274725657-1149-8-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <alpine.DEB.2.00.1005241615300.25605@kaball-desktop>
References: <alpine.DEB.2.00.1005241615300.25605@kaball-desktop>
X-OriginalArrivalTime: 24 May 2010 18:24:12.0441 (UTC) FILETIME=[4F087890:01CAFB6E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.5.4.3

