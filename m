Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889Ab1CIRln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:41:43 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:8739 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932876Ab1CIRlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:41:40 -0500
X-IronPort-AV: E=Sophos;i="4.62,291,1297054800"; 
   d="scan'208";a="139432605"
From: Ian Campbell <ian.campbell@citrix.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 05/14] xen: events: rename restore_cpu_pirqs -> restore_pirqs
Date: Wed,  9 Mar 2011 17:41:17 +0000
Message-Id: <1299692486-28634-5-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
References: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 09 Mar 2011 17:41:39.0774 (UTC) FILETIME=[3EE825E0:01CBDE81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is nothing per-cpu about this function.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 drivers/xen/events.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index d52defd..e828456 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1213,7 +1213,7 @@ static int retrigger_dynirq(struct irq_data *data)
 	return ret;
 }
 
-static void restore_cpu_pirqs(void)
+static void restore_pirqs(void)
 {
 	int pirq, rc, irq, gsi;
 	struct physdev_map_pirq map_irq;
@@ -1375,7 +1375,7 @@ void xen_irq_resume(void)
 		restore_cpu_ipis(cpu);
 	}
 
-	restore_cpu_pirqs();
+	restore_pirqs();
 }
 
 static struct irq_chip xen_dynamic_chip __read_mostly = {
-- 
1.5.6.5

