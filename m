Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab2DYPP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:15:29 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:29090 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab2DYPP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:15:28 -0400
X-IronPort-AV: E=Sophos;i="4.75,481,1330923600"; 
   d="scan'208";a="192014963"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: xen-devel@lists.xen.org
CC: konrad.wilk@oracle.com, Stefano.Stabellini@eu.citrix.com,
        tobias.geiger@vido.info, linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH] xen: use the pirq number to check the pirq_eoi_map
Date: Wed, 25 Apr 2012 16:11:38 +0100
Message-ID: <1335366698-19875-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In pirq_check_eoi_map use the pirq number rather than the Linux irq
number to check whether an eoi is needed in the pirq_eoi_map.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Tested-by: Tobias Geiger <tobias.geiger@vido.info>
---
 drivers/xen/events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 4b33acd..0a8a17c 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -274,7 +274,7 @@ static unsigned int cpu_from_evtchn(unsigned int evtchn)
 
 static bool pirq_check_eoi_map(unsigned irq)
 {
-	return test_bit(irq, pirq_eoi_map);
+	return test_bit(pirq_from_irq(irq), pirq_eoi_map);
 }
 
 static bool pirq_needs_eoi_flag(unsigned irq)
-- 
1.7.2.5

