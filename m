Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab0LAHqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 02:46:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:51681 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833Ab0LAHqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 02:46:09 -0500
Date: Wed, 1 Dec 2010 07:45:51 GMT
From: tip-bot for Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yong.zhang0@gmail.com, kaneshige.kenji@jp.fujitsu.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, kaneshige.kenji@jp.fujitsu.com,
        yong.zhang0@gmail.com
In-Reply-To: <4CF4B778.90604@jp.fujitsu.com>
References: <4CF4B778.90604@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq: Fix incorrect proc spurious output
Message-ID: <tip-25c9170ed64a6551beefe9315882f754e14486f4@git.kernel.org>
Git-Commit-ID: 25c9170ed64a6551beefe9315882f754e14486f4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 01 Dec 2010 07:45:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  25c9170ed64a6551beefe9315882f754e14486f4
Gitweb:     http://git.kernel.org/tip/25c9170ed64a6551beefe9315882f754e14486f4
Author:     Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
AuthorDate: Tue, 30 Nov 2010 17:36:08 +0900
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 1 Dec 2010 08:44:26 +0100

genirq: Fix incorrect proc spurious output

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
Cc: stable@kernel.org [2.6.33+]
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/irq/proc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 01b1d3a..6c8a2a9 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -214,7 +214,7 @@ static int irq_spurious_proc_show(struct seq_file *m, void *v)
 
 static int irq_spurious_proc_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, irq_spurious_proc_show, NULL);
+	return single_open(file, irq_spurious_proc_show, PDE(inode)->data);
 }
 
 static const struct file_operations irq_spurious_proc_fops = {
