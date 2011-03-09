Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873Ab1CIRlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:41:40 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:8739 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932843Ab1CIRlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:41:37 -0500
X-IronPort-AV: E=Sophos;i="4.62,291,1297054800"; 
   d="scan'208";a="139432592"
From: Ian Campbell <ian.campbell@citrix.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 03/14] xen: events: simplify comment
Date: Wed,  9 Mar 2011 17:41:15 +0000
Message-Id: <1299692486-28634-3-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
References: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 09 Mar 2011 17:41:36.0477 (UTC) FILETIME=[3CF110D0:01CBDE81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is never valid assume any particular relationship between a Xen
PIRQ number and and Linux IRQ number so there is no need to hedge when
saying so.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 drivers/xen/events.c |   10 +++-------
 include/xen/events.h |    4 +---
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 2ce95a6..a9c154d 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -583,13 +583,9 @@ int xen_allocate_pirq(unsigned gsi, int shareable, char *name)
 	return xen_map_pirq_gsi(gsi, gsi, shareable, name);
 }
 
-/* xen_map_pirq_gsi might allocate irqs from the top down, as a
- * consequence don't assume that the irq number returned has a low value
- * or can be used as a pirq number unless you know otherwise.
- *
- * One notable exception is when xen_map_pirq_gsi is called passing an
- * hardware gsi as argument, in that case the irq number returned
- * matches the gsi number passed as second argument.
+/*
+ * Do not make any assumptions regarding the relationship between the
+ * IRQ number returned here and the Xen pirq argument.
  *
  * Note: We don't assign an event channel until the irq actually started
  * up.  Return an existing irq if we've already got one for the gsi.
diff --git a/include/xen/events.h b/include/xen/events.h
index 962da2c..f6fed94 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -68,9 +68,7 @@ int xen_set_callback_via(uint64_t via);
 void xen_evtchn_do_upcall(struct pt_regs *regs);
 void xen_hvm_evtchn_do_upcall(void);
 
-/* Allocate an irq for a physical interrupt, given a gsi.  "Legacy"
- * GSIs are identity mapped; others are dynamically allocated as
- * usual. */
+/* Allocate an irq for a physical interrupt, given a gsi. */
 int xen_allocate_pirq(unsigned gsi, int shareable, char *name);
 int xen_map_pirq_gsi(unsigned pirq, unsigned gsi, int shareable, char *name);
 
-- 
1.5.6.5

