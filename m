Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab2JANl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:41:56 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44923 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2JANlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:41:55 -0400
Date: Mon, 1 Oct 2012 15:41:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpu change for v3.7
Message-ID: <20121001134149.GA23871@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cpu-for-linus

   HEAD: dec08a837fda146fee498ffc5ecd0d2eeeacd025 x86: Remove the useless branch in c_start()

One small cleanup.

 Thanks,

	Ingo

------------------>
Michael Wang (1):
      x86: Remove the useless branch in c_start()


 arch/x86/kernel/cpu/proc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 8022c66..fbd8955 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -140,10 +140,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 
 static void *c_start(struct seq_file *m, loff_t *pos)
 {
-	if (*pos == 0)	/* just in case, cpu 0 is not the first */
-		*pos = cpumask_first(cpu_online_mask);
-	else
-		*pos = cpumask_next(*pos - 1, cpu_online_mask);
+	*pos = cpumask_next(*pos - 1, cpu_online_mask);
 	if ((*pos) < nr_cpu_ids)
 		return &cpu_data(*pos);
 	return NULL;
