Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000Ab2DZSf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:35:59 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34310 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758932Ab2DZSfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:35:11 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/4] xen: use the pirq number to check the pirq_eoi_map
Date: Thu, 26 Apr 2012 14:29:23 -0400
Message-Id: <1335464965-24767-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1335464965-24767-1-git-send-email-konrad.wilk@oracle.com>
References: <1335464965-24767-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

In pirq_check_eoi_map use the pirq number rather than the Linux irq
number to check whether an eoi is needed in the pirq_eoi_map.

The reason is that the irq number is not always identical to the
pirq number so if we wrongly use the irq number to check the
pirq_eoi_map we are going to check for the wrong pirq to EOI.

As a consequence some interrupts might not be EOI'ed by the
guest correctly.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Tested-by: Tobias Geiger <tobias.geiger@vido.info>
[v1: Added some extra wording to git commit]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
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
1.7.7.5

