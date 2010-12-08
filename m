Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab0LHIFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 03:05:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43953 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507Ab0LHIF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 03:05:28 -0500
Date: Wed, 8 Dec 2010 09:05:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq fix
Message-ID: <20101208080517.GA27391@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

 Thanks,

	Ingo

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
