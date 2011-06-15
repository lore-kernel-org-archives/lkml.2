Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab1FOTMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:12:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20144 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab1FOTMG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:12:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/4] xen: Fix compile warning when CONFIG_SMP is not defined.
Date: Wed, 15 Jun 2011 15:11:34 -0400
Message-Id: <1308165095-17303-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308165095-17303-1-git-send-email-konrad.wilk@oracle.com>
References: <1308165095-17303-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090201.4DF903FF.00C1:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. which is quite benign.

drivers/xen/events.c:398: warning: unused variable ‘desc’

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 553da68..30df85d 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -395,9 +395,9 @@ static void unmask_evtchn(int port)
 static void xen_irq_init(unsigned irq)
 {
 	struct irq_info *info;
+#ifdef CONFIG_SMP
 	struct irq_desc *desc = irq_to_desc(irq);
 
-#ifdef CONFIG_SMP
 	/* By default all event channels notify CPU#0. */
 	cpumask_copy(desc->irq_data.affinity, cpumask_of(0));
 #endif
-- 
1.7.4.1

