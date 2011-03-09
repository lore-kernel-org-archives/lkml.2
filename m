Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865Ab1CIRli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:41:38 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:8739 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932841Ab1CIRlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:41:35 -0500
X-IronPort-AV: E=Sophos;i="4.62,291,1297054800"; 
   d="scan'208";a="139432562"
From: Ian Campbell <ian.campbell@citrix.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 02/14] xen: events: fix xen_map_pirq_gsi error return
Date: Wed,  9 Mar 2011 17:41:14 +0000
Message-Id: <1299692486-28634-2-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
References: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 09 Mar 2011 17:41:34.0915 (UTC) FILETIME=[3C02B930:01CBDE81]
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

