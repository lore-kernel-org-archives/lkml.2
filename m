Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874Ab1DNPa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:30:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63971 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609Ab1DNPaY (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 14 Apr 2011 11:30:24 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/5] xen/irq: Export 'xen_pirq_from_irq' function.
Date: Thu, 14 Apr 2011 11:30:13 -0400
Message-Id: <1302795014-13289-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302795014-13289-1-git-send-email-konrad.wilk@oracle.com>
References: <1302795014-13289-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DA7130E.0052:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need this to find the real Xen PIRQ value for a device
that requests an MSI or MSI-X. In the past we used
'xen_gsi_from_irq' since that function would return
an Xen PIRQ or GSI depending on the provided IRQ. Now that
we have seperated that we need to use the correct
function.

[v2: Deal with rebase on stable/irq.cleanup]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/events.c |    6 ++++++
 include/xen/events.h |    3 +++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 0ac7a14..e4e8e9a 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -763,6 +763,12 @@ out:
 	return irq;
 }
 
+
+int xen_pirq_from_irq(unsigned irq)
+{
+	return pirq_from_irq(irq);
+}
+EXPORT_SYMBOL_GPL(xen_pirq_from_irq);
 int bind_evtchn_to_irq(unsigned int evtchn)
 {
 	int irq;
diff --git a/include/xen/events.h b/include/xen/events.h
index 932e540..9af21e1 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -95,6 +95,9 @@ int xen_destroy_irq(int irq);
 /* Return irq from pirq */
 int xen_irq_from_pirq(unsigned pirq);
 
+/* Return the pirq allocated to the irq. */
+int xen_pirq_from_irq(unsigned irq);
+
 /* Determine whether to ignore this IRQ if it is passed to a guest. */
 int xen_test_irq_shared(int irq);
 
-- 
1.7.1

