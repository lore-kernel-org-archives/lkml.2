Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab2I0GJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 02:09:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54740 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab2I0GJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 02:09:33 -0400
Date: Wed, 26 Sep 2012 23:07:18 -0700
From: tip-bot for Michael Wang <wangyun@linux.vnet.ibm.com>
Message-ID: <tip-dec08a837fda146fee498ffc5ecd0d2eeeacd025@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        wangyun@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        wangyun@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <1348033343-23658-1-git-send-email-wangyun@linux.vnet.ibm.com>
References: <1348033343-23658-1-git-send-email-wangyun@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86: Remove the useless branch in c_start()
Git-Commit-ID: dec08a837fda146fee498ffc5ecd0d2eeeacd025
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 23:07:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dec08a837fda146fee498ffc5ecd0d2eeeacd025
Gitweb:     http://git.kernel.org/tip/dec08a837fda146fee498ffc5ecd0d2eeeacd025
Author:     Michael Wang <wangyun@linux.vnet.ibm.com>
AuthorDate: Wed, 19 Sep 2012 13:42:23 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 26 Sep 2012 13:27:56 +0200

x86: Remove the useless branch in c_start()

Since 'cpu == -1' in cpumask_next() is legal, no need to handle
'*pos == 0' specially.

About the comments:

	/* just in case, cpu 0 is not the first */

A test with a cpumask in which cpu 0 is not the first has been
done, and it works well.

This patch will remove that useless branch to clean the code.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: kjwinchester@gmail.com
Cc: borislav.petkov@amd.com
Cc: ak@linux.intel.com
Link: http://lkml.kernel.org/r/1348033343-23658-1-git-send-email-wangyun@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/proc.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

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
