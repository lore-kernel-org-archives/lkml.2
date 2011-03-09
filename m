Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853Ab1CIRlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:41:37 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:8739 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932470Ab1CIRle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:41:34 -0500
X-IronPort-AV: E=Sophos;i="4.62,291,1297054800"; 
   d="scan'208";a="139432557"
From: Ian Campbell <ian.campbell@citrix.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 01/14] xen: events: separate two unrelated halves of if condition
Date: Wed,  9 Mar 2011 17:41:13 +0000
Message-Id: <1299692486-28634-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
References: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 09 Mar 2011 17:41:33.0243 (UTC) FILETIME=[3B0398B0:01CBDE81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clarifies which bit the comment applies to.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 drivers/xen/events.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 6befe62..684b095 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1143,10 +1143,14 @@ static int rebind_irq_to_cpu(unsigned irq, unsigned tcpu)
 	struct evtchn_bind_vcpu bind_vcpu;
 	int evtchn = evtchn_from_irq(irq);
 
-	/* events delivered via platform PCI interrupts are always
-	 * routed to vcpu 0 */
-	if (!VALID_EVTCHN(evtchn) ||
-		(xen_hvm_domain() && !xen_have_vector_callback))
+	if (!VALID_EVTCHN(evtchn))
+		return -1;
+
+	/*
+	 * Events delivered via platform PCI interrupts are always
+	 * routed to vcpu 0 and hence cannot be rebound.
+	 */
+	if (xen_hvm_domain() && !xen_have_vector_callback)
 		return -1;
 
 	/* Send future instances of this interrupt to other vcpu. */
-- 
1.5.6.5

