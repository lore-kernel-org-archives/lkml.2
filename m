Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab1I2Ty3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 15:54:29 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36387 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab1I2TxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 15:53:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5/9] xen/events: Don't check the info for NULL as it is already done.
Date: Thu, 29 Sep 2011 15:52:47 -0400
Message-Id: <1317325971-21603-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
References: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090206.4E84CC9F.0065,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The list operation checks whether the 'info' structure that is
retrieved from the list is NULL (otherwise it would not been able
to retrieve it). This check is not neccessary.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 5db04bf..71d2363 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -779,7 +779,7 @@ int xen_irq_from_pirq(unsigned pirq)
 	mutex_lock(&irq_mapping_update_lock);
 
 	list_for_each_entry(info, &xen_irq_list_head, list) {
-		if (info == NULL || info->type != IRQT_PIRQ)
+		if (info->type != IRQT_PIRQ)
 			continue;
 		irq = info->irq;
 		if (info->u.pirq.pirq == pirq)
-- 
1.7.4.1

