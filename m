Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421Ab1BLDTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 22:19:51 -0500
Received: from smtp.outflux.net ([198.145.64.163]:52803 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758200Ab1BLDTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 22:19:50 -0500
Date: Fri, 11 Feb 2011 19:19:35 -0800
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Eugene Teo <eugeneteo@kernel.org>
Message-ID: <20110212031935.GA23210@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bcc: 
Subject: [PATCH] hide kernel addresses via %pK in /proc/timer_list
Reply-To: 
Organization: Canonical

In the continuing effort to avoid kernel addresses leaking to unprivileged
users, this patch switches to %pK for /proc/timer_list reporting.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 kernel/time/timer_list.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 32a19f9..3258455 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -41,7 +41,7 @@ static void print_name_offset(struct seq_file *m, void *sym)
 	char symname[KSYM_NAME_LEN];
 
 	if (lookup_symbol_name((unsigned long)sym, symname) < 0)
-		SEQ_printf(m, "<%p>", sym);
+		SEQ_printf(m, "<%pK>", sym);
 	else
 		SEQ_printf(m, "%s", symname);
 }
@@ -112,7 +112,7 @@ next_one:
 static void
 print_base(struct seq_file *m, struct hrtimer_clock_base *base, u64 now)
 {
-	SEQ_printf(m, "  .base:       %p\n", base);
+	SEQ_printf(m, "  .base:       %pK\n", base);
 	SEQ_printf(m, "  .index:      %d\n",
 			base->index);
 	SEQ_printf(m, "  .resolution: %Lu nsecs\n",
-- 
1.7.2.3

-- 
Kees Cook
Ubuntu Security Team
