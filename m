Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab1EPVT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:19:26 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39327 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab1EPVTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:19:25 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, "Ted Ts'o" <tytso@mit.edu>,
        Michal Nazarewicz <mina86@mina86.com>,
        Jiri Slaby <jirislaby@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: [PATCH 3/3] checkpatch.pl: Add check for task comm references
Date: Mon, 16 May 2011 14:19:17 -0700
Message-Id: <1305580757-13175-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1305580757-13175-1-git-send-email-john.stultz@linaro.org>
References: <1305580757-13175-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that accessing current->comm needs to be protected,
avoid new current->comm or other task->comm usage by adding
a warning to checkpatch.pl.

Fair warning: I know zero perl, so this was written in the
style of "monkey see, monkey do". It does appear to work
in my testing though.

Thanks to Jiri Slaby and Michal Nazarewicz for help improving
the regex!

Close review and feedback would be appreciated.

CC: Ted Ts'o <tytso@mit.edu>
CC: Michal Nazarewicz <mina86@mina86.com>
CC: Jiri Slaby <jirislaby@gmail.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: David Rientjes <rientjes@google.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 scripts/checkpatch.pl |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d867081..3a713c2 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2868,6 +2868,10 @@ sub process {
 			WARN("usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc\n" . $herecurr);
 		}
 
+# check for current->comm usage
+		if ($line =~ /\b(?:current|task|tsk|t)\s*->\s*comm\b/) {
+			WARN("comm access needs to be protected. Use get_task_comm, or printk's \%ptc formatting.\n" . $herecurr);
+		}
 # check for %L{u,d,i} in strings
 		my $string;
 		while ($line =~ /(?:^|")([X\t]*)(?:"|$)/g) {
-- 
1.7.3.2.146.gca209

