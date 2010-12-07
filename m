Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab0LGPgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:36:09 -0500
Received: from www.tglx.de ([62.245.132.106]:32931 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842Ab0LGPgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:36:08 -0500
Date: Tue, 7 Dec 2010 16:35:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] genirq fixes for 2.6.37
Message-ID: <alpine.LFD.2.00.1012071634140.2653@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-fixes-for-linus git tree from:

 git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

Thanks,

	tglx

------------------>
Kenji Kaneshige (1):
      genirq: Fix incorrect proc spurious output


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
