Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab0LHBKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:10:04 -0500
Received: from kroah.org ([198.145.64.141]:33834 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932609Ab0LHBDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:53 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:47 2010
Message-Id: <20101208005747.510778883@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [261/289] genirq: Fix incorrect proc spurious output
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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
Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
LKML-Reference: <4CF4B778.90604@jp.fujitsu.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/irq/proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -214,7 +214,7 @@ static int irq_spurious_proc_show(struct
 
 static int irq_spurious_proc_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, irq_spurious_proc_show, NULL);
+	return single_open(file, irq_spurious_proc_show, PDE(inode)->data);
 }
 
 static const struct file_operations irq_spurious_proc_fops = {


