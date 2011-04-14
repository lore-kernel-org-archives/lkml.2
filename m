Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933533Ab1DNRrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:47:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:38607 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933471Ab1DNRr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:47:27 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 106/209] sysctl: min/max bounds are optional
Date: Thu, 14 Apr 2011 13:42:16 -0400
Message-Id: <1302803039-9400-107-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit a9febbb4bd1302b6f01aa1203b0a804e4e5c9e25 upstream

sysctl check complains with a WARN() when proc_doulongvec_minmax() or
proc_doulongvec_ms_jiffies_minmax() are used by a vector of longs (with
more than one element), with no min or max value specified.

This is unexpected, given we had a bug on this min/max handling :)

Reported-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Miller <davem@davemloft.net>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/sysctl_check.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
index 04cdcf7..10b90d8 100644
--- a/kernel/sysctl_check.c
+++ b/kernel/sysctl_check.c
@@ -143,15 +143,6 @@ int sysctl_check_table(struct nsproxy *namespaces, struct ctl_table *table)
 				if (!table->maxlen)
 					set_fail(&fail, table, "No maxlen");
 			}
-			if ((table->proc_handler == proc_doulongvec_minmax) ||
-			    (table->proc_handler == proc_doulongvec_ms_jiffies_minmax)) {
-				if (table->maxlen > sizeof (unsigned long)) {
-					if (!table->extra1)
-						set_fail(&fail, table, "No min");
-					if (!table->extra2)
-						set_fail(&fail, table, "No max");
-				}
-			}
 #ifdef CONFIG_PROC_SYSCTL
 			if (table->procname && !table->proc_handler)
 				set_fail(&fail, table, "No proc_handler");
-- 
1.7.4.4

