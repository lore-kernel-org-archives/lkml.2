Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab1I2TxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 15:53:10 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36358 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab1I2TxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 15:53:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/9] xen/events: BUG() when we can't allocate our event->irq array.
Date: Thu, 29 Sep 2011 15:52:46 -0400
Message-Id: <1317325971-21603-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
References: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E84CC9D.0130:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case we can't allocate we are doomed. We should BUG_ON
instead of trying to dereference it later on.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/events.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 7523719..5db04bf 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1670,6 +1670,8 @@ void __init xen_init_IRQ(void)
 
 	evtchn_to_irq = kcalloc(NR_EVENT_CHANNELS, sizeof(*evtchn_to_irq),
 				    GFP_KERNEL);
+	if (!evtchn_to_irq)
+		BUG();
 	for (i = 0; i < NR_EVENT_CHANNELS; i++)
 		evtchn_to_irq[i] = -1;
 
-- 
1.7.4.1

