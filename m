Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab0LLXsb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:48:31 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36774 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab0LLXsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:25 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: kaneshige.kenji@jp.fujitsu.com, ak@linux.intel.com, yong.zhang0@gmail.com,
        tglx@linutronix.de, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [198/223] genirq: Fix incorrect proc spurious output
Message-Id: <20101212234824.9CE9DB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:24 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

commit 25c9170ed64a6551beefe9315882f754e14486f4 upstream.

Since commit a1afb637(switch /proc/irq/*/spurious to seq_file) all
/proc/irq/XX/spurious files show the information of irq 0.

Current irq_spurious_proc_open() passes on NULL as the 3rd argument,
which is used as an IRQ number in irq_spurious_proc_show(), to the
single_open(). Because of this, all the /proc/irq/XX/spurious file
shows IRQ 0 information regardless of the IRQ number.

To fix the problem, irq_spurious_proc_open() must pass on the
appropreate data (IRQ number) to single_open().

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
LKML-Reference: <4CF4B778.90604@jp.fujitsu.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/irq/proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/kernel/irq/proc.c
===================================================================
--- linux.orig/kernel/irq/proc.c
+++ linux/kernel/irq/proc.c
@@ -214,7 +214,7 @@ static int irq_spurious_proc_show(struct
 
 static int irq_spurious_proc_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, irq_spurious_proc_show, NULL);
+	return single_open(file, irq_spurious_proc_show, PDE(inode)->data);
 }
 
 static const struct file_operations irq_spurious_proc_fops = {
