Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab0JUNkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:40:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50795 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758113Ab0JUNk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:40:28 -0400
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=cQ77kgW3POkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=eJfxgxciAAAA:8 a=meVymXHHAAAA:8 a=qW4DTLnXnzhnartrxEMA:9 a=MfXA5dNFie9jhTQg0mkA:7 a=1_nxkg7A7K6h9g30HT6ciHMW9kEA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=W39ifWXXhksA:10 a=jeBq3FmKZ4MA:10 a=NCB2jsFcvnE9qcNj:21 a=La905yXmWvmCbm6G:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH][GIT PULL] tracing: Do not limit the size of the number of
 CPU buffers
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 21 Oct 2010 09:40:26 -0400
Message-ID: <1287668426.16971.579.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I rebased my tree. This one removed the trace_bprintk() from modules
patch, since it may be questionable. But to not keep this patch from
being pulled, I put it separately. I'll post a core-3 soon with the
trace_bprintk() patch as well.

-- Steve


Please pull the latest tip/perf/core-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core-2


Steven Rostedt (1):
      tracing: Do not limit the size of the number of CPU buffers

----
 kernel/trace/trace.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)
---------------------------
commit dd49a38cf30944be27892c10b1c0e5b3fa73bcb2
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed Oct 20 21:51:26 2010 -0400

    tracing: Do not limit the size of the number of CPU buffers
    
    The tracing per_cpu buffers were limited to 999 CPUs for a mear
    savings in stack space of a char array. Up the array to 30 characters
    which is more than enough to hold a 64 bit number.
    
    Reported-by: Robin Holt <holt@sgi.com>
    Suggested-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 001bcd2..82d9b81 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3996,13 +3996,9 @@ static void tracing_init_debugfs_percpu(long cpu)
 {
 	struct dentry *d_percpu = tracing_dentry_percpu();
 	struct dentry *d_cpu;
-	/* strlen(cpu) + MAX(log10(cpu)) + '\0' */
-	char cpu_dir[7];
+	char cpu_dir[30]; /* 30 characters should be more than enough */
 
-	if (cpu > 999 || cpu < 0)
-		return;
-
-	sprintf(cpu_dir, "cpu%ld", cpu);
+	snprintf(cpu_dir, 30, "cpu%ld", cpu);
 	d_cpu = debugfs_create_dir(cpu_dir, d_percpu);
 	if (!d_cpu) {
 		pr_warning("Could not create debugfs '%s' entry\n", cpu_dir);


