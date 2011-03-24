Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159Ab1CXUhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:37:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:38157 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932184Ab1CXUhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:37:40 -0400
Date: Thu, 24 Mar 2011 21:37:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: ian.campbell@citrix.com, Jeremy Fitzhardinge <jeremy@goop.org>,
        konrad.wilk@oracle.com
Subject: [PATCH] xen: Use new irq_move functions
Message-ID: <alpine.LFD.2.00.1103242135380.31464@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -0.7
X-Linutronix-Spam-Level: /
X-Linutronix-Spam-Status: No , -0.7 points, 5.0 required,  ALL_TRUSTED=-1,URIBL_RHS_DOB=0.276
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions take irq_data as an argument and avoid a redundant
lookup in the sparse irq case.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/events.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/drivers/xen/events.c
===================================================================
--- linux-2.6-tip.orig/drivers/xen/events.c
+++ linux-2.6-tip/drivers/xen/events.c
@@ -585,7 +585,7 @@ static void ack_pirq(struct irq_data *da
 {
 	int evtchn = evtchn_from_irq(data->irq);
 
-	move_native_irq(data->irq);
+	irq_move_irq(data);
 
 	if (VALID_EVTCHN(evtchn)) {
 		mask_evtchn(evtchn);
@@ -1339,7 +1339,7 @@ static void ack_dynirq(struct irq_data *
 {
 	int evtchn = evtchn_from_irq(data->irq);
 
-	move_masked_irq(data->irq);
+	irq_move_masked_irq(data);
 
 	if (VALID_EVTCHN(evtchn))
 		unmask_evtchn(evtchn);
