Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab1EYGeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 02:34:22 -0400
Received: from mail4.comsite.net ([205.238.176.238]:48020 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab1EYGeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 02:34:19 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
Subject: [PATCH 3/4] irq: remove unnecessary __ref on irq_alloc_descs
From: Milton Miller <miltonm@bga.com>
Message-Id: <irq-alloc-no-longer-needs-ref@mdm.bga.com>
In-Reply-To: <generic-irq-changes@mdm.bga.com>
References: <generic-irq-changes@mdm.bga.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: <linux-kernel@vger.kernel.org>
Date: Wed, 25 May 2011 01:34:18 -0500
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

febcb0c59a (irq: Remove unnecessary bootmem code) removed the
slab_is_available() conditonal call to alloc_bootmem* but missed
removeing the __ref annotation.

Signed-off-by: Milton Miller <miltonm@bga.com>

Index: work.git/kernel/irq/irqdesc.c
===================================================================
--- work.git.orig/kernel/irq/irqdesc.c	2011-05-23 14:29:22.960588100 -0500
+++ work.git/kernel/irq/irqdesc.c	2011-05-23 14:29:27.377586564 -0500
@@ -351,8 +351,7 @@ EXPORT_SYMBOL_GPL(irq_free_descs);
  *
  * Returns the first irq number or error code
  */
-int __ref
-irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node)
+int irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node)
 {
 	int start, ret;
 
