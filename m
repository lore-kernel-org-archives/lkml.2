Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab1CJQKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:10:53 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:63084 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab1CJQIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 11:08:34 -0500
X-IronPort-AV: E=Sophos;i="4.62,296,1297054800"; 
   d="scan'208";a="139621098"
From: Ian Campbell <ian.campbell@citrix.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 02/14] xen: events: fix xen_map_pirq_gsi error return
Date: Thu, 10 Mar 2011 16:08:03 +0000
Message-Id: <1299773295-348-2-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299773279.17339.813.camel@zakaz.uk.xensource.com>
References: <1299773279.17339.813.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 10 Mar 2011 16:08:20.0557 (UTC) FILETIME=[5FED2FD0:01CBDF3D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix initial value of irq so that first goto out (if pirq or gsi
arguments are too large) actually returns an error.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 drivers/xen/events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 684b095..2ce95a6 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -596,7 +596,7 @@ int xen_allocate_pirq(unsigned gsi, int shareable, char *name)
  */
 int xen_map_pirq_gsi(unsigned pirq, unsigned gsi, int shareable, char *name)
 {
-	int irq = 0;
+	int irq = -1;
 	struct physdev_irq irq_op;
 
 	spin_lock(&irq_mapping_update_lock);
-- 
1.5.6.5

