Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab0K3Ig4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 03:36:56 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52575 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab0K3Igz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 03:36:55 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4CF4B778.90604@jp.fujitsu.com>
Date: Tue, 30 Nov 2010 17:36:08 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] genirq: fix incorrect proc spurious output
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the problem that all the /proc/irq/XX/spurious files shows the IRQ
0 information.

Current irq_spurious_proc_open() passes on NULL as the 3rd argument,
which is used as an IRQ number in irq_spurious_proc_show(), to the
single_open(). Because of this, all the /proc/irq/XX/spurious file
shows IRQ 0 information regardless of the IRQ number.

To fix the problem, irq_spurious_proc_open() must pass on the
appropreate data (IRQ number) to single_open().

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 kernel/irq/proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-next-20101125/kernel/irq/proc.c
===================================================================
--- linux-next-20101125.orig/kernel/irq/proc.c
+++ linux-next-20101125/kernel/irq/proc.c
@@ -214,7 +214,7 @@ static int irq_spurious_proc_show(struct
 
 static int irq_spurious_proc_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, irq_spurious_proc_show, NULL);
+	return single_open(file, irq_spurious_proc_show, PDE(inode)->data);
 }
 
 static const struct file_operations irq_spurious_proc_fops = {

